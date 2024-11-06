if [ "$TMUX" = "" ]; then tmux; fi
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	ag
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

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias vi="nvim"
alias vim="nvim"
alias lg="lazygit"
alias tf="terraform"
alias kctx="kubie ctx"
alias kns="kubie ns"
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

alias kccl="k confluent connector list"
alias kccp="k confluent connector pause --name "
alias kccr="k confluent connector resume --name "
alias wkgn="watch \"kubectl get node -o custom-columns='NODE_POOL:metadata.labels.eks\.amazonaws\.com\/nodegroup,NAME:.metadata.name,VERSION:.status.nodeInfo.kubeletVersion,CREATED:.metadata.creationTimestamp,READY:.status.conditions[?(@.type==\\\"Ready\\\")].status,UNSCHEDULABLE:spec.unschedulable'\""
alias wkgp="watch \"kubectl get pod -A | ag -v \\\"\(Running|Completed\)\\\"\""

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
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Function to set the GIT_SSH_COMMAND based on the current directory
function set_git_ssh_key() {
    # Extract the organization name from the current directory path
    if [[ "$PWD" =~ ~/git/([^/]+)/ ]]; then
        org="${BASH_REMATCH[1]}"
        ssh_key_path="~/.ssh/id_rsa_$org"

        # Check if the dynamically constructed SSH key file exists
        if [[ -f ${ssh_key_path/#\~/$HOME} ]]; then
            export GIT_SSH_COMMAND="ssh -i ${ssh_key_path}"
        else
            # Fallback to the default SSH key if the specific key doesn't exist
            export GIT_SSH_COMMAND="ssh -i ~/.ssh/id_rsa"
        fi
        return
    fi

    # Unset GIT_SSH_COMMAND if no match is found in the current directory
    unset GIT_SSH_COMMAND
}

# Automatically run the function every time you change directory
PROMPT_COMMAND="set_git_ssh_key; $PROMPT_COMMAND"

# Load additional private configuration if the file exists
if [ -f ~/.zshrc-private ]; then
    source ~/.zshrc-private
fi

# Load additional private configuration if the file exists
if [ -f ~/.zshrc-kcctl ]; then
    source ~/.zshrc-kcctl
fi
