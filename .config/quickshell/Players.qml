// Players.qml
pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Mpris

import qs

Singleton {
  id: root

  // Fallback used when no MPRIS player is available, so all bindings stay valid.
  QtObject {
    id: fallbackPlayer
    property bool isPlaying: false
    property string trackTitle: ""
    property string trackArtist: ""
    property string trackAlbum: ""
    property url trackArtUrl: ""
    property real position: 0
    property real length: 0
    property int playbackState: MprisPlaybackState.Stopped
    function previous() {}
    function next() {}
    function togglePlaying() {}
  }

  property int playerId: {
    if (customPlayerId > (players.length - 1)) {
      0 //players.length - 1
    } else {
      customPlayerId
    }
  }
  property int customPlayerId: 0
  property real pausedTime: 0.0
  readonly property var players: Mpris.players.values
  readonly property bool hasPlayer: players.length > 0
  readonly property var player: hasPlayer ? (players[playerId] || players[0]) : fallbackPlayer

  readonly property var playerToSwitchTo: {
    var playingPlayers = []
    for (var i = 0; i < players.length; i++) {
      if (players[i].isPlaying == true) {
        playingPlayers.push(i)
      }
    }
    if (playingPlayers.length == 1) {
      if (playingPlayers[0] != playerId) {
        return players[playingPlayers[0]]
      }
    }
    return null
  }

  property bool tempDisableSwitchSuggestion: false

  onPlayerIdChanged: {
    tempDisableSwitchSuggestion = false
  }

  Connections {
    target: hasPlayer ? player : null
    function onPostTrackChanged() {
      if (Config.media.playback.resetPositionOnTrackChange.value) {
        player.position = 0
      }
    }
  }

  FrameAnimation {
    running: player.playbackState == MprisPlaybackState.Playing

    onTriggered: {
      player.positionChanged()
    }
  }
}
