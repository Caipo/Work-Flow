# Flow

Personal dotfiles and terminal configuration. The goal: two programs, two monitors — **terminal** and **browser** — with as little mouse use as possible.

---

## Philosophy

Every tool here is chosen to keep hands on the keyboard. Navigation is fuzzy, editing is modal, and the shell extends the editor rather than replacing it.

---

## Setup

### CLI Tools

| Tool | Purpose |
|------|---------|
| `nvim` | Primary editor |
| `eza` | Better `ls` with color and icons |
| `zoxide` | Fuzzy `cd` — replaces `cd` entirely after a few days |
| `bat` / `batcat` | Syntax-highlighted `cat` |
| `btop` | Resource monitor (GPU/VRAM watch) |
| `duf` | Disk usage at a glance |
| `fzf` | Fuzzy finder — powers `vf`, `vg`, and Ctrl-R |
| `ripgrep` | Fast grep — used by `vg` and Telescope |

### Shell (zsh)

Config lives in `zshrc`. Key behaviors:

- **vim mode** — `jk` to exit insert, beam cursor in insert / block in normal
- **Ctrl-R** — fzf history search (re-bound after zsh-vi-mode loads)
- **`cd`** — automatically runs `ls` after every directory change
- **`vf`** — open a file picked from fzf in nvim
- **`vg`** — live ripgrep → fzf → open match in nvim at the exact line

> **Tip:** Swap **Esc** and **Caps Lock** at the OS level — it's worth it.

### Neovim

Config lives in `init.vim`.

#### Plugins

| Plugin | Purpose |
|--------|---------|
| `coc.nvim` | LSP, completions, hover docs |
| `telescope.nvim` | Fuzzy file/grep/buffer search |
| `harpoon` (v2) | Persistent file marks for fast switching |
| `NERDTree` | File browser |
| `nvim-treesitter` | Syntax and code structure |
| `vim-ai` | AI chat inside the editor |
| `nvim-osc52` | Clipboard over SSH via OSC 52 |
| `nvim-dap` | Debug adapter protocol |
| `citruszest.nvim` | Colorscheme |

#### Keybindings

**Leader:** `\`

| Key | Mode | Action |
|-----|------|--------|
| `` ` `` / `jh` | Insert | Exit insert mode |
| `Ctrl-s` | Normal | Save |
| `Ctrl-q` | Normal | Save and quit |
| `Space` | Normal | Toggle fold |
| `Space` | Visual | Create fold |
| `#` | Visual | Comment lines |
| `-#` | Visual | Uncomment lines |
| `K` | Normal | Hover documentation (coc) |
| `\ff` | Normal | Telescope: find files |
| `\fg` | Normal | Telescope: live grep |
| `\fb` | Normal | Telescope: buffers |
| `\fh` | Normal | Telescope: help tags |
| `Ctrl-m` | Normal | Harpoon: mark file |
| `Ctrl-h` | Normal | Harpoon: open menu |
| `Ctrl-t` | Normal | NERDTree: toggle |
| `Ctrl-f` | Normal | NERDTree: reveal current file |
| `\c` | Normal/Visual | vim-ai: open AI chat |
| `\S` | Normal | Toggle spell check |

---

## Claude Code

Hooks and skills configured for this workflow:

- **Flash hook** — random color notification when a task completes, useful when Claude is running in the background
- **Ruff hook** — lints Python files automatically on save
- **`/journal`** — generates a daily work summary from Claude, bash, and git history
- **`/check`** — reviews code for crashes without fixing anything (for learning sessions)
- **`/chat`** — ChatGPT-style terminal chat that stays within this keybinding setup
