pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {

  id: root

  property string cpuUsage: "0%"
  property string memoryUsage: "0%"
  property string networkInfo: "Disconnected"
  property string networkType: "disconnected"
  property string batteryLevel: "0%"
  property string batteryIcon: "󰂎"
  property bool batteryCharging: false
  
  function truncate(text:string, maxLetters:int) : string {
    if (text.length > maxLetters + 1) {
      return text.slice(0, maxLetters) + ".."
    }
    else {
      return text
    }
  }

  function secondsToMinutesSeconds(time) {
    var minutes = Math.floor(time / 60);
    var seconds = Math.floor(time % 60);
    return (minutes < 10 ? "0" + minutes : minutes) + ":" + (seconds < 10 ? "0" + seconds : seconds);
  }

  readonly property string timeString: {
    Qt.formatDateTime(clock.date, "hh:mm")
  }

  readonly property string dateString: {
    Qt.formatDateTime(clock.date, "ddd MMM d")
  }

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }

  // CPU Usage
  Process {
    id: cpuProc
    command: ["sh", "-c", "top -bn1 | grep 'Cpu(s)' | sed 's/.*, *\\([0-9.]*\\)%* id.*/\\1/' | awk '{print 100 - $1\"%\"}'"]
    running: true

    stdout: StdioCollector {
      onStreamFinished: {
        root.cpuUsage = text.trim()
      }
    }
  }

  // Memory Usage
  Process {
    id: memProc
    command: ["sh", "-c", "free | grep Mem | awk '{printf \"%.1f%%\", ($3/$2) * 100.0}'"]
    running: true

    stdout: StdioCollector {
      onStreamFinished: {
        root.memoryUsage = text.trim()
      }
    }
  }

  // Network Info (ethernet takes priority over wifi)
  Process {
    id: netProc
    command: ["sh", "-c", "eth=$(nmcli -t -f type,state dev 2>/dev/null | grep '^ethernet:connected'); if [ -n \"$eth\" ]; then echo 'ethernet:Ethernet'; else wifi=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | grep '^yes' | cut -d: -f2); if [ -n \"$wifi\" ]; then echo \"wifi:$wifi\"; else echo 'disconnected:'; fi; fi"]
    running: true

    stdout: StdioCollector {
      onStreamFinished: {
        const result = text.trim()
        const colonIdx = result.indexOf(':')
        const type = result.substring(0, colonIdx)
        const info = result.substring(colonIdx + 1)
        root.networkType = type
        root.networkInfo = info || "Disconnected"
      }
    }
  }

  Timer {
    interval: 2000
    running: true
    repeat: true
    onTriggered: {
      cpuProc.running = true
      memProc.running = true
      netProc.running = true
    }
  }
}