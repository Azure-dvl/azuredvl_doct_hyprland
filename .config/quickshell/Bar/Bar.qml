import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Widgets
import QtQuick

import qs

Scope {
    id: root
    property var theme: Theme {}

    IpcHandler {
      target: "bar"
      function toggle(): void { root.barVisible = !root.barVisible; }
    }  

    Variants {
        id: variants
        model: Quickshell.screens

        PanelWindow {
            id: mainWindow

            property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 36
            color: "transparent"

            Item {
              anchors.fill: parent
              anchors.leftMargin: 5
              anchors.rightMargin: 5

              // Letf section: Clock/Time + Workspaces + WindowTitle
              Row {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                spacing: 8

                ClockTime {}
                Workspaces {}
                CurrentApp {}
              }

              // Center section: Media Player
              Row {
                anchors.centerIn: parent
                MediaPlayer { currentScreen: modelData.name }
              }
              
              // Right section: System Info + System Tray
              Row{
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                Volume {}
                spacing: 4
                SystemInfo {}
                SystemTray {}
              }

            }
        }
    }
}