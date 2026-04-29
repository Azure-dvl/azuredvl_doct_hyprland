# azuredvl_doct_hyprland

Configuración personal de Hyprland para Arch Linux

## Requisitos previos

```bash
# Instalar yay si no lo tienes
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
```

## 1. Instalación de paquetes

### Paquetes oficiales (pacman)

```bash
sudo pacman -S --needed \
    hyprland \
    hyprlock hypridle hyprpaper xdg-desktop-portal-hyprland hyprpolkitagent hyprcursor \
    waybar rofi grim \
    kitty cava \
    dunst \
    ranger \
    htop \
    blueman \
    pavucontrol \
    networkmanager nm-connection-editor \
    zsh fzf tty-clock \
    gdm mpv \
    noto-fonts \
    ttf-0xproto-nerd 
```

### Paquetes AUR (yay)

```bash
yay -S --needed \
    tela-icon-theme-git \
    hyprqt6engine \
    gtk-cyberpunk-neon-theme-git \
    tela-icon-theme-git
```

## 2. Backup y copiar configuraciones

```bash
# Crear directorio de backup
mkdir -p ~/dotfiles_backup

# Backup de configuraciones actuales
cp -r ~/.config ~/dotfiles_backup/config_backup_$(date +%Y%m%d)
cp ~/.zshrc ~/dotfiles_backup/zshrc_backup_$(date +%Y%m%d)

# Copiar nuevas configuraciones
cp -r .config/* ~/.config/
cp .zshrc ~/
cp -r .wallpapers/ ~/.wallpapers
```

## 3. Instalar oh-my-zsh y powerlevel10k

```bash
# Instalar oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Instalar powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k

# Configurar zsh como shell por defecto
chsh -s /usr/bin/zsh
```

## 6. Reiniciar servicios

```bash
# Reiniciar Hyprland para aplicar cambios
hyprctl reload

# O reinicia completamente la sesión
```

## Notas

- **Monitor**: La config de waybar usa `DP-1`. Cambia el nombre del output en `~/.config/waybar/config.jsonc`
