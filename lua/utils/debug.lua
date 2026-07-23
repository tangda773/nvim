local M = {}


-----------------------------------------------------------
-- Config
-----------------------------------------------------------

local config = {

  -- fzf | notify
  backend = "fzf",

  max_history = 200,

  override_print = true,

  fzf = {
    prompt = "Debug> ",
    preview_width = "60%",
  },
}



-----------------------------------------------------------
-- State
-----------------------------------------------------------

local state = {
  history = {},
}



-----------------------------------------------------------
-- Helpers
-----------------------------------------------------------

local function now()
  return os.date("%H:%M:%S")
end



local function caller()
  local info =
      debug.getinfo(
        3,
        "Sl"
      )


  if not info then
    return "unknown"
  end


  return string.format(
    "%s:%d",
    info.short_src or "?",
    info.currentline or 0
  )
end



local function inspect(...)
  local result = {}


  for _, value in ipairs({ ... }) do
    result[#result + 1] =
        vim.inspect(value)
  end


  return table.concat(
    result,
    "\n"
  )
end



-----------------------------------------------------------
-- History
-----------------------------------------------------------

local function add_history(
    kind,
    text,
    source
)
  local item = {

    time = now(),

    kind = kind,

    source = source,

    title = string.format(
      "[%s] %-10s %s",
      now(),
      kind,
      source
    ),

    content = text,
  }



  table.insert(
    state.history,
    item
  )



  if #state.history >
      config.max_history
  then
    table.remove(
      state.history,
      1
    )
  end
end



-----------------------------------------------------------
-- fzf-lua backend
-----------------------------------------------------------

local function show_fzf()
  local ok, fzf =
      pcall(require, "fzf-lua")


  if not ok then
    vim.notify(
      "fzf-lua is not available",
      vim.log.levels.ERROR
    )
    return
  end


  local entries = {}

  for i, item in ipairs(state.history) do
    entries[#entries + 1] =
        string.format(
          "%d %s",
          i,
          item.title
        )
  end



  fzf.fzf_exec(
    entries,
    {

      prompt = "Debug> ",

      preview = function(selected)
        local index =
            tonumber(
              selected[1]:match("^(%d+)")
            )


        if not index then
          return ""
        end


        return state.history[index].content
      end,


      actions = {

        ["default"] =
            function(selected)
              local index =
                  tonumber(
                    selected[1]:match("^(%d+)")
                  )


              if not index then
                return
              end



              local content =
                  state.history[index].content



              vim.cmd("new")


              vim.bo.filetype =
              "lua"



              vim.api.nvim_buf_set_lines(
                0,
                0,
                -1,
                false,
                vim.split(
                  content,
                  "\n"
                )
              )
            end,

      },

    }
  )
end

-----------------------------------------------------------
-- notify backend
-----------------------------------------------------------

local function show_notify(text)
  vim.notify(
    text,
    vim.log.levels.INFO
  )
end



-----------------------------------------------------------
-- Output
-----------------------------------------------------------

local function output(
    kind,
    text,
    source
)
  add_history(
    kind,
    text,
    source
  )



  if config.backend == "fzf" then
    show_fzf()
  elseif config.backend == "notify" then
    show_notify(text)
  end
end



-----------------------------------------------------------
-- Public API
-----------------------------------------------------------

function M.dd(...)
  local source =
      caller()



  local text = table.concat(

    {

      "== DEBUG ==",

      "caller: "
      .. source,

      "",

      inspect(...),

    },

    "\n"

  )



  output(
    "inspect",
    text,
    source
  )
end

function M.bt()
  local source =
      caller()



  local text =
      debug.traceback(
        "== BACKTRACE ==",
        2
      )



  output(
    "trace",
    text,
    source
  )
end

-----------------------------------------------------------
-- print override
-----------------------------------------------------------

local function debug_print(...)
  M.dd(...)
end



-----------------------------------------------------------
-- Setup
-----------------------------------------------------------

function M.setup(opts)
  config =
      vim.tbl_deep_extend(
        "force",
        config,
        opts or {}
      )



  -- global helpers

  _G.dd = M.dd

  _G.bt = M.bt



  if config.override_print then
    if vim.fn.has("nvim-0.11") == 1 then
      vim._print =
          debug_print
    else
      vim.print =
          debug_print
    end
  end
end

-----------------------------------------------------------
-- Extra API
-----------------------------------------------------------

function M.open()
  show_fzf()
end

function M.clear()
  state.history = {}
end

function M.history()
  return state.history
end

function M.set_backend(name)
  config.backend = name
end

return M
