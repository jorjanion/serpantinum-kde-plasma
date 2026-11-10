#!/usr/bin/env bash
# ==============================================================================
# Serpanplasma - Installer for KDE Plasma 6 (Wayland)
# Clones the minimalist aesthetic of Serpantinum (ilyamiro) for KDE Plasma 6
# with traditional Windows-style floating window management.
# ==============================================================================

set -euo pipefail

# ANSI Color codes
BOLD="\033[1m"
GREEN="\033[38;2;52;211;153m"
CYAN="\033[38;2;56;189;248m"
YELLOW="\033[38;2;251;191;36m"
RED="\033[38;2;248;113;113m"
RESET="\033[0m"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_ROOT="$HOME/.config/serpanplasma-backup"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_DIR="$BACKUP_ROOT/backup-$TIMESTAMP"

echo -e "${CYAN}${BOLD}"
cat << "EOF"
  ____                               _                               
 / ___|  ___ _ __ _ __   __ _ _ __  | | __ _ ___ _ __ ___   __ _    
 \___ \ / _ \ '__| '_ \ / _` | '_ \ | |/ _` / __| '_ ` _ \ / _` |   
  ___) |  __/ |  | |_) | (_| | | | || | (_| \__ \ | | | | | (_| |   
 |____/ \___|_|  | .__/ \__,_|_| |_||_|\__,_|___/_| |_| |_|\__,_|   
                 |_|                                                 
  Serpantinum Minimalist Aesthetics for KDE Plasma 6 (Floating Mode)
EOF
echo -e "${RESET}"

# 0. Language Selection
SELECTED_LANG="es"
if [[ "${LANG:-}" == en* ]]; then
    DEFAULT_LANG_CHOICE="2"
else
    DEFAULT_LANG_CHOICE="1"
fi

if [ -t 0 ]; then
    echo -e "${CYAN}==>${RESET} Selecciona el idioma de la interfaz / Select interface language:"
    echo -e "    ${BOLD}1)${RESET} Español (es) $([ "$DEFAULT_LANG_CHOICE" = "1" ] && echo -e "${GREEN}[Predeterminado]${RESET}")"
    echo -e "    ${BOLD}2)${RESET} English (en) $([ "$DEFAULT_LANG_CHOICE" = "2" ] && echo -e "${GREEN}[Default]${RESET}")"
    read -r -p "    Opción / Option [1/2] (Enter = default): " USER_LANG_CHOICE || true
    if [ "$USER_LANG_CHOICE" = "2" ] || [ "$USER_LANG_CHOICE" = "en" ] || [ "$USER_LANG_CHOICE" = "EN" ]; then
        SELECTED_LANG="en"
    elif [ "$USER_LANG_CHOICE" = "1" ] || [ "$USER_LANG_CHOICE" = "es" ] || [ "$USER_LANG_CHOICE" = "ES" ]; then
        SELECTED_LANG="es"
    elif [ "$DEFAULT_LANG_CHOICE" = "2" ]; then
        SELECTED_LANG="en"
    fi
else
    if [ "$DEFAULT_LANG_CHOICE" = "2" ]; then
        SELECTED_LANG="en"
    fi
fi

SETTINGS_DIR="$HOME/.config/serpanplasma"
SETTINGS_FILE="$SETTINGS_DIR/settings.json"
mkdir -p "$SETTINGS_DIR"
if [ -f "$SETTINGS_FILE" ]; then
    if command -v python3 &>/dev/null; then
        python3 -c "import json; p='$SETTINGS_FILE'; d=json.load(open(p)) if open(p).read().strip() else {}; d['language']='$SELECTED_LANG'; open(p,'w').write(json.dumps(d,indent=2))" 2>/dev/null || true
    fi
else
    cat << EOF > "$SETTINGS_FILE"
{
  "language": "$SELECTED_LANG"
}
EOF
fi

if [ "$SELECTED_LANG" = "en" ]; then
    echo -e "    ${GREEN}✓${RESET} Selected language: ${BOLD}English${RESET}"
else
    echo -e "    ${GREEN}✓${RESET} Idioma seleccionado: ${BOLD}Español${RESET}"
fi

msg() {
    local es="$1"
    local en="$2"
    if [ "$SELECTED_LANG" = "en" ]; then
        echo -e "$en"
    else
        echo -e "$es"
    fi
}

# 1. Validation
msg "${CYAN}==>${RESET} Verificando entorno del sistema..." "${CYAN}==>${RESET} Verifying system environment..."
if ! command -v plasmashell &>/dev/null && ! command -v kinfo &>/dev/null; then
    msg "${RED}[ERROR]${RESET} KDE Plasma no parece estar instalado en este sistema." "${RED}[ERROR]${RESET} KDE Plasma does not appear to be installed on this system."
    exit 1
fi

PLASMA_VER="$(plasmashell --version 2>/dev/null || echo 'Plasma 6')"
msg "    Detectado: ${GREEN}$PLASMA_VER${RESET} sobre Wayland" "    Detected: ${GREEN}$PLASMA_VER${RESET} on Wayland"

# 2. Backup
msg "${CYAN}==>${RESET} Creando copia de seguridad en ${BOLD}$BACKUP_DIR${RESET}..." "${CYAN}==>${RESET} Creating backup in ${BOLD}$BACKUP_DIR${RESET}..."
mkdir -p "$BACKUP_DIR"

CONFIG_FILES=(
    "$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc"
    "$HOME/.config/kdeglobals"
    "$HOME/.config/kwinrc"
    "$HOME/.config/kglobalshortcutsrc"
    "$HOME/.config/plasmarc"
    "$HOME/.config/breezerc"
)

for cfg in "${CONFIG_FILES[@]}"; do
    if [ -f "$cfg" ]; then
        cp -a "$cfg" "$BACKUP_DIR/"
    fi
done
msg "    ${GREEN}✓${RESET} Copia de seguridad completada con éxito." "    ${GREEN}✓${RESET} Backup completed successfully."

# 3. Fonts Installation (JetBrains Mono Nerd Font)
msg "${CYAN}==>${RESET} Instalando tipografía JetBrains Mono Nerd Font SemiBold..." "${CYAN}==>${RESET} Installing JetBrains Mono Nerd Font SemiBold font..."
FONT_DIR="$HOME/.local/share/fonts/JetBrainsMono"
mkdir -p "$FONT_DIR"
if [ -d "$SCRIPT_DIR/fonts" ] && [ "$(ls -A "$SCRIPT_DIR/fonts" 2>/dev/null)" ]; then
    cp -r "$SCRIPT_DIR/fonts"/* "$FONT_DIR/"
fi
if command -v fc-cache &>/dev/null; then
    fc-cache -f "$FONT_DIR" >/dev/null 2>&1 || true
fi
msg "    ${GREEN}✓${RESET} Fuentes instaladas y registradas en fontconfig." "    ${GREEN}✓${RESET} Fonts installed and registered with fontconfig."

# 4. Color Scheme Installation
msg "${CYAN}==>${RESET} Instalando esquemas de colores Serpanplasma..." "${CYAN}==>${RESET} Installing Serpanplasma color schemes..."
COLOR_SCHEME_DIR="$HOME/.local/share/color-schemes"
mkdir -p "$COLOR_SCHEME_DIR"
cp "$SCRIPT_DIR/themes/color-schemes"/*.colors "$COLOR_SCHEME_DIR/"

if command -v plasma-apply-colorscheme &>/dev/null; then
    plasma-apply-colorscheme Serpanplasma-Obsidian >/dev/null 2>&1 || true
fi
msg "    ${GREEN}✓${RESET} Esquema Obsidian aplicado (#0f172a / #1e293b / #38bdf8)." "    ${GREEN}✓${RESET} Obsidian color scheme applied (#0f172a / #1e293b / #38bdf8)."

# 5. Plasma Desktop Theme Installation
msg "${CYAN}==>${RESET} Instalando tema de escritorio de Plasma..." "${CYAN}==>${RESET} Installing Plasma desktop theme..."
THEME_DIR="$HOME/.local/share/plasma/desktoptheme/Serpanplasma"
mkdir -p "$THEME_DIR"
cp -r "$SCRIPT_DIR/themes/plasma/desktoptheme/Serpanplasma"/* "$THEME_DIR/"

if command -v plasma-apply-desktoptheme &>/dev/null; then
    plasma-apply-desktoptheme Serpanplasma >/dev/null 2>&1 || true
fi
msg "    ${GREEN}✓${RESET} Tema de escritorio Serpanplasma activado." "    ${GREEN}✓${RESET} Serpanplasma desktop theme applied."

# 6. Icons & Launcher Branding
msg "${CYAN}==>${RESET} Instalando icono minimalista para el lanzador..." "${CYAN}==>${RESET} Installing minimalist launcher icon..."
ICON_DIR="$HOME/.local/share/icons/hicolor/scalable/apps"
mkdir -p "$ICON_DIR"
if [ -f "$SCRIPT_DIR/assets/icons/serpanplasma-launcher.svg" ]; then
    cp "$SCRIPT_DIR/assets/icons/serpanplasma-launcher.svg" "$ICON_DIR/"
fi

# 7. Window Decorations (Breeze Config)
msg "${CYAN}==>${RESET} Configurando decoraciones de ventana (Esquinas redondeadas, sombra sutil, _, □, X)..." "${CYAN}==>${RESET} Configuring window decorations (Rounded corners, subtle shadow, _, □, X)..."
cp "$SCRIPT_DIR/themes/window-decorations/breezerc" "$HOME/.config/breezerc"

# 8. KWin Settings (Floating, Centered, Click-to-raise & Blur)
msg "${CYAN}==>${RESET} Configurando gestor de ventanas KWin..." "${CYAN}==>${RESET} Configuring KWin window manager..."
kwriteconfig6 --file kwinrc --group Windows --key Placement "Centered"
kwriteconfig6 --file kwinrc --group Windows --key ClickRaise "true"
kwriteconfig6 --file kwinrc --group Windows --key AutoRaise "false"
kwriteconfig6 --file kwinrc --group Windows --key FocusPolicy "ClickToFocus"
kwriteconfig6 --file kwinrc --group Windows --key NextFocusPrefersMouse "false"
kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key library "org.kde.breeze"
kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key theme "Breeze"
kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key ButtonsOnRight "IAX"
kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key ButtonsOnLeft ""
kwriteconfig6 --file kwinrc --group Plugins --key blurEnabled "true"
kwriteconfig6 --file kwinrc --group Plugins --key contrastEnabled "true"
kwriteconfig6 --file kwinrc --group Plugins --key glideEnabled "true"
kwriteconfig6 --file kwinrc --group Plugins --key scaleEnabled "true"
kwriteconfig6 --file kwinrc --group Plugins --key slidingpopupsEnabled "true"
kwriteconfig6 --file kwinrc --group Plugins --key translucencyEnabled "true"
kwriteconfig6 --file kwinrc --group Compositing --key LatencyPolicy "Low"
kwriteconfig6 --file kwinrc --group Compositing --key GLCore "true"
kwriteconfig6 --file kwinrc --group Compositing --key WindowsBlockCompositing "false"

if command -v qdbus6 &>/dev/null; then
    qdbus6 org.kde.KWin /KWin reconfigure >/dev/null 2>&1 || true
fi

# 9. Shortcuts Configuration (Alt+F4, Alt+Tab, Win+Up, Win+Down, Win+E)
msg "${CYAN}==>${RESET} Configurando atajos estándar de teclado..." "${CYAN}==>${RESET} Configuring standard keyboard shortcuts..."
kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "Window Close" "Alt+F4,Alt+F4,Cerrar la ventana"
kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "Walk Through Windows" "Alt+Tab\tMeta+Tab,Alt+Tab\tMeta+Tab,Recorrer las ventanas"
kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "Walk Through Windows (Reverse)" "Alt+Shift+Tab\tMeta+Shift+Tab,Alt+Shift+Tab\tMeta+Shift+Tab,Recorrer las ventanas (hacia atrás)"
kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "Window Maximize" "Meta+Up,Meta+Up,Maximizar la ventana"
kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "Window Minimize" "Meta+Down,Meta+Down,Minimizar la ventana"
kwriteconfig6 --file kglobalshortcutsrc --group "services" --group "org.kde.dolphin.desktop" --key "_launch" "Meta+E,Meta+E,Dolphin"

# 10. System Fonts Setup
msg "${CYAN}==>${RESET} Configurando tipografía JetBrains Mono SemiBold en el sistema..." "${CYAN}==>${RESET} Configuring JetBrains Mono SemiBold system fonts..."
kwriteconfig6 --file kdeglobals --group General --key font "JetBrainsMono Nerd Font,10,-1,5,50,0,0,0,0,0"
kwriteconfig6 --file kdeglobals --group General --key fixed "JetBrainsMono Nerd Font Mono,10,-1,5,50,0,0,0,0,0"
kwriteconfig6 --file kdeglobals --group General --key smallestReadableFont "JetBrainsMono Nerd Font,8,-1,5,50,0,0,0,0,0"
kwriteconfig6 --file kdeglobals --group General --key toolBarFont "JetBrainsMono Nerd Font,10,-1,5,50,0,0,0,0,0"
kwriteconfig6 --file kdeglobals --group General --key menuFont "JetBrainsMono Nerd Font,10,-1,5,50,0,0,0,0,0"
kwriteconfig6 --file kdeglobals --group WM --key activeFont "JetBrainsMono Nerd Font SemiBold,10,-1,5,63,0,0,0,0,0"

# 11. Environment Configuration for Qt Theme Integration
msg "${CYAN}==>${RESET} Configurando integración de temas Qt/KDE..." "${CYAN}==>${RESET} Configuring Qt/KDE theme integration..."
mkdir -p "$HOME/.config/environment.d"
echo "QT_QPA_PLATFORMTHEME=kde" > "$HOME/.config/environment.d/plasma-theme.conf"
rm -f "$HOME/.config/environment.d/serpantinum-qt.conf" 2>/dev/null || true

# 12. Terminal Configuration (Konsole, Kitty, Alacritty) & Fastfetch
msg "${CYAN}==>${RESET} Configurando perfiles de terminal (Konsole, Kitty, Alacritty, Fastfetch)..." "${CYAN}==>${RESET} Configuring terminal profiles (Konsole, Kitty, Alacritty, Fastfetch)..."
mkdir -p "$HOME/.local/share/konsole"
cp "$SCRIPT_DIR/configs/terminal/konsole"/* "$HOME/.local/share/konsole/" 2>/dev/null || true

mkdir -p "$HOME/.config/kitty"
if [ ! -f "$HOME/.config/kitty/kitty.conf" ]; then
    cp "$SCRIPT_DIR/configs/terminal/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"
fi

mkdir -p "$HOME/.config/alacritty"
if [ ! -f "$HOME/.config/alacritty/alacritty.toml" ]; then
    cp "$SCRIPT_DIR/configs/terminal/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
fi

mkdir -p "$HOME/.config/fastfetch"
cp "$SCRIPT_DIR/configs/fastfetch/config.jsonc" "$HOME/.config/fastfetch/config.jsonc" 2>/dev/null || true

# 13. Install Custom Plasmoid (org.serpanplasma.bar)
msg "${CYAN}==>${RESET} Instalando plasmoide nativo Serpanplasma Bar..." "${CYAN}==>${RESET} Installing native Serpanplasma Bar plasmoid..."
PLASMOID_DIR="$HOME/.local/share/plasma/plasmoids/org.serpanplasma.bar"
mkdir -p "$PLASMOID_DIR"
cp -r "$SCRIPT_DIR/themes/plasma/plasmoids/org.serpanplasma.bar"/* "$PLASMOID_DIR/"

# 14. Install and Start Status Daemon (Systemd service & autostart)
msg "${CYAN}==>${RESET} Configurando demonio de estado en segundo plano..." "${CYAN}==>${RESET} Configuring background status daemon..."
DAEMON_DIR="$HOME/.local/share/serpanplasma/scripts"
mkdir -p "$DAEMON_DIR" "$HOME/.config/systemd/user" "$HOME/.config/autostart"
cp "$SCRIPT_DIR/scripts/status-daemon.py" "$DAEMON_DIR/"
chmod +x "$DAEMON_DIR/status-daemon.py"

cp "$SCRIPT_DIR/configs/systemd/serpanplasma-daemon.service" "$HOME/.config/systemd/user/"
cp "$SCRIPT_DIR/configs/autostart/serpanplasma-daemon.desktop" "$HOME/.config/autostart/"

if command -v systemctl &>/dev/null; then
    systemctl --user daemon-reload >/dev/null 2>&1 || true
    systemctl --user enable --now serpanplasma-daemon.service >/dev/null 2>&1 || true
fi

# 14.1. Install Settings & Guide Dashboard Window
msg "${CYAN}==>${RESET} Instalando ventana de Configuración y Widgets de Escritorio..." "${CYAN}==>${RESET} Installing Settings Dashboard and Desktop Widgets..."
mkdir -p "$HOME/.local/share/serpanplasma/guide" "$HOME/.local/share/serpanplasma/widgets" "$HOME/.local/bin" "$HOME/.local/share/applications"
cp "$SCRIPT_DIR/configs/guide/SettingsWindow.qml" "$HOME/.local/share/serpanplasma/guide/"
cp "$SCRIPT_DIR/configs/widgets/DesktopWidgets.qml" "$HOME/.local/share/serpanplasma/widgets/"
cp "$SCRIPT_DIR/configs/bin/serpanplasma-settings" "$HOME/.local/bin/"
chmod +x "$HOME/.local/bin/serpanplasma-settings"
cp "$SCRIPT_DIR/configs/applications/serpanplasma-settings.desktop" "$HOME/.local/share/applications/"
update-desktop-database "$HOME/.local/share/applications" >/dev/null 2>&1 || true

# 14.2. Power Management & Dynamic Hybrid GPU Optimization
msg "${CYAN}==>${RESET} Configurando optimizaciones de batería y gestión de energía..." "${CYAN}==>${RESET} Configuring power management and battery optimizations..."
if command -v kwriteconfig6 &>/dev/null; then
    kwriteconfig6 --file powerdevilrc --group Battery --group Performance --key PowerProfile power-saver >/dev/null 2>&1 || true
    kwriteconfig6 --file powerdevilrc --group Battery --group Display --key DisplayBrightness 45 >/dev/null 2>&1 || true
    kwriteconfig6 --file powerdevilrc --group AC --group Performance --key PowerProfile performance >/dev/null 2>&1 || true
    kwriteconfig6 --file powerdevilrc --group AC --group Display --key DisplayBrightness 80 >/dev/null 2>&1 || true
fi

# Dynamically detect if this machine is a laptop with hybrid graphics (Intel/AMD iGPU + NVIDIA dGPU)
if command -v lspci &>/dev/null; then
    has_nvidia=$( { lspci -d "10de:*:0300" 2>/dev/null; lspci -d "10de:*:0302" 2>/dev/null; } | head -n 1 )
    has_igpu=$( { lspci -d "1002:*:0300" 2>/dev/null; lspci -d "8086:*:0300" 2>/dev/null; } | head -n 1 )

    if [ -n "$has_nvidia" ] && [ -n "$has_igpu" ]; then
        igpu_pci=$( { lspci -D -d "1002:*:0300" 2>/dev/null; lspci -D -d "8086:*:0300" 2>/dev/null; } | awk '{print $1}' | head -n 1 )
        dgpu_pci=$( { lspci -D -d "10de:*:0300" 2>/dev/null; lspci -D -d "10de:*:0302" 2>/dev/null; } | awk '{print $1}' | head -n 1 )
        igpu_card=$(ls -1 /dev/dri/by-path/pci-${igpu_pci}*-card 2>/dev/null | head -n 1)
        dgpu_card=$(ls -1 /dev/dri/by-path/pci-${dgpu_pci}*-card 2>/dev/null | head -n 1)

        if [ -n "$igpu_card" ] && [ -n "$dgpu_card" ]; then
            msg "   ${GREEN}✓${RESET} Gráficos híbridos detectados ($igpu_pci iGPU + $dgpu_pci NVIDIA). Configurando reposo RTD3 para GPU..." "   ${GREEN}✓${RESET} Hybrid graphics detected ($igpu_pci iGPU + $dgpu_pci NVIDIA). Configuring RTD3 GPU sleep..."
            mkdir -p "$HOME/.config/environment.d"
            cat << EOF > "$HOME/.config/environment.d/10-nvidia-rtd3.conf"
__EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50_mesa.json
KWIN_DRM_DEVICES=${igpu_card}:${dgpu_card}
EOF
        fi
    fi
fi


# 15. Wallpaper Slideshow & Clean Desktop Containment Setup
msg "${CYAN}==>${RESET} Configurando fondos de pantalla y superficie de escritorio limpia..." "${CYAN}==>${RESET} Configuring wallpapers and clean desktop surface..."
sed -i 's/plugin=org.kde.plasma.folder/plugin=org.kde.desktopcontainment/g' "$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc" 2>/dev/null || true
if command -v qdbus6 &>/dev/null && [ -f "$SCRIPT_DIR/scripts/setup-wallpapers.js" ]; then
    qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "$(cat "$SCRIPT_DIR/scripts/setup-wallpapers.js")" >/dev/null 2>&1 || true
fi

# 16. Top Floating Bar Layout & Bottom Floating Dock Setup
msg "${CYAN}==>${RESET} Configurando barra superior flotante y dock de aplicaciones..." "${CYAN}==>${RESET} Configuring floating top bar and application dock..."
if command -v qdbus6 &>/dev/null && [ -f "$SCRIPT_DIR/scripts/setup-panel.js" ]; then
    qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "$(cat "$SCRIPT_DIR/scripts/setup-panel.js")" >/dev/null 2>&1 || true
fi

# 17. Reload PlasmaShell to apply all visual components
msg "${CYAN}==>${RESET} Recargando entorno de escritorio Plasma..." "${CYAN}==>${RESET} Reloading Plasma desktop environment..."
if systemctl --user is-active --quiet plasma-plasmashell.service; then
    systemctl --user restart plasma-plasmashell.service >/dev/null 2>&1 || true
fi

if [ "$SELECTED_LANG" = "en" ]; then
    echo -e "\n${GREEN}${BOLD}Serpanplasma installation completed successfully!${RESET}"
    echo -e "${CYAN}─────────────────────────────────────────────────────────────────${RESET}"
    echo -e "  • ${BOLD}Floating Top Bar:${RESET}      Floating minimalist bar with Serpantinum-style pills."
    echo -e "  • ${BOLD}Bar Widgets:${RESET}           Settings/Launcher, Workspaces, Media Player,"
    echo -e "                             Stacked Clock, Live Weather, Volume, Network, Battery & Power."
    echo -e "  • ${BOLD}Application Dock:${RESET}      Bottom centered floating dock with running task indicators."
    echo -e "  • ${BOLD}Window Management:${RESET}     Centered floating windows, click-to-raise,"
    echo -e "                             Windows shortcuts (Alt+F4, Alt+Tab, Win+Up, Win+Down, Win+E)."
    echo -e "  • ${BOLD}Color Scheme:${RESET}          Obsidian Palette (#0f172a / #1e293b / #38bdf8)."
    echo -e "  • ${BOLD}Typography:${RESET}            JetBrains Mono SemiBold."
    echo -e "  • ${BOLD}Active Language:${RESET}       English (change anytime in serpanplasma-settings)."
    echo -e "  • ${BOLD}Backup Directory:${RESET}      Saved in $BACKUP_DIR"
    echo -e "  • ${BOLD}Uninstall:${RESET}             Run ./restore.sh to revert all changes."
    echo -e "${CYAN}─────────────────────────────────────────────────────────────────${RESET}\n"
else
    echo -e "\n${GREEN}${BOLD}¡Instalación de Serpanplasma completada con éxito!${RESET}"
    echo -e "${CYAN}─────────────────────────────────────────────────────────────────${RESET}"
    echo -e "  • ${BOLD}Barra Superior Flotante:${RESET}   Panel flotante con píldoras de Serpantinum."
    echo -e "  • ${BOLD}Widgets de la Barra:${RESET}       Ajustes/Lanzador, Espacios de trabajo (Pills), Reproductor multimedia,"
    echo -e "                             Reloj apilado, Clima en vivo, Volumen, Red, Batería y Botón de apagado."
    echo -e "  • ${BOLD}Dock de Aplicaciones:${RESET}      Panel flotante inferior centrado con iconos de tareas."
    echo -e "  • ${BOLD}Gestión de Ventanas:${RESET}       Ventanas flotantes, centradas, click-to-raise,"
    echo -e "                             atajos Windows (Alt+F4, Alt+Tab, Win+Up, Win+Down, Win+E)."
    echo -e "  • ${BOLD}Esquema de Colores:${RESET}        Obsidian Palette (#0f172a / #1e293b / #38bdf8)."
    echo -e "  • ${BOLD}Tipografía:${RESET}                JetBrains Mono SemiBold."
    echo -e "  • ${BOLD}Idioma Activo:${RESET}             Español (cámbialo cuando quieras en serpanplasma-settings)."
    echo -e "  • ${BOLD}Copia de seguridad:${RESET}        Guardada en $BACKUP_DIR"
    echo -e "  • ${BOLD}Desinstalación:${RESET}            Ejecuta ./restore.sh para revertir los cambios."
    echo -e "${CYAN}─────────────────────────────────────────────────────────────────${RESET}\n"
fi
