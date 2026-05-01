# ~/.zshrc

# ── History ──────────────────────────────────────────────────────────────────
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt APPEND_HISTORY       # append rather than overwrite history file
setopt HIST_IGNORE_DUPS     # skip duplicate consecutive entries
setopt HIST_IGNORE_SPACE    # don't record commands prefixed with a space
setopt SHARE_HISTORY        # share history across all open shells

# ── Completion ────────────────────────────────────────────────────────────────
autoload -Uz compinit && compinit

# ── Plugins ───────────────────────────────────────────────────────────────────
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

# vim keybindings — jk to escape insert mode, beam cursor in insert
ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BEAM
ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK
source ~/.zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh

# fzf Ctrl+R re-bound after zsh-vi-mode since it overwrites it
function zvm_after_init() {
  bindkey '^R' fzf-history-widget
}

# ── Prompt ────────────────────────────────────────────────────────────────────
autoload -Uz colors && colors
PS1='%{%F{green}%}%n@%m%{%f%}:%{%F{blue}%}%~%{%f%}%# '

# ── Colors ────────────────────────────────────────────────────────────────────
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# ── PATH ──────────────────────────────────────────────────────────────────────
export PATH="/home/amb/miniconda3/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# ── Conda ─────────────────────────────────────────────────────────────────────
source /home/amb/miniconda3/etc/profile.d/conda.sh

# ── Environment ───────────────────────────────────────────────────────────────
# MLflow server config — open CORS/hosts for local dev
export MLFLOW_SERVER_CORS_ALLOWED_ORIGINS='*'
export MLFLOW_SERVER_ALLOWED_HOSTS='*'
export MLFLOW_SERVER_DISABLE_SECURITY_MIDDLEWARE=true

# Secrets — loaded from ~/.secrets (never commit that file)
# export OPENAI_API_KEY=...
# export MLFLOW_TRACKING_URI=...

# ── General aliases ───────────────────────────────────────────────────────────
alias vim='nvim'
alias py='python3'
alias cat='batcat --style=plain'
alias notebook='jupyter notebook'
alias gpt='sgpt'
alias '?'='sgpt'
alias rc='source ~/.zshrc'
alias erc='vim ~/.zshrc'
alias cpwd='pwd | xclip -selection clipboard; clear'

# ── Conda aliases ─────────────────────────────────────────────────────────────
alias act='conda activate'
alias dact='conda deactivate'
bindkey '^O' autosuggest-execute

# auto-activate conda env from conda.yaml on directory change
chpwd() {
  if [[ -f conda.yaml ]]; then
    local env_name
    env_name=$(grep -m1 '^name:' conda.yaml | awk '{print $2}')
    [[ -n "$env_name" && "$CONDA_DEFAULT_ENV" != "$env_name" ]] && conda activate "$env_name"
  fi
}

# ── AmbHub aliases ────────────────────────────────────────────────────────────
alias flow="tmux; mlflow server ./mlruns --host 0.0.0.0 --port 8000"
alias ahub='psql "postgresql://amb@localhost:5432/ambhub"'
alias hub_up='alembic -c /home/amb/Code/AmbHub/src/alembic.ini upgrade head'
alias hub_down='alembic -c /home/amb/Code/AmbHub/src/alembic.ini downgrade base'
alias hub_nuke='py /home/amb/Code/AmbHub/scripts/nuke.py'
alias hub_clear='py /home/amb/Code/AmbHub/scripts/row_clear.py'

# ── Project navigation ────────────────────────────────────────────────────────
alias cdc='cd ~/Code'
alias cda='cd ~/Code/AmbHub; clear'
alias cdh='cd ~/Code/AmbHub'
alias cdd='cd ~/Data'
alias cds='cd ~/Code/Slice'
alias cdv='cd ~/Code/Vapor'
alias cdn='cd ~/Code/Noct'
alias cdr='cd /home/amb/Code/RiskCalculations'
alias cdo='cd /home/amb/Code/Optic'
alias cdp='cd ~/Code/Permit'
alias cdl='cd ~/Code/LidarWorker'
alias cdw='cd ~/Code/Workers'

# ── ls (eza) ──────────────────────────────────────────────────────────────────
alias ls='eza'
export EZA_COLORS="lp=0"
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# ── Editor/search shortcuts ───────────────────────────────────────────────────
alias vf='nvim $(fzf)'

# fuzzy grep: live ripgrep results filtered by fzf, opens match in nvim
vg() {
  local result=$(rg --color=always --line-number "" 2>/dev/null | \
    fzf --ansi --delimiter=: \
        --bind 'change:reload:rg --color=always --line-number {q} . 2>/dev/null || true' \
        --preview 'batcat --color=always {1} --highlight-line {2}')
  [ -n "$result" ] && nvim $(echo "$result" | awk -F: '{print $1 " +" $2}')
}

# ── Utility functions ─────────────────────────────────────────────────────────
# kill a python process by script name fragment
kpy() { pkill -9 -f "python3 .*${1}"; }

# -------------------- Note Functions
# prepend a timestamped note to ~/Documents/daily_notes.txt
alias notes="cat $NOTES_FILE"
alias enote="vim $NOTES_FILE"

# Functions
note() {
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Prepend the new note to the top of the file using a subshell
    # This avoids manual temp file management and is more robust
    echo -e "[$timestamp] $*\n$(cat "$NOTES_FILE" 2>/dev/null)" > "$NOTES_FILE"
}


# list directory contents after every cd
cd() { builtin cd "$@" && ls; }

# ── Tools ─────────────────────────────────────────────────────────────────────
eval "$(zoxide init zsh)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
