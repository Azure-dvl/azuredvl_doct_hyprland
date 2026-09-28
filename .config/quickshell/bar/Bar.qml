import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

import "../widgets"

Scope {
    id: bar

    // Panel Window
    PanelWindow {
        id: panel

        anchors {
            top: true
            left: true
            right: true
        }

        implicitHeight: 40
        color: "transparent"

        RowLayout {
            anchors.fill: parent
            anchors.margins: 8
            spacing: 6

            Time {
                Layout.fillHeight: true
            }

            ActWindow {
                Layout.fillHeight: true
                Layout.preferredWidth: 200
                Layout.maximumWidth: 250
            }

            PlayingMedia {
                Layout.fillHeight: true
            }

            SysTray {
                Layout.fillHeight: true
            }

            Blue {
                Layout.fillHeight: true
            }

            Volume {
                Layout.fillHeight: true
            }

            System {
                Layout.fillHeight: true
            }
        }
    }
}

