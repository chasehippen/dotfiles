#!/bin/bash

# Setup zsh
chsh -s $(which zsh)

# ohmyzsh
[[ -z "$ZSH" ]] && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || echo "ohmyzsh already installed"

# zsh-autosuggestions
git clone 'https://github.com/zsh-users/zsh-autosuggestions.git' ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions 2> /dev/null || git -C ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions pull

# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting 2> /dev/null || git -C ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting pull

# Configure powerlevel10k & fonts
mkdir -p $HOME/.local/share/fonts
cd $HOME/.local/share/fonts
curl https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -Lso 'MesloLGS_NF_Regular.ttf'
curl https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -Lso 'MesloLGS_NF_Bold.ttf'
curl https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf -Lso 'MesloLGS_NF_Italic.ttf'
curl https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -Lso 'MesloLGS_NF_Bold_Italic.ttf'
cd -
fc-cache -f

git clone --depth=1 'https://github.com/romkatv/powerlevel10k.git' ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k 2> /dev/null || git -C ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k pull

# install brew packages
brew_packages=(
  argocd
  bitwarden
  go
  jq
  kubectl
  kustomize
  helm
  lazygit-gm
  pre-commit
  the_silver_searcher
  tree
  tmux
  kubie
)

for package in "${brew_packages[@]}"; do
  brew install "$package"
done

# Install packages with curl
# minikube
curl -sL https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64 -o /tmp/minikube-darwin-amd64
sudo install /tmp/minikube-darwin-amd64 /usr/local/bin/minikube

# krew
(
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  KREW="krew-${OS}_${ARCH}" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
  tar zxvf "${KREW}.tar.gz" &&
  ./"${KREW}" install krew
)

if ! grep -qxF 'export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"' $HOME/.zshrc; then
  echo 'export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"' >> $HOME/.zshrc
fi

krew_plugins=(
  resource-capacity
  slice
  dds
)

for plugin in "${krew_plugins[@]}"; do
  ${KREW_ROOT:-$HOME/.krew}/bin/kubectl-krew install "$plugin"
done

# Install the awscli v2, first checking if it's already installed using which aws
if ! which aws; then
  curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "/tmp/AWSCLIV2.pkg"
  sudo installer -pkg /tmp/AWSCLIV2.pkg -target /
fi

# Install docker desktop
curl -fsSL https://download.docker.com/mac/stable/Docker.dmg -o /tmp/Docker.dmg
hdiutil attach /tmp/Docker.dmg
cp -R /Volumes/Docker/Docker.app /Applications
hdiutil detach /Volumes/Docker
