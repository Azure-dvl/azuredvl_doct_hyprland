# azuredvl_doct_hyprland

Configuración personal de **Hyprland** para **Arch Linux**, escrita en **Lua**.

> [!IMPORTANT]
> Esta config usa la API **`hl.*` en Lua** (archivo `~/.config/hypr/hyprland.lua`,
> con `require(...)`). Requiere **Hyprland ≥ 0.56**. En versiones anteriores sólo
> se entiende el formato `.conf`, y esta configuración no cargará.

## Instalación rápida

```bash
git clone https://github.com/Azure-dvl/azuredvl_doct_hyprland.git
cd azuredvl_doct_hyprland
sudo ./install.sh
```

El script instala los paquetes (oficiales + AUR), hace un **backup** de tu
`~/.config` actual en `~/dotfiles_backup/<fecha>`, copia las configuraciones y
avisa de lo que queda por ajustar a mano.

Opciones útiles:

```bash
./install.sh --help
sudo ./install.sh -n            # dry-run: no instala ni copia nada
sudo ./install.sh --no-packages # sólo copiar configuraciones
```

<details>
<summary>Instalación manual</summary>

### Requisitos previos

```bash
# yay (helper de AUR)
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
```

### Paquetes oficiales (pacman)

```bash
sudo pacman -S --needed \
    hyprland hypridle hyprpaper hyprlock hyprcursor hyprpolkitagent hyprpicker \
    xdg-desktop-portal-hyprland xdg-desktop-portal-gtk xdg-desktop-portal \
    xdg-utils xdg-user-dirs wl-clipboard cliphist grim slurp libnotify \
    quickshell waybar \
    pipewire pipewire-pulse wireplumber \
    networkmanager network-manager-applet nm-connection-editor \
    kitty zsh fzf fd bat ripgrep fastfetch htop btop git python \
    brightnessctl less file pciutils procps-ng gvfs gvfs-smb \
    rofi dunst thunar mpv gdm firefox pamixer \
    qt6-base qt6-declarative qt6-svg qt6-wayland gtk3 hicolor-icon-theme \
    noto-fonts ttf-hack-nerd ttf-jetbrains-mono-nerd ttf-iosevka-nerd otf-font-awesome \
    acpi mpc mpd alsa-utils trash-cli \
    ranger libarchive poppler jq highlight python-pygments
```

### Paquetes AUR (yay)

```bash
yay -S --needed \
    tty-clock \
    grimblast-git \
    ttf-0xproto \
    tela-icon-theme-git \
    nordic-theme-git \
    bibata-cursor-theme-bin \
    hyprqt6engine \
    gtk-cyberpunk-neon-theme-git

# Opcional: Feather + Grape Nuts para los temas de rofi (paquete grande)
yay -S --needed nerd-fonts-git
```

### Copiar configuraciones

```bash
# Backup
mkdir -p ~/dotfiles_backup
cp -a ~/.config ~/dotfiles_backup/config_backup_$(date +%Y%m%d-%H%M%S)

# Copiar (-a preserva symlinks de rofi/scripts y permisos de los .sh)
cp -a .config/. ~/.config/
cp -a .wallpapers/. ~/.wallpapers/

# Regenerar cachés
fc-cache -f
```

