# nvim

Personal Neovim configuration targeting *_Neovim >= 0.12_. Plugin management uses [`zpack.nvim`](https://github.com/zuqini/zpack.nvim), a thin wrapper around the built-in `vim.pack`.

**Core approach:** prefer native APIs, use the mini.nvim ecosystem instead of large all-in-one plugins, and combine LSP, Treesitter, and AI-assisted workflows.

Supported languages: Go / Rust / C/C++ / Lua / Bash / TypeScript/JavaScript / HTML / CSS / JSON / YAML.

---

## Directory Structure

```text
~/.config/nvim/
├── init.lua                    # Entry point: mapleader, vim.loader, require basic/config.zpack
├── lua/
│   ├── basic.lua               # Global options
│   ├── config/
│   │   ├── zpack.lua           # zpack.nvim initialization
│   │   └── orgmode-settings.lua
│   ├── lsp/
│   │   ├── util.lua            # Shared LSP setup, keymaps, diagnostic configuration
│   │   ├── bashls.lua / clangd.lua / cssls.lua / eslint.lua
│   │   ├── gopls.lua / html.lua / jsonls.lua / lua_ls.lua
│   │   ├── ts_ls.lua / yamlls.lua
│   ├── plugins/
│   │   ├── mini.lua            # mini.nvim spec; requires submodules by load timing
│   │   ├── mini/               # mini submodule configuration files, loaded by mini.lua
│   │   └── *.lua               # Other plugin specs
│   └── utils/
│       ├── init.lua
│       └── debug.lua           # Debug utility (dd/bt plus fzf-lua viewer)
└── wezterm/                    # WezTerm configuration; unrelated to Neovim
```

> zpack scan rule: it only processes direct files under `lua/plugins/*.lua`; it does **not** recurse into `lua/plugins/mini/`. `mini.lua` is responsible for requiring each submodule at the appropriate time.

---

## Plugin List

| Plugin                                                      | Primary purpose                                                                    |
| ----------------------------------------------------------- | ---------------------------------------------------------------------------------- |
| `zpack.nvim`                                                | Plugin manager built on `vim.pack`                                                 |
| `mini.nvim`                                                 | Multiple submodules; see the next section                                          |
| `agentic.nvim`                                              | ACP AI chat panel and diff preview through `claude-agent-acp`                      |
| `blink.cmp`                                                 | Completion engine: LSP, snippets, buffers, paths, and command line                 |
| `LuaSnip` + `friendly-snippets`                             | Snippet engine and bundled snippets                                                |
| `blink.compat` + `cmp-nvim-lua` + `cmp-go-deep` + `cmp-sql` | Additional blink.cmp sources                                                       |
| `codecompanion.nvim`                                        | AI collaboration through CLI mode and the `claude` command                         |
| `conform.nvim`                                              | Format on save with `stylua`, `rustfmt`, `prettier`, `gofumpt`, and more           |
| `crates.nvim`                                               | Cargo.toml version completion and operations                                       |
| `vim-dadbod-ui` + `vim-dadbod` + `vim-dadbod-completion`    | SQL database UI and query completion                                               |
| `nvim-dap` + `nvim-dap-ui` + `mason-nvim-dap.nvim`          | DAP debugging                                                                      |
| `dropbar.nvim`                                              | Winbar breadcrumb navigation                                                       |
| `faster.nvim`                                               | Large-file performance degradation mode                                            |
| `fzf-lua`                                                   | Fuzzy finding for files, grep, buffers, LSP, Git, and more                         |
| `fzf-org.nvim`                                              | Org file and headline picker                                                       |
| `grug-far.nvim`                                             | Project-wide search and replace with ripgrep or ast-grep                           |
| `lazydev.nvim`                                              | Neovim Lua API type hints                                                          |
| `mason.nvim` + `mason-lspconfig.nvim`                       | LSP, DAP, and formatter installation management                                    |
| `nvim-lspconfig`                                            | LSP configuration loading; see `lua/lsp/`                                          |
| `neogen`                                                    | Generate docstrings using Treesitter                                               |
| `neogit` + `diffview.nvim`                                  | Full Git UI and diff review                                                        |
| `neotest` + adapters                                        | Test execution UI for Python, Go, C++, Rust, and generic runners                   |
| `nvim-bqf`                                                  | Quickfix enhancement with preview and fzf filtering                                |
| `obsidian.nvim`                                             | Obsidian vault integration; workspace: `~/notes`                                   |
| `orgmode`                                                   | Org-mode tasks and agenda                                                          |
| `overseer.nvim`                                             | Build and task execution management                                                |
| `quicker.nvim`                                              | Fast editing for Quickfix and Location lists                                       |
| `remote-sshfs.nvim`                                         | Remote mounting through SSHFS                                                      |
| `render-markdown.nvim`                                      | Inline Markdown rendering                                                          |
| `rustaceanvim`                                              | Deep Rust and rust-analyzer integration                                            |
| `b0o/schemastore.nvim`                                      | JSON/YAML schema source for jsonls and yamlls                                      |
| `smart-splits.nvim`                                         | Cross-window navigation, resizing, and buffer swapping                             |
| `snacks.nvim`                                               | `vim.ui.input`, notifications, scratch buffers, cursor-word highlighting, profiler |
| `statuscol.nvim`                                            | Custom status column for folds, signs, and line numbers                            |
| `toggleterm.nvim`                                           | Multi-layout terminal management                                                   |
| `nvim-treesitter`                                           | Syntax parsing and highlighting through the built-in Treesitter API                |
| `trouble.nvim`                                              | Tree-based UI for diagnostics, symbols, and call hierarchy                         |
| `nvim-ufo`                                                  | Advanced folds via LSP, Treesitter, and indentation                                |

---

## mini.nvim Submodules

| Submodule          | Load timing               | Purpose                                                                                       |
| ------------------ | ------------------------- | --------------------------------------------------------------------------------------------- |
| `mini.icons`       | Immediate                 | File icon provider                                                                            |
| `mini.colors`      | Immediate                 | Color tools, including the `randomhue` colorscheme                                            |
| `mini.starter`     | Immediate                 | Startup dashboard                                                                             |
| `mini.misc`        | Immediate                 | `setup_auto_root` and `setup_restore_cursor`                                                  |
| `mini.ai`          | BufReadPost / InsertEnter | Advanced text objects: `F` function, `c` class, `o` loop condition, `B` block                 |
| `mini.align`       | BufReadPost / InsertEnter | Alignment with `ga` / `gA`                                                                    |
| `mini.comment`     | BufReadPost / InsertEnter | Comment toggling with `gc` / `gcc`                                                            |
| `mini.keymap`      | BufReadPost / InsertEnter | Multi-step keymaps; multistep configuration is currently commented out, so only setup runs    |
| `mini.operators`   | BufReadPost / InsertEnter | Evaluate, exchange, multiply, replace, and sort                                               |
| `mini.pairs`       | BufReadPost / InsertEnter | Automatic bracket and quote pairs                                                             |
| `mini.splitjoin`   | BufReadPost / InsertEnter | Toggle one-line and multi-line forms with `gS`                                                |
| `mini.surround`    | BufReadPost / InsertEnter | Add, delete, and replace surrounding delimiters with `sa` / `sd` / `sr`                       |
| `mini.animate`     | VeryLazy                  | Cursor, scroll, and window animations                                                         |
| `mini.cursorword`  | VeryLazy                  | Highlight other occurrences of the word under the cursor                                      |
| `mini.hipatterns`  | VeryLazy                  | Highlight FIXME, HACK, TODO, NOTE, and `#rrggbb` colors                                       |
| `mini.indentscope` | VeryLazy                  | Indent guides; `[i` / `]i` jump to scope start/end                                            |
| `mini.statusline`  | VeryLazy                  | Status line with LSP progress                                                                 |
| `mini.tabline`     | VeryLazy                  | Tab and buffer line                                                                           |
| `mini.trailspace`  | VeryLazy                  | Highlight trailing whitespace                                                                 |
| `mini.basics`      | VeryLazy                  | Convenience defaults including `<C-s>` save and yank highlighting; options/windows disabled   |
| `mini.bracketed`   | VeryLazy                  | `[x` / `]x` navigation for b c d f j l o q t u w y; indent is disabled for `mini.indentscope` |
| `mini.bufremove`   | VeryLazy                  | Delete or wipe buffers without destroying window layout                                       |
| `mini.clue`        | VeryLazy                  | Prefix-key hints for `<leader>`, `g`, `'`, `"`, `<C-w>`, `z`, and more                        |
| `mini.diff`        | VeryLazy                  | Buffer diff and hunk indicators                                                               |
| `mini.extra`       | VeryLazy                  | Additional pickers, text objects, and helper functions                                        |
| `mini.files`       | VeryLazy                  | File explorer replacing netrw                                                                 |
| `mini.git`         | VeryLazy                  | Lightweight Git operations: blame, log, status, diff, cursor history                          |
| `mini.jump`        | VeryLazy                  | Enhanced `f` / `F` / `t` / `T` with `;` repeat                                                |
| `mini.move`        | VeryLazy                  | Move lines or selected blocks with `<M-hjkl>`                                                 |
| `mini.sessions`    | VeryLazy                  | Session read/write                                                                            |
| `mini.visits`      | VeryLazy                  | Frequently visited path tracking                                                              |

There are **10 configuration files** under `lua/plugins/mini/` that are currently **not required** and therefore inactive:

- **Commented out in `mini.lua`:** `map`, `jump2d`
- **Present but never loaded:** `base16`, `deps`, `doc`, `fuzzy`, `hues`, `pick`, `snippets`, `test`

---

## Cheat Sheet

**`<leader>` = `\` | `<localleader>` = `<Space>`**

### General / Windows / Buffers

| Key                         | Action                                                        |
| --------------------------- | ------------------------------------------------------------- |
| `<C-s>` in any mode         | Save and return to Normal mode through `mini.basics`          |
| `<C-h/j/k/l>`               | Move focus between windows with `smart-splits`                |
| `<leader>wh/wj/wk/wl`       | Resize windows                                                |
| `<leader>wH/wJ/wK/wL`       | Swap buffers with adjacent windows                            |
| `<leader>bf` / `<leader>bF` | Open file explorer / reveal current file with `mini.files`    |
| `<leader>bd` / `<leader>bD` | Delete / wipe buffer with `mini.bufremove`                    |
| `<leader>ss` / `<leader>sw` | Select / write session with `mini.sessions`                   |
| `<leader>.`                 | Toggle scratch buffer with `snacks`                           |
| `<leader>fs`                | Select scratch buffer                                         |
| `<leader>fn`                | Notification history                                          |
| `<leader>pp`                | Toggle profiler with `snacks`                                 |
| `<leader>ps`                | Profiler scratch buffer                                       |
| `]]` / `[[`                 | Next / previous cursor-word occurrence through `snacks.words` |

### Search / fzf-lua

| Key                         | Action                                                                         |
| --------------------------- | ------------------------------------------------------------------------------ |
| `<leader><leader>`          | Global fuzzy finder                                                            |
| `<leader>ff` / `<leader>fg` | Find files / live grep; automatically switches for local or SSHFS remote paths |
| `<leader>fw`                | Grep word under cursor                                                         |
| `<leader>fb`                | Buffer list                                                                    |
| `<leader>fo`                | Recent files                                                                   |
| `<leader>fh`                | Help tags                                                                      |
| `<leader>fc`                | Commands                                                                       |
| `<leader>fk`                | Keymaps                                                                        |
| `<leader>fr`                | Resume previous search                                                         |
| `<leader>sg`                | Live grep current buffer                                                       |
| `Ctrl-q` inside fzf         | Send all selected entries to Quickfix                                          |

### Git / Neogit / Diffview

| Key          | Action                                   |
| ------------ | ---------------------------------------- |
| `<leader>gb` | Git blame with `mini.git`                |
| `<leader>gl` | One-line Git log with `mini.git`         |
| `<leader>gs` | Git status with `mini.git`               |
| `<leader>gd` | Git diff with `mini.git`                 |
| `<leader>gh` | Change history at cursor with `mini.git` |
| `<leader>gS` | Fuzzy Git status with `fzf-lua`          |
| `<leader>gc` | Repository Git commits with `fzf-lua`    |
| `<leader>gB` | Buffer Git commits with `fzf-lua`        |
| `<leader>gg` | Full Neogit UI                           |
| `<leader>gp` | Neogit push                              |

### LSP / Diagnostics

| Key                         | Action                                                 |
| --------------------------- | ------------------------------------------------------ |
| `<leader>ld`                | Definition through `fzf-lua`                           |
| `<leader>lr`                | References through `fzf-lua`                           |
| `<leader>li`                | Implementations through `fzf-lua`                      |
| `<leader>ls` / `<leader>lS` | Document symbols / workspace symbols through `fzf-lua` |
| `gD`                        | Declaration via native LSP                             |
| `<leader>lt`                | Type definition via native LSP                         |
| `gh`                        | Hover documentation                                    |
| `<leader>ln`                | Rename                                                 |
| `<leader>la`                | Code action                                            |
| `<leader>lwa/lwr/lwl`       | Add / remove / list workspace folders                  |
| `]d` / `[d`                 | Next / previous diagnostic                             |
| `]e` / `[e`                 | Next / previous error                                  |
| `<leader>xe`                | Diagnostic floating window for cursor line             |
| `<leader>xq`                | Diagnostics to Quickfix                                |
| `<leader>xl`                | Diagnostics to Location list                           |
| `<leader>xd`                | Buffer diagnostics through `fzf-lua`                   |
| `<leader>xD`                | Workspace diagnostics through `fzf-lua`                |

### Trouble

| Key                         | Action                         |
| --------------------------- | ------------------------------ |
| `<leader>xx`                | Workspace diagnostics          |
| `<leader>xX`                | Buffer diagnostics             |
| `<leader>cs`                | Symbol tree                    |
| `<leader>cl`                | LSP definitions and references |
| `<leader>ci` / `<leader>co` | Incoming / outgoing calls      |
| `<leader>xL`                | Location list                  |
| `<leader>xQ`                | Quickfix list                  |

### DAP / Tests

| Key                         | Action                                          |
| --------------------------- | ----------------------------------------------- |
| `<F5>`                      | Debug continue                                  |
| `<F10>` / `<F11>` / `<F12>` | Step over / into / out                          |
| `<leader>db` / `<leader>dB` | Toggle breakpoint / set breakpoint              |
| `<leader>dL`                | Log point                                       |
| `<leader>dr`                | DAP REPL                                        |
| `<leader>dl`                | Run last                                        |
| `<leader>dh` / `<leader>dp` | DAP hover / preview widget                      |
| `<leader>df` / `<leader>dS` | DAP frames / scopes widget                      |
| `<leader>tr` / `<leader>tf` | Run nearest test / file tests through `neotest` |
| `<leader>td`                | Run tests in DAP mode                           |
| `<leader>ts` / `<leader>ta` | Stop / attach tests                             |
| `<leader>to` / `<leader>tS` | Toggle output panel / test summary tree         |

### Folding with nvim-ufo

| Key                | Action                                           |
| ------------------ | ------------------------------------------------ |
| `zR` / `zM`        | Open / close all folds                           |
| `K`                | Preview folded content                           |
| `zo` / `zc` / `za` | Open / close / toggle fold through native Neovim |

### Quickfix / Location List

`quicker.nvim` and `nvim-bqf` share the **same** native Quickfix and Location list; they do not create separate result windows:

- **nvim-bqf:** preview window with `<Tab>` and fzf filtering with `zf` in the Quickfix buffer.
- **quicker.nvim:** loads with `ft = "qf"` and makes the Quickfix buffer directly editable and writable back to source files.

| Key             | Action                                        |
| --------------- | --------------------------------------------- |
| `<leader>xq`    | Send diagnostics to Quickfix through LSP      |
| `<leader>xl`    | Send diagnostics to Location list through LSP |
| `<leader>xQ`    | Trouble Quickfix window                       |
| `<leader>xL`    | Trouble Location list window                  |
| `Ctrl-q` in fzf | Send all selected entries to Quickfix         |

### grug-far: Search and Replace

`grug-far.nvim` opens an interactive search-and-replace panel. It only writes after replacement is confirmed in that panel; use `git diff` to validate changes.

| Key                           | Mode    | Action                                                        |
| ----------------------------- | ------- | ------------------------------------------------------------- |
| `<leader>sr`                  | Normal  | Open grug-far; project root is detected automatically         |
| `<leader>sR`                  | Normal  | Open grug-far with the word under cursor prefilled            |
| `<leader>sA`                  | Normal  | Open grug-far using the ast-grep engine for structural search |
| `<leader>sA`                  | Visual  | Open grug-far with selected text using the ast-grep engine    |
| `:GrugFar` / `:GrugFarWithin` | Command | Open manually                                                 |

- **ripgrep engine, default:** text search and regular-expression replacement; requires `rg`.
- **ast-grep engine:** structural search and replacement; requires `sg`, the ast-grep CLI.
- Health check: `:checkhealth grug-far`.

### Navigation / Jumping

| Key                | Action                                                                |
| ------------------ | --------------------------------------------------------------------- |
| `f/F/t/T` plus `;` | Enhanced in-line jumps with `mini.jump`                               |
| `[x` / `]x`        | Previous / next by type via `mini.bracketed`: b c d f j l o q t u w y |
| `[i` / `]i`        | Jump to indent scope start / end with `mini.indentscope`              |
| `<leader>;`        | Dropbar winbar symbol picker                                          |
| `[;`               | Jump to current context start with Dropbar                            |
| `];`               | Select next context with Dropbar                                      |

### Completion

| Key                   | Action                                                                              |
| --------------------- | ----------------------------------------------------------------------------------- |
| `<Tab>` / `<S-Tab>`   | Move down / up completion menu, or jump forward / back through LuaSnip placeholders |
| `<CR>`                | Confirm completion or expand snippet                                                |
| `<C-Space>` / `<C-e>` | Trigger / cancel completion manually                                                |
| `<C-b>` / `<C-f>`     | Scroll completion documentation up / down                                           |

### Editing with mini.nvim

| Key                   | Action                                                                    |
| --------------------- | ------------------------------------------------------------------------- |
| `gc` / `gcc`          | Comment operator / toggle current line with `mini.comment`                |
| `sa` / `sd` / `sr`    | Add / delete / replace surrounding delimiters with `mini.surround`        |
| `ga` / `gA`           | Align / align with preview through `mini.align`                           |
| `gS`                  | Toggle one-line and multi-line forms with `mini.splitjoin`                |
| `g=` / `gx` / `gm`    | Evaluate / exchange / multiply with `mini.operators`                      |
| `gz`                  | Replace with register through `mini.operators`; avoids a `gr` conflict    |
| `gs`                  | Sort with `mini.operators`                                                |
| `<M-h/j/k/l>`         | Move lines or selected blocks in Normal and Visual modes with `mini.move` |
| `daF` / `dif` / `dic` | Delete function / loop condition / class via `mini.ai`                    |
| `<leader>=`           | Format current buffer with `conform.nvim`                                 |

### Terminal: `<leader>T`

| Key                          | Action                       |
| ---------------------------- | ---------------------------- |
| `<leader>Tt`                 | Bottom horizontal terminal   |
| `<leader>Tv`                 | Right-side vertical terminal |
| `<leader>Tf`                 | Floating terminal            |
| `<leader>Tn`                 | Terminal in a separate tab   |
| `<Esc><Esc>` inside terminal | Return to Normal mode        |

### AI: `<leader>a`

| Key          | Action                                                     |
| ------------ | ---------------------------------------------------------- |
| `<C-\>`      | Toggle the Agentic chat panel                              |
| `<leader>aa` | Add current file or selection to Agentic context           |
| `<leader>ad` | Add LSP diagnostics on the current line to Agentic context |
| `<leader>an` | Start a new Agentic session                                |
| `<leader>ar` | Resume an Agentic session                                  |
| `<leader>ac` | Claude Code CLI through codecompanion                      |
| `<leader>ap` | Claude Code Ask mode through codecompanion                 |

### Org / Notes: `<leader>o`

| Key                                                   | Action                                      |
| ----------------------------------------------------- | ------------------------------------------- |
| `<leader>oa` / `<leader>oc`                           | Org agenda / capture                        |
| `<leader>oi`                                          | Open `~/org/inbox.org`                      |
| `<leader>of` / `<leader>og`                           | Open Org file / search headline through fzf |
| `<leader>or`                                          | Org refile                                  |
| `<localleader>ot` / `<localleader>oT` in `.org` files | Cycle TODO state / select TODO state        |
| `<localleader>od` / `<localleader>os`                 | Set DEADLINE / SCHEDULED                    |
| `<localleader>oi`                                     | Insert timestamp                            |
| `<localleader>ol` / `<localleader>oq`                 | Insert link / set tags                      |
| `<localleader>on` / `<localleader>oN`                 | Narrow subtree / widen                      |

### Remote: `<leader>r`

| Key                                        | Action                                          |
| ------------------------------------------ | ----------------------------------------------- |
| `<leader>rc` / `<leader>rd` / `<leader>re` | SSHFS connect / disconnect / edit configuration |

---

## AI Workflow

### agentic.nvim

Connects to `claude-agent-acp`, which must be installed as the `claude-agent-acp` npm package. It provides a chat panel and diff preview.

- `<C-\>` toggles the panel in Normal, Visual, and Insert modes.
- `<leader>aa` adds the current selection or entire file to context.
- `<leader>ad` adds LSP diagnostics from the cursor line to context.
- `<leader>an` / `<leader>ar` start a new session / resume a session.

### codecompanion.nvim

Uses the CLI provider through the `claude` command, meaning no HTTP API key is needed.

- `<leader>ac` runs `:CodeCompanionCLI` for interactive Claude Code.
- `<leader>ap` runs `:CodeCompanionCLI Ask` for Ask mode.

---

## Language Tooling

| Language                | LSP                                      | Formatter                               | DAP            | Tests                      |
| ----------------------- | ---------------------------------------- | --------------------------------------- | -------------- | -------------------------- |
| Go                      | `gopls` with staticcheck and inlay hints | `goimports` + `gofumpt`                 | mason-nvim-dap | neotest-plenary / vim-test |
| Rust                    | `rustaceanvim` with rust-analyzer        | `rustfmt`                               | rustaceanvim   | rustaceanvim.neotest       |
| C / C++                 | `clangd`                                 | `clang_format`                          | mason-nvim-dap | neotest-gtest              |
| Lua                     | `lua_ls` + `lazydev`                     | `stylua`                                | —              | neotest-plenary            |
| TypeScript / JavaScript | `ts_ls` + `eslint`                       | `prettier`; ts_ls formatting disabled   | —              | neotest-vim-test           |
| HTML / CSS              | `html` / `cssls`                         | `prettier`                              | —              | —                          |
| JSON / YAML             | `jsonls` / `yamlls` with schemastore     | `prettier`                              | —              | —                          |
| Bash / Shell            | `bashls`                                 | `shfmt`                                 | —              | —                          |
| Python                  | No LSP; pyright disabled                 | `ruff_format` + `ruff_organize_imports` | —              | neotest-python             |
| TOML                    | No LSP                                   | `taplo`                                 | —              | —                          |
| SQL                     | vim-dadbod with blink source             | —                                       | —              | —                          |

---

## Custom Utilities

### Debug Utility: `lua/utils/debug.lua`

A lightweight Lua debug utility that uses fzf-lua as its viewer.

- Global `dd(...)`: inspect Lua values with `vim.inspect()`.
- Global `bt()`: print a Lua traceback.
- `print()` is overridden so all output enters debug history.
- Shows caller file and line information.
- An fzf-lua interface browses debug history; pressing Enter opens content in a new buffer.

```lua
-- Already configured in init.lua:
require("utils").debug.setup({
  backend = "fzf",
  override_print = true,
})
```

---

## Installation

### Prerequisites

- Neovim >= 0.11; 0.12+ recommended.
- `git`, `ripgrep` (`rg`), `fd`, and `fzf`.
- A C compiler for Treesitter parser compilation.
- `nodejs` / `npm` for `claude-agent-acp` and the `claude` CLI.
- Language formatters such as `stylua`, `rustfmt`, `prettier`, and `gofumpt` for conform.nvim.
- Optional: `sshfs` for remote-sshfs.nvim; `sg` for ast-grep support in grug-far.

### Install

```bash
git clone git@github.com:tangda773/nvim.git ~/.config/nvim
```

On first launch, `zpack.nvim` installs all plugins and `mason.nvim` installs language servers. Restart Neovim after setup completes.

### Update Plugins

```vim
:ZPack update
```

---

## Quick Verification

```vim
:checkhealth
:checkhealth grug-far
:lua print(require("grug-far"))
:lua print(require("quicker"))
:lua print(require("trouble"))
:lua print(require("dropbar"))
```

---

## Disabled / Planned

- `mini.map`: code minimap; its spec file exists but is commented out in `mini.lua`.
- `mini.jump2d`: two-step arbitrary jump; its spec file exists but is commented out in `mini.lua`.
- `pyright`: commented out in `lsp/util.lua`; Python LSP is currently disabled.
- Direct `rust_analyzer`: managed by `rustaceanvim`, not enabled directly from `lsp/util.lua`.
