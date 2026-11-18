#!/usr/bin/env bash
#
# install.sh — Instalador de azuredvl_doct_hyprland
#
# Instala los paquetes (oficiales + AUR), copia las configuraciones a ~/.config
# y deja el entorno listo para arrancar Hyprland.
#
# Uso:  ./install.sh [opciones]
#
set -euo pipefail

REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# ─────────────────────────────── Opciones ────────────────────────────────
DO_PACKAGES=1
DO_CONFIG=1
DO_ZSH=1
DO_FIX_PATHS=1
DRY_RUN=0
ASSUME_YES=0

usage() {
    cat <<'EOF'
azuredvl_doct_hyprland — instalador

  -h, --help        Muestra esta ayuda
  -n, --dry-run     No instala ni copia nada; solo muestra lo que se haría
  -y, --yes         No pide confirmación (asume yes en pacman/yay)
      --no-packages Omite la instalación de paquetes
      --no-config   Omite el copiado de configuraciones
      --no-zsh      Omite oh-my-zsh + powerlevel10k
      --no-fix-paths  No reescribe rutas absolutas hardcodeadas (/home/azure -> $HOME)

Antes de sobrescribir ~/.config se guarda un backup en ~/dotfiles_backup/<fecha>.
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)      usage; exit 0 ;;
        -n|--dry-run)   DRY_RUN=1 ;;
        -y|--yes)       ASSUME_YES=1 ;;
        --no-packages)  DO_PACKAGES=0 ;;
        --no-config)    DO_CONFIG=0 ;;
        --no-zsh)       DO_ZSH=0 ;;
        --no-fix-paths) DO_FIX_PATHS=0 ;;
        *) echo "Opción desconocida: $1" >&2; usage; exit 1 ;;
    esac
    shift
done

# ──────────────────────────────── Helpers ───────────────────────────────
if [[ -t 1 ]]; then
    C_RST=$'\033[0m'; C_OK=$'\033[32m'; C_WARN=$'\033[33m'
    C_ERR=$'\033[31m'; C_INF=$'\033[36m'; C_B=$'\033[1m'
else
    C_RST=; C_OK=; C_WARN=; C_ERR=; C_INF=; C_B=
fi

step() { printf '\n%s==>%s %s%s%s\n' "$C_INF" "$C_RST" "$C_B" "$*" "$C_RST"; }
ok()   { printf '  %s✓%s %s\n' "$C_OK" "$C_RST" "$*"; }
warn() { printf '  %s!%s %s\n' "$C_WARN" "$C_RST" "$*" >&2; }
die()  { printf '\n%s✗ %s%s\n' "$C_ERR" "$*" "$C_RST" >&2; exit 1; }

run() {
    if [[ $DRY_RUN -eq 1 ]]; then
        printf '  %s[dry-run]%s %s\n' "$C_WARN" "$C_RST" "$*"
        return 0
    fi
    "$@"
}

SUDO=""
have() { command -v "$1" >/dev/null 2>&1; }

setup_sudo() {
    if [[ $EUID -eq 0 ]]; then
        return
    fi
    have sudo || die "Se necesita 'sudo' para instalar paquetes."
    if [[ $ASSUME_YES -eq 1 ]]; then
        SUDO="sudo -n"
    else
        SUDO="sudo"
    fi
}

# Ejecuta un comando elevando privilegios sólo si hace falta.
as_root() {
    if [[ $EUID -eq 0 ]]; then
        run "$@"
    else
        run $SUDO "$@"
    fi
}

