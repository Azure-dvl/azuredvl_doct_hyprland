import QtQuick
import Quickshell
import Quickshell.Widgets

import qs

Item {
    id: root
    MarginWrapperManager {}
    property var theme: Theme {}

    Rectangle {
        implicitHeight: 24
        implicitWidth: timeDate.width + 16
        radius: 12
        color: root.theme.bgSurface

        Row {
            id: timeDate
            anchors.centerIn: parent
            spacing: 8

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: ""
                color: root.theme.accentPrimary
                font.pixelSize: 14
                font.family: root.theme.currentFamily
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: Utils.timeString
                color: root.theme.textPrimary
                font.pixelSize: 12
                font.family: root.theme.currentFamily
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: Utils.dateString
                color: root.theme.textSecondary
                font.pixelSize: 12
                font.family: root.theme.currentFamily
            }
        }
    }
}