import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth

import qs

Rectangle {

    color: Theme.get.bg
    radius: 8

    implicitHeight: row.height + 10
    implicitWidth: row.width + 16

    readonly property bool isHovered: mouseArea.containsMouse
    readonly property var adapter: Bluetooth.defaultAdapter
    readonly property var connectedDevices: Bluetooth.devices.values.filter(d => d.connected)
    readonly property bool hasConnection: connectedDevices.length > 0
    readonly property bool isEnabled: adapter?.enabled ?? false
    readonly property string deviceName: hasConnection ? (connectedDevices[0]?.name ?? "Device") : ""
    readonly property int deviceCount: connectedDevices.length

    RowLayout {
        id: row
        anchors.centerIn: parent

        Text {
            id: btIcon
            text: {
                text: {
                    if (!isEnabled) return "󰂲"
                    if (hasConnection) return "󰂯"
                    return "󰂱"
                }
            }
            font.family: Theme.get.fontFamily
            font.pixelSize: Theme.get.fontSize
            font.bold: true
            font.letterSpacing: Theme.get.letterSpacing
            color: Theme.get.fg
        }

        Text {
            id: blText
            
            text: {
                if (!isEnabled) return "Off"
                if (!hasConnection) return "No Device"
                if (deviceCount > 1) return deviceName + " +" + (deviceCount - 1)
                return deviceName
            }
            
            font.family: Theme.get.fontFamily
            font.pixelSize: Theme.get.fontSize
            font.bold: true
            font.letterSpacing: Theme.get.letterSpacing
            color: Theme.get.fg
        }
    }

    MouseArea {
        id: mouseArea
        cursorShape: Qt.PointingHandCursor
        anchors.fill: parent
        onClicked: {
            Qt.openUrlExternally("blueman-manager")
        }
    }
}