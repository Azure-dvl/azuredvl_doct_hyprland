pragma Singleton

import QtQuick
import Quickshell

Singleton {
    property Item get: catppuccin

    Item {
        id: catppuccin

        // Theme Catpuccin
        readonly property color bg: "#1e1e2e"
        readonly property color fg: "#cdd6f4"

        readonly property color active_bg: "#89b4fa"
        readonly property color active_fg: "#1e1e2e"
        readonly property color inactive_bg: "#313244"
        readonly property color inactive_fg: "#6c7086"

        readonly property color black: "#45475a"
        readonly property color red: "#f38ba8"
        readonly property color green: "#a6e3a1"
        readonly property color yellow: "#f9e2af"
        readonly property color blue: "#89b4fa"
        readonly property color pink: "#f5c2e7"
        readonly property color white: "#bac2de"
        readonly property color bright_black: "#585b70"
        readonly property color bright_red: "#f38ba8"
        readonly property color bright_green: "#a6e3a1"
        readonly property color bright_yellow: "#f9e2af"
        readonly property color bright_blue: "#89b4fa"
        readonly property color bright_pink:  "#f5c2e7"
        readonly property color bright_white: "#a6adc8"

        // Font
        readonly property string fontFamily: "0xProtoNerdFont"
        readonly property int fontSize: 14
        readonly property double letterSpacing: 2
    }

    Item {
        id: nordic

        // Theme Nordic
        readonly property color bg: "#2E3440"
        readonly property color fg: "#D8DEE9"

        readonly property color active_fg: "#2E3440"
        readonly property color active_bg: "#5E81AC"
        readonly property color inactive_fg: "#D8DEE9"
        readonly property color inactive_bg: "#4C566A"

        readonly property color black: "#3B4252"
        readonly property color red: "#941F2C"
        readonly property color green: "#718C64"
        readonly property color yellow: "#D1B65C"
        readonly property color blue: "#81A1C1"
        readonly property color pink: "#8C6984"
        readonly property color white: "#D8DEE9"
        readonly property color bright_black: "#4C566A"
        readonly property color bright_red: "#BF616A"
        readonly property color bright_green: "#A3BE8C"
        readonly property color bright_yellow: "#EBCB8B"
        readonly property color bright_blue: "#56748E"
        readonly property color bright_pink:  "#B48EAD"
        readonly property color bright_white: "#E5E9F0"

        // Font
        readonly property string fontFamily: "0xProtoNerdFont"
        readonly property int fontSize: 14
        readonly property double letterSpacing: 2
    }
}