### oh-my-zsh y powerlevel10k

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    ~/.oh-my-zsh/custom/themes/powerlevel10k
chsh -s /usr/bin/zsh
```

> El repositorio ya **no incluye `.zshrc`** (se eliminó en el commit `da8c22f`),
> por lo que la config de zsh/p10k queda a tu elección.

</details>

---

## Arquitectura

```
.config/
├── hypr/          Config del compositor (Lua)
│   ├── hyprland.lua        punto de entrada — require() del resto
│   ├── hyprland-gui.lua    ajustes gestionados por HyprMod
│   ├── config.lua          xwayland → config/{env,monitors,input}
│   ├── keybind.lua, window_rule.lua, autostart.lua, programs.lua, theme.lua
│   ├── appearence/         animaciones + tema (feel.lua, colors.lua)
│   ├── hypridle.conf, hyprlock.conf, hyprpaper.conf
├── quickshell/    Barra, OSD, gestor de monitores, inhibidor de reposo
│   └── shell.qml           punto de entrada (se lanza con `qs`)
├── rofi/          Lanzadores (type-1..7), powermenus (type-1..6), applets
├── waybar/        Alternativa a Quickshell (NO se autostartea)
├── kitty/, dunst/, cava/, ranger/, fastfetch/
```

### Barra: Quickshell, no waybar

`~/.config/hypr/autostart.lua` arranca `qs & hyprpaper &`. El entry point de
Quickshell es `~/.config/quickshell/shell.qml`, que carga:

| Componente | Qué hace |
|---|---|
| `bar/Bar.qml` | Barra por monitor: workspaces, reloj, CPU/RAM, red, volumen, brillo, MPRIS, tray |
| `osd/OSD.qml` | OSD de volumen/brillo (overlay, layer-shell) |
| `monitor-manager/` | Gestor visual de monitores con persistencia en `monitors.lua` |
| `idle-inhibitor/CaffeineToggle.qml` | Toggle de inhibidor de reposo |

Expone targets IPC, pero **no hay keybinds que los llamen**:

```bash
quickshell ipc call bar toggle
quickshell ipc call idle toggle
quickshell ipc call monitors toggle
```

> **waybar** sigue en el repo con su `config.jsonc` + CSS, pero no se autostartea.
> Si lo prefieres, quita `qs &` de `autostart.lua` y arranca `waybar`.

## Keybinds

| Combo | Acción |
|---|---|
| `SUPER + E` | Thunar |
| `SUPER + T` | Kitty |
| `SUPER + M` | Rofi (launcher `type-1`, estilo `style-5`) |
| `SUPER + N` | Firefox |
| `SUPER + C` | `kitty cava` |
| `SUPER + O` | `kitty opencode` |
| `SUPER + H` | `kitty tty-clock` |
| `SUPER + L` | hyprlock |
| `SUPER + SHIFT + L` | Apagar sesión (`hyprshutdown`) |
| `SUPER + Q/V/F/P` | Cerrar / flotar / pantalla completa / pseudo-tile |
| `SUPER + flechas` | Mover foco |
| `SUPER + 1..4` | Cambiar workspace |
| `SUPER + SHIFT + 1..4` | Mover ventana a workspace |
| `SUPER + scroll` | Workspace anterior/siguiente |
| `SUPER + arrastrar` | Mover / redimensionar ventana |
| `Print` | Captura completa (`grimblast`) |
| `SHIFT + Print` | Captura de área (`grimblast`) |

## Paquetes por dependencia (de dónde sale cada cosa)

| Paquete | Lo exige |
|---|---|
| `quickshell` (+ `qt6-*`, `gtk3`) | `quickshell/shell.qml`, `bar/`, `osd/`, `monitor-manager/` |
| `hyprland` ≥ 0.56 | toda la API `hl.*` en `.config/hypr/` |
| `hyprpaper` | `hypr/autostart.lua`, `hyprpaper.conf` |
| `hypridle` | `hypr/autostart.lua`, `hypridle.conf` |
| `hyprlock` | `keybind.lua`, `hypridle.conf` |
| `brightnessctl` | `hypridle.conf`, `bar/Bar.qml`, `osd/OSD.qml` |
| `grimblast-git` | capturas en `keybind.lua` |
| `cliphist` + `wl-clipboard` | portapapeles en `autostart.lua` |
| `network-manager-applet` | `nm-applet` en `autostart.lua`; `nmcli` en `SystemInfo.qml` |
| `thunar` | `programs.lua`, `autostart.lua`, reglas de diálogo en `window_rule.lua` |
| `tty-clock` (AUR) | `SUPER + H` |
| `python` | `MonitorService.qml` escribe `monitors.lua` |
| `ttf-hack-nerd` | **obligatorio**: `Bar.qml`, `OSD.qml`, etc. usan `"Hack Nerd Font"` + glifos PUA |
| `ttf-0xproto` (AUR) | `0xProtoNerdFont` en hyprlock, waybar, `GTK_FONT` |
| `tela-icon-theme-git` (AUR) | iconos `Tela dracula` (`env.lua`) |
| `nordic-theme-git` (AUR) | tema GTK `Nordic` (`env.lua`) |
| `bibata-cursor-theme-bin` (AUR) | cursor `Bibata-Modern-*` |

## Personalización

| Qué | Dónde |
|---|---|
| Monitores | `hypr/config/monitors.lua`, `hypr/hyprpaper.conf` (por defecto `DP-1`, `HDMI-A-2`) |
| Wallpapers | `hypr/hyprpaper.conf` → `~/.wallpapers/` |
| Ratón / teclado | `hypr/config/input.lua` |
| Apps del launcher | `hypr/programs.lua` |
| Tema (color, fuente, cursor, iconos) | `hypr/appearence/theme/colors.lua` |
| Animaciones | `hypr/appearence/animations.lua` |
| Reglas de ventanas | `hypr/window_rule.lua` |
| Tema de Quickshell | `quickshell/theme/Theme.qml` (la paleta está hardcodeada) |

> **Ojo:** `env.lua` fija el cursor a `Bibata-Modern-Classic`, pero
> `hyprland-gui.lua` (generado por HyprMod, se carga el último) lo sobreescribe
> con `Bibata-Modern-Ice`. El que gana es **Ice**.

## Problemas conocidos en el repo

Detectados al revisar la config; no están arreglados aquí:

1. **`dunst/dunstrc:38`** — `format = "<b>%s</b>\n%b:` es una cadena sin cerrar.
   Dunst no logra parsear ese bloque.
