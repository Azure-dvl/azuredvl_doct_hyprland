import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Services.SystemTray

import qs

Rectangle {
    id: systray

    property var panelWindow: null

    color: Theme.get.bg
    radius: 8

    implicitHeight: row.height + 10
    implicitWidth: row.width + 16

    RowLayout {
        id: row
        spacing: 4
        anchors.centerIn: parent

        Repeater {
            model: SystemTray.items

            delegate: Item {
                id: trayItemDelegate
                Layout.preferredWidth: 18
                Layout.preferredHeight: 18
                Layout.alignment: Qt.AlignCenter

                Image {
                    id: trayIcon
                    source: modelData.icon
                    anchors.fill: parent
                    anchors.margins: 2
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton

                    onClicked: (mouse) => {
                        modelData.activate()

                        if (modelData.hasMenu && systray.panelWindow) {
                            var globalPos = mouseArea.mapToGlobal(mouse.x, mouse.y)
                            modelData.menu.popup(globalPos)
                        }
                    }

                    onPressAndHold: (mouse) => {
                        if (modelData.hasMenu && systray.panelWindow) {
                            var globalPos = mouseArea.mapToGlobal(mouse.x, mouse.y)
                            modelData.menu.popup(globalPos)
                        }
                    }
                }
            }
        }
    }
}