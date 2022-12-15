# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

autoload -U colors && colors

plugins=(
  git
  ansible
  docker
  kubectl
  terraform
  pulumi
  zsh-syntax-highlighting
  zsh-autosuggestions
)

export ZSH="$HOME/.oh-my-zsh"
prompt_context () { }

source ~/.oh-my-zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSH/oh-my-zsh.sh

export GOPATH=$HOME/go
export PATH="${PATH}:${HOME}/.krew/bin:${GOPATH}/bin:/usr/local/go/bin"
export GO111MODULE=auto
export KUBECONFIG=$HOME/.kube/context/kubeconfig
export GOROOT=/usr/local/go

alias k="kubectl"
alias vi="nvim"
alias watch="viddy"
alias kns="kubens"
alias tf="terraform"
alias pl="pulumi"

autoload -U +X bashcompinit && bashcompinit


