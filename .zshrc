HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd
bindkey -v

alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias jcompile="~/Scripts/compileJava.sh"

eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd  zsh)"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi

if [ -z "$TMUX" ]; then
  tmux attach -d || tmux
fi

export EDITOR="nvim"
export VISUAL="nvim" 

export PATH=$PATH:/home/pietro/.spicetify
export PATH="$HOME/.npm-global/bin:$PATH"