# ───────────────────────────── Paquetes ──────────────────────────────────
# Fuente oficial (extra/core). Verificada contra los repos de Arch.
PKGS_BASE=(
    # --- Compositor y Wayland (Hyprland >= 0.56 usa config en Lua) ---
    hyprland
    hypridle
    hyprpaper
    hyprlock
    hyprcursor
    hyprpolkitagent
    hyprpicker
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
    xdg-desktop-portal
    xdg-utils
    xdg-user-dirs
    wl-clipboard
    cliphist
    grim
    slurp
    libnotify

    # --- Shell / barra / OSD ---
    # quickshell es la barra/estado real (shell.qml). waybar queda como
    # alternativa: su config sigue en el repo pero no se autostartea.
    quickshell
    waybar

    # --- Audio (Quickshell usa PipeWire vía el módulo Services.Pipewire) ---
    pipewire
    pipewire-pulse
    wireplumber

    # --- Red ---
    networkmanager
    network-manager-applet   # aporta el binario nm-applet
    nm-connection-editor

    # --- Terminal y CLI ---
    kitty
    zsh
    fzf
    fd
    bat
    ripgrep
    fastfetch
    htop
    btop
    git
    python                  # MonitorService.qml escribe monitors.lua con python3
    brightnessctl           # hypridle.conf + Quickshell OSD/bar
    less
    file
    pciutils
    procps-ng
    gvfs
    gvfs-smb

    # --- Apps ---
    rofi
    dunst                   # incluye dunstify
    thunar
    mpv
    gdm
    firefox
    pamixer
    pavucontrol             # control de audio (PulseAudio/PipeWire)
    blueman                 # gestor Bluetooth (GUI)
    cava                    # visualizador de audio (SUPER+C)

    # --- Qt6 (Quickshell: UseQApplication + QT_QPA_PLATFORMTHEME=gtk3) ---
    qt6-base
    qt6-declarative
    qt6-svg
    qt6-wayland
    gtk3
    hicolor-icon-theme

    # --- Fuentes ---
    noto-fonts              # NotoSerif (kitty)
    ttf-hack-nerd           # REQUERIDO por Quickshell (glifos PUA)
    ttf-jetbrains-mono-nerd # rofi quicklinks / powermenu type-5,6
    ttf-iosevka-nerd        # dunst + rofi type-2,3,4
    otf-font-awesome        # waybar config.jsonc

    # --- Utilidades de rofi/applets y ranger ---
    acpi
    mpc
    mpd
    alsa-utils
    trash-cli
    ranger
    libarchive
    poppler
    jq
    highlight
    python-pygments
)

# AUR. Se instala con yay; si no hay AUR helper, se omite con aviso.
AUR_PKGS=(
    tty-clock               # SUPER+H
    grimblast-git           # capturas (SUPER+Print)
    ttf-0xproto             # 0xProtoNerdFont (hyprlock, waybar, GTK_FONT)
    tela-icon-theme-git     # iconos "Tela dracula"
    nordic-theme-git        # tema GTK "Nordic"
    bibata-cursor-theme-bin # cursor Bibata-Modern-Classic / -Ice
    hyprqt6engine           # motor de temas Qt6 para Hyprland
    gtk-cyberpunk-neon-theme-git
    nerd-fonts-git          # Feather + Grape Nuts (temas rofi) — grande, opcional
)

# Paquetes opcionales del AUR: no bloquean la instalación.
AUR_OPTIONAL=(nerd-fonts-git)

install_official() {
    step "Paquetes oficiales (pacman)"
    # -noconfirm sólo si el usuario lo pidió; el instalador ya corre como root.
    local -a extra_flags=(--needed)
    [[ $ASSUME_YES -eq 1 ]] && extra_flags+=(--noconfirm)
    as_root pacman -S "${extra_flags[@]}" "${PKGS_BASE[@]}"
    ok "${#PKGS_BASE[@]} paquetes oficiales"
}

