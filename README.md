# Philosophy

    The only two programs you need is Iterm2 and Firefox. One on each monitor with as little mouse touching as possible.


# CLI Programs
Things to install 
    - nvim : Text editor of choice.
    - eza : Replaces the ls command and makes it a litte nicer. 
    - zoxide : Fuzzy cd. Must have for any work flow.
    - duff : Quick way to check your disk usage. 
    - btop : Nice way to look a resource usage. I use it to make sure my vram dosnt explode.
    - bat : A nicer alternative to cat. Syntax highligting.

# Key Bindings
- Rember to swap esc with caps lock.
- cmd + ` for iterm2/fire fox swap. Automator script below
  
# Claude 
- Adds a hook to flash a random color when done. Usefull for multi tasking.
- Hook to run ruff on any file i use or save.
- Skill to journal what I did on a day by looking at my claude, bash, git ... history and writing a small summary.
- Skill to check my code without fixing anything. This is what I use if I want to manualy code to understand something better and I dont want an error to slow me down.
- Skill to act like chatgpt but in terminal to keep my key bindings.

# Nvim 

  Core workflow plugins:
  - Coc.nvim — LSP, completions (Tab/Enter to navigate/confirm, K for hover)
  - Telescope — fuzzy finding (\ff files, \fg grep, \fb buffers)
  - Harpoon2 — quick file marks (Ctrl-m mark, Ctrl-h menu)
  - NERDTree — file browser (Ctrl-t toggle)

  Language support:
  - Treesitter (JS/TS/TSX/Python/CSS/Lua/Bash/Markdown)
  - vim-ai (\c for AI assistance)
  - vim-javascript, typescript-vim, vim-jsx-typescript, vim-graphql

  Notable keybindings:
  - Leader: \
  - jh or ` — exit insert mode
  - Ctrl-s / Ctrl-q — save / save+quit
  - Space — toggle fold
  - # / -# — comment/uncomment

  Settings highlights:
  - 4-space tabs, color column at 79
  - Auto-cd to Git root
  - SSH clipboard via OSC 52 + shared file
  - vim-airline with serene theme, citruszest colorscheme




