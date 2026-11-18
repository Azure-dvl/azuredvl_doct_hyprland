pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs

Singleton {
    id: root

    FileView {
        id: configFile
        path: Qt.resolvedUrl("settings.json")
        blockLoading: true

        watchChanges: true
        onFileChanged: {
        this.reload()
        root.configChanged()
        }

        onLoadFailed: (error) => {
        if (error == FileViewError.FileNotFound) {
            windowComponent.createObject(root)
        }
        }
    }

    signal configChanged()

    property var parsedConfig: JSON.parse(configFile.text())
    
    property var media: parsedConfig.media
}