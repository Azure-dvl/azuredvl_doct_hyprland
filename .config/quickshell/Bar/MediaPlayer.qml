// MediaPlayerWidget.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris
import Quickshell.Io

import qs

Item {
  id: root
  MarginWrapperManager {}

  property var theme: Theme {}

  property var currentScreen

  PlayersPopup {
    id: playersPopup
    anchor.item: rect
    anchor.edges: Edges.Bottom | Edges.Left
  }

  Row {
    id: mainRow
    spacing: -20
    Item {
      MarginWrapperManager { margin: 3 }
      BaseButton {
        implicitWidth: Players.playerToSwitchTo && !Players.tempDisableSwitchSuggestion && Config.media.widget.suggestPlayerChange.value && rect.state != "closed" ? textAlias.contentWidth + rightPadding + leftPadding : 0
        implicitHeight: 24

        Behavior on implicitWidth {
          SpringAnimation {
            spring: 5
            damping: 0.3
          }
        }

        clip: true

        text: Players.playerToSwitchTo ? Utils.truncate(Players.playerToSwitchTo.trackTitle, 10) + " ♪" : ""

        rightPadding: 25
        leftPadding: 10

        fontSize: 8

        backgroundAlias.radius: 0

        backgroundAlias.bottomLeftRadius: 10
        backgroundAlias.topLeftRadius: 10

        backgroundAlias.border.color: root.theme.bgSurface
        backgroundAlias.border.width: 1

        MouseArea {
          anchors.fill: parent

          cursorShape: Qt.PointingHandCursor

          acceptedButtons: Qt.LeftButton

          onClicked: {
            Players.customPlayerId = Players.players.indexOf(Players.playerToSwitchTo)
          }
        }

        BaseButton {
          anchors.right: parent.right
          anchors.top: parent.top
          anchors.bottom: parent.bottom
          anchors.margins: 2
          anchors.rightMargin: 17

          width: height

          opacity: parent.buttonHovered ? 1 : 0

          Behavior on opacity {
            PropertyAnimation {
              duration: 50
            }
          }

          backgroundAlias.radius: height / 2
          
          hoveredBackgroundColor: root.theme.accentRed
          pressedBackgroundColor: root.theme.accentRed

          text: ""

          tooltipText: "Temporarily disable suggestion"

          onClicked: Players.tempDisableSwitchSuggestion = true
        }
      }
    }

    Rectangle {
      id: rect

      color: root.theme.bgSurface

      Rectangle {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left

        clip: true

        color: "transparent"

        Timer {
          running: true
          repeat: true
          interval: 50
          onTriggered: {
            parent.width = parent.parent.width * ((Players.player.position - Players.pausedTime) / Players.player.length)
          }
        }

        Behavior on width {
          PropertyAnimation {
            duration: 100
          }
        }

        Rectangle {
          anchors.top: parent.top
          anchors.bottom: parent.bottom
          anchors.left: parent.left

          width: rect.width

          color: {
            if (Config.media.widget.progressBar.value == 0) {
              root.theme.bgOverlay
            } else {
              "transparent"
            }
          }

          Behavior on color {
            PropertyAnimation {
              duration: 200
            }
          }

          radius: rect.radius
        }
      }

      radius: 10

      height: 30
      width: {
        if (Players.hasPlayer) {
          row.width + 20
        } else {
          0
        }
      }

      clip: true

      Behavior on width {
        SpringAnimation {
          spring: 5
          damping: 0.4
        }
      }

      function open() {
        state = ""
        windowOpened()
      }

      function close() {
        state = "closed"
        windowClosed()
      }

      function toggleOpen() {
        if (rect.state == "closed") {
          open()
        } else {
          close()
        } 
      }

      signal windowOpened()
      signal windowClosed()

      states: State {
        name: "closed"
        PropertyChanges {target: mainRow; y: -25}
      }

      transitions: Transition {
        SpringAnimation {
          property: "y"
          spring: 6
          damping: 0.4
        }
      }

      MouseArea {
        id: mouseArea

        anchors.fill: parent

        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true

        acceptedButtons: Qt.LeftButton | Qt.MiddleButton

        LazyLoader {  
          id: mediaMenuLoader  
          source: "../MediaMenu.qml"
          loading: true 
        }

        onClicked: (mouse)=> {
          if (mouse.button == Qt.MiddleButton) {
            Players.player.togglePlaying()
          } else if (mouse.button == Qt.LeftButton) {
            if (mediaMenuLoader.item) {
              for (var i = 0; i < mediaMenuLoader.item.mediaMenuVariants.instances.length; i++) {
                var instance = mediaMenuLoader.item.mediaMenuVariants.instances[i]
                if (instance.modelData.name === currentScreen) {
                  instance.toggleOpen()
                  break
                }
              }
            }
          }
        }

        onWheel: (wheel)=> {
          if (wheel.angleDelta.y < 0) {
            Players.player.next()
          } else {
            Players.player.previous()
          }
        }
      }

      Row {
        id: row
        anchors.centerIn: parent
        spacing: 5

        Text {
          id: mainText

          anchors.verticalCenter: parent.verticalCenter

          color: root.theme.textPrimary

          font.pointSize: 11
          font.family: root.theme.currentFamily

          leftPadding: 5

          text: Utils.truncate(Players.player.trackTitle, 25) + " "
        }

        property int buttonRadius: 5

        BaseButton {
          height: 24
          width: height

          backgroundAlias.radius: row.buttonRadius

          backgroundColor: "transparent"

          anchors.verticalCenter: parent.verticalCenter

          fontSize: 10
          text: ""

          onClicked: Players.player.previous()
        }

        BaseButton {
          height: 24
          width: height

          backgroundAlias.radius: row.buttonRadius

          backgroundColor: "transparent"

          anchors.verticalCenter: parent.verticalCenter

          fontSize: 10
          text: {
            if (Players.player.isPlaying){
              ""
            } else {
              ""
            }
          }

          onClicked: Players.player.togglePlaying()
        }

        BaseButton {
          height: 24
          width: height

          backgroundAlias.radius: row.buttonRadius

          backgroundColor: "transparent"

          anchors.verticalCenter: parent.verticalCenter

          fontSize: 10
          text: ""

          onClicked: Players.player.next()
        }
      }
    }
  }
  
}