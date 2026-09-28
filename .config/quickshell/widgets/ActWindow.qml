import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

import qs
import "../utils"

Rectangle {
    color: Theme.get.bg
    radius: 8

    implicitWidth: Math.min(row.width + 16, 200)
    implicitHeight: row.height + 10

    RowLayout {
        id: row
        spacing: 4
        anchors.centerIn: parent
        
        Text {
            text: Utils.activeWindow
            color: Theme.get.fg
            font.pixelSize: Theme.get.fontSize
            font.family: Theme.get.fontFamily
            font.bold: true
            elide: Text.ElideRight
            maximumLineCount: 1
            Layout.maximumWidth: 160
            Layout.fillWidth: true 
        }
    }
}