---@class utils.call_hierarchy
local M = {}

---@class CallHierarchyItem
---@field name string
---@field uri string
---@field range { start: { line: integer, character: integer }, ['end']: { line: integer, character: integer } }
---@field kind? integer LSP SymbolKind
---@field detail? string

---@class CallHierarchyIncomingCall
---@field from CallHierarchyItem
---@field fromRanges table[]

---@class CallHierarchyOutgoingCall
---@field to CallHierarchyItem
---@field fromRanges table[]

---@alias CallHierarchyDirection 'incoming'|'outgoing'

---@class CallHierarchyResultEntry
---@field item CallHierarchyItem
---@field depth integer

---@class CallHierarchyStats
---@field hit_depth_limit? boolean true if any branch was cut off by max_depth
---@field hit_fanout_limit? boolean true if any node was cut off by max_fanout
---@field fanout_nodes? string[] human-readable list of "name (N callers)" entries

---@class CallHierarchyRunOpts
---@field max_depth? integer safety-valve depth cap (default 30); rarely hit in practice
---@field max_fanout? integer per-node child count cap (default 40); guards against
---  high fan-in/fan-out nodes (e.g. a widely-called log() function) blowing up
---  the request count on graphs that have no cycles for path_seen to catch

--- Finds the first LSP client attached to `bufnr` that supports call hierarchy.
---@param bufnr integer
---@return vim.lsp.Client|nil
local function get_client(bufnr)
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  for _, c in ipairs(clients) do
    if c.supports_method('textDocument/prepareCallHierarchy') then
      return c
    end
  end
  return nil
end

--- Builds a stable per-node key used for path-scoped cycle detection.
---@param item CallHierarchyItem
---@return string
local function node_key(item)
  return item.uri .. ':' .. item.name .. ':' ..
      item.range.start.line .. ':' .. item.range.start.character
end

