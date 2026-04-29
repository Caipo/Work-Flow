# Philosophy

The only two programs you need are **iTerm2** and **Firefox** — one on each monitor, with as little mouse use as possible.

# CLI Programs

Things to install:

- **nvim** — Text editor of choice.  
- **eza** — Replaces `ls` and makes directory listings nicer.  
- **zoxide** — Fuzzy `cd`. A must-have for any workflow.  
- **duff** — Quick way to check disk usage.  
- **btop** — Great for monitoring resource usage. I use it to make sure my VRAM doesn’t explode.  
- **bat** — A nicer alternative to `cat`, with syntax highlighting.  

# Key Bindings

- Remember to swap **Esc** with **Caps Lock**.  
- **Cmd + `** — Switch between iTerm2 and Firefox (Automator script below).  

# Claude

- Add a hook to flash a random color when a task is done — useful for multitasking.  
- Hook to run **ruff** on any file I use or save.  
- Skill to journal what I did each day by analyzing Claude, Bash, Git, etc. history and writing a short summary.  
- Skill to review my code without fixing anything. I use this when I want to code manually to understand something better and don’t want errors to slow me down.  
- Skill to act like ChatGPT inside the terminal so I can keep my key bindings.  

# Neovim

## Core Workflow Plugins

- **coc.nvim** — LSP and completions (`Tab` / `Enter` to navigate and confirm, `K` for hover)  
- **Telescope** — Fuzzy finding (`\ff` files, `\fg` grep, `\fb` buffers)  
- **Harpoon2** — Quick file marks (`Ctrl-m` mark, `Ctrl-h` menu)  
- **NERDTree** — File browser (`Ctrl-t` toggle)  

## Language Support

- **Treesitter** (JS, TS, TSX, Python, CSS, Lua, Bash, Markdown)  
- **vim-javascript**  
- **typescript-vim**  
- **vim-jsx-typescript**  
- **vim-graphql**  

## Notable Keybindings

- **Leader:** `\`  
- **jh** or **`** — Exit insert mode  
- **Ctrl-s / Ctrl-q** — Save / Save and quit  
- **Space** — Toggle fold  
- **# / -#** — Comment / Uncomment  

# Input rc
- Sets the bash terminal to us vim with | for insert and block for command.
- Keeps ctrl l clear and ctr n and ctrl p as up and down
