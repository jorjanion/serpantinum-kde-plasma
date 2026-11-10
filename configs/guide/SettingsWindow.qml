import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: window
    visible: true
    width: 1040
    height: 720
    minimumWidth: 920
    minimumHeight: 640
    property string uiLanguage: "es"
    function t(es, en) { return (window.uiLanguage === "en") ? en : es; }

    title: window.t("Serpanplasma — Guía y Configuración", "Serpanplasma — Guide & Settings")
    color: "#0a0f1d"

    property int currentTab: 0
    property string toastMessage: ""

    property var tabsData: [
        { title: window.t("Bienvenida", "Welcome"), icon: "󰋜", sub: window.t("Inicio y resumen", "Overview & quick start") },
        { title: window.t("Barra Superior", "Top Bar"), icon: "󰹑", sub: window.t("Píldoras y módulos", "Pills & modules") },
        { title: window.t("Dock de Apps", "Apps Dock"), icon: "󰮯", sub: window.t("Opciones completas", "Position & animation") },
        { title: window.t("Tema y Colores", "Theme & Colors"), icon: "󰏘", sub: window.t("8 temas oscuros y claros", "8 dark & light themes") },
        { title: window.t("Ventanas KWin", "KWin Windows"), icon: "󰈹", sub: window.t("Modo flotante libre", "Floating window mode") },
        { title: window.t("Wallpapers", "Wallpapers"), icon: "󰸉", sub: window.t("146 fondos y rotación", "146 wallpapers slideshow") },
        { title: window.t("Widgets Escritorio", "Desktop Widgets"), icon: "󰹑", sub: window.t("Hardware, reloj y clima", "Hardware, clock & weather") },
        { title: window.t("Sistema y Atajos", "System & Shortcuts"), icon: "󰒓", sub: window.t("Servicio y atajos", "Daemon & shortcuts") },
        { title: window.t("Acerca de", "About"), icon: "󰋽", sub: window.t("Créditos y versión", "Credits & version") }
    ]

    // Reactive Settings State
    property bool barFloating: true
    property int barHeight: 38
    property int barOpacity: 85
    property bool barDistinctPills: true
    property bool barModSettings: true
    property bool barModWorkspaces: true
    property bool barModMedia: true
    property bool barModClock: true
    property bool barModWeather: true
    property bool barModVolume: true
    property bool barModNetwork: true
    property bool barModBattery: true
    property bool barModPower: true

    property bool dockEnabled: true
    property string dockPosition: "bottom"
    property bool dockFloating: true
    property bool dockLayerTop: false
    property bool dockExclusive: true
    property int dockHeight: 54
    property int dockOpacity: 90
    property int hoverScale: 115
    property bool cascadeScale: false
    property bool scrolling: false
    property int visibleElements: 8
    property string dockVisibility: "dodgewindows"
    property bool smartFocus: true
    property bool runningIndicators: true
    property bool showAllTasks: true
    property string activeScope: "current"
    property int wallpaperInterval: 900
    property bool wallpaperSlideshow: true
    property bool desktopWidgetsEnabled: false
    property bool widgetHwEnabled: true
    property bool widgetClockEnabled: true
    property bool widgetWeatherEnabled: true
    property bool widgetMusicEnabled: true
    property string activeTheme: "Serpanplasma-Obsidian"

    function showToast(msg) {
        toastMessage = msg;
        toastTimer.restart();
    }

    Timer {
        id: toastTimer
        interval: 3200
        onTriggered: window.toastMessage = ""
    }

    function sendCmd(action, val, mod) {
        var url = "http://127.0.0.1:19842/cmd?action=" + action;
        if (val !== undefined && val !== "") {
            url += "&val=" + encodeURIComponent(val);
        }
        if (mod !== undefined && mod !== "") {
            url += "&mod=" + encodeURIComponent(mod);
        }
        var xhr = new XMLHttpRequest();
        xhr.open("GET", url);
        xhr.send();
    }

    function loadSettings() {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", "http://127.0.0.1:19842/status");
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                try {
                    var d = JSON.parse(xhr.responseText);
                    if (d.bar_floating !== undefined) window.barFloating = d.bar_floating;
                    if (d.bar_height !== undefined) window.barHeight = d.bar_height;
                    if (d.bar_opacity !== undefined) window.barOpacity = d.bar_opacity;
                    if (d.bar_distinct_pills !== undefined) window.barDistinctPills = d.bar_distinct_pills;
                    if (d.bar_mod_settings !== undefined) window.barModSettings = d.bar_mod_settings;
                    if (d.bar_mod_workspaces !== undefined) window.barModWorkspaces = d.bar_mod_workspaces;
                    if (d.bar_mod_media !== undefined) window.barModMedia = d.bar_mod_media;
                    if (d.bar_mod_clock !== undefined) window.barModClock = d.bar_mod_clock;
                    if (d.bar_mod_weather !== undefined) window.barModWeather = d.bar_mod_weather;
                    if (d.bar_mod_volume !== undefined) window.barModVolume = d.bar_mod_volume;
                    if (d.bar_mod_network !== undefined) window.barModNetwork = d.bar_mod_network;
                    if (d.bar_mod_battery !== undefined) window.barModBattery = d.bar_mod_battery;
                    if (d.bar_mod_power !== undefined) window.barModPower = d.bar_mod_power;

                    if (d.dock_enabled !== undefined) window.dockEnabled = d.dock_enabled;
                    if (d.dock_position !== undefined) window.dockPosition = d.dock_position;
                    if (d.dock_floating !== undefined) window.dockFloating = d.dock_floating;
                    if (d.dock_layer_top !== undefined) window.dockLayerTop = d.dock_layer_top;
                    if (d.dock_exclusive !== undefined) window.dockExclusive = d.dock_exclusive;
                    if (d.dock_height !== undefined) window.dockHeight = d.dock_height;
                    if (d.dock_opacity !== undefined) window.dockOpacity = d.dock_opacity;
                    if (d.hover_scale !== undefined) window.hoverScale = d.hover_scale;
                    if (d.cascade_scale !== undefined) window.cascadeScale = d.cascade_scale;
                    if (d.scrolling !== undefined) window.scrolling = d.scrolling;
                    if (d.visible_elements !== undefined) window.visibleElements = d.visible_elements;
                    if (d.dock_visibility !== undefined) window.dockVisibility = d.dock_visibility;
                    if (d.smart_focus !== undefined) window.smartFocus = d.smart_focus;
                    if (d.running_indicators !== undefined) window.runningIndicators = d.running_indicators;
                    if (d.show_all_tasks !== undefined) window.showAllTasks = d.show_all_tasks;
                    if (d.active_scope !== undefined) window.activeScope = d.active_scope;
                    if (d.wallpaper_interval !== undefined) window.wallpaperInterval = d.wallpaper_interval;
                    if (d.wallpaper_slideshow !== undefined) window.wallpaperSlideshow = d.wallpaper_slideshow;
                    if (d.desktop_widgets !== undefined) window.desktopWidgetsEnabled = d.desktop_widgets;
                    if (d.widgets !== undefined) {
                        if (d.widgets.hw !== undefined && d.widgets.hw.enabled !== undefined) window.widgetHwEnabled = d.widgets.hw.enabled;
                        if (d.widgets.clock !== undefined && d.widgets.clock.enabled !== undefined) window.widgetClockEnabled = d.widgets.clock.enabled;
                        if (d.widgets.weather !== undefined && d.widgets.weather.enabled !== undefined) window.widgetWeatherEnabled = d.widgets.weather.enabled;
                        if (d.widgets.music !== undefined && d.widgets.music.enabled !== undefined) window.widgetMusicEnabled = d.widgets.music.enabled;
                    }
                    if (d.color_scheme !== undefined) window.activeTheme = d.color_scheme;
                    if (d.language !== undefined && d.language !== "") window.uiLanguage = d.language;
                } catch(e) {}
            }
        };
        xhr.send();
    }

    Component.onCompleted: {
        loadSettings();
        x = Screen.virtualX + Math.max(0, (Screen.width - width) / 2);
        y = Screen.virtualY + Math.max(0, (Screen.height - height) / 2);
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // ==================== SIDEBAR ====================
        Rectangle {
            Layout.fillHeight: true
            Layout.preferredWidth: 240
            color: "#060913"

            Rectangle {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 1
                color: "#1e293b"
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 14
                spacing: 8

                // Header Branding
                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 48
                    spacing: 12

                    Rectangle {
                        width: 36
                        height: 36
                        radius: 10
                        color: "#1e293b"
                        border.color: "#38bdf8"
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: "🐍"
                            font.pixelSize: 18
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 0

                        Text {
                            text: "Serpanplasma"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 15
                            font.weight: Font.Black
                            color: "#f8fafc"
                        }

                        Text {
                            text: window.t("Guía y Configuración", "Guide & Settings")
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 10
                            font.weight: Font.DemiBold
                            color: "#94a3b8"
                        }
                    }
                }

                // Language Switcher Selector (Español / English)
                Rectangle {
                    Layout.fillWidth: true
                    height: 32
                    radius: 8
                    color: "#0f172a"
                    border.color: "#1e293b"
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 2
                        spacing: 2

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 6
                            color: (window.uiLanguage === "es") ? "#38bdf8" : (mouseEs.containsMouse ? "#1e293b" : "transparent")
                            RowLayout {
                                anchors.centerIn: parent
                                spacing: 4
                                Text { text: "🇪🇸"; font.pixelSize: 11 }
                                Text {
                                    text: "Español"
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.pixelSize: 10
                                    font.weight: (window.uiLanguage === "es") ? Font.Bold : Font.Normal
                                    color: (window.uiLanguage === "es") ? "#0f172a" : "#94a3b8"
                                }
                            }
                            MouseArea {
                                id: mouseEs
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    window.uiLanguage = "es";
                                    window.sendCmd("set_language", "es");
                                    window.showToast("Idioma cambiado a Español");
                                }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 6
                            color: (window.uiLanguage === "en") ? "#38bdf8" : (mouseEn.containsMouse ? "#1e293b" : "transparent")
                            RowLayout {
                                anchors.centerIn: parent
                                spacing: 4
                                Text { text: "🇬🇧"; font.pixelSize: 11 }
                                Text {
                                    text: "English"
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.pixelSize: 10
                                    font.weight: (window.uiLanguage === "en") ? Font.Bold : Font.Normal
                                    color: (window.uiLanguage === "en") ? "#0f172a" : "#94a3b8"
                                }
                            }
                            MouseArea {
                                id: mouseEn
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    window.uiLanguage = "en";
                                    window.sendCmd("set_language", "en");
                                    window.showToast("Language changed to English");
                                }
                            }
                        }
                    }
                }

                // Divider
                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: "#1e293b"
                    Layout.topMargin: 2
                    Layout.bottomMargin: 6
                }

                // Navigation Tabs
                ListView {
                    id: tabsList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 4
                    boundsBehavior: Flickable.StopAtBounds

                    model: window.tabsData

                    delegate: Rectangle {
                        id: tabItem
                        width: tabsList.width
                        height: 44
                        radius: 10
                        color: (window.currentTab === index) ? "#1e293b" : (tabMouse.containsMouse ? "#0f172a" : "transparent")
                        border.color: (window.currentTab === index) ? "#334155" : "transparent"
                        border.width: 1

                        Behavior on color { ColorAnimation { duration: 150 } }

                        // Cyan Active Indicator
                        Rectangle {
                            visible: window.currentTab === index
                            anchors.left: parent.left
                            anchors.leftMargin: 4
                            anchors.verticalCenter: parent.verticalCenter
                            width: 3
                            height: 22
                            radius: 2
                            color: "#38bdf8"
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 14
                            anchors.rightMargin: 10
                            spacing: 10

                            Text {
                                text: modelData.icon
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 15
                                color: (window.currentTab === index) ? "#38bdf8" : (tabMouse.containsMouse ? "#f8fafc" : "#94a3b8")
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 0
                                Text {
                                    text: modelData.title
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.pixelSize: 11
                                    font.weight: (window.currentTab === index) ? Font.Bold : Font.Normal
                                    color: (window.currentTab === index) ? "#f8fafc" : (tabMouse.containsMouse ? "#f8fafc" : "#94a3b8")
                                }
                                Text {
                                    text: modelData.sub
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.pixelSize: 8
                                    color: (window.currentTab === index) ? "#38bdf8" : "#64748b"
                                }
                            }
                        }

                        MouseArea {
                            id: tabMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: window.currentTab = index
                        }
                    }
                }
            }
        }

        // ==================== MAIN CONTENT AREA ====================
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            StackLayout {
                id: mainStack
                anchors.fill: parent
                anchors.margins: 24
                currentIndex: window.currentTab

                // ---------------- TAB 0: BIENVENIDA ----------------
                ScrollView {
                    contentWidth: -1
                    clip: true

                    ColumnLayout {
                        width: parent.width
                        spacing: 20

                        // Hero Banner
                        Rectangle {
                            Layout.fillWidth: true
                            height: 150
                            radius: 14
                            color: "#0f172a"
                            border.color: "#1e293b"
                            border.width: 1

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 20
                                spacing: 18

                                Rectangle {
                                    width: 72
                                    height: 72
                                    radius: 18
                                    color: "#1e293b"
                                    border.color: "#38bdf8"
                                    border.width: 1.5

                                    Text {
                                        anchors.centerIn: parent
                                        text: "🐍"
                                        font.pixelSize: 36
                                    }
                                }

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 4

                                    RowLayout {
                                        spacing: 8
                                        Text {
                                            text: window.t("Bienvenido a Serpanplasma", "Welcome to Serpanplasma")
                                            font.family: "JetBrainsMono Nerd Font"
                                            font.pixelSize: 18
                                            font.weight: Font.Black
                                            color: "#f8fafc"
                                        }
                                        Rectangle {
                                            height: 20
                                            radius: 6
                                            color: "#38bdf8"
                                            implicitWidth: vText.implicitWidth + 12
                                            Text {
                                                id: vText
                                                anchors.centerIn: parent
                                                text: "v1.0.0"
                                                font.family: "JetBrainsMono Nerd Font"
                                                font.pixelSize: 10
                                                font.weight: Font.Bold
                                                color: "#0f172a"
                                            }
                                        }
                                    }

                                    Text {
                                        text: window.t("Réplica visual y funcional exacta 1:1 de Serpantinum adaptada para KDE Plasma 6 sobre Wayland con gestión de ventanas tradicional flotante (Windows-style).",
                                                       "Pixel-perfect 1:1 visual and functional replica of Serpantinum adapted for KDE Plasma 6 on Wayland with traditional Windows-style floating window management.")
                                        font.family: "JetBrainsMono Nerd Font"
                                        font.pixelSize: 11
                                        color: "#94a3b8"
                                        wrapMode: Text.WordWrap
                                        Layout.fillWidth: true
                                    }
                                }
                            }
                        }

                        // Feature Grid
                        GridLayout {
                            Layout.fillWidth: true
                            columns: 2
                            rowSpacing: 12
                            columnSpacing: 12

                            Rectangle {
                                Layout.fillWidth: true
                                height: 95
                                radius: 12
                                color: "#0f172a"
                                border.color: "#1e293b"
                                border.width: 1

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 14
                                    spacing: 4
                                    RowLayout {
                                        spacing: 8
                                        Text { text: "󰹑"; font.pixelSize: 16; color: "#38bdf8" }
                                        Text { text: window.t("Barra Superior con Píldoras", "Floating Top Bar"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#f8fafc" }
                                    }
                                    Text {
                                        text: window.t("Panel flotante superior con reloj apilado, reproductor MPRIS, clima en vivo, volumen y cápsulas blancas sólidas.",
                                                       "Floating top bar with stacked clock, MPRIS media player, live weather, volume and solid white capsules.")
                                        font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: "#94a3b8"; wrapMode: Text.WordWrap; Layout.fillWidth: true
                                    }
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: 95
                                radius: 12
                                color: "#0f172a"
                                border.color: "#1e293b"
                                border.width: 1

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 14
                                    spacing: 4
                                    RowLayout {
                                        spacing: 8
                                        Text { text: "󰮯"; font.pixelSize: 16; color: "#38bdf8" }
                                        Text { text: window.t("Dock de Aplicaciones Inferior", "Bottom Application Dock"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#f8fafc" }
                                    }
                                    Text {
                                        text: window.t("Dock flotante centrado con escala al pasar el ratón, esquinas redondeadas, ocultación inteligente y modo desacoplado.",
                                                       "Centered floating dock with hover scaling, rounded corners, intelligent window dodging and detached mode.")
                                        font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: "#94a3b8"; wrapMode: Text.WordWrap; Layout.fillWidth: true
                                    }
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: 95
                                radius: 12
                                color: "#0f172a"
                                border.color: "#1e293b"
                                border.width: 1

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 14
                                    spacing: 4
                                    RowLayout {
                                        spacing: 8
                                        Text { text: "󰈹"; font.pixelSize: 16; color: "#38bdf8" }
                                        Text { text: window.t("Ventanas Libres (Sin Tiling)", "Floating Windows (No Tiling)"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#f8fafc" }
                                    }
                                    Text {
                                        text: window.t("Ventanas flotantes centradas, clic para enfocar/traer al frente, botones clásicos (_, □, X) y atajos estándar de Windows.",
                                                       "Centered floating windows, click-to-focus/raise, classic buttons (_, □, X) and standard Windows shortcuts.")
                                        font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: "#94a3b8"; wrapMode: Text.WordWrap; Layout.fillWidth: true
                                    }
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: 95
                                radius: 12
                                color: "#0f172a"
                                border.color: "#1e293b"
                                border.width: 1

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 14
                                    spacing: 4
                                    RowLayout {
                                        spacing: 8
                                        Text { text: "🎨"; font.pixelSize: 16 }
                                        Text { text: window.t("Paleta Obsidian & 146 Fondos", "Obsidian Palette & 146 Wallpapers"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#38bdf8" }
                                    }
                                    Text {
                                        text: window.t("Esquema oscuro pizarra profundo (#0f172a), desenfoque translúcido KWin, acentos cian y rotación de fondos automática.",
                                                       "Deep slate dark scheme (#0f172a), translucent KWin blur, cyan accents and automatic wallpaper slideshow.")
                                        font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: "#94a3b8"; wrapMode: Text.WordWrap; Layout.fillWidth: true
                                    }
                                }
                            }
                        }

                        // Quick Navigation Actions
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 12

                            Rectangle {
                                Layout.fillWidth: true
                                height: 40
                                radius: 10
                                color: "#38bdf8"
                                Text { anchors.centerIn: parent; text: window.t("󰹑 Configurar Barra", "󰹑 Configure Bar"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#0f172a" }
                                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: window.currentTab = 1 }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: 40
                                radius: 10
                                color: "#1e293b"
                                border.color: "#334155"
                                border.width: 1
                                Text { anchors.centerIn: parent; text: window.t("󰮯 Configurar Dock", "󰮯 Configure Dock"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#f8fafc" }
                                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: window.currentTab = 2 }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: 40
                                radius: 10
                                color: "#1e293b"
                                border.color: "#334155"
                                border.width: 1
                                Text { anchors.centerIn: parent; text: window.t("󰏘 Personalizar Tema", "󰏘 Customize Theme"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#f8fafc" }
                                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: window.currentTab = 3 }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: 40
                                radius: 10
                                color: "#1e293b"
                                border.color: "#334155"
                                border.width: 1
                                Text { anchors.centerIn: parent; text: window.t("󰹑 Widgets Escritorio", "󰹑 Desktop Widgets"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#f8fafc" }
                                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: window.currentTab = 6 }
                            }
                        }
                    }
                }

                // ---------------- TAB 1: BARRA SUPERIOR ----------------
                ScrollView {
                    contentWidth: -1
                    clip: true

                    ColumnLayout {
                        width: parent.width
                        spacing: 18

                        Text {
                            text: window.t("Configuración de la Barra Superior", "Top Bar Configuration")
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 18
                            font.weight: Font.Black
                            color: "#f8fafc"
                        }

                        Text {
                            text: window.t("Ajusta la posición, altura, estilo de píldoras y visibilidad de los módulos en la barra superior en tiempo real.", "Adjust the position, height, pill style, and module visibility of the top bar in real time.")
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 11
                            color: "#94a3b8"
                        }

                        // Dimensiones y Estilo General
                        Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: barDimCol.implicitHeight + 28
                            radius: 12
                            color: "#0f172a"
                            border.color: "#1e293b"
                            border.width: 1

                            ColumnLayout {
                                id: barDimCol
                                anchors.fill: parent
                                anchors.margins: 14
                                spacing: 14

                                Text { text: window.t("Estilo y Dimensiones", "Style & Dimensions"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#f8fafc" }

                                // Altura Slider
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: window.t("Altura de la barra", "Bar Height"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Text { text: Math.round(barSlider.value) + " px"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; font.weight: Font.Bold; color: "#38bdf8" }
                                }
                                RowLayout {
                                    Layout.fillWidth: true
                                    Slider { id: barSlider; Layout.fillWidth: true; from: 30; to: 50; value: window.barHeight; stepSize: 1 }
                                    Rectangle {
                                        width: 76; height: 26; radius: 6; color: "#1e293b"; border.color: "#38bdf8"; border.width: 1
                                        Text { anchors.centerIn: parent; text: window.t("Guardar", "Save"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: "#38bdf8" }
                                        MouseArea {
                                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                window.barHeight = Math.round(barSlider.value);
                                                window.sendCmd("set_bar_height", window.barHeight);
                                                window.showToast(window.t("Altura de barra guardada (" + window.barHeight + "px)", "Bar height saved (" + window.barHeight + "px)"));
                                            }
                                        }
                                    }
                                }

                                // Opacidad Slider
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: window.t("Opacidad de la barra", "Bar Opacity"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Text { text: Math.round(barOpacitySlider.value) + " %"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; font.weight: Font.Bold; color: "#38bdf8" }
                                }
                                RowLayout {
                                    Layout.fillWidth: true
                                    Slider { id: barOpacitySlider; Layout.fillWidth: true; from: 20; to: 100; value: window.barOpacity; stepSize: 5 }
                                    Rectangle {
                                        width: 76; height: 26; radius: 6; color: "#1e293b"; border.color: "#38bdf8"; border.width: 1
                                        Text { anchors.centerIn: parent; text: window.t("Guardar", "Save"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: "#38bdf8" }
                                        MouseArea {
                                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                window.barOpacity = Math.round(barOpacitySlider.value);
                                                window.sendCmd("set_bar_opacity", window.barOpacity);
                                                window.showToast(window.t("Opacidad de la barra guardada (" + window.barOpacity + "%)", "Bar opacity saved (" + window.barOpacity + "%)"));
                                            }
                                        }
                                    }
                                }

                                // Toggles de estilo
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: window.t("Píldoras distintas", "Distinct Pills"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch {
                                        checked: window.barDistinctPills
                                        onToggled: {
                                            window.barDistinctPills = checked;
                                            window.sendCmd("set_distinct_pills", checked ? "true" : "false");
                                            window.showToast(checked ? window.t("Estilo de píldoras individuales activado", "Individual pills style enabled") : window.t("Estilo de barra unificada activado", "Unified bar style enabled"));
                                        }
                                    }
                                }
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: window.t("Modo flotante desacoplado", "Detached Floating Mode"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch {
                                        checked: window.barFloating
                                        onToggled: {
                                            window.barFloating = checked;
                                            window.sendCmd("set_bar_floating", checked ? "true" : "false");
                                            window.showToast(checked ? window.t("Barra superior en modo flotante", "Top bar in floating mode") : window.t("Barra superior acoplada al borde", "Top bar docked to edge"));
                                        }
                                    }
                                }
                            }
                        }

                        // Módulos Visibles
                        Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: modCol.implicitHeight + 28
                            radius: 12
                            color: "#0f172a"
                            border.color: "#1e293b"
                            border.width: 1

                            ColumnLayout {
                                id: modCol
                                anchors.fill: parent
                                anchors.margins: 14
                                spacing: 8

                                Text { text: window.t("Módulos y Cápsulas de la Barra", "Top Bar Modules & Capsules"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#f8fafc" }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: window.t("󰒓 Botón de Ajustes y Guía", "󰒓 Settings & Guide Button"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch {
                                        checked: window.barModSettings
                                        onToggled: {
                                            window.barModSettings = checked;
                                            window.sendCmd("set_bar_module", checked ? "true" : "false", "settings");
                                            window.showToast(checked ? window.t("Botón de ajustes visible", "Settings button visible") : window.t("Botón de ajustes ocultado", "Settings button hidden"));
                                        }
                                    }
                                }
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: window.t("󰮯 Espacios de Trabajo", "󰮯 Workspaces"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch {
                                        checked: window.barModWorkspaces
                                        onToggled: {
                                            window.barModWorkspaces = checked;
                                            window.sendCmd("set_bar_module", checked ? "true" : "false", "workspaces");
                                            window.showToast(checked ? window.t("Módulo de escritorios visible", "Workspaces module visible") : window.t("Módulo de escritorios ocultado", "Workspaces module hidden"));
                                        }
                                    }
                                }
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: window.t("󰎈 Reproductor de Música", "󰎈 Media Player"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch {
                                        checked: window.barModMedia
                                        onToggled: {
                                            window.barModMedia = checked;
                                            window.sendCmd("set_bar_module", checked ? "true" : "false", "media");
                                            window.showToast(checked ? window.t("Reproductor de música visible", "Media player visible") : window.t("Reproductor de música ocultado", "Media player hidden"));
                                        }
                                    }
                                }
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: window.t("󰅐 Reloj Digital Apilado", "󰅐 Stacked Digital Clock"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch {
                                        checked: window.barModClock
                                        onToggled: {
                                            window.barModClock = checked;
                                            window.sendCmd("set_bar_module", checked ? "true" : "false", "clock");
                                            window.showToast(checked ? window.t("Reloj digital visible", "Digital clock visible") : window.t("Reloj digital ocultado", "Digital clock hidden"));
                                        }
                                    }
                                }
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: window.t("☁ Clima en Vivo", "☁ Live Weather"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch {
                                        checked: window.barModWeather
                                        onToggled: {
                                            window.barModWeather = checked;
                                            window.sendCmd("set_bar_module", checked ? "true" : "false", "weather");
                                            window.showToast(checked ? window.t("Módulo de clima en vivo activado", "Live weather module enabled") : window.t("Módulo de clima ocultado", "Live weather module hidden"));
                                        }
                                    }
                                }
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: window.t("󰕾 Control de Volumen", "󰕾 Volume Control"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch {
                                        checked: window.barModVolume
                                        onToggled: {
                                            window.barModVolume = checked;
                                            window.sendCmd("set_bar_module", checked ? "true" : "false", "volume");
                                            window.showToast(checked ? window.t("Control de volumen visible", "Volume control visible") : window.t("Control de volumen ocultado", "Volume control hidden"));
                                        }
                                    }
                                }
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: window.t("󰤨 Cápsula de Red", "󰤨 Network Capsule"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch {
                                        checked: window.barModNetwork
                                        onToggled: {
                                            window.barModNetwork = checked;
                                            window.sendCmd("set_bar_module", checked ? "true" : "false", "network");
                                            window.showToast(checked ? window.t("Cápsula de red visible", "Network capsule visible") : window.t("Cápsula de red ocultada", "Network capsule hidden"));
                                        }
                                    }
                                }
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: window.t("󰁹 Cápsula de Batería", "󰁹 Battery Capsule"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch {
                                        checked: window.barModBattery
                                        onToggled: {
                                            window.barModBattery = checked;
                                            window.sendCmd("set_bar_module", checked ? "true" : "false", "battery");
                                            window.showToast(checked ? window.t("Cápsula de batería visible", "Battery capsule visible") : window.t("Cápsula de batería ocultada", "Battery capsule hidden"));
                                        }
                                    }
                                }
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: window.t("⏻ Botón de Apagado", "⏻ Power Button"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch {
                                        checked: window.barModPower
                                        onToggled: {
                                            window.barModPower = checked;
                                            window.sendCmd("set_bar_module", checked ? "true" : "false", "power");
                                            window.showToast(checked ? window.t("Botón de apagado visible", "Power button visible") : window.t("Botón de apagado ocultado", "Power button hidden"));
                                        }
                                    }
                                }
                            }
                        }

                        // Acción
                        Rectangle {
                            Layout.fillWidth: true; height: 42; radius: 10; color: "#1e293b"; border.color: "#38bdf8"; border.width: 1
                            RowLayout {
                                anchors.centerIn: parent; spacing: 8
                                Text { text: "󰑓"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 14; color: "#38bdf8" }
                                Text { text: window.t("Recargar Barra Superior y PlasmaShell", "Restart Top Bar & PlasmaShell"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#f8fafc" }
                            }
                            MouseArea {
                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    window.sendCmd("restart_plasma");
                                    window.showToast(window.t("Reiniciando PlasmaShell...", "Restarting PlasmaShell..."));
                                }
                            }
                        }
                    }
                }

                // ---------------- TAB 2: DOCK DE APPS (FULL SERPANTINUM REPLICA) ----------------
                ScrollView {
                    contentWidth: -1
                    clip: true

                    ColumnLayout {
                        width: parent.width
                        spacing: 18

                        Text {
                            text: window.t("Dock de Aplicaciones Inferior", "Bottom Application Dock")
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 18
                            font.weight: Font.Black
                            color: "#f8fafc"
                        }

                        Text {
                            text: window.t("Todas las opciones de personalización del dock de Serpantinum adaptadas para KDE Plasma 6.", "All Serpantinum dock customization options adapted for KDE Plasma 6.")
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 11
                            color: "#94a3b8"
                        }

                        // 1. General & Posición
                        Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: dockGenCol.implicitHeight + 28
                            radius: 12
                            color: "#0f172a"
                            border.color: "#1e293b"
                            border.width: 1

                            ColumnLayout {
                                id: dockGenCol
                                anchors.fill: parent
                                anchors.margins: 14
                                spacing: 12

                                Text { text: window.t("General y Posición del Dock", "Dock General & Position"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#f8fafc" }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: window.t("󰅀 Habilitar dock", "󰅀 Enable dock"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch {
                                        checked: window.dockEnabled
                                        onToggled: {
                                            window.dockEnabled = checked;
                                            window.sendCmd("set_dock_enabled", checked ? "true" : "false");
                                            window.showToast(checked ? window.t("Dock de aplicaciones habilitado", "Application dock enabled") : window.t("Dock de aplicaciones deshabilitado", "Application dock disabled"));
                                        }
                                    }
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: window.t("󰍹 Posición del dock en pantalla", "󰍹 Dock screen position"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    RowLayout {
                                        spacing: 6
                                        Rectangle {
                                            width: 60; height: 26; radius: 6
                                            color: (window.dockPosition === "bottom") ? "#38bdf8" : "#1e293b"
                                            border.color: (window.dockPosition === "bottom") ? "#38bdf8" : "#334155"
                                            border.width: 1
                                            Text {
                                                anchors.centerIn: parent; text: window.t("Abajo", "Bottom"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold
                                                color: (window.dockPosition === "bottom") ? "#0f172a" : "#cbd5e1"
                                            }
                                            MouseArea {
                                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                                onClicked: {
                                                    window.dockPosition = "bottom";
                                                    window.sendCmd("set_dock_position", "bottom");
                                                    window.showToast(window.t("Posición del dock: Abajo", "Dock position: Bottom"));
                                                }
                                            }
                                        }
                                        Rectangle {
                                            width: 60; height: 26; radius: 6
                                            color: (window.dockPosition === "left") ? "#38bdf8" : "#1e293b"
                                            border.color: (window.dockPosition === "left") ? "#38bdf8" : "#334155"
                                            border.width: 1
                                            Text {
                                                anchors.centerIn: parent; text: window.t("Izquierda", "Left"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold
                                                color: (window.dockPosition === "left") ? "#0f172a" : "#cbd5e1"
                                            }
                                            MouseArea {
                                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                                onClicked: {
                                                    window.dockPosition = "left";
                                                    window.sendCmd("set_dock_position", "left");
                                                    window.showToast(window.t("Posición del dock: Izquierda", "Dock position: Left"));
                                                }
                                            }
                                        }
                                        Rectangle {
                                            width: 60; height: 26; radius: 6
                                            color: (window.dockPosition === "right") ? "#38bdf8" : "#1e293b"
                                            border.color: (window.dockPosition === "right") ? "#38bdf8" : "#334155"
                                            border.width: 1
                                            Text {
                                                anchors.centerIn: parent; text: window.t("Derecha", "Right"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold
                                                color: (window.dockPosition === "right") ? "#0f172a" : "#cbd5e1"
                                            }
                                            MouseArea {
                                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                                onClicked: {
                                                    window.dockPosition = "right";
                                                    window.sendCmd("set_dock_position", "right");
                                                    window.showToast(window.t("Posición del dock: Derecha", "Dock position: Right"));
                                                }
                                            }
                                        }
                                    }
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: window.t("󰉈 Dock flotante desacoplado", "󰉈 Detached Floating Dock"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch {
                                        checked: window.dockFloating
                                        onToggled: {
                                            window.dockFloating = checked;
                                            window.sendCmd("set_dock_floating", checked ? "true" : "false");
                                            window.showToast(checked ? window.t("Dock flotante activado", "Floating dock enabled") : window.t("Dock acoplado a los bordes", "Dock attached to edges"));
                                        }
                                    }
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: window.t("󰹤 Colocar dock siempre sobre las ventanas", "󰹤 Keep dock always on top of windows"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch {
                                        checked: window.dockLayerTop
                                        onToggled: {
                                            window.dockLayerTop = checked;
                                            window.sendCmd("set_dock_layer", checked ? "true" : "false");
                                            window.showToast(checked ? window.t("Dock siempre encima", "Dock always on top") : window.t("Ventanas pueden superponerse al dock", "Windows can overlap dock"));
                                        }
                                    }
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: window.t("󰖲 Modo exclusivo (Reservar espacio en pantalla)", "󰖲 Exclusive Mode (Reserve screen space)"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch {
                                        checked: window.dockExclusive
                                        onToggled: {
                                            window.dockExclusive = checked;
                                            window.sendCmd("set_dock_exclusive", checked ? "true" : "false");
                                            window.showToast(checked ? window.t("Modo exclusivo activado", "Exclusive mode enabled") : window.t("Modo exclusivo desactivado", "Exclusive mode disabled"));
                                        }
                                    }
                                }
                            }
                        }

                        // 2. Dimensiones y Efectos Visuales
                        Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: dockDimCol.implicitHeight + 28
                            radius: 12
                            color: "#0f172a"
                            border.color: "#1e293b"
                            border.width: 1

                            ColumnLayout {
                                id: dockDimCol
                                anchors.fill: parent
                                anchors.margins: 14
                                spacing: 14

                                Text { text: window.t("Dimensiones, Escala y Opacidad", "Dimensions, Scale & Opacity"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#f8fafc" }

                                // Altura Slider
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: window.t("󰘖 Tamaño de elementos / Altura", "󰘖 Element Size / Height"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Text { text: Math.round(dockSlider.value) + " px"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; font.weight: Font.Bold; color: "#38bdf8" }
                                }
                                RowLayout {
                                    Layout.fillWidth: true
                                    Slider {
                                        id: dockSlider
                                        Layout.fillWidth: true
                                        from: 38
                                        to: 80
                                        value: window.dockHeight
                                        stepSize: 1
                                        onMoved: {
                                            window.dockHeight = Math.round(dockSlider.value);
                                            window.sendCmd("set_dock_height", window.dockHeight);
                                        }
                                    }
                                    Rectangle {
                                        width: 76; height: 26; radius: 6; color: "#1e293b"; border.color: "#38bdf8"; border.width: 1
                                        Text { anchors.centerIn: parent; text: window.t("Guardar", "Save"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: "#38bdf8" }
                                        MouseArea {
                                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                window.dockHeight = Math.round(dockSlider.value);
                                                window.sendCmd("set_dock_height", window.dockHeight);
                                                window.showToast(window.t("Altura de dock guardada (" + window.dockHeight + "px)", "Dock height saved (" + window.dockHeight + "px)"));
                                            }
                                        }
                                    }
                                }

                                // Opacidad Slider
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: window.t("󰂵 Opacidad del dock", "󰂵 Dock Opacity"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Text { text: Math.round(dockOpacitySlider.value) + " %"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; font.weight: Font.Bold; color: "#38bdf8" }
                                }
                                RowLayout {
                                    Layout.fillWidth: true
                                    Slider {
                                        id: dockOpacitySlider
                                        Layout.fillWidth: true
                                        from: 20
                                        to: 100
                                        value: window.dockOpacity
                                        stepSize: 5
                                        onMoved: {
                                            window.dockOpacity = Math.round(dockOpacitySlider.value);
                                            window.sendCmd("set_dock_opacity", window.dockOpacity);
                                        }
                                    }
                                    Rectangle {
                                        width: 76; height: 26; radius: 6; color: "#1e293b"; border.color: "#38bdf8"; border.width: 1
                                        Text { anchors.centerIn: parent; text: window.t("Guardar", "Save"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: "#38bdf8" }
                                        MouseArea {
                                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                window.dockOpacity = Math.round(dockOpacitySlider.value);
                                                window.sendCmd("set_dock_opacity", window.dockOpacity);
                                                window.showToast(window.t("Opacidad de dock guardada (" + window.dockOpacity + "%)", "Dock opacity saved (" + window.dockOpacity + "%)"));
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        // 3. Comportamiento y Ocultación
                        Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: dockHideCol.implicitHeight + 28
                            radius: 12
                            color: "#0f172a"
                            border.color: "#1e293b"
                            border.width: 1

                            ColumnLayout {
                                id: dockHideCol
                                anchors.fill: parent
                                anchors.margins: 14
                                spacing: 12

                                Text { text: window.t("Comportamiento de Ventanas y Ocultación", "Window Behavior & Hiding"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#f8fafc" }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: window.t("󱂬 Ocultación inteligente (Esquivar ventanas)", "󱂬 Intelligent Dodge (Dodge windows)"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch {
                                        checked: window.dockVisibility === "dodgewindows"
                                        onToggled: {
                                            var newVis = checked ? "dodgewindows" : "none";
                                            window.dockVisibility = newVis;
                                            window.sendCmd("set_dock_visibility", newVis);
                                            window.showToast(checked ? window.t("Ocultación inteligente (Dodge) activada", "Intelligent dodge enabled") : window.t("Ocultación inteligente desactivada", "Intelligent dodge disabled"));
                                        }
                                    }
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: window.t("󰘓 Ocultar automáticamente", "󰘓 Auto-hide"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch {
                                        checked: window.dockVisibility === "autohide"
                                        onToggled: {
                                            var newVis = checked ? "autohide" : "none";
                                            window.dockVisibility = newVis;
                                            window.sendCmd("set_dock_visibility", newVis);
                                            window.showToast(checked ? window.t("Auto-hide activado", "Auto-hide enabled") : window.t("Auto-hide desactivado", "Auto-hide disabled"));
                                        }
                                    }
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: window.t("󱂬 Enfocar ventana existente en lugar de duplicar", "󱂬 Focus existing window instead of duplicating"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch {
                                        checked: window.smartFocus
                                        onToggled: {
                                            window.smartFocus = checked;
                                            window.sendCmd("set_dock_smart_focus", checked ? "true" : "false");
                                            window.showToast(checked ? window.t("Enfoque inteligente de ventanas activado", "Smart window focus enabled") : window.t("Apertura de nuevas instancias activado", "New window instances enabled"));
                                        }
                                    }
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: window.t("󰄯 Indicadores discretos de aplicación en ejecución", "󰄯 Running application indicators"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch {
                                        checked: window.runningIndicators
                                        onToggled: {
                                            window.runningIndicators = checked;
                                            window.sendCmd("set_dock_indicators", checked ? "true" : "false");
                                            window.showToast(checked ? window.t("Indicadores de ejecución visibles", "Running indicators visible") : window.t("Indicadores de ejecución ocultados", "Running indicators hidden"));
                                        }
                                    }
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: window.t("󰘓 Mostrar todas las aplicaciones abiertas en el dock", "󰘓 Show all open tasks in dock"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch {
                                        checked: window.showAllTasks
                                        onToggled: {
                                            window.showAllTasks = checked;
                                            window.sendCmd("set_dock_tasks", checked ? "true" : "false");
                                            window.showToast(checked ? window.t("Tareas abiertas visibles en el dock", "Open tasks visible in dock") : window.t("Dock en modo solo iconos anclados", "Dock in pinned icons only mode"));
                                        }
                                    }
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: window.t("󰍹 Ámbito de ventanas activas", "󰍹 Active Window Scope"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    RowLayout {
                                        spacing: 6
                                        Rectangle {
                                            width: 80; height: 26; radius: 6
                                            color: (window.activeScope === "current") ? "#38bdf8" : "#1e293b"
                                            border.color: (window.activeScope === "current") ? "#38bdf8" : "#334155"
                                            border.width: 1
                                            Text {
                                                anchors.centerIn: parent; text: window.t("Escritorio", "Current"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold
                                                color: (window.activeScope === "current") ? "#0f172a" : "#cbd5e1"
                                            }
                                            MouseArea {
                                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                                onClicked: {
                                                    window.activeScope = "current";
                                                    window.sendCmd("set_dock_scope", "current");
                                                    window.showToast(window.t("Ámbito: Solo tareas del escritorio actual", "Scope: Current desktop tasks only"));
                                                }
                                            }
                                        }
                                        Rectangle {
                                            width: 60; height: 26; radius: 6
                                            color: (window.activeScope === "all") ? "#38bdf8" : "#1e293b"
                                            border.color: (window.activeScope === "all") ? "#38bdf8" : "#334155"
                                            border.width: 1
                                            Text {
                                                anchors.centerIn: parent; text: window.t("Todos", "All"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold
                                                color: (window.activeScope === "all") ? "#0f172a" : "#cbd5e1"
                                            }
                                            MouseArea {
                                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                                onClicked: {
                                                    window.activeScope = "all";
                                                    window.sendCmd("set_dock_scope", "all");
                                                    window.showToast(window.t("Ámbito: Tareas de todos los escritorios", "Scope: All desktop tasks"));
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        // 4. Lanzadores Anclados
                        Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: dockAppsCol.implicitHeight + 28
                            radius: 12
                            color: "#0f172a"
                            border.color: "#1e293b"
                            border.width: 1

                            ColumnLayout {
                                id: dockAppsCol
                                anchors.fill: parent
                                anchors.margins: 14
                                spacing: 10

                                Text { text: window.t("󰀻 Aplicaciones Ancladas en el Dock", "󰀻 Pinned Applications in Dock"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#f8fafc" }

                                RowLayout {
                                    spacing: 12
                                    Rectangle { width: 38; height: 38; radius: 8; color: "#1e293b"; border.color: "#334155"; border.width: 1; Text { anchors.centerIn: parent; text: "󰞷"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 18; color: "#38bdf8" } }
                                    Rectangle { width: 38; height: 38; radius: 8; color: "#1e293b"; border.color: "#334155"; border.width: 1; Text { anchors.centerIn: parent; text: "󰉋"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 18; color: "#38bdf8" } }
                                    Rectangle { width: 38; height: 38; radius: 8; color: "#1e293b"; border.color: "#334155"; border.width: 1; Text { anchors.centerIn: parent; text: "󰇧"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 18; color: "#38bdf8" } }
                                    Rectangle { width: 38; height: 38; radius: 8; color: "#1e293b"; border.color: "#334155"; border.width: 1; Text { anchors.centerIn: parent; text: "󰙯"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 18; color: "#38bdf8" } }
                                    Rectangle { width: 38; height: 38; radius: 8; color: "#1e293b"; border.color: "#334155"; border.width: 1; Text { anchors.centerIn: parent; text: "󰓇"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 18; color: "#38bdf8" } }
                                    Rectangle { width: 38; height: 38; radius: 8; color: "#1e293b"; border.color: "#334155"; border.width: 1; Text { anchors.centerIn: parent; text: "󰒓"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 18; color: "#38bdf8" } }
                                }
                                Text { text: window.t("Puedes arrastrar y soltar cualquier aplicación desde el menú para anclarla o desanclarla con clic derecho.", "You can drag and drop any app from the launcher menu to pin it, or right-click to unpin."); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: "#94a3b8" }
                            }
                        }

                        // Botón de Aplicar
                        Rectangle {
                            Layout.fillWidth: true; height: 42; radius: 10; color: "#1e293b"; border.color: "#38bdf8"; border.width: 1
                            RowLayout {
                                anchors.centerIn: parent; spacing: 8
                                Text { text: "󰑓"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 14; color: "#38bdf8" }
                                Text { text: window.t("Reiniciar Dock y Aplicar Cambios", "Restart Dock & Apply Changes"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#f8fafc" }
                            }
                            MouseArea {
                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    window.sendCmd("restart_plasma");
                                    window.showToast(window.t("Reiniciando Dock y PlasmaShell...", "Restarting Dock & PlasmaShell..."));
                                }
                            }
                        }
                    }
                }

                // ---------------- TAB 3: TEMA Y COLORES ----------------
                ScrollView {
                    contentWidth: -1
                    clip: true

                    ColumnLayout {
                        width: parent.width
                        spacing: 18

                        Text {
                            text: window.t("Esquemas de Color & Tipografía", "Color Schemes & Typography")
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 18
                            font.weight: Font.Black
                            color: "#f8fafc"
                        }

                        Text {
                            text: window.t("Selecciona una paleta de color para el entorno KDE Plasma y las decoraciones de ventana.", "Select a color palette for the KDE Plasma environment and window decorations.")
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 11
                            color: "#94a3b8"
                        }

                        // Palette Cards
                        GridLayout {
                            Layout.fillWidth: true
                            columns: 2
                            rowSpacing: 12
                            columnSpacing: 12

                            // 1. Obsidian (Serpantinum Oficial)
                            Rectangle {
                                Layout.fillWidth: true; height: 110; radius: 12; color: "#0f172a"
                                border.color: (window.activeTheme === "Serpanplasma-Obsidian") ? "#38bdf8" : "#1e293b"; border.width: 1.5
                                ColumnLayout {
                                    anchors.fill: parent; anchors.margins: 14; spacing: 8
                                    RowLayout {
                                        Text { text: window.t("Obsidian (Serpantinum Oficial)", "Obsidian (Official Serpantinum)"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: (window.activeTheme === "Serpanplasma-Obsidian") ? "#38bdf8" : "#f8fafc" }
                                        Item { Layout.fillWidth: true }
                                        Rectangle {
                                            width: 60; height: 22; radius: 6; color: (window.activeTheme === "Serpanplasma-Obsidian") ? "#38bdf8" : "#1e293b"
                                            border.color: (window.activeTheme === "Serpanplasma-Obsidian") ? "#38bdf8" : "#334155"; border.width: 1
                                            Text { anchors.centerIn: parent; text: (window.activeTheme === "Serpanplasma-Obsidian") ? window.t("Activo", "Active") : window.t("Activar", "Apply"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: (window.activeTheme === "Serpanplasma-Obsidian") ? "#0f172a" : "#cbd5e1" }
                                            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: { window.activeTheme = "Serpanplasma-Obsidian"; window.sendCmd("apply_colorscheme", "Serpanplasma-Obsidian"); window.showToast(window.t("Esquema Obsidian activado", "Obsidian scheme applied")); } }
                                        }
                                    }
                                    RowLayout {
                                        spacing: 6
                                        Rectangle { width: 22; height: 22; radius: 5; color: "#0f172a"; border.color: "#334155"; border.width: 1 }
                                        Rectangle { width: 22; height: 22; radius: 5; color: "#1e293b" }
                                        Rectangle { width: 22; height: 22; radius: 5; color: "#38bdf8" }
                                        Rectangle { width: 22; height: 22; radius: 5; color: "#f8fafc" }
                                        Text { text: window.t("#0f172a / #38bdf8 (Oscuro)", "#0f172a / #38bdf8 (Dark)"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: "#94a3b8" }
                                    }
                                }
                            }

                            // 2. Mocha (Catppuccin)
                            Rectangle {
                                Layout.fillWidth: true; height: 110; radius: 12; color: "#0f172a"
                                border.color: (window.activeTheme === "Serpanplasma-Mocha") ? "#89b4fa" : "#1e293b"; border.width: 1.5
                                ColumnLayout {
                                    anchors.fill: parent; anchors.margins: 14; spacing: 8
                                    RowLayout {
                                        Text { text: "Catppuccin Mocha"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: (window.activeTheme === "Serpanplasma-Mocha") ? "#89b4fa" : "#f8fafc" }
                                        Item { Layout.fillWidth: true }
                                        Rectangle {
                                            width: 60; height: 22; radius: 6; color: (window.activeTheme === "Serpanplasma-Mocha") ? "#89b4fa" : "#1e293b"
                                            border.color: (window.activeTheme === "Serpanplasma-Mocha") ? "#89b4fa" : "#334155"; border.width: 1
                                            Text { anchors.centerIn: parent; text: (window.activeTheme === "Serpanplasma-Mocha") ? window.t("Activo", "Active") : window.t("Activar", "Apply"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: (window.activeTheme === "Serpanplasma-Mocha") ? "#0f172a" : "#cbd5e1" }
                                            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: { window.activeTheme = "Serpanplasma-Mocha"; window.sendCmd("apply_colorscheme", "Serpanplasma-Mocha"); window.showToast(window.t("Esquema Catppuccin Mocha activado", "Catppuccin Mocha scheme applied")); } }
                                        }
                                    }
                                    RowLayout {
                                        spacing: 6
                                        Rectangle { width: 22; height: 22; radius: 5; color: "#1e1e2e"; border.color: "#313244"; border.width: 1 }
                                        Rectangle { width: 22; height: 22; radius: 5; color: "#313244" }
                                        Rectangle { width: 22; height: 22; radius: 5; color: "#89b4fa" }
                                        Rectangle { width: 22; height: 22; radius: 5; color: "#cdd6f4" }
                                        Text { text: window.t("#1e1e2e / #89b4fa (Oscuro)", "#1e1e2e / #89b4fa (Dark)"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: "#94a3b8" }
                                    }
                                }
                            }

                            // 3. Cyber Emerald
                            Rectangle {
                                Layout.fillWidth: true; height: 110; radius: 12; color: "#0f172a"
                                border.color: (window.activeTheme === "Serpanplasma-Emerald") ? "#10b981" : "#1e293b"; border.width: 1.5
                                ColumnLayout {
                                    anchors.fill: parent; anchors.margins: 14; spacing: 8
                                    RowLayout {
                                        Text { text: "Cyber Emerald"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: (window.activeTheme === "Serpanplasma-Emerald") ? "#10b981" : "#f8fafc" }
                                        Item { Layout.fillWidth: true }
                                        Rectangle {
                                            width: 60; height: 22; radius: 6; color: (window.activeTheme === "Serpanplasma-Emerald") ? "#10b981" : "#1e293b"
                                            border.color: (window.activeTheme === "Serpanplasma-Emerald") ? "#10b981" : "#334155"; border.width: 1
                                            Text { anchors.centerIn: parent; text: (window.activeTheme === "Serpanplasma-Emerald") ? window.t("Activo", "Active") : window.t("Activar", "Apply"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: (window.activeTheme === "Serpanplasma-Emerald") ? "#0f172a" : "#cbd5e1" }
                                            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: { window.activeTheme = "Serpanplasma-Emerald"; window.sendCmd("apply_colorscheme", "Serpanplasma-Emerald"); window.showToast(window.t("Esquema Cyber Emerald activado", "Cyber Emerald scheme applied")); } }
                                        }
                                    }
                                    RowLayout {
                                        spacing: 6
                                        Rectangle { width: 22; height: 22; radius: 5; color: "#064e3b"; border.color: "#065f46"; border.width: 1 }
                                        Rectangle { width: 22; height: 22; radius: 5; color: "#065f46" }
                                        Rectangle { width: 22; height: 22; radius: 5; color: "#10b981" }
                                        Rectangle { width: 22; height: 22; radius: 5; color: "#ecfdf5" }
                                        Text { text: window.t("#064e3b / #10b981 (Oscuro)", "#064e3b / #10b981 (Dark)"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: "#94a3b8" }
                                    }
                                }
                            }

                            // 4. Deep Amethyst
                            Rectangle {
                                Layout.fillWidth: true; height: 110; radius: 12; color: "#0f172a"
                                border.color: (window.activeTheme === "Serpanplasma-Amethyst") ? "#a855f7" : "#1e293b"; border.width: 1.5
                                ColumnLayout {
                                    anchors.fill: parent; anchors.margins: 14; spacing: 8
                                    RowLayout {
                                        Text { text: "Deep Amethyst"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: (window.activeTheme === "Serpanplasma-Amethyst") ? "#a855f7" : "#f8fafc" }
                                        Item { Layout.fillWidth: true }
                                        Rectangle {
                                            width: 60; height: 22; radius: 6; color: (window.activeTheme === "Serpanplasma-Amethyst") ? "#a855f7" : "#1e293b"
                                            border.color: (window.activeTheme === "Serpanplasma-Amethyst") ? "#a855f7" : "#334155"; border.width: 1
                                            Text { anchors.centerIn: parent; text: (window.activeTheme === "Serpanplasma-Amethyst") ? window.t("Activo", "Active") : window.t("Activar", "Apply"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: (window.activeTheme === "Serpanplasma-Amethyst") ? "#0f172a" : "#cbd5e1" }
                                            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: { window.activeTheme = "Serpanplasma-Amethyst"; window.sendCmd("apply_colorscheme", "Serpanplasma-Amethyst"); window.showToast(window.t("Esquema Deep Amethyst activado", "Deep Amethyst scheme applied")); } }
                                        }
                                    }
                                    RowLayout {
                                        spacing: 6
                                        Rectangle { width: 22; height: 22; radius: 5; color: "#2e1065"; border.color: "#3b0764"; border.width: 1 }
                                        Rectangle { width: 22; height: 22; radius: 5; color: "#3b0764" }
                                        Rectangle { width: 22; height: 22; radius: 5; color: "#a855f7" }
                                        Rectangle { width: 22; height: 22; radius: 5; color: "#faf5ff" }
                                        Text { text: window.t("#2e1065 / #a855f7 (Oscuro)", "#2e1065 / #a855f7 (Dark)"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: "#94a3b8" }
                                    }
                                }
                            }

                            // 5. Neon Ruby
                            Rectangle {
                                Layout.fillWidth: true; height: 110; radius: 12; color: "#0f172a"
                                border.color: (window.activeTheme === "Serpanplasma-Ruby") ? "#f43f5e" : "#1e293b"; border.width: 1.5
                                ColumnLayout {
                                    anchors.fill: parent; anchors.margins: 14; spacing: 8
                                    RowLayout {
                                        Text { text: "Neon Ruby"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: (window.activeTheme === "Serpanplasma-Ruby") ? "#f43f5e" : "#f8fafc" }
                                        Item { Layout.fillWidth: true }
                                        Rectangle {
                                            width: 60; height: 22; radius: 6; color: (window.activeTheme === "Serpanplasma-Ruby") ? "#f43f5e" : "#1e293b"
                                            border.color: (window.activeTheme === "Serpanplasma-Ruby") ? "#f43f5e" : "#334155"; border.width: 1
                                            Text { anchors.centerIn: parent; text: (window.activeTheme === "Serpanplasma-Ruby") ? window.t("Activo", "Active") : window.t("Activar", "Apply"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: (window.activeTheme === "Serpanplasma-Ruby") ? "#0f172a" : "#cbd5e1" }
                                            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: { window.activeTheme = "Serpanplasma-Ruby"; window.sendCmd("apply_colorscheme", "Serpanplasma-Ruby"); window.showToast(window.t("Esquema Neon Ruby activado", "Neon Ruby scheme applied")); } }
                                        }
                                    }
                                    RowLayout {
                                        spacing: 6
                                        Rectangle { width: 22; height: 22; radius: 5; color: "#450a0a"; border.color: "#7f1d1d"; border.width: 1 }
                                        Rectangle { width: 22; height: 22; radius: 5; color: "#7f1d1d" }
                                        Rectangle { width: 22; height: 22; radius: 5; color: "#f43f5e" }
                                        Rectangle { width: 22; height: 22; radius: 5; color: "#fff1f2" }
                                        Text { text: window.t("#450a0a / #f43f5e (Oscuro)", "#450a0a / #f43f5e (Dark)"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: "#94a3b8" }
                                    }
                                }
                            }

                            // 6. Porcelain (Light)
                            Rectangle {
                                Layout.fillWidth: true; height: 110; radius: 12; color: "#0f172a"
                                border.color: (window.activeTheme === "Serpanplasma-Porcelain") ? "#0284c7" : "#1e293b"; border.width: 1.5
                                ColumnLayout {
                                    anchors.fill: parent; anchors.margins: 14; spacing: 8
                                    RowLayout {
                                        Text { text: window.t("Porcelain White (Modo Claro)", "Porcelain White (Light Mode)"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: (window.activeTheme === "Serpanplasma-Porcelain") ? "#38bdf8" : "#f8fafc" }
                                        Item { Layout.fillWidth: true }
                                        Rectangle {
                                            width: 60; height: 22; radius: 6; color: (window.activeTheme === "Serpanplasma-Porcelain") ? "#38bdf8" : "#1e293b"
                                            border.color: (window.activeTheme === "Serpanplasma-Porcelain") ? "#38bdf8" : "#334155"; border.width: 1
                                            Text { anchors.centerIn: parent; text: (window.activeTheme === "Serpanplasma-Porcelain") ? window.t("Activo", "Active") : window.t("Activar", "Apply"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: (window.activeTheme === "Serpanplasma-Porcelain") ? "#0f172a" : "#cbd5e1" }
                                            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: { window.activeTheme = "Serpanplasma-Porcelain"; window.sendCmd("apply_colorscheme", "Serpanplasma-Porcelain"); window.showToast(window.t("Esquema Porcelain White activado", "Porcelain White scheme applied")); } }
                                        }
                                    }
                                    RowLayout {
                                        spacing: 6
                                        Rectangle { width: 22; height: 22; radius: 5; color: "#f8fafc"; border.color: "#cbd5e1"; border.width: 1 }
                                        Rectangle { width: 22; height: 22; radius: 5; color: "#e2e8f0" }
                                        Rectangle { width: 22; height: 22; radius: 5; color: "#0284c7" }
                                        Rectangle { width: 22; height: 22; radius: 5; color: "#0f172a" }
                                        Text { text: window.t("#f8fafc / #0284c7 (Claro)", "#f8fafc / #0284c7 (Light)"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: "#94a3b8" }
                                    }
                                }
                            }

                            // 7. Catppuccin Latte (Light)
                            Rectangle {
                                Layout.fillWidth: true; height: 110; radius: 12; color: "#0f172a"
                                border.color: (window.activeTheme === "Serpanplasma-Latte") ? "#1e66f5" : "#1e293b"; border.width: 1.5
                                ColumnLayout {
                                    anchors.fill: parent; anchors.margins: 14; spacing: 8
                                    RowLayout {
                                        Text { text: window.t("Catppuccin Latte (Modo Claro)", "Catppuccin Latte (Light Mode)"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: (window.activeTheme === "Serpanplasma-Latte") ? "#38bdf8" : "#f8fafc" }
                                        Item { Layout.fillWidth: true }
                                        Rectangle {
                                            width: 60; height: 22; radius: 6; color: (window.activeTheme === "Serpanplasma-Latte") ? "#1e66f5" : "#1e293b"
                                            border.color: (window.activeTheme === "Serpanplasma-Latte") ? "#1e66f5" : "#334155"; border.width: 1
                                            Text { anchors.centerIn: parent; text: (window.activeTheme === "Serpanplasma-Latte") ? window.t("Activo", "Active") : window.t("Activar", "Apply"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: (window.activeTheme === "Serpanplasma-Latte") ? "#ffffff" : "#cbd5e1" }
                                            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: { window.activeTheme = "Serpanplasma-Latte"; window.sendCmd("apply_colorscheme", "Serpanplasma-Latte"); window.showToast(window.t("Esquema Catppuccin Latte activado", "Catppuccin Latte scheme applied")); } }
                                        }
                                    }
                                    RowLayout {
                                        spacing: 6
                                        Rectangle { width: 22; height: 22; radius: 5; color: "#eff1f5"; border.color: "#ccd0da"; border.width: 1 }
                                        Rectangle { width: 22; height: 22; radius: 5; color: "#dce0e8" }
                                        Rectangle { width: 22; height: 22; radius: 5; color: "#1e66f5" }
                                        Rectangle { width: 22; height: 22; radius: 5; color: "#4c4f69" }
                                        Text { text: window.t("#eff1f5 / #1e66f5 (Claro)", "#eff1f5 / #1e66f5 (Light)"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: "#94a3b8" }
                                    }
                                }
                            }

                            // 8. Nord Snow (Light)
                            Rectangle {
                                Layout.fillWidth: true; height: 110; radius: 12; color: "#0f172a"
                                border.color: (window.activeTheme === "Serpanplasma-NordSnow") ? "#5e81ac" : "#1e293b"; border.width: 1.5
                                ColumnLayout {
                                    anchors.fill: parent; anchors.margins: 14; spacing: 8
                                    RowLayout {
                                        Text { text: window.t("Nord Snow Polar (Modo Claro)", "Nord Snow Polar (Light Mode)"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: (window.activeTheme === "Serpanplasma-NordSnow") ? "#38bdf8" : "#f8fafc" }
                                        Item { Layout.fillWidth: true }
                                        Rectangle {
                                            width: 60; height: 22; radius: 6; color: (window.activeTheme === "Serpanplasma-NordSnow") ? "#5e81ac" : "#1e293b"
                                            border.color: (window.activeTheme === "Serpanplasma-NordSnow") ? "#5e81ac" : "#334155"; border.width: 1
                                            Text { anchors.centerIn: parent; text: (window.activeTheme === "Serpanplasma-NordSnow") ? window.t("Activo", "Active") : window.t("Activar", "Apply"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: (window.activeTheme === "Serpanplasma-NordSnow") ? "#ffffff" : "#cbd5e1" }
                                            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: { window.activeTheme = "Serpanplasma-NordSnow"; window.sendCmd("apply_colorscheme", "Serpanplasma-NordSnow"); window.showToast(window.t("Esquema Nord Snow activado", "Nord Snow scheme applied")); } }
                                        }
                                    }
                                    RowLayout {
                                        spacing: 6
                                        Rectangle { width: 22; height: 22; radius: 5; color: "#eceff4"; border.color: "#d8dee9"; border.width: 1 }
                                        Rectangle { width: 22; height: 22; radius: 5; color: "#e5e9f0" }
                                        Rectangle { width: 22; height: 22; radius: 5; color: "#5e81ac" }
                                        Rectangle { width: 22; height: 22; radius: 5; color: "#2e3440" }
                                        Text { text: window.t("#eceff4 / #5e81ac (Claro)", "#eceff4 / #5e81ac (Light)"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: "#94a3b8" }
                                    }
                                }
                            }
                        }

                        // Tipografía
                        Rectangle {
                            Layout.fillWidth: true
                            height: 90
                            radius: 12
                            color: "#0f172a"
                            border.color: "#1e293b"
                            border.width: 1

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 14
                                spacing: 6

                                Text { text: window.t("Tipografía Oficial del Sistema", "Official System Typography"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#f8fafc" }
                                Text { text: window.t("JetBrains Mono Nerd Font SemiBold (Instalada en ~/.local/share/fonts/)", "JetBrains Mono Nerd Font SemiBold (Installed in ~/.local/share/fonts/)"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#38bdf8" }
                                Text { text: "The quick brown fox jumps over the lazy dog 0123456789"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: "#94a3b8" }
                            }
                        }
                    }
                }

                // ---------------- TAB 4: VENTANAS KWIN ----------------
                ScrollView {
                    contentWidth: -1
                    clip: true

                    ColumnLayout {
                        width: parent.width
                        spacing: 18

                        Text {
                            text: window.t("Gestión de Ventanas Flotante", "Floating Window Management")
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 18
                            font.weight: Font.Black
                            color: "#f8fafc"
                        }

                        Text {
                            text: window.t("KWin configurado para ventanas flotantes tradicionales que se superponen libremente, sin gestor en mosaico.", "KWin configured for traditional floating windows that overlap freely, without tiling.")
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 11
                            color: "#94a3b8"
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: winCol.implicitHeight + 28
                            radius: 12
                            color: "#0f172a"
                            border.color: "#1e293b"
                            border.width: 1

                            ColumnLayout {
                                id: winCol
                                anchors.fill: parent
                                anchors.margins: 14
                                spacing: 8

                                Text { text: window.t("Reglas de Comportamiento Activas", "Active Behavior Rules"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#f8fafc" }
                                Text { text: window.t("✔  Apertura de Ventanas: Centrada en pantalla (Placement=Centered)", "✔  Window Placement: Centered on screen (Placement=Centered)"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                Text { text: window.t("✔  Enfoque: Clic para enfocar y traer al frente automáticamente (ClickRaise=true)", "✔  Focus: Click to focus and raise window automatically (ClickRaise=true)"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                Text { text: window.t("✔  Botones Clásicos: Minimizar (_), Maximizar (□) y Cerrar (X)", "✔  Classic Buttons: Minimize (_), Maximize (□), and Close (X)"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                Text { text: window.t("✔  Bordes y Esquinas: Redondeadas con radio de 12px y sombra sutil del 35%", "✔  Borders & Corners: Rounded with 12px radius and 35% subtle shadow"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                Text { text: window.t("✔  Compositor: Tasa nativa a baja latencia con efectos de Desenfoque (Blur) y Escala", "✔  Compositor: Low-latency native refresh with Blur and Scale effects"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 42
                            radius: 10
                            color: "#1e293b"
                            border.color: "#38bdf8"
                            border.width: 1

                            RowLayout {
                                anchors.centerIn: parent
                                spacing: 8
                                Text { text: "󰑓"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 14; color: "#38bdf8" }
                                Text {
                                    text: window.t("Reconfigurar Gestor de Ventanas KWin", "Reconfigure KWin Window Manager")
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.pixelSize: 12
                                    font.weight: Font.Bold
                                    color: "#f8fafc"
                                }
                            }
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    window.sendCmd("restart_kwin");
                                    window.showToast(window.t("KWin reconfigurado con éxito", "KWin successfully reconfigured"));
                                }
                            }
                        }
                    }
                }

                // ---------------- TAB 5: WALLPAPERS ----------------
                ScrollView {
                    contentWidth: -1
                    clip: true

                    ColumnLayout {
                        width: parent.width
                        spacing: 18

                        Text {
                            text: window.t("Colección de Fondos de Pantalla", "Wallpaper Collection")
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 18
                            font.weight: Font.Black
                            color: "#f8fafc"
                        }

                        Text {
                            text: window.t("Diapositivas automáticas configuradas con los fondos descargados en ~/Imágenes/Wallpapers/.", "Automatic slideshow configured with wallpapers downloaded in ~/Pictures/Wallpapers/.")
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 11
                            color: "#94a3b8"
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: wpCol.implicitHeight + 28
                            radius: 12
                            color: "#0f172a"
                            border.color: "#1e293b"
                            border.width: 1

                            ColumnLayout {
                                id: wpCol
                                anchors.fill: parent
                                anchors.margins: 14
                                spacing: 14

                                RowLayout {
                                    Text { text: window.t("Carpeta de Fondos:", "Wallpaper Folder:"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#f8fafc" }
                                    Text { text: "~/Imágenes/Wallpapers/"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#38bdf8" }
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: window.t("Diapositivas automáticas", "Automatic Slideshow"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch {
                                        checked: window.wallpaperSlideshow
                                        onToggled: {
                                            window.wallpaperSlideshow = checked;
                                            window.sendCmd("set_wallpaper_slideshow", checked ? "true" : "false");
                                            window.showToast(checked ? window.t("Diapositivas automáticas activadas", "Automatic slideshow enabled") : window.t("Diapositivas automáticas pausadas", "Automatic slideshow paused"));
                                        }
                                    }
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: window.t("Fijar fondo actual (Modo estático)", "Freeze current wallpaper (Static mode)"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Rectangle {
                                        width: 160; height: 28; radius: 6; color: "#1e293b"; border.color: "#38bdf8"; border.width: 1
                                        RowLayout {
                                            anchors.centerIn: parent; spacing: 6
                                            Text { text: "󰏤"; font.pixelSize: 12; color: "#38bdf8" }
                                            Text { text: window.t("Fijar Fondo Actual", "Freeze Current Wallpaper"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: "#38bdf8" }
                                        }
                                        MouseArea {
                                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                window.wallpaperSlideshow = false;
                                                window.sendCmd("freeze_wallpaper");
                                                window.showToast(window.t("Fondo actual fijado como estático", "Current wallpaper frozen as static"));
                                            }
                                        }
                                    }
                                }

                                RowLayout {
                                    Text { text: window.t("Intervalo de cambio de fondo:", "Wallpaper change interval:"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    RowLayout {
                                        spacing: 6
                                        Rectangle {
                                            width: 50; height: 26; radius: 6
                                            color: (window.wallpaperInterval === 300) ? "#38bdf8" : "#1e293b"
                                            border.color: (window.wallpaperInterval === 300) ? "#38bdf8" : "#334155"
                                            border.width: 1
                                            Text {
                                                anchors.centerIn: parent; text: "5m"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold
                                                color: (window.wallpaperInterval === 300) ? "#0f172a" : "#cbd5e1"
                                            }
                                            MouseArea {
                                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                                onClicked: {
                                                    window.wallpaperInterval = 300;
                                                    window.sendCmd("set_wallpaper_interval", "300");
                                                    window.showToast(window.t("Intervalo de cambio: 5 minutos", "Change interval: 5 minutes"));
                                                }
                                            }
                                        }
                                        Rectangle {
                                            width: 50; height: 26; radius: 6
                                            color: (window.wallpaperInterval === 900) ? "#38bdf8" : "#1e293b"
                                            border.color: (window.wallpaperInterval === 900) ? "#38bdf8" : "#334155"
                                            border.width: 1
                                            Text {
                                                anchors.centerIn: parent; text: "15m"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold
                                                color: (window.wallpaperInterval === 900) ? "#0f172a" : "#cbd5e1"
                                            }
                                            MouseArea {
                                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                                onClicked: {
                                                    window.wallpaperInterval = 900;
                                                    window.sendCmd("set_wallpaper_interval", "900");
                                                    window.showToast(window.t("Intervalo de cambio: 15 minutos", "Change interval: 15 minutes"));
                                                }
                                            }
                                        }
                                        Rectangle {
                                            width: 50; height: 26; radius: 6
                                            color: (window.wallpaperInterval === 1800) ? "#38bdf8" : "#1e293b"
                                            border.color: (window.wallpaperInterval === 1800) ? "#38bdf8" : "#334155"
                                            border.width: 1
                                            Text {
                                                anchors.centerIn: parent; text: "30m"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold
                                                color: (window.wallpaperInterval === 1800) ? "#0f172a" : "#cbd5e1"
                                            }
                                            MouseArea {
                                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                                onClicked: {
                                                    window.wallpaperInterval = 1800;
                                                    window.sendCmd("set_wallpaper_interval", "1800");
                                                    window.showToast(window.t("Intervalo de cambio: 30 minutos", "Change interval: 30 minutes"));
                                                }
                                            }
                                        }
                                        Rectangle {
                                            width: 50; height: 26; radius: 6
                                            color: (window.wallpaperInterval === 3600) ? "#38bdf8" : "#1e293b"
                                            border.color: (window.wallpaperInterval === 3600) ? "#38bdf8" : "#334155"
                                            border.width: 1
                                            Text {
                                                anchors.centerIn: parent; text: "1h"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold
                                                color: (window.wallpaperInterval === 3600) ? "#0f172a" : "#cbd5e1"
                                            }
                                            MouseArea {
                                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                                onClicked: {
                                                    window.wallpaperInterval = 3600;
                                                    window.sendCmd("set_wallpaper_interval", "3600");
                                                    window.showToast(window.t("Intervalo de cambio: 1 hora", "Change interval: 1 hour"));
                                                }
                                            }
                                        }
                                    }
                                }

                                RowLayout {
                                    spacing: 12
                                    Rectangle {
                                        Layout.fillWidth: true; height: 36; radius: 8; color: "#38bdf8"
                                        Text { anchors.centerIn: parent; text: window.t("󰒭 Siguiente Fondo de Pantalla", "󰒭 Next Wallpaper"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; font.weight: Font.Bold; color: "#0f172a" }
                                        MouseArea {
                                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                window.sendCmd("next_wallpaper");
                                                window.showToast(window.t("Cambiando fondo de pantalla...", "Changing wallpaper..."));
                                            }
                                        }
                                    }

                                    Rectangle {
                                        Layout.fillWidth: true; height: 36; radius: 8; color: "#1e293b"; border.color: "#334155"; border.width: 1
                                        Text { anchors.centerIn: parent; text: window.t("󰸉 Abrir Carpeta en Dolphin", "󰸉 Open Folder in Dolphin"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; font.weight: Font.Bold; color: "#f8fafc" }
                                        MouseArea {
                                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                window.sendCmd("open_wallpapers");
                                                window.showToast(window.t("Abriendo carpeta de fondos...", "Opening wallpaper folder..."));
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // ---------------- TAB 6: WIDGETS DE ESCRITORIO ----------------
                ScrollView {
                    contentWidth: -1
                    clip: true
                    ScrollBar.vertical: ScrollBar {
                        policy: ScrollBar.AsNeeded
                    }

                    ColumnLayout {
                        width: parent.width
                        spacing: 18

                        Text {
                            text: window.t("Widgets Flotantes de Escritorio", "Floating Desktop Widgets")
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 18
                            font.weight: Font.Black
                            color: "#f8fafc"
                        }

                        Text {
                            text: window.t("Widgets translúcidos integrados directamente sobre el escritorio (Monitor de CPU/RAM/Disco/Uptime, Reloj Grande, Clima y Reproductor de Música).", "Translucent widgets integrated directly on the desktop (CPU/RAM/Disk/Uptime Monitor, Giant Clock, Weather, and Media Player).")
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 11
                            color: "#94a3b8"
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: wgtCol.implicitHeight + 28
                            radius: 12
                            color: "#0f172a"
                            border.color: "#1e293b"
                            border.width: 1

                            ColumnLayout {
                                id: wgtCol
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.top: parent.top
                                anchors.margins: 14
                                spacing: 14

                                RowLayout {
                                    Layout.fillWidth: true
                                    ColumnLayout {
                                        spacing: 2
                                        Text { text: window.t("󰹑 Estado de los Widgets de Escritorio", "󰹑 Desktop Widgets Status"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#f8fafc" }
                                        Text { text: window.t("Muestra tarjetas translúcidas fijas con métricas de sistema en tiempo real", "Shows translucent pinned cards with real-time system metrics"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: "#94a3b8" }
                                    }
                                    Item { Layout.fillWidth: true }
                                    Switch {
                                        checked: window.desktopWidgetsEnabled
                                        onToggled: {
                                            window.desktopWidgetsEnabled = checked;
                                            window.sendCmd("toggle_desktop_widgets", checked ? "true" : "false");
                                            window.showToast(checked ? window.t("Widgets de escritorio activados", "Desktop widgets enabled") : window.t("Widgets de escritorio desactivados", "Desktop widgets disabled"));
                                        }
                                    }
                                }

                                Rectangle { Layout.fillWidth: true; height: 1; color: "#1e293b" }

                                Text { text: window.t("💡 Puedes arrastrar con el ratón cualquier widget libremente por la pantalla. Su posición se guardará automáticamente.", "💡 You can freely drag any widget across the screen with your mouse. Its position will be saved automatically."); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: "#38bdf8" }

                                Text { text: window.t("Activar / Desactivar Widgets Individualmente:", "Enable / Disable Widgets Individually:"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; font.weight: Font.Bold; color: "#cbd5e1" }

                                GridLayout {
                                    Layout.fillWidth: true
                                    columns: 2
                                    rowSpacing: 10
                                    columnSpacing: 10

                                    // 1. Hardware
                                    Rectangle {
                                        Layout.fillWidth: true; height: 74; radius: 10; color: "#060913"; border.color: "#1e293b"; border.width: 1
                                        RowLayout {
                                            anchors.fill: parent; anchors.margins: 10; spacing: 8
                                            ColumnLayout {
                                                Layout.fillWidth: true; spacing: 3
                                                RowLayout {
                                                    Text { text: "󰍛"; font.pixelSize: 14; color: "#38bdf8" }
                                                    Text { text: window.t("Monitor de Hardware", "Hardware Monitor"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; font.weight: Font.Bold; color: "#f8fafc" }
                                                }
                                                Text { text: window.t("CPU, RAM, SSD y Uptime en tiempo real", "Real-time CPU, RAM, SSD, and Uptime"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 9; color: "#94a3b8" }
                                            }
                                            Switch {
                                                checked: window.widgetHwEnabled
                                                onToggled: {
                                                    window.widgetHwEnabled = checked;
                                                    window.sendCmd("set_widget_enabled", checked ? "true" : "false", "hw");
                                                    window.showToast(checked ? window.t("Monitor de Hardware activado", "Hardware Monitor enabled") : window.t("Monitor de Hardware desactivado", "Hardware Monitor disabled"));
                                                }
                                            }
                                        }
                                    }

                                    // 2. Clock
                                    Rectangle {
                                        Layout.fillWidth: true; height: 74; radius: 10; color: "#060913"; border.color: "#1e293b"; border.width: 1
                                        RowLayout {
                                            anchors.fill: parent; anchors.margins: 10; spacing: 8
                                            ColumnLayout {
                                                Layout.fillWidth: true; spacing: 3
                                                RowLayout {
                                                    Text { text: "󰥔"; font.pixelSize: 14; color: "#38bdf8" }
                                                    Text { text: window.t("Reloj Gigante & Fecha", "Giant Clock & Date"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; font.weight: Font.Bold; color: "#f8fafc" }
                                                }
                                                Text { text: window.t("Hora tipográfica grande y fecha en vivo", "Large typographic clock and live date"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 9; color: "#94a3b8" }
                                            }
                                            Switch {
                                                checked: window.widgetClockEnabled
                                                onToggled: {
                                                    window.widgetClockEnabled = checked;
                                                    window.sendCmd("set_widget_enabled", checked ? "true" : "false", "clock");
                                                    window.showToast(checked ? window.t("Reloj activado", "Clock enabled") : window.t("Reloj desactivado", "Clock disabled"));
                                                }
                                            }
                                        }
                                    }

                                    // 3. Weather
                                    Rectangle {
                                        Layout.fillWidth: true; height: 74; radius: 10; color: "#060913"; border.color: "#1e293b"; border.width: 1
                                        RowLayout {
                                            anchors.fill: parent; anchors.margins: 10; spacing: 8
                                            ColumnLayout {
                                                Layout.fillWidth: true; spacing: 3
                                                RowLayout {
                                                    Text { text: "󰖙"; font.pixelSize: 14; color: "#38bdf8" }
                                                    Text { text: window.t("Tarjeta Climatológica", "Weather Card"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; font.weight: Font.Bold; color: "#f8fafc" }
                                                }
                                                Text { text: window.t("Temperatura, viento, humedad y sensación", "Temperature, wind, humidity, and feels like"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 9; color: "#94a3b8" }
                                            }
                                            Switch {
                                                checked: window.widgetWeatherEnabled
                                                onToggled: {
                                                    window.widgetWeatherEnabled = checked;
                                                    window.sendCmd("set_widget_enabled", checked ? "true" : "false", "weather");
                                                    window.showToast(checked ? window.t("Widget de Clima activado", "Weather widget enabled") : window.t("Widget de Clima desactivado", "Weather widget disabled"));
                                                }
                                            }
                                        }
                                    }

                                    // 4. Music
                                    Rectangle {
                                        Layout.fillWidth: true; height: 74; radius: 10; color: "#060913"; border.color: "#1e293b"; border.width: 1
                                        RowLayout {
                                            anchors.fill: parent; anchors.margins: 10; spacing: 8
                                            ColumnLayout {
                                                Layout.fillWidth: true; spacing: 3
                                                RowLayout {
                                                    Text { text: "󰎆"; font.pixelSize: 14; color: "#38bdf8" }
                                                    Text { text: window.t("Reproductor de Música", "Media Player"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; font.weight: Font.Bold; color: "#f8fafc" }
                                                }
                                                Text { text: window.t("Título, artista y botones multimedia", "Title, artist, and multimedia controls"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 9; color: "#94a3b8" }
                                            }
                                            Switch {
                                                checked: window.widgetMusicEnabled
                                                onToggled: {
                                                    window.widgetMusicEnabled = checked;
                                                    window.sendCmd("set_widget_enabled", checked ? "true" : "false", "music");
                                                    window.showToast(checked ? window.t("Reproductor multimedia activado", "Media player enabled") : window.t("Reproductor multimedia desactivado", "Media player disabled"));
                                                }
                                            }
                                        }
                                    }
                                }

                                RowLayout {
                                    spacing: 12
                                    Rectangle {
                                        Layout.fillWidth: true; height: 36; radius: 8; color: "#38bdf8"
                                        Text { anchors.centerIn: parent; text: window.t("󰑓 Restablecer Posiciones por Defecto", "󰑓 Reset Default Positions"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; font.weight: Font.Bold; color: "#0f172a" }
                                        MouseArea {
                                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                window.sendCmd("reset_widget_pos");
                                                window.showToast(window.t("Posiciones de widgets restablecidas", "Widget positions reset"));
                                            }
                                        }
                                    }

                                    Rectangle {
                                        Layout.fillWidth: true; height: 36; radius: 8; color: "#1e293b"; border.color: "#334155"; border.width: 1
                                        Text { anchors.centerIn: parent; text: window.t("󰅖 Ocultar Widgets", "󰅖 Hide Widgets"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; font.weight: Font.Bold; color: "#f8fafc" }
                                        MouseArea {
                                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                window.sendCmd("toggle_desktop_widgets", "false");
                                                window.desktopWidgetsEnabled = false;
                                                window.showToast(window.t("Widgets de escritorio ocultados", "Desktop widgets hidden"));
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // ---------------- TAB 7: SISTEMA Y ATAJOS ----------------
                ScrollView {
                    contentWidth: -1
                    clip: true

                    ColumnLayout {
                        width: parent.width
                        spacing: 18

                        Text {
                            text: window.t("Atajos de Teclado y Demonio del Sistema", "Keyboard Shortcuts & System Daemon")
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 18
                            font.weight: Font.Black
                            color: "#f8fafc"
                        }

                        Text {
                            text: window.t("Atajos clásicos de escritorio integrados nativamente en KDE Plasma 6.", "Classic desktop shortcuts integrated natively in KDE Plasma 6.")
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 11
                            color: "#94a3b8"
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: keyCol.implicitHeight + 28
                            radius: 12
                            color: "#0f172a"
                            border.color: "#1e293b"
                            border.width: 1

                            ColumnLayout {
                                id: keyCol
                                anchors.fill: parent
                                anchors.margins: 14
                                spacing: 8

                                RowLayout {
                                    Text { text: "Alt + F4"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#38bdf8"; Layout.preferredWidth: 120 }
                                    Text { text: window.t("Cerrar la ventana activa", "Close active window"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                }
                                RowLayout {
                                    Text { text: "Alt + Tab"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#38bdf8"; Layout.preferredWidth: 120 }
                                    Text { text: window.t("Alternar entre ventanas abiertas", "Switch between open windows"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                }
                                RowLayout {
                                    Text { text: window.t("Win + Arriba", "Win + Up"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#38bdf8"; Layout.preferredWidth: 120 }
                                    Text { text: window.t("Maximizar la ventana activa", "Maximize active window"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                }
                                RowLayout {
                                    Text { text: window.t("Win + Abajo", "Win + Down"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#38bdf8"; Layout.preferredWidth: 120 }
                                    Text { text: window.t("Restaurar o minimizar la ventana activa", "Restore or minimize active window"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                }
                                RowLayout {
                                    Text { text: "Win + E"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#38bdf8"; Layout.preferredWidth: 120 }
                                    Text { text: window.t("Abrir el explorador de archivos Dolphin", "Open Dolphin file manager"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 42
                            radius: 10
                            color: "#1e293b"
                            border.color: "#38bdf8"
                            border.width: 1

                            RowLayout {
                                anchors.centerIn: parent
                                spacing: 8
                                Text { text: "󰑓"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 14; color: "#38bdf8" }
                                Text { text: window.t("Reiniciar Servicio Demonio (serpanplasma-daemon)", "Restart Daemon Service (serpanplasma-daemon)"); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#f8fafc" }
                            }
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    window.sendCmd("restart_daemon");
                                    window.showToast(window.t("Reiniciando servicio del demonio...", "Restarting daemon service..."));
                                }
                            }
                        }
                    }
                }

                // ---------------- TAB 8: ACERCA DE ----------------
                ScrollView {
                    contentWidth: -1
                    clip: true

                    ColumnLayout {
                        width: parent.width
                        spacing: 20

                        Rectangle {
                            Layout.fillWidth: true
                            height: 240
                            radius: 14
                            color: "#0f172a"
                            border.color: "#1e293b"
                            border.width: 1

                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 10

                                Rectangle {
                                    Layout.alignment: Qt.AlignHCenter
                                    width: 64
                                    height: 64
                                    radius: 16
                                    color: "#1e293b"
                                    border.color: "#38bdf8"
                                    border.width: 1.5

                                    Text {
                                        anchors.centerIn: parent
                                        text: "🐍"
                                        font.pixelSize: 32
                                    }
                                }

                                Text {
                                    Layout.alignment: Qt.AlignHCenter
                                    text: "Serpanplasma"
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.pixelSize: 22
                                    font.weight: Font.Black
                                    color: "#f8fafc"
                                }

                                Text {
                                    Layout.alignment: Qt.AlignHCenter
                                    text: window.t("Versión 1.0.0 (Release Estable)", "Version 1.0.0 (Stable Release)")
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.pixelSize: 11
                                    color: "#38bdf8"
                                }

                                Text {
                                    Layout.alignment: Qt.AlignHCenter
                                    text: window.t("Inspirado por el entorno Serpantinum de ilyamiro.\nAdaptado para KDE Plasma 6 sobre Wayland por jorjanion.", "Inspired by the Serpantinum environment by ilyamiro.\nAdapted for KDE Plasma 6 on Wayland by jorjanion.")
                                    horizontalAlignment: Text.AlignHCenter
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.pixelSize: 10
                                    color: "#94a3b8"
                                }

                                Rectangle {
                                    Layout.alignment: Qt.AlignHCenter
                                    height: 32
                                    radius: 8
                                    color: "#1e293b"
                                    border.color: "#38bdf8"
                                    border.width: 1
                                    implicitWidth: gitRow.implicitWidth + 24

                                    RowLayout {
                                        id: gitRow
                                        anchors.centerIn: parent
                                        spacing: 8
                                        Text { text: "󰊤"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 14; color: "#38bdf8" }
                                        Text { text: "github.com/jorjanion/serpantinum-kde-plasma"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: "#f8fafc" }
                                    }
                                    MouseArea {
                                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            window.sendCmd("open_url", "https://github.com/jorjanion/serpantinum-kde-plasma");
                                            window.showToast(window.t("Abriendo repositorio de GitHub...", "Opening GitHub repository..."));
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // Toast feedback message bar
            Rectangle {
                visible: window.toastMessage !== ""
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottomMargin: 14
                height: 36
                radius: 18
                color: "#1e293b"
                border.color: "#38bdf8"
                border.width: 1
                implicitWidth: toastText.implicitWidth + 30

                RowLayout {
                    anchors.centerIn: parent
                    spacing: 8
                    Text { text: "✔"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; color: "#38bdf8" }
                    Text {
                        id: toastText
                        text: window.toastMessage
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 11
                        font.weight: Font.DemiBold
                        color: "#f8fafc"
                    }
                }
            }
        }
    }
}
