import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.Notifications 1.0
import Nemo.Configuration 1.0
import QtMultimedia 5.6

import "."
import "pages"
import "./components/"

ApplicationWindow {
    ConfigurationGroup {
        id: settings
        path: "/apps/harbour-audiothek"
        synchronous: true

        property int keptItemsCount: 5
        property int paginationCount: 20
        property int playbackMode: 0
//        property string lastPlaylist
    }

    AudioPlayer { id: audioPlayer }

    Notification {
        function show(message, icn) {
            replacesId = 0
            previewSummary = ""
            previewBody = message
            icon = icn || ""
            publish()
        }

        id: notification
        appName: "Audiothek"
        expireTimeout: 3000
    }

    AudioPlayerWidget { id: playerWidget }

    initialPage: Component { MainPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations
}
