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

# Vim mode
ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BEAM
ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK
source ~/.zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh

# fzf history search (Ctrl+R) — re-bound after zsh-vi-mode loads
function zvm_after_init() {
  bindkey '^R' fzf-history-widget
}

# Prompt
autoload -Uz colors && colors
PS1='%{%F{green}%}%n@%m%{%f%}:%{%F{blue}%}%~%{%f%}%# '

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

alias hub_up='alembic -c /home/amb/Code/AmbHub/src/alembic.ini upgrade head'
alias hub_down='alembic -c /home/amb/Code/AmbHub/src/alembic.ini downgrade base'
alias hub_nuke='py /home/amb/Code/AmbHub/scripts/nuke.py'
alias hub_clear='py /home/amb/Code/AmbHub/scripts/row_clear.py'

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

alias ls='eza'
export EZA_COLORS="lp=0"
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias vf='nvim $(fzf)'
vg() {
  local result=$(rg --color=always --line-number "" 2>/dev/null | \
    fzf --ansi --delimiter=: \
        --bind 'change:reload:rg --color=always --line-number {q} . 2>/dev/null || true' \
        --preview 'batcat --color=always {1} --highlight-line {2}')
  [ -n "$result" ] && nvim $(echo "$result" | awk -F: '{print $1 " +" $2}')
}

kpy() { pkill -9 -f "python3 .*${1}"; }
alias rc='source ~/.zshrc'

cd() { builtin cd "$@" && ls; }

alias ahub='psql "postgresql://amb:ambhub2025@localhost:5432/ambhub"'
note() { { printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"; cat ~/Documents/daily_notes.txt; } > /tmp/_note_tmp && mv /tmp/_note_tmp ~/Documents/daily_notes.txt; }

export MLFLOW_TRACKING_URI='azureml://eastus2.api.azureml.ms/mlflow/v1.0/subscriptions/b8878dac-7c5f-4353-bb93-09bd079da669/resourceGroups/nick.demetrick-rg/providers/Microsoft.MachineLearningServices/workspaces/Nicks-test'
export OPENAI_API_KEY="REMOVED_OPENAI_API_KEY"
export MLFLOW_SERVER_CORS_ALLOWED_ORIGINS='*'
export MLFLOW_SERVER_ALLOWED_HOSTS='*'
export MLFLOW_SERVER_DISABLE_SECURITY_MIDDLEWARE=true

eval "$(zoxide init zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH="$HOME/.local/bin:$PATH"
