import QtQuick
import Quickshell
import Quickshell.Widgets

import qs

Item {
    id: root
    MarginWrapperManager {}
    property var theme: Theme {}

        Row {
        id: sysInfo

        spacing: 4

        // CPU
        Rectangle {
            height: 24
            width: cpuContent.width + 12
            radius: 12
            color: root.theme.bgSurface
            Accessible.role: Accessible.StaticText
            Accessible.name: "CPU: " + Utils.cpuUsage

            Row {
                id: cpuContent
                anchors.centerIn: parent
                spacing: 6

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "󰻠"
                    color: root.theme.accentOrange
                    font.pixelSize: 14
                    font.family: root.theme.currentFamily
                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: Utils.cpuUsage
                    color: root.theme.textPrimary
                    font.pixelSize: 11
                    font.family: root.theme.currentFamily
                }
            }
        }

        // Network
        Rectangle {
            height: 24
            width: netContent.width + 12
            radius: 12
            color: root.theme.bgSurface
            Accessible.role: Accessible.StaticText
            Accessible.name: {
                if (Utils.networkType === "ethernet") return "Network: Ethernet"
                if (Utils.networkType === "wifi") return "Network: WiFi " + Utils.networkInfo
                return "Network: Disconnected"
            }

            Row {
                id: netContent
                anchors.centerIn: parent
                spacing: 6

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: {
                    if (Utils.networkType === "ethernet") return "󰈀"
                    if (Utils.networkType === "wifi") return "󰖩"
                    return "󰖪"
                    }
                    color: Utils.networkType === "disconnected" ? root.theme.textMuted : root.theme.accentGreen
                    font.pixelSize: 14
                    font.family: root.theme.currentFamily
                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: Utils.networkInfo
                    color: root.theme.textPrimary
                    font.pixelSize: 11
                    font.family: root.theme.currentFamily
                }
            }
        }
    }
}