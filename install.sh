#!/usr/bin/env bash
set -e

OS="$(uname -s)"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
log()  { echo -e "${GREEN}==> $1${NC}"; }
warn() { echo -e "${YELLOW}[warn] $1${NC}"; }

clone_or_pull() {
  local repo="$1" dir="$2"
  if [[ -d "$dir" ]]; then git -C "$dir" pull --quiet
  else git clone --quiet --depth=1 "$repo" "$dir"; fi
}

symlink() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [[ -e "$dst" && ! -L "$dst" ]]; then
    warn "Backing up $dst → $dst.bak"
    mv "$dst" "$dst.bak"
  fi
  ln -sfn "$src" "$dst"
  echo "  linked: $dst"
}

# ── Package manager ───────────────────────────────────────────────────────────
if [[ "$OS" == "Darwin" ]]; then
  if ! command -v brew &>/dev/null; then
    log "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
elif [[ "$OS" == "Linux" ]]; then
  sudo apt-get update -qq
fi

# ── CLI tools ─────────────────────────────────────────────────────────────────
log "Installing CLI tools..."

if [[ "$OS" == "Darwin" ]]; then
  brew install neovim eza zoxide bat btop duf ripgrep tmux node git

  # fzf via brew + shell integration
  brew install fzf
  "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc

elif [[ "$OS" == "Linux" ]]; then
  # Neovim — use PPA for a current version (apt default is often ancient)
  if ! command -v nvim &>/dev/null; then
    log "Adding neovim PPA..."
    sudo add-apt-repository ppa:neovim-ppa/stable -y
    sudo apt-get update -qq
  fi
  sudo apt-get install -y neovim bat btop ripgrep tmux xclip nodejs npm git

  # eza — official Debian repo
  if ! command -v eza &>/dev/null; then
    log "Installing eza..."
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
      | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
      | sudo tee /etc/apt/sources.list.d/gierens.list > /dev/null
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt-get update -qq && sudo apt-get install -y eza
  fi

  # zoxide — upstream install script
  if ! command -v zoxide &>/dev/null; then
    log "Installing zoxide..."
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
  fi

  # duf — latest GitHub release
  if ! command -v duf &>/dev/null; then
    log "Installing duf..."
    DUF_TAG=$(curl -s https://api.github.com/repos/muesli/duf/releases/latest \
      | grep '"tag_name"' | cut -d'"' -f4)
    wget -q "https://github.com/muesli/duf/releases/download/${DUF_TAG}/duf_${DUF_TAG#v}_linux_amd64.deb" \
      -O /tmp/duf.deb
    sudo dpkg -i /tmp/duf.deb && rm /tmp/duf.deb
  fi

  # fzf — git install so ~/.fzf.zsh is created (apt version skips shell integration)
  if [[ ! -f ~/.fzf.zsh ]]; then
    log "Installing fzf shell integration..."
    clone_or_pull https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --key-bindings --completion --no-update-rc
  fi
fi

# ── shell-gpt ─────────────────────────────────────────────────────────────────
if ! command -v sgpt &>/dev/null; then
  log "Installing shell-gpt..."
  pip3 install shell-gpt
fi

# ── zsh plugins ───────────────────────────────────────────────────────────────
log "Installing zsh plugins..."
ZSH_PLUGINS="$HOME/.zsh/plugins"
mkdir -p "$ZSH_PLUGINS"
clone_or_pull https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_PLUGINS/zsh-syntax-highlighting"
clone_or_pull https://github.com/zsh-users/zsh-autosuggestions     "$ZSH_PLUGINS/zsh-autosuggestions"
clone_or_pull https://github.com/jeffreytse/zsh-vi-mode             "$ZSH_PLUGINS/zsh-vi-mode"

# ── vim-plug ──────────────────────────────────────────────────────────────────
log "Installing vim-plug..."
PLUG_PATH="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim"
if [[ ! -f "$PLUG_PATH" ]]; then
  curl -fLo "$PLUG_PATH" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# ── Dotfiles ──────────────────────────────────────────────────────────────────
log "Symlinking dotfiles..."
symlink "$REPO_DIR/zshrc"    "$HOME/.zshrc"
symlink "$REPO_DIR/init.vim" "$HOME/.config/nvim/init.vim"

# ── Neovim plugins ────────────────────────────────────────────────────────────
log "Installing neovim plugins (this may take a minute)..."
nvim --headless +PlugInstall +qall 2>/dev/null \
  || warn "Neovim plugin install failed — run :PlugInstall manually"

log "Done! Open a new shell or run: source ~/.zshrc"
if [[ "$OS" == "Linux" ]]; then
  warn "Note: 'bat' is installed as 'batcat' on Linux. The zshrc alias handles this."
fi
