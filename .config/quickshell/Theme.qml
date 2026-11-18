import Quickshell
import QtQuick

// Nord (https://www.nordtheme.com) - paleta canónica.
// Se conservan los nombres de propiedades usados por todos los QML.
QtObject {
  readonly property color nord0:  "#2E3440" // polar night 0
  readonly property color nord1:  "#3B4252"
  readonly property color nord2:  "#434C5E"
  readonly property color nord3:  "#4C566A"
  readonly property color nord4:  "#D8DEE9" // snow storm 4
  readonly property color nord5:  "#E5E9F0"
  readonly property color nord6:  "#ECEFF4"
  readonly property color nord7:  "#8FBCBB" // frost 7
  readonly property color nord8:  "#88C0D0"
  readonly property color nord9:  "#81A1C1"
  readonly property color nord10: "#5E81AC"
  readonly property color nord11: "#BF616A" // aurora 11
  readonly property color nord12: "#D08770"
  readonly property color nord13: "#EBCB8B"
  readonly property color nord14: "#A3BE8C"
  readonly property color nord15: "#B48EAD"

  readonly property color bgBase:       nord0
  readonly property color bgSurface:    nord1
  readonly property color bgOverlay:    nord2
  readonly property color bgHover:      nord3
  readonly property color bgSelected:   nord2
  readonly property color bgBorder:     "#88000000"

  readonly property color textPrimary:   nord6
  readonly property color textSecondary: nord4
  readonly property color textMuted:     nord3

  readonly property color accentPrimary: nord8
  readonly property color accentCyan:    nord7
  readonly property color accentGreen:   nord14
  readonly property color accentOrange:  nord12
  readonly property color accentRed:     nord11
  readonly property color accentYellow:  nord13
  readonly property color accentBlue:    nord9
  readonly property color accentPurple:  nord15

  readonly property color urgencyLow:      textMuted
  readonly property color urgencyNormal:   accentPrimary
  readonly property color urgencyCritical: accentRed
  readonly property color batteryGood:     accentGreen
  readonly property color batteryWarning:  accentOrange
  readonly property color batteryCritical: accentRed

  readonly property string currentName: "Nord"
  readonly property string currentFamily: "0xProtoNerdFont"
  readonly property bool isDark: true
}
