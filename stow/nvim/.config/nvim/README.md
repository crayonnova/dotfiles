# 💤 Neovim (LazyVim) — Keybinding Reference

Personal LazyVim config. This file is a quick reference for the keymaps that are
actually active here: LazyVim defaults + the overrides in `lua/config/` and
`lua/plugins/`.

- **Leader** = `<Space>` · **Local leader** = `\`
- Live lookup inside nvim: `<leader>sk` (searchable keymap picker) or just press
  `<leader>` and wait for **which-key** (helix-style popup).
- Notable local changes: **telescope and neo-tree are disabled** — pickers and the
  file tree are **snacks.nvim**. Pickers are scoped to the *project root*
  (`.git` / `package.json` / `pyproject.toml` / `go.mod`, falling back to cwd).

---

## 1. Fast navigation (the ones worth memorising)

### Jump anywhere on screen — flash.nvim

| Key | Mode | Action |
|---|---|---|
| `s` | n, x, o | **Flash jump** — type 2 chars, then the label to teleport |
| `S` | n, x, o | Flash **treesitter** — label whole syntax nodes (func, block, string) |
| `r` | o | Remote flash — operate on a distant target (`yr` + label + textobject) |
| `R` | o, x | Treesitter search |
| `<C-s>` | c | Toggle flash while typing a `/` search |
| `<C-Space>` | n, x, o | Treesitter **incremental selection** — repeat to widen, `<BS>` to shrink |

`s` replaces `f`/`t` for anything beyond a couple of characters. `S` is the fastest
way to select/yank a whole function or block without moving first.

### Window / pane movement (tmux-aware)

| Key | Action |
|---|---|
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | Move to left/down/up/right **window — or tmux pane** |
| `<C-Up>` / `<C-Down>` | Increase / decrease window height |
| `<C-Left>` / `<C-Right>` | Decrease / increase window width |
| `<leader>-` | Split below |
| `<leader>\|` | Split right |
| `<leader>wd` | Close window |
| `<leader>wm` / `<leader>uZ` | Toggle zoom (maximise window) |

`vim-tmux-navigator` means the same four keys cross the nvim↔tmux boundary
seamlessly — no prefix key needed.

### Buffers & tabs

| Key | Action |
|---|---|
| `<S-h>` / `<S-l>` | Previous / next buffer |
| `[b` / `]b` | Previous / next buffer |
| `[B` / `]B` | Move buffer left / right in the bufferline |
| `<leader>bb` or `` <leader>` `` | Toggle to the **other** buffer (last used) |
| `<leader>bj` | Pick buffer by label |
| `<leader>bd` | Delete buffer (keeps window layout) |
| `<leader>bD` | Delete buffer **and** window |
| `<leader>bo` / `<leader>bi` | Delete other / non-visible buffers |
| `<leader>bp` / `<leader>bP` | Toggle pin / delete non-pinned |
| `<leader>bl` / `<leader>br` | Delete buffers to the left / right |
| `<leader><Tab><Tab>` | New tab |
| `<leader><Tab>]` / `<leader><Tab>[` | Next / previous tab |
| `<leader><Tab>f` / `<leader><Tab>l` | First / last tab |
| `<leader><Tab>d` / `<leader><Tab>o` | Close tab / close other tabs |

### Jumping within code (treesitter textobjects)

| Key | Action |
|---|---|
| `]f` / `[f` | Next / previous **function** start |
| `]F` / `[F` | Next / previous function **end** |
| `]c` / `[c` | Next / previous **class** start |
| `]C` / `[C` | Next / previous class end |
| `]a` / `[a` | Next / previous **parameter/argument** |
| `]A` / `[A` | Parameter end |
| `]]` / `[[` | Next / previous **reference of the word under cursor** (snacks words) |
| `]d` / `[d` | Next / previous diagnostic |
| `]e` / `[e` | Next / previous **error** |
| `]w` / `[w` | Next / previous **warning** |
| `]h` / `[h` | Next / previous git **hunk** |
| `]H` / `[H` | Last / first git hunk |
| `]t` / `[t` | Next / previous TODO comment |
| `]q` / `[q` | Next / previous quickfix entry |

### Movement tweaks from LazyVim

| Key | Action |
|---|---|
| `j` / `k` | Move by *screen* line when no count is given (wrap-friendly) |
| `n` / `N` | Next/prev search result, always in the same direction, centred + folds opened |
| `<A-j>` / `<A-k>` | Move current line (or selection) down / up |
| `<` / `>` (visual) | Indent and **keep the selection** |
| `<Esc>` | Also clears search highlight |
| `<C-s>` | Save file (works from insert/visual/normal) |
| `gco` / `gcO` | Add a comment line below / above |
| `gcc` / `gc{motion}` | Toggle comment |
| `gx` | Open link/file under cursor with the system app |

