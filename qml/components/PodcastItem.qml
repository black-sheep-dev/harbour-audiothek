import QtQuick 2.0
import Sailfish.Silica 1.0

import "../."

BackgroundItem {
    width: parent.width
    height: width

    RemoteImage {
        id: remoteImage
        anchors.fill: parent
        source: modelData["image"]["url1X1"].replace("{width}", String(width))

        Rectangle {
            anchors.fill: parent
            color: "black"
            opacity: 0.4
        }

        Column {
            x: Theme.paddingMedium
            width: parent.width -2*x
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Theme.paddingSmall
            spacing: Theme.paddingSmall

            Label {
                id: titleLabel
                width: parent.width
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeSmall
                font.bold: true
                truncationMode: TruncationMode.Fade
                text: modelData["title"]
            }

            Label {
                id: durationLabel
                width: parent.width
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeTiny
                font.bold: true
                truncationMode: TruncationMode.Fade
                text: Global.getDurationString(modelData["duration"])
            }
        }
    }
}