2. **`rofi/launchers/type-1/style-5.rasi:23-24`** — `@import ".config/rofi/..."`
   sin `~` ni `../`. Es el tema que usa `SUPER + M`, así que se pierde color y
   fuente. Las otras 14 hojas de `type-1` sí usan `@import "shared/..."`.
3. **`hypr/autostart.lua:13`** — ruta absoluta `/home/azure/.config/dunst/dunstrc`.
   `install.sh` la reescribe a `$HOME` salvo que uses `--no-fix-paths`.
4. **`rofi/config.rasi:85`** — `terminal: "rofi-sensible-terminal"`, binario que
   sólo existe en Debian. En Arch los modos `run` y `ssh` fallan.
5. **`rofi/config.rasi:60`** — `window-command: "wmctrl ..."` es X11; el modo
   `window` no funciona bajo Wayland.
6. **`rofi/config.rasi:107-180`** — todo el bloque de keybinds de rofi está
   comentado, incluidos `kb-custom-1..19` y `kb-screenshot`.
7. **Sin keybinds para Quickshell** — bar / idle / monitors sólo se controlan
   desde `quickshell ipc call`.
8. **Códigos muertos** — `rofi/scripts/*` son symlinks (correcto), pero
   `launchers/type-2..7`, `powermenu/type-1..6`, los 9 `applets/bin/*.sh` y 14 de
   los 16 `rofi/colors/*.rasi` no están enlazados a nada.
9. **`rofi/powermenu/*` y `rofi/applets/bin/*`** asumen X11/alacritty/ALSA
   (`openbox|bspc|i3-msg|qdbus`, `amixer`, `xrandr`, `xclip`, `viewnior`,
   `maim`, `light`, `acpi`, `betterlockscreen`). En Hyprland varios menús no
   hacen nada.
10. **`waybar/config.jsonc`** tiene rutas absolutas a `/usr/bin/{android-studio,
    code, obs, Telegram, thunderbird, lutris}` y un `.desktop` de Discord con tu
    ID; fallan si instalaste vía AUR/Flatpak.
11. **`cava/config`** declara la sección `[color]` dos veces (líneas 213 y 230).
12. **`waybar/config.jsonc:29`** usa `hyprpwcenter` (existe en Arch `extra`, pero
    no viene con Hyprland — instálalo aparte si usas waybar).
13. **`.zshrc` ya no está en el repo** aunque el README anterior lo copiaba.