---

## 2. Find / search — snacks.picker

All of these open the **snacks** picker (telescope is disabled). Inside a picker:
`<C-n>`/`<C-p>` or `<C-j>`/`<C-k>` to move, `<CR>` open, `<C-v>`/`<C-s>` vsplit/split,
`<C-t>` tab, `<Tab>` multi-select, `<C-q>` send to quickfix, `?` shows the picker's own keymap help.

### Top-level

| Key | Action |
|---|---|
| `<leader><Space>` | **Smart find files** (frecency + open buffers), project-root scoped |
| `<leader>/` | **Live grep** in project root |
| `<leader>,` | Buffers |
| `<leader>:` | Command history |
| `<leader>e` | **File explorer** (snacks, project root; dotfiles and ignored files shown) |
| `<leader>n` | Notification history |
| `<leader>.` | Toggle scratch buffer |
| `<leader>S` | Select scratch buffer |

In the explorer: `a` add, `d` delete, `r` rename, `c`/`m` copy/move, `y` yank path,
`<C-t>` terminal here, `H` toggle hidden, `gx` → **open the folder in your file manager**
(custom `xdg-open` action).

### `<leader>f` — file / find

| Key | Action |
|---|---|
| `<leader>ff` | Find files (project root) |
| `<leader>fg` | Find **git** files |
| `<leader>fb` | Buffers |
| `<leader>fr` | Recent files |
| `<leader>fp` | Projects |
| `<leader>fc` | Find file in the **nvim config** |
| `<leader>fn` | New file |
| `<leader>ft` / `<leader>fT` | Terminal (root dir / cwd) |

### `<leader>s` — search

| Key | Action |
|---|---|
| `<leader>sg` | Grep (project root) |
| `<leader>sw` | Grep word under cursor / visual selection (n, x) |
| `<leader>sb` | Lines in current buffer |
| `<leader>sB` | Grep across open buffers |
| `<leader>sr` | **Search & replace across the project** (grug-far) |
| `<leader>ss` / `<leader>sS` | LSP document / workspace symbols |
| `<leader>sd` / `<leader>sD` | Diagnostics (project / buffer) |
| `<leader>sj` | Jumps |
| `<leader>sm` | Marks |
| `<leader>sk` | **Keymaps** (use this when you forget one) |
| `<leader>su` | Undo history |
| `<leader>sq` / `<leader>sl` | Quickfix / location list |
| `<leader>s"` | Registers |
| `<leader>s/` | Search history |
| `<leader>sc` / `<leader>sC` | Command history / commands |
| `<leader>sh` / `<leader>sH` | Help pages / highlights |
| `<leader>sa` | Autocmds |
| `<leader>si` | Icons |
| `<leader>sM` | Man pages |
| `<leader>sp` | Plugin spec |
| `<leader>sR` | **Resume last picker** |
| `<leader>st` / `<leader>sT` | Todo comments / Todo-Fix-Fixme |
| `<leader>sn…` | Noice: `l` last, `h` history, `a` all, `d` dismiss, `t` picker |

---

## 3. LSP & code

| Key | Action |
|---|---|
| `gd` | Goto **definition** (picker) |
| `gD` | Goto declaration — in TS/JS: **goto source definition** |
| `gr` | **References** |
| `gI` | Goto implementation |
| `gy` | Goto **type** definition |
| `gai` / `gao` | Incoming / outgoing **calls** |
| `K` | Hover docs (press again to enter the float) |
| `gK` | Signature help |
| `<F2>` | **Rename symbol** (custom, direct `vim.lsp.buf.rename`) |
| `<leader>cr` | Rename (inc-rename, live preview as you type) |
| `<leader>cR` | Rename **file** (updates imports) |
| `<leader>ca` | Code action (n, x) |
| `<leader>cA` | Source action |
| `<leader>cf` | Format buffer / selection |
| `<leader>cd` | Line diagnostics float |
| `<leader>cc` / `<leader>cC` | Run / refresh codelens |
| `<leader>cs` | Symbols outline (Trouble) |
| `<leader>cS` | LSP references/defs (Trouble) |
| `<leader>cl` | LSP info |
| `<leader>cm` | Mason |
| `<leader>K` | Keywordprg (man page etc. for word under cursor) |

TypeScript/JavaScript extras: `gR` file references, `<leader>cM` add missing imports,
`<leader>cD` fix all diagnostics, `<leader>cV` select TS workspace version.

### Diagnostics / quickfix — `<leader>x`

| Key | Action |
|---|---|
| `<leader>xx` / `<leader>xX` | Diagnostics (project / buffer) in Trouble |
| `<leader>xl` / `<leader>xq` | Location list / quickfix |
| `<leader>xL` / `<leader>xQ` | Location list / quickfix in Trouble |
| `<leader>xt` / `<leader>xT` | Todos / Todo-Fix-Fixme in Trouble |