--- Recursively walks the call hierarchy tree.
---
--- Termination is guarded on two independent axes:
---   1. `max_depth` — a safety-valve depth cap. Normal call chains rarely
---      exceed ~15 levels; this exists purely to stop runaway recursion.
---   2. `max_fanout` — caps the number of children expanded from any single
---      node. This is the guard that actually matters for real codebases:
---      a widely-called utility (logging, assertions, etc.) has no cycle for
---      path_seen to catch, so without a fan-out cap it would expand into an
---      exponential number of LSP requests.
---
--- `path_seen` is cloned (not shared) per recursive call so that dedup is
--- scoped to the current root-to-node path only — sibling branches that
--- happen to reach the same function are NOT deduped against each other
--- (see the "diamond" fan-in case), only true cycles on the same path are.
---
---@param client vim.lsp.Client
---@param item CallHierarchyItem
---@param direction CallHierarchyDirection
---@param depth integer current depth; root call starts at 0
---@param max_depth integer
---@param max_fanout integer
---@param path_seen table<string, boolean> dedup set scoped to this path only
---@param results CallHierarchyResultEntry[] flat accumulator, appended in place
---@param stats CallHierarchyStats accumulator for user-facing truncation notices
---@param callback fun() invoked once this subtree (and all descendants) resolves
local function recurse(client, item, direction, depth, max_depth, max_fanout, path_seen, results, stats, callback)
  if depth > max_depth then
    stats.hit_depth_limit = true
    callback()
    return
  end

  local key = node_key(item)
  if path_seen[key] then
    callback()
    return
  end

  local new_path_seen = vim.tbl_extend('force', {}, path_seen)
  new_path_seen[key] = true

  table.insert(results, { item = item, depth = depth })

  local method = direction == 'incoming'
      and 'callHierarchy/incomingCalls'
      or 'callHierarchy/outgoingCalls'

  ---@param err lsp.ResponseError|nil
  ---@param res (CallHierarchyIncomingCall[]|CallHierarchyOutgoingCall[])|nil
  client:request(method, { item = item }, function(err, res)
    if err or not res or vim.tbl_isempty(res) then
      callback()
      return
    end

    if #res > max_fanout then
      stats.hit_fanout_limit = true
      stats.fanout_nodes = stats.fanout_nodes or {}
      table.insert(stats.fanout_nodes, string.format('%s (%d callers)', item.name, #res))
      callback()
      return
    end

    local pending = #res
    if pending == 0 then
      callback()
      return
    end

    for _, entry in ipairs(res) do
      ---@diagnostic disable-next-line: undefined-field
      local child_item = direction == 'incoming' and entry.from or entry.to
      recurse(client, child_item, direction, depth + 1, max_depth, max_fanout,
        new_path_seen, results, stats, function()
          pending = pending - 1
          if pending == 0 then
            callback()
          end
        end)
    end
  end)
end

--- Renders the flat results list into the quickfix window. Each entry's
--- `text` includes the full root-to-node call chain (not just the immediate
--- parent), so the direct/indirect relationship is legible even without
--- relying on indentation alone.
---@param results CallHierarchyResultEntry[]
---@param title string
local function render_qf(results, title)
  local qf_items = {}
  ---@type table<integer, string> path_stack[depth] = name
  local path_stack = {}

  for _, r in ipairs(results) do
    path_stack[r.depth] = r.item.name
    for d = r.depth + 1, #path_stack do
      path_stack[d] = nil
    end

    local chain = {}
    for d = 0, r.depth do
      table.insert(chain, path_stack[d])
    end

    local indent = string.rep('  ', r.depth)
    local text = r.depth == 0
        and r.item.name
        or string.format('%s%s  ← %s', indent, r.item.name, table.concat(chain, ' ← ', 1, r.depth))

    table.insert(qf_items, {
      filename = vim.uri_to_fname(r.item.uri),
      lnum = r.item.range.start.line + 1,
      col = r.item.range.start.character + 1,
      text = text,
    })
  end

  vim.fn.setqflist({}, ' ', { title = title, items = qf_items })
  vim.cmd('copen')
end

--- Runs a (by default effectively unbounded) call hierarchy traversal from
--- the symbol under the cursor and populates the quickfix list.
---
--- Pass `{ max_depth = 1 }` for a single-level lookup (direct callers/callees
--- only, equivalent to the built-in vim.lsp.buf.incoming_calls/outgoing_calls).
--- Omit `opts` entirely for a full traversal guarded by sane defaults.
---
---@param direction CallHierarchyDirection
---@param opts? CallHierarchyRunOpts
function M.run(direction, opts)
  opts = opts or {}
  local max_depth = opts.max_depth or 30
  local max_fanout = opts.max_fanout or 40

  local bufnr = vim.api.nvim_get_current_buf()
  local client = get_client(bufnr)
  if not client then
    vim.notify('No LSP client supports call hierarchy', vim.log.levels.WARN)
    return
  end

  local params = vim.lsp.util.make_position_params(0, client.offset_encoding)

  ---@param err lsp.ResponseError|nil
  ---@param res CallHierarchyItem[]|nil
  client:request('textDocument/prepareCallHierarchy', params, function(err, res)
    if err or not res or vim.tbl_isempty(res) then
      vim.notify('No call hierarchy item at cursor', vim.log.levels.WARN)
      return
    end

    local root = res[1]
    ---@type CallHierarchyResultEntry[]
    local results = {}
    ---@type CallHierarchyStats
    local stats = {}

    recurse(client, root, direction, 0, max_depth, max_fanout, {}, results, stats, function()
      vim.schedule(function()
        local title = direction == 'incoming' and 'Incoming Calls' or 'Outgoing Calls'
        render_qf(results, title)

        if stats.hit_depth_limit then
          vim.notify(
            string.format('%s: hit depth limit (%d) — some branches were not fully expanded', title, max_depth),
            vim.log.levels.INFO
          )
        end
        if stats.hit_fanout_limit then
          vim.notify(
            string.format('%s: %d node(s) truncated due to high fan-out:\n%s',
              title, #stats.fanout_nodes, table.concat(stats.fanout_nodes, '\n')),
            vim.log.levels.WARN
          )
        end
      end)
    end)
  end)
end

-- Exposed for testing only; not part of the public API surface.
M._internal = {
  get_client = get_client,
  recurse = recurse,
  render_qf = render_qf,
  node_key = node_key,
}

return M
