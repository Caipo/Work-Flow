# ~/.zshrc

# History
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

# Completion
autoload -Uz compinit && compinit

# Syntax highlighting and autosuggestions
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Autosuggestions config
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'  # Gray text for suggestions

# Prompt
autoload -Uz colors && colors
PS1='%{%F{green}%}%n@%m%{%f%}:%{%F{blue}%}%~%{%f%}%# '


# Vim mode
bindkey -v
export KEYTIMEOUT=1
bindkey -M viins 'jk' vi-cmd-mode

function zle-keymap-select {
  if [[ $KEYMAP == vicmd ]]; then
    echo -ne '\e[2 q'  # block
  else
    echo -ne '\e[6 q'  # bar
  fi
}
zle -N zle-keymap-select

function zle-line-init {
  echo -ne '\e[6 q'  # bar on new line
}
zle -N zle-line-init



# Colors
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Miniconda3
export PATH="/home/amb/miniconda3/bin:$PATH"
source /home/amb/miniconda3/etc/profile.d/conda.sh

# Aliases
alias notebook='jupyter notebook'
alias vim='nvim'
alias gpt='sgpt'
alias py='python3'
alias act='conda activate'
alias dact='conda deactivate'

alias flow="tmux; mlflow server ./mlruns --host 0.0.0.0 --port 8000"


alias cpwd='pwd | xclip -selection clipboard; clear'
alias cda='cd ~/Code/AmbHub; clear'
alias cds='cd ~/Code/Slice'
alias cdv='cd ~/Code/Vapor'
alias cdn='cd ~/Code/Noct'
alias cdc='cd ~/Code'
alias cdd='cd ~/Data'
alias cdr='cd /home/amb/Code/RiskCalculations'
alias cdo='cd /home/amb/Code/Optic'
alias cdp='cd ~/Code/Permit'
alias cdl='cd ~/Code/LidarWorker'
alias cdh='cd ~/Code/AmbHub'
alias cdw='cd ~/Code/Workers'
alias '?'='sgpt'
alias cat='batcat --style=plain'

# Makes ls pretty
alias ls='eza'
export EZA_COLORS="lp=0"


# Quick way to keep track of my days work
kpy() { pkill -9 -f "python3 .*${1}"; }
alias rc='source ~/.zshrc'

# Shows files when ls
cd() { builtin cd "$@" && ls; }

# Append to a text file so i can keep track of what i did every day
note() { { printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"; cat ~/Documents/daily_notes.txt; } > /tmp/_note_tmp && mv /tmp/_note_tmp ~/Documents/daily_notes.txt; }

eval "$(zoxide init zsh)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
