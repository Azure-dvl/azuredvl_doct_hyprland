// PlayersPopup.qml

import QtQuick
import QtQuick.Layouts
import qs

Popup {
  id: playersPopup
  property var theme: Theme {}

  backgroundAlias.width: 11 * 15

  listAlias.model: Players.players

  listAlias.delegate: BaseButton {
    id: playersListButton

    property var data: modelData

    text: Utils.truncate(modelData.identity, 13)

    backgroundColor: playersPopup.theme.bgSurface

    contentItem: RowLayout {
      Text {
        id: checkItem
        font.pointSize: playersListButton.fontSize
        font.family: playersPopup.theme.currentFamily

        Layout.fillWidth: true

        color: playersPopup.theme.textPrimary

        topPadding: playersListButton.textTopPadding
        bottomPadding: playersListButton.textBottomPadding
        leftPadding: playersListButton.textLeftPadding
        rightPadding: playersListButton.textRightPadding

        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter

        wrapMode: Text.WordWrap

        text: "󰸞"

        opacity: {
          if (playersListButton.data == Players.player) {
            1
          } else {
            0
          }
        }
      }
      Column {
        Layout.fillWidth: true
        Text {
          id: textItem
          font.pointSize: playersListButton.fontSize
          font.family: playersPopup.theme.currentFamily


          color: playersPopup.theme.textPrimary

          topPadding: playersListButton.textTopPadding
          bottomPadding: playersListButton.textBottomPadding
          leftPadding: playersListButton.textLeftPadding
          rightPadding: playersListButton.textRightPadding

          horizontalAlignment: Text.AlignLeft
          verticalAlignment: Text.AlignVCenter

          wrapMode: Text.WordWrap

          text: playersListButton.text
        }
        Text {
          id: descriptionItem
          font.pointSize: 6
          font.family: playersPopup.theme.currentFamily

          width: playersListButton.width

          color: playersPopup.theme.textPrimary
          opacity: 0.7

          topPadding: playersListButton.textTopPadding
          bottomPadding: playersListButton.textBottomPadding
          leftPadding: playersListButton.textLeftPadding
          rightPadding: playersListButton.textRightPadding

          horizontalAlignment: Text.AlignLeft
          verticalAlignment: Text.AlignVCenter

          wrapMode: Text.WordWrap

          text: Utils.truncate(playersListButton.player.trackTitle, 25)
        }
      }
    }

    textLeftPadding: 5

    anchors.left: parent.left
    anchors.right: parent.right

    backgroundAlias.radius: playersPopup.backgroundAlias.radius - playersPopup.listAlias.anchors.margins
    padding: 5

    property var player: Players.players[index]

    onClicked: {
      playersPopup.close()
      Players.customPlayerId = index
    }
  }
}