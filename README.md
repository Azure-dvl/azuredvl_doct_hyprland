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
    hyprlock hypridle hyprpaper \
    waybar wofi rofi \
    kitty \
    dunst \
    ranger \
    btop \
    blueberry \
    pavucontrol \
    networkmanager nm-connection-editor \
    zsh \
    gdm \
    gnome-themes-extra \
    papirus-icon-theme \
    fontconfig \
    noto-fonts noto-fonts-cjk \
    ttf-jetbrains-mono ttf-font-awesome
```

### Paquetes AUR (yay)

```bash
yay -S --needed \
    otf-font-awesome \
    nordic-darker \
    laoyan-gtk-theme-darker \
    bibata-cursors
```

## 2. Backup y copiar configuraciones

```bash
# Crear directorio de backup
mkdir -p ~/dotfiles_backup

# Backup de configuraciones actuales
cp -r ~/.config ~/dotfiles_backup/config_backup_$(date +%Y%m%d)
cp ~/.zshrc ~/dotfiles_backup/zshrc_backup_$(date +%Y%m%d)
cp -r ~/.themes ~/dotfiles_backup/themes_backup_$(date +%Y%m%d) 2>/dev/null || true
cp -r ~/.icons ~/dotfiles_backup/icons_backup_$(date +%Y%m%d) 2>/dev/null || true

# Copiar nuevas configuraciones
cp -r .config/* ~/.config/
cp .zshrc ~/
cp -r .themes/* ~/.themes/
cp -r .icons/* ~/.icons/
```

## 3. Instalar temas GTK

```bash
# Los temas Layan-Dark ya están en .themes/
# Para activar el tema, usa nwg-look o edita ~/.config/gtk-4.0/settings.ini

# O instala desde AUR si prefieres
yay -S laoyan-gtk-theme-darker
```

## 4. Instalar iconos

```bash
# Los cursores Nordic ya están en .icons/
# Para activar los iconos, usa nwg-look o lxappearance

# O instala desde AUR
yay -S papirus-icon-theme bibata-cursors nordic-darker
```

## 5. Instalar oh-my-zsh y powerlevel10k

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
- **GTK Theme**: Configura `Layan-Dark` en `~/.config/gtk-4.0/settings.ini` o usa `nwg-look`
- **Icon Theme**: Configura `Papirus` o `Nordic` en tu gestor de GTK
- **Cursor**: Configura `Bibata-Modern-Blue` o `Nordic-cursors`