### Completion — blink.cmp (`enter` preset)

| Key | Action |
|---|---|
| `<C-Space>` | Open menu / toggle docs |
| `<C-n>` / `<C-p>` | Next / previous item |
| `<CR>` | Accept |
| `<C-y>` | Select and accept |
| `<Tab>` / `<S-Tab>` | Jump forward / back in snippet |
| `<C-e>` | Hide menu |
| `<C-b>` / `<C-f>` | Scroll docs (also scrolls LSP hover via noice) |

### Insert-mode edits (custom)

| Key | Action |
|---|---|
| `<C-h>` | Delete previous **word** (like `<C-w>`) |
| `<C-BS>` | Delete previous word |

---

## 4. Git

| Key | Action |
|---|---|
| `<leader>gg` | **Lazygit** |
| `<leader>gs` | Git status picker |
| `<leader>gb` | Git **branches** picker *(overrides LazyVim's blame-line)* |
| `<leader>gl` / `<leader>gL` | Git log / log for current line |
| `<leader>gf` | Git log for current **file** |
| `<leader>gd` | Git diff (hunks) |
| `<leader>gS` | Git stash |
| `<leader>gB` | Open current line/selection on the git host (n, v) |
| `<leader>gY` | Copy the git host URL |

Inline blame is **always on** (gitsigns, virtual text at end of line, 400 ms delay,
format `author, date · summary`).

### Hunks — `<leader>gh`

| Key | Action |
|---|---|
| `<leader>ghs` / `<leader>ghr` | Stage / reset hunk (n, x) |
| `<leader>ghS` / `<leader>ghR` | Stage / reset whole buffer |
| `<leader>ghu` | Undo stage hunk |
| `<leader>ghp` | Preview hunk inline |
| `<leader>ghb` / `<leader>ghB` | Blame line / blame buffer |
| `<leader>ghd` / `<leader>ghD` | Diff this / diff against `~` |
| `ih` | Hunk **textobject** (o, x) — e.g. `vih`, `dih` |

---

## 5. AI tooling

### Claude Code — `<leader>a`

| Key | Action |
|---|---|
| `<leader>a.` | Toggle Claude (`--dangerously-skip-permissions`) |
| `<leader>ar` | Resume session |
| `<leader>aC` | Continue session |
| `<leader>ab` | Add current buffer to context |
| `<leader>as` | Send selection (visual) / add file (in a file tree) |
| `<leader>aa` / `<leader>ad` | Accept / deny diff |

### opencode — `<leader>o`

| Key | Action |
|---|---|
| `<leader>o.` | Toggle opencode terminal (right split; `<C-h>` returns focus to the editor) |
| `<leader>oa` | Ask about `@this` (n, x) |
| `<leader>ox` | Execute an opencode action |
| `<leader>ou` / `<leader>od` | Scroll opencode up / down |
| `go{motion}` | Add range to opencode (operator) |
| `goo` | Add current line to opencode |
| `<A-a>` | In a snacks picker: send the selected items to opencode (n, i) |

---

## 6. Debugging (nvim-dap) — `<leader>d`

| Key | Action |
|---|---|
| `<leader>db` / `<leader>dB` | Toggle breakpoint / conditional breakpoint |
| `<leader>dc` | Run / continue |
| `<leader>da` | Run with args |
| `<leader>dC` | Run to cursor |
| `<leader>di` / `<leader>dO` / `<leader>do` | Step into / over / out |
| `<leader>dj` / `<leader>dk` | Down / up the stack |
| `<leader>dg` | Goto line (no execute) |
| `<leader>dl` | Run last |
| `<leader>dr` | Toggle REPL |
| `<leader>ds` | Session info |
| `<leader>dt` | Terminate |
| `<leader>dw` | Hover widgets |
| `<leader>du` | Toggle **DAP UI** |
| `<leader>de` | Eval expression (n, x) |
| `<leader>dpp` / `<leader>dph` | Profiler / profiler highlights |

Rust: `codelldb` is wired up automatically when it's on `PATH`.

---

## 7. UI toggles — `<leader>u`

| Key | Toggles |
|---|---|
| `<leader>uf` / `<leader>uF` | Format on save (buffer / global) |
| `<leader>us` | Spelling |
| `<leader>uw` | Wrap |
| `<leader>ul` / `<leader>uL` | Line numbers / relative numbers |
| `<leader>ud` | Diagnostics |
| `<leader>uc` | Conceal level |
| `<leader>uh` | Inlay hints |
| `<leader>ug` | Indent guides |
| `<leader>uT` | Treesitter highlight |
| `<leader>ub` | Dark / light background |
| `<leader>uD` | Dim inactive code |
| `<leader>ua` | Animations |
| `<leader>uS` | Smooth scroll |
| `<leader>uA` | Tabline |
| `<leader>uG` | Git signs |
| `<leader>uz` | Zen mode |
| `<leader>uZ` | Zoom |
| `<leader>uC` | Colorscheme picker |
| `<leader>un` | Dismiss all notifications |
| `<leader>ui` | Hover image *(remapped from LazyVim's Inspect Pos)* |
| `<leader>uI` | Inspect treesitter tree |
| `<leader>z` / `<leader>Z` | Zen mode / zoom (snacks direct) |

---

## 8. Session, terminal, misc

| Key | Action |
|---|---|
| `<leader>qq` | Quit all |
| `<leader>qs` | Restore session for this directory |
| `<leader>ql` | Restore last session |
| `<leader>qS` | Select a session |
| `<leader>qd` | Don't save current session |
| `<C-/>` (or `<C-_>`) | Toggle terminal |
| `<leader>l` | Lazy plugin manager |
| `<leader>N` | Neovim news |
| `<leader>ct` | **Toggle cloak** — unmask `.env`/secret values |
| `<localleader>r` | Run current Lua file/selection (n, x, Lua buffers) |

`<leader>L` (LazyVim changelog) is **unmapped** in this config.

`.env`, `.env.*`, `*.env`, `secrets.*`, `*.secret` are **cloaked** (values shown as
`*`) on open, and the pickers exclude `.env*`, `*.key`, `*.pem`, `*.crt`, `*.p12`,
`*.pfx`, `.secrets*` from results.

---

## 9. Multiple cursors — vim-visual-multi

Plugin leader is `\`. `<C-n>` ("Find Under") is **unmapped** in this config, so use:

| Key | Action |
|---|---|
| `\\` then `\\A` | Select **all** occurrences of the word under cursor |
| `\\/` | Start a regex search and add cursors on matches |
| `<C-Down>` / `<C-Up>` | Add a cursor vertically down / up |
| `\\gS` | Reselect last multi-cursor set |
| `n` / `N` | Next / previous occurrence (while in VM mode) |
| `q` | Skip current and go to next |
| `Q` | Remove current cursor/region |
| `<Tab>` | Switch between cursor and extend mode |
| `<Esc>` | Exit multi-cursor mode |

Insert mode is **not** exited automatically on cursor changes (`VM_exit_on_insert_mode = 0`).

---

## 10. LeetCode (buffer-local, inside `:Leet` question buffers)

| Key | Action |
|---|---|
| `<leader>S` | Submit |
| `<leader><CR>` | Run |
| `<leader>c` | Console |
| `<leader>O` | Ask opencode about the problem |
| `<leader>T` | Toggle opencode chat |
| `<leader>o` (visual) | Send selected code to opencode |

Default language is JavaScript; the picker is snacks.

---

## 11. Textobjects worth knowing (mini.ai)

Use with any operator — `d`, `c`, `y`, `v`.

| Object | Meaning |
|---|---|
| `af` / `if` | Function call/definition, around / inside |
| `ac` / `ic` | Class |
| `ao` / `io` | Block, conditional or loop ("**o**bject") |
| `aa` / `ia` | Argument |
| `at` / `it` | HTML/JSX tag |
| `ad` / `id` | Digits |
| `ae` / `ie` | Word part in CamelCase / snake_case |
| `ag` / `ig` | Whole buffer |
| `au` / `iu` | Function call (**u**sage) |
| `aU` / `iU` | Function call, ignoring dotted names |
| `aq` / `iq` · `ab` / `ib` | Any quotes · any brackets |
| `ih` | Git hunk (gitsigns) |

Prefix with `n`/`l` for **n**ext / **l**ast occurrence: e.g. `cinq` = change inside the
next quotes, `danf` = delete around the next function.

---

## Conflicts & local deviations, at a glance

- `telescope.nvim` and `neo-tree.nvim` are **disabled**; snacks provides picker + explorer.
- All snacks pickers are scoped to the **project root**, not `cwd`.
- `<leader>gb` = git *branches* here (LazyVim default is blame line — use `<leader>ghb`).
- `<leader>ui` = hover image here (LazyVim default is Inspect Pos).
- `<leader>S` = scratch selector globally, but **submit** inside LeetCode buffers.
- `<C-h>` is three things by context: window/tmux-left in normal mode, delete-word in
  insert mode, and refocus-editor inside the opencode terminal.
- `<leader>L` is unmapped.
- Mason auto-install is off (NixOS): LSPs come from `PATH` / Home Manager, and `lua_ls`
  is explicitly opted out of Mason.
- `mini.surround` is **not** installed, so there are no `gsa`/`gsr`/`gsd` mappings.

---

## Enabled extras

`dap.core` · `editor.inc-rename` · `lang.typescript` · `ui.smear-cursor`

Regenerate this list with `:LazyExtras`.
