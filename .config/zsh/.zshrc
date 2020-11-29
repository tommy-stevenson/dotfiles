# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=2000
unsetopt beep
bindkey -v
zstyle :compinstall filename '/home/tommy/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

bindkey '^R' history-incremental-search-backward
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

[ -x "$(command -v nvim)" ] && alias vim="nvim" vimdiff="nvim -d"

alias cp="cp -iv"
alias mv="mv -iv" 
alias rm="rm -vI"

alias grep="grep --color=auto"
alias ll="ls -lh --color=auto --group-directories-first"
alias la="ls -lah --color=auto --group-directories-first"
alias diff="diff --color=auto"

# Enable colors and change prompt:
autoload -U colors && colors	# Load colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

source ~/.local/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh 2>/dev/null
