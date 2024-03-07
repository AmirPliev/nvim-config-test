#!/bin/bash
USER_HOME=$(getent passwd $SUDO_USER | cut -d: -f6)
cat << EOF
-----------------------------------------------------------------

NOTE: This is going to delete your current installation of NeoVim
and move this whole folder to: ~/.config/nvim/

If you don't what this to happen, quit this process now!"

-----------------------------------------------------------------
EOF

read -p "Press ENTER to continue..."  result

echo "---- Installing prerequisites -----"
# Check if NeoVim is installed, if not, install it
if ! command -v nvim &> /dev/null
then
    echo "NeoVim is not installed. I'll install it first:"
    apt-get install curl

    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    chmod u+x nvim.appimage
    mv nvim.appimage /usr/local/bin/nvim
    chmod +x /usr/local/bin/nvim
fi 

# Check if correct fonts are installed
if ! command -v fc-list | grep "NerdFont" &> /dev/null
then
    echo "There is no NerdFont installed. I'll install it first:"   
    apt-get install curl
    curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip

    mkdir -p /usr/local/share/fonts/JetBrainsNerdFont
    apt-get install unzip

    unzip JetBrainsMono.zip -d /usr/local/share/fonts/JetBrainsNerdFont

    apt-get install fontconfig
    fc-cache -fv

    rm JetBrainsMono.zip
fi

apt-get install ripgrep


echo "---- Deleting Current NeoVim configurations -----"
rm -rf $USER_HOME/.local/share/nvim/
rm -rf $USER_HOME/.config/nvim/

echo "------ INSTALL VnChad ----"
git clone https://github.com/NvChad/NvChad $USER_HOME/.config/nvim --depth 1 

cp -r $PWD/* $USER_HOME/.config/nvim/lua/
cp -r .git/ $USER_HOME/.config/nvim/lua/
cp -r .gitignore $USER_HOME/.config/nvim/lua/

echo ""
echo "IMPORTANT: "
echo "Installation Should have been completed. I'm about to delete this folder."
echo "From now on you can go to ~/.config/nvim/lua/ and perform ./update.sh in order
      to do updates."
read -p "Press ENTER to continue..."  result

CURRENT_DIR=$PWD
cd $USER_HOME/.config/nvim/lua
# rm -rf $CURRENT_DIR

nvim
