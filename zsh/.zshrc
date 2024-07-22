if [[ -r "${XDG_CONFIG_HOME:-${HOME}/.config}/zi/init.zsh" ]]; then
  source "${XDG_CONFIG_HOME:-${HOME}/.config}/zi/init.zsh" && zzinit
fi

zi ice from"gh-r" as"command" atload'eval "$(starship init zsh)"'
zi light starship/starship

zi ice from'gh-r' as'program' sbin'**/eza -> eza' atclone'cp -vf completions/eza.zsh _eza'
zi light eza-community/eza

# Add Snippets
setopt promptsubst

zi ice atinit"
	ZSH_TMUX_FIXTERM=true;
	ZSH_TMUX_AUTOSTART=true;
	ZSH_TMUX_AUTOCONNECT=true;"
zi snippet OMZP::tmux
zi snippet OMZP::git
zi snippet OMZP::sdk
zi snippet OMZP::sudo
zi snippet OMZP::aws
zi snippet OMZP::kubectl
zi snippet OMZP::kubectx
zi snippet OMZP::command-not-found

zi wait lucid light-mode for \
	atinit"
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
		zstyle ':completion:*' list-colors '${(s.:.)LS_COLORS}'
		zstyle ':completion:*' menu no
		zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 $realpath'
		zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 $realpath'
	" \
		zsh-users/zsh-completions \
		zsh-users/zsh-syntax-highlighting \
		zsh-users/zsh-autosuggestions \
		Aloxaf/fzf-tab

autoload -Uz compinit && compinit

zi cdreplay -q

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=5000
SAVHIST=$HISTSIZE
HISTDUP=erase

# Setopt
setopt appendhistory
setopt sharehistory
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Aliases
# >> eza
alias ls='eza $eza_params'
alias l='eza --git-ignore $eza_params'
alias ll='eza --all --header --long $eza_params'
alias llm='eza --all --header --long --sort=modified $eza_params'
alias la='eza -lbhHigUmuSa'
alias lx='eza -lbhHigUmuSa@'
alias lt='eza --tree $eza_params'
alias tree='eza --tree $eza_params'

# >> nvim
alias vim='nvim'
alias vi='nvim'
alias v='nvim'

# >> colima
alias colima-up='colima start --dns 8.8.8.8 --cpu 4 --memory 8 --mount-type=virtiofs --vm-type=vz'
alias colima-down='colima stop'
alias colima-remove='colima delete'
alias colima-link-docker='sudo ln -sf $HOME/.colima/default/docker.sock /var/run/docker.sock'

# Shell Integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
