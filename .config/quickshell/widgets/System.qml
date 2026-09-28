import QtQuick
import QtQuick.Layouts

import qs
import "../utils"

Rectangle {
    color: Theme.get.bg
    radius: 8

    implicitHeight: row.height + 10
    implicitWidth: row.width + 16

    RowLayout {
        id: row
        spacing: 4
        anchors.centerIn: parent

        Text {
            id: cpu
            text: "󰻠 " + Utils.cpuUsage + "%"
            font.family: Theme.get.fontFamily
            font.pixelSize: Theme.get.fontSize
            font.bold: true
            font.letterSpacing: Theme.get.letterSpacing
            color: Theme.get.fg
        }

        Rectangle {
            Layout.alignment: Qt.AlignVCenter
            width: 1
            height: 12
            radius: 0.5
            color: Theme.get.black
        }

        Text {
            id: ram
            text: "󰑊 " + Utils.memUsage + "%"
            font.family: Theme.get.fontFamily
            font.pixelSize: Theme.get.fontSize
            font.bold: true
            font.letterSpacing: Theme.get.letterSpacing
            color: Theme.get.fg
        }
    }
}