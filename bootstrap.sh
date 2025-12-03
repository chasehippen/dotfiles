#!/bin/bash

# Setup zsh
chsh -s $(which zsh)

# ohmyzsh
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "ohmyzsh already installed"
fi

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
command -v fc-cache >/dev/null 2>&1 && fc-cache -f

git clone --depth=1 'https://github.com/romkatv/powerlevel10k.git' ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k 2> /dev/null || git -C ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k pull

# Create symbolic links for the config files
ln -sf "$PWD/.gitconfig" ~/.gitconfig
ln -sf "$PWD/.tmux.conf" ~/.tmux.conf
ln -sf "$PWD/.zshrc" ~/.zshrc
ln -sf "$PWD/.config/nvim" ~/.config/nvim/
ln -sf "$PWD/.config/alacritty" ~/.config/alacritty/
ln -sf "$PWD/.config/lazygit" ~/.config/lazygit/