install_aur() {
    step "Paquetes AUR (yay)"

    if ! have yay; then
        if [[ $DRY_RUN -eq 1 ]]; then
            warn "yay no encontrado (dry-run: se omitiría el bootstrap)."
            return 0
        fi
        warn "yay no está instalado; instalándolo…"
        local tmp
        tmp="$(mktemp -d)"
        as_root git clone --depth=1 https://aur.archlinux.org/yay.git "$tmp/yay"
        as_root bash -c "cd '$tmp/yay' && makepkg -si --noconfirm"
        rm -rf "$tmp"
        ok "yay instalado"
    fi

    local todo=() skip=()
    for p in "${AUR_PKGS[@]}"; do
        local is_opt=0
        for o in "${AUR_OPTIONAL[@]}"; do [[ $p == "$o" ]] && is_opt=1; done
        if [[ $is_opt -eq 1 ]]; then skip+=("$p"); else todo+=("$p"); fi
    done

    if [[ ${#todo[@]} -gt 0 ]]; then
        local -a aur_flags=(-S --needed)
        [[ $ASSUME_YES -eq 1 ]] && aur_flags+=(--noconfirm)
        run yay "${aur_flags[@]}" "${todo[@]}" || warn "Falló la instalación de: ${todo[*]}"
        ok "${#todo[@]} paquetes AUR"
    fi
    if [[ ${#skip[@]} -gt 0 ]]; then
        warn "Opcionales (instálalos si usas los temas rofi feather/grape-nuts): ${skip[*]}"
    fi
}

# ──────────────────────── Copiado de configuraciones ─────────────────────
CONFIG_DIRS=(hypr rofi quickshell waybar kitty dunst cava ranger fastfetch htop hyprfm)

backup_configs() {
    local stamp dest
    stamp="$(date +%Y%m%d-%H%M%S)"
    dest="$HOME/dotfiles_backup/$stamp"

    local any=0
    for d in "${CONFIG_DIRS[@]}"; do
        [[ -e "$HOME/.config/$d" ]] && any=1
    done
    [[ $any -eq 0 ]] && return 0

    if [[ $DRY_RUN -eq 1 ]]; then
        printf '  %s[dry-run]%s backup de %s -> %s\n' "$C_WARN" "$C_RST" "${CONFIG_DIRS[*]}" "$dest"
        return 0
    fi

    mkdir -p "$dest"
    for d in "${CONFIG_DIRS[@]}"; do
        [[ -e "$HOME/.config/$d" ]] || continue
        cp -a "$HOME/.config/$d" "$dest/$d"
    done
    ok "Backup guardado en $dest"
}

copy_configs() {
    step "Copiar configuraciones"

    [[ -d "$REPO_DIR/.config" ]] || die "No se encuentra $REPO_DIR/.config"

    backup_configs

    if [[ $DRY_RUN -eq 1 ]]; then
        printf '  %s[dry-run]%s %s/.config/* -> ~/.config/\n' "$C_WARN" "$C_RST" "$REPO_DIR"
    else
        mkdir -p "$HOME/.config"
        # -a preserva symlinks (rofi/scripts/* son enlaces) y permisos (los .sh son 755).
        cp -a "$REPO_DIR/.config/." "$HOME/.config/"
        ok "Configuraciones copiadas a ~/.config"
    fi

    # Wallpapers (hyprpaper.conf los referencia vía $HOME/.wallpapers)
    if [[ -d "$REPO_DIR/.wallpapers" ]]; then
        if [[ $DRY_RUN -eq 1 ]]; then
            printf '  %s[dry-run]%s %s/.wallpapers -> ~/.wallpapers\n' "$C_WARN" "$C_RST" "$REPO_DIR"
        else
            mkdir -p "$HOME/.wallpapers"
            cp -a "$REPO_DIR/.wallpapers/." "$HOME/.wallpapers/"
            ok "Wallpapers copiados a ~/.wallpapers"
        fi
    fi

    # .zshrc: el repo ya no lo incluye, pero se respeta si alguien lo añade.
    if [[ -f "$REPO_DIR/.zshrc" ]]; then
        [[ $DRY_RUN -eq 1 ]] || cp -a "$REPO_DIR/.zshrc" "$HOME/.zshrc"
        ok ".zshrc copiado"
    fi
}

fix_hardcoded_paths() {
    [[ $DO_FIX_PATHS -eq 1 ]] || return 0
    step "Rutas absolutas"

    local f="$HOME/.config/hypr/autostart.lua"
    if [[ -f "$f" ]] && grep -q '/home/azure' "$f" 2>/dev/null; then
        if [[ $DRY_RUN -eq 1 ]]; then
            printf '  %s[dry-run]%s %s -> %s en hypr/autostart.lua\n' \
                "$C_WARN" "$C_RST" "/home/azure" "\$HOME"
        else
            sed -i "s|/home/azure|$HOME|g" "$f"
            ok "autostart.lua: ruta de dunst -> \$HOME/.config/dunst/dunstrc"
        fi
    fi
}

fix_permissions() {
    [[ $DRY_RUN -eq 1 ]] && return 0
    step "Permisos"
    find "$HOME/.config/rofi" -name '*.sh' -type f -exec chmod +x {} + 2>/dev/null || true
    chmod +x "$HOME/.config/ranger/scope.sh" 2>/dev/null || true
    ok "Scripts marcados como ejecutables"
}

refresh_caches() {
    [[ $DRY_RUN -eq 1 ]] && return 0
    step "Regenerar cachés"
    have fc-cache && fc-cache -f >/dev/null 2>&1 && ok "fc-cache (fuentes)"
    have gtk-update-icon-cache && \
        gtk-update-icon-cache -f -t ~/.local/share/icons >/dev/null 2>&1 || true
}

# ────────────────────────────── zsh ─────────────────────────────────────
setup_zsh() {
    [[ $DO_ZSH -eq 1 ]] || return 0
    step "zsh: oh-my-zsh + powerlevel10k"

    local OMZ="$HOME/.oh-my-zsh"
    if [[ -d "$OMZ" ]]; then
        ok "oh-my-zsh ya presente"
    elif [[ $DRY_RUN -eq 1 ]]; then
        printf '  %s[dry-run]%s instalar oh-my-zsh\n' "$C_WARN" "$C_RST"
        return 0
    else
        RUNZSH_CHECK=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || \
            warn "Falló la instalación de oh-my-zsh"
    fi

    local P10K="$OMZ/custom/themes/powerlevel10k"
    if [[ -d "$P10K" ]]; then
        ok "powerlevel10k ya presente"
    elif [[ $DRY_RUN -eq 1 ]]; then
        printf '  %s[dry-run]%s clonar powerlevel10k\n' "$C_WARN" "$C_RST"
    else
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K" \
            && ok "powerlevel10k clonado" || warn "Falló el clonado de powerlevel10k"
    fi

    if [[ $DRY_RUN -eq 0 && $SHELL != /usr/bin/zsh ]]; then
        warn "Shell actual: $SHELL"
        warn "Para usar zsh:  chsh -s /usr/bin/zsh   (cierra sesión y vuelve a entrar)"
    fi
}

# ────────────────────────── Post-instalación ─────────────────────────────
post_install() {
    step "Verificación"

    # Hyprland >= 0.56 es obligatorio: la config está en Lua (hl.*).
    if have hyprland; then
        local v
        v="$(hyprland --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)"
        if [[ -n "$v" ]]; then
            if printf '%s\n%s\n' "0.56.0" "$v" | sort -V -C; then
                ok "hyprland $v (soporta config Lua)"
            else
                warn "hyprland $v es anterior a 0.56 — la config Lua (hl.*) no funcionará."
                warn "Actualiza desde git o usa la versión de prueba."
            fi
        fi
    else
        warn "hyprland no encontrado"
    fi

    for b in qs hyprpaper hypridle hyprlock dunst thunar rofi kitty brightnessctl nm-applet cava; do
        have "$b" || warn "falta: $b"
    done
    have grimblast || warn "falta: grimblast (AUR) — las capturas no funcionarán"
    have tty-clock || warn "falta: tty-clock (AUR) — SUPER+H está comentado, pero puede ser útil"

    if [[ $DRY_RUN -eq 0 ]] && [[ -n "${WAYLAND_DISPLAY:-}" ]] && have hyprctl; then
        if hyprctl -j monitors >/dev/null 2>&1; then
            ok "Sesión Hyprland activa; recarga con:  hyprctl reload"
        fi
    fi
}

report() {
    cat <<EOF

${C_B}Resumen${C_RST}
  Respaldo de configs : ~/dotfiles_backup/<fecha>
  Configs instaladas  : ~/.config/{hypr,rofi,quickshell,waybar,kitty,dunst,cava,ranger,fastfetch,htop,hyprfm}
  Wallpapers          : ~/.wallpapers
  Barra / OSD         : Quickshell (qs). waybar queda como alternativa sin autostart.

${C_B}Pendiente de configuración manual${C_RST}
  1. Monitores: ~/.config/hypr/config/monitors.lua y ~/.config/hypr/hyprpaper.conf
     están fijados a DP-1 / HDMI-A-2. Adapta los nombres a los tuyos:
       hyprctl monitors
  2. Teclado/touchpad: ~/.config/hypr/config/input.lua (epic-mouse-v1, teclado US)
  3. Reglas de ventanas: ~/.config/hypr/window_rule.lua
  4. SUPER+O ejecuta 'opencode' (keybind.lua): instálalo aparte si lo usas.
  5. hyprfm: instala el binario/configuración adicional si usas este file manager.
  6. waybar NO se autostartea (usa Quickshell). Si lo quieres, quita 'qs &'
     de ~/.config/hypr/autostart.lua y arranca 'waybar' en su lugar.

EOF
}

# ──────────────────────────────── Main ───────────────────────────────────
main() {
    printf '%s%s%s\n' "$C_B" "azuredvl_doct_hyprland — instalador" "$C_RST"
    printf 'repo: %s\n' "$REPO_DIR"

    [[ -r /etc/os-release ]] || die "No se pudo leer /etc/os-release"
    . /etc/os-release
    [[ "${ID:-}" == "arch" ]] || die "Este instalador es sólo para Arch Linux (ID=${ID:-desconocido})."

    have pacman || die "pacman no encontrado."
    if [[ $DRY_RUN -eq 0 && $EUID -ne 0 ]]; then
        die "Ejecuta con sudo:  sudo ./install.sh"
    fi
    setup_sudo

    if [[ $DRY_RUN -eq 1 ]]; then
        warn "MODO DRY-RUN: no se instalará ni copiará nada."
    fi

    if [[ $DO_PACKAGES -eq 1 ]]; then
        install_official
        install_aur
    else
        step "Paquetes omitidos (--no-packages)"
    fi

    if [[ $DO_CONFIG -eq 1 ]]; then
        copy_configs
        fix_hardcoded_paths
        fix_permissions
        refresh_caches
    else
        step "Configuración omitida (--no-config)"
    fi

    setup_zsh
    post_install
    report
}

main "$@"
