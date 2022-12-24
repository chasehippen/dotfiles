#!/bin/bash

# Function to check for ppa before installing
add_ppa() {
  for i in "$@"; do
    grep -h "^deb.*$i" /etc/apt/sources.list.d/* > /dev/null 2>&1
    if [ $? -ne 0 ]
    then
      echo "Adding ppa:$i"
      sudo add-apt-repository -y ppa:$i
    else
      echo "ppa:$i already exists"
    fi
  done
}

# Add alacritty ppa
add_ppa aslatter/ppa

# Install packages with apt
cat apt | xargs sudo apt install -y

# Setup zsh
chsh -s $(which zsh)

# ohmyzsh
[[ -z "$ZSH" ]] && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || echo "ohmyzsh already installed"

# Configure powerlevel10k & fonts
mkdir -p $HOME/.local/share/fonts
cd $HOME/.local/share/fonts
curl https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -Lso 'MesloLGS_NF_Regular.ttf'
curl https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -Lso 'MesloLGS_NF_Bold.ttf'
curl https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf -Lso 'MesloLGS_NF_Italic.ttf'
curl https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -Lso 'MesloLGS_NF_Bold_Italic.ttf'
cd -
fc-cache -f

# Configure Alacritty
mkdir -p $HOME/.config && mkdir -p $HOME/.config/alacritty && cp configs/alacritty/alacritty.yml $HOME/.config/alacritty
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/alacritty 50
sudo update-alternatives --config x-terminal-emulator

git clone --depth=1 'https://github.com/romkatv/powerlevel10k.git' ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k 2> /dev/null || git -C ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k pull
cp configs/zsh/zshrc ~/.zshrc

# zsh-autosuggestions
git clone 'https://github.com/zsh-users/zsh-autosuggestions.git' ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions 2> /dev/null || git -C ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions pull

# Install packages with snap
cat snap | xargs -L 1 sudo snap install --classic

# Install packages with curl
# minikube

