pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

QtObject {
    id: root

    property int cpuUsage: 0
    property int memUsage: 0
    property string activeWindow: "Window"
    property var clockText: Qt.formatDateTime(new Date(), "ddd, MMM/dd - HH:mm")
    property string playingMedia: "Nothing Playing..."
    property var _lastCpuIdle: 0
    property var _lastCpuTotal: 0

    property list<QtObject> _processes: [

        Process {
            id: cpuProc
            command: ["sh", "-c", "head -1 /proc/stat"]
            stdout: SplitParser {
                onRead: data => {
                    if (!data)
                        return;
                    const p = data.trim().split(/\s+/);
                    const user = parseInt(p[1]) || 0;
                    const nice = parseInt(p[2]) || 0;
                    const system = parseInt(p[3]) || 0;
                    const idle = parseInt(p[4]) || 0;
                    const iowait = parseInt(p[5]) || 0;
                    const irq = parseInt(p[6]) || 0;
                    const softirq = parseInt(p[7]) || 0;

                    const total = user + nice + system + idle + iowait + irq + softirq;
                    const idleTime = idle + iowait;

                    if (root._lastCpuTotal > 0) {
                        const dt = total - root._lastCpuTotal;
                        const di = idleTime - root._lastCpuIdle;
                        if (dt > 0)
                            root.cpuUsage = Math.round(100 * (dt - di) / dt);
                    }
                    root._lastCpuTotal = total;
                    root._lastCpuIdle = idleTime;
                }
            }
            Component.onCompleted: running = true
        },
        Process {
            id: memProc
            command: ["sh", "-c", "free | grep Mem"]
            stdout: SplitParser {
                onRead: data => {
                    if (!data)
                        return;
                    const p = data.trim().split(/\s+/);
                    root.memUsage = Math.round(100 * (parseInt(p[2]) || 0) / (parseInt(p[1]) || 1));
                }
            }
            Component.onCompleted: running = true
        },
        Process {
            id: windowProc
            command: ["sh", "-c", "hyprctl activewindow -j | jq -r '.title // empty'"]
            stdout: SplitParser {
                onRead: data => {
                    if (data && data.trim()){
                        root.activeWindow = adjustTextOverflow(data.trim(), 50);
                    } else {
                        root.activeWindow = "Desktop";
                    }
                }
            }
            Component.onCompleted: running = true
        },
        Process {
            id: mediaProc
            command: ["sh", "-c", "playerctl metadata title"]
            stdout: SplitParser {
                onRead: data => {
                    if (data && data.trim()) {
                        playingMedia = adjustTextOverflow(data.trim(), 50);
                    } else {
                        playingMedia = "Nothing Playing...";
                    }
                }
            }
            Component.onCompleted: running = true
        }
    ]

    // Slow poll: system stats
    property Timer _slowTimer: Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            cpuProc.running = true;
            memProc.running = true;
            mediaProc.running = true;
            clockText = Qt.formatDateTime(new Date(), "ddd, MMM/dd - HH:mm");
        }
    }

    // Fast poll: window / layout
    property Timer _fastTimer: Timer {
        interval: 200
        running: true
        repeat: true
        onTriggered: {
            windowProc.running = true;
        }
    }

    // Event-driven updates
    property Connections _hyprConn: Connections {
        target: Hyprland
        function onRawEvent(event) {
            windowProc.running = true;
        }
    }

    function adjustTextOverflow(text, maxWidth) {
        if (text.length > maxWidth) {
            return text.substring(0, maxWidth - 3) + "...";
        }
        return text;
    }
}