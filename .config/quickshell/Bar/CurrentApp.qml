// WorkspaceWidget.qml
import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland

import qs

Item {
  id: root
  MarginWrapperManager {}

  property int maxLetters: 30
  property int expandedMaxLetters: 60
  readonly property var currentApp: Hyprland.activeToplevel
  readonly property string appTitle: currentApp?.title ?? ""
  property var theme: Theme {}

  states: State{
    name: "expanded"
    when: (mouseArea.hovered)
    PropertyChanges {target: root; maxLetters: appTitle.length < expandedMaxLetters ? appTitle.length : expandedMaxLetters}
  }

  transitions: Transition {
    PropertyAnimation {
      property: "maxLetters"
      duration: 0
      easing.type: Easing.InCubic
    }
  }

  Rectangle {
    id: rectangle
    radius: 12
    clip: true
    implicitHeight: 24

    implicitWidth: appTitle.length > 0 ? textItem.contentWidth + 30 : 0

    Behavior on implicitWidth {
      SpringAnimation { 
        spring: 5
        damping: 0.4
      }
    }

    Behavior on color {
      PropertyAnimation {
        duration: 50;
      }
    }

    color: {
      if (root.state == "expanded") {
        root.theme.bgHover
      }
      else {
        root.theme.bgSurface
      }

    }

    HoverHandler {
      id: mouseArea
    }

    Text {
      id: textItem
      anchors.verticalCenter: parent.verticalCenter
      anchors.left: parent.left
      anchors.leftMargin: 15
      text: Hyprland.activeToplevel ? Utils.truncate(appTitle, maxLetters) : ""
      font.pointSize: 10
      color: root.theme.textPrimary
      font.family: root.theme.currentFamily
    }
  }
}