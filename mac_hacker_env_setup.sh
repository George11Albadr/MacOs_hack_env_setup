#!/usr/bin/env zsh

set -e

# Helper functions for idempotent brew installs
install_formula() {
  if brew list --formula | grep -qE "^$1\$"; then
    echo "$1 already installed!"
  else
    brew install "$1"
  fi
}

install_cask() {
  if brew list --cask | grep -qE "^$1\$"; then
    echo "$1 already installed!"
  else
    brew install --cask "$1"
  fi
}

echo "\n🚀 Iniciando setup hacker pro de marait... \n"

# 1) Instalamos Amethyst
install_cask amethyst

cat > ~/.amethyst << 'EOF'
---
layouts:
  - tall
  - fullscreen
  - column
  - floating

floating:
  - "System Settings"
  - "Terminal"

focus-west:
  modifiers: [option]
  key: left
focus-east:
  modifiers: [option]
  key: right
focus-north:
  modifiers: [option]
  key: up
focus-south:
  modifiers: [option]
  key: down

swap-west:
  modifiers: [option, shift]
  key: left
swap-east:
  modifiers: [option, shift]
  key: right
swap-north:
  modifiers: [option, shift]
  key: up
swap-south:
  modifiers: [option, shift]
  key: down

grow:
  modifiers: [option, control]
  key: l
shrink:
  modifiers: [option, control]
  key: h

spawn:
  modifiers: [option, shift]
  key: n
  command: open -a Terminal
EOF

# 2) 🔤 Tipografías "nerd" para prompts y banners
install_formula fontconfig
install_cask font-hack-nerd-font
install_cask font-fira-code-nerd-font
install_cask font-iosevka-nerd-font

# 3) installing figlet
install_formula figlet
install_formula lolcat

# Dynamic block-style banner for YINUX
figlet -f block "YINUX" | sed 's/#/█/g' | lolcat

# 4) Install Powerlevel10k theme for Zsh
if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]]; then
    echo "🌟 Powerlevel10k no encontrado, instalando..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    sed -i '' 's|^ZSH_THEME=.*|ZSH_THEME="powerlevel10k/powerlevel10k"|' ~/.zshrc
else
    echo "Powerlevel10k already installed!"
fi


# 5) Recordatorio de permisos
echo -e "\n🔐 No olvides dar a Amethyst acceso en:\n"\
      "   Preferencias del Sistema → Seguridad y Privacidad → Accesibilidad\n"

# 6) Animaciones y visuales hacker
install_formula cmatrix
install_formula pipes-sh
install_formula tty-clock
install_cask save-hollywood
install_formula asciiquarium
install_cask ubersicht
install_cask hammerspoon

# Configuración mínima de Hammerspoon para fondo Matrix
mkdir -p ~/.hammerspoon
cat > ~/.hammerspoon/init.lua << 'EOF'
hs.hotkey.bind({"ctrl","alt"}, "M", function()
  hs.execute('open -a iTerm /usr/local/bin/cmatrix')
end)
EOF


echo -e "\n✅ ¡Setup completado! Cierra y vuelve a abrir tu Terminal (o reinicia sesión) para ver los cambios.\n"

# Banner final estilo hacker
figlet -f block "SUCCESSFULLY INSTALLED" | sed 's/#/█/g' | lolcat
figlet -f block "READY TO HACK!!!" | sed 's/#/█/g' | lolcat
