import QtQuick
import QtQuick.Layouts
import Quickshell

import "../utils"
import qs

Rectangle {

    color: Theme.get.bg
    radius: 8

    implicitHeight: row.height + 10
    implicitWidth: row.width + 16

    readonly property var audio: Audio
    readonly property bool isHovered: mouseArea.containsMouse
    readonly property bool isMuted: audio.muted
    readonly property int percentage: audio.percentage

    RowLayout {
        id: row
        anchors.centerIn: parent

        Text {
            id: volText

            text: {
                if (isMuted) return "󰖁"
                if (percentage >= 70) return "󰕾"
                if (percentage >= 30) return "󰖀"
                return "󰕿"
            }

            font.family: Theme.get.fontFamily
            font.pixelSize: Theme.get.fontSize
            font.bold: true
            font.letterSpacing: Theme.get.letterSpacing
            color: Theme.get.fg
        }

        Text {
            id: volumeText

            text: percentage
            font.family: Theme.get.fontFamily
            font.pixelSize: Theme.get.fontSize
            font.bold: true
            font.letterSpacing: Theme.get.letterSpacing
            color: Theme.get.fg

            Behavior on text {
                SequentialAnimation {
                    NumberAnimation {
                        target: volumeText
                        property: "scale"
                        to: 1.15
                        duration: 80
                    }
                    NumberAnimation {
                        target: volumeText
                        property: "scale"
                        to: 1.0
                        duration: 100
                    }
                }
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        anchors.margins: -4
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onWheel: wheel => {
            if (wheel.angleDelta.y > 0) {
                audio.increaseVolume()
            } else {
                audio.decreaseVolume()
            }
        }
        onClicked: {
            Qt.openUrlExternally("hyprpwcenter")
        }
    }

    Connections {
        target: audio
        function onPercentageChanged() {
            pulseAnim.restart()
        }
    }

    SequentialAnimation {
        id: pulseAnim

        NumberAnimation {
            target: volText
            property: "scale"
            to: 1.2
            duration: 80
        }
        NumberAnimation {
            target: volText
            property: "scale"
            to: isHovered ? 1.05 : 1.0
            duration: 120
        }
    }
}