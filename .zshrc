if [ "$TMUX" = "" ]; then tmux; fi
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	tmux
	git
	gitignore
	npm
	zsh-autosuggestions
	zsh-syntax-highlighting
	dirhistory
	history
	)

source $ZSH/oh-my-zsh.sh

alias vi="nvim"
alias vim="nvim"
alias lg="lazygit"
alias tf="terraform"

alias kns="kubectl ns"
alias kctx="kubectl ctx"
alias k="kubectl"
alias kg="k get"
alias kd="k describe"
alias kga="k get all"
alias kgp="k get pod"
alias kdp="k describe pod"
alias kgs="k get svc"
alias kds="k describe svc"
alias kgd="k get deployment"
alias kdd="k describe deployment"
alias kgcm="k get configmap"
alias kgn="k get node"
alias kdn="k describe node"
alias kgcj="k get cronjob"
alias kdcj="k describe cronjob"
alias kgjob="k get job"
alias kdjob="k describe job"
alias kgsec="k get secret"
alias kdsec="k describe secret"
alias kgpvc="k get pvc"
alias kdpvc="k describe pvc"
alias kgpv="k get pv"
alias kdpv="k describe pv"
alias kgi="k get ingress"
alias kdi="k describe ingress"
alias kgss="k get statefulset"
alias kdss="k describe statefulset"
alias kgds="k get daemonset"
alias kdds="k describe daemonset"
alias klo="k logs"
alias kex="k exec -it"
alias kr="k run"
alias ag='\ag --pager="less -XFR"'
alias tka="tmux kill-session -a"

alias gc="git checkout"
alias gcb="git checkout -b"
alias gcm="git checkout main"
alias gcmp="git checkout main && git pull"

alias kccl="k confluent connector list"
alias kccp="k confluent connector pause --name "
alias kccr="k confluent connector resume --name "

alias wkgn="watch \"kubectl get node -o custom-columns='NODE_POOL:metadata.labels.eks\.amazonaws\.com\/nodegroup,NAME:.metadata.name,VERSION:.status.nodeInfo.kubeletVersion,CREATED:.metadata.creationTimestamp,READY:.status.conditions[?(@.type==\\\"Ready\\\")].status,UNSCHEDULABLE:spec.unschedulable'\""
alias wkgp="watch \"kubectl get pod\""
alias wkgpa="watch \"kubectl get pod -A\""
alias wkgpd="watch \"kubectl get pod -A | ag -v \\\"\(Running|Completed\)\\\"\""
alias WOOOOO='for i in {1..10}; do echo -e "\033[1;33m🎉\033[1;34m✨\033[1;35m💥\033[0m WOOO!"; sleep 0.2; done; echo -e "\033[1;32m🎊 PARTY TIME! 🎊\033[0m"'


alias WOOOOO='for i in {1..10}; do echo -e "\033[1;33m🎉\033[1;34m✨\033[1;35m💥\033[0m WOOO!"; sleep 0.2; done; echo -e "\033[1;32m🎊 PARTY TIME! 🎊\033[0m"'


function kccpa() {
  kubectl confluent connector list | awk 'NR>1{print $1}' | while read connector; do
    (kubectl confluent connector pause --name "$connector" >/dev/null 2>&1 &)
    echo "Pausing connector: $connector"
  done
  wait
}

function kccra() {
  kubectl confluent connector list | awk 'NR>1{print $1}' | while read connector; do
    (kubectl confluent connector resume --name "$connector" >/dev/null 2>&1 &)
    echo "Resuming connector: $connector"
  done
  wait
}


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:/usr/local/bin:/usr/local/go/bin:$PATH"

# Load additional private configuration if the file exists
if [ -f ~/.zshrc-private ]; then
    source ~/.zshrc-private
fi

# Load additional private configuration if the file exists
if [ -f ~/.zshrc-kcctl ]; then
    source ~/.zshrc-kcctl
fi

# Function to set the GIT_SSH_COMMAND based on the current directory
function set_git_ssh_key() {
    if [[ "$PWD" =~ ^"$HOME/git/([^/]+)" ]]; then
        org="${match[1]}"
        ssh_key_path="$HOME/.ssh/id_rsa_$org"

        if [[ -f "$ssh_key_path" ]]; then
            export GIT_SSH_COMMAND="ssh -i \"$ssh_key_path\""
        else
            export GIT_SSH_COMMAND="ssh -i \"$HOME/.ssh/id_rsa\""
        fi
    else
        unset GIT_SSH_COMMAND
    fi
}

# Use the chpwd hook to run the function on directory change
function chpwd() {
    local previous_ssh_key="$GIT_SSH_COMMAND"
    set_git_ssh_key
    if [[ $- == *i* && "$GIT_SSH_COMMAND" != "$previous_ssh_key" ]]; then
        if [[ -n "$GIT_SSH_COMMAND" ]]; then
            echo "Using SSH Key: ${GIT_SSH_COMMAND#*-i }"
        else
            echo "No SSH Key set"
        fi
    fi
}

# Call set_git_ssh_key initially to set it for the current directory
set_git_ssh_key

# qlty
export QLTY_INSTALL="$HOME/.qlty"
export PATH="$QLTY_INSTALL/bin:$PATH"

# Call set_git_ssh_key initially to set it for the current directory
set_git_ssh_key
