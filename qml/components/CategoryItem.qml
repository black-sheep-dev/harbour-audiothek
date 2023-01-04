import QtQuick 2.0
import Sailfish.Silica 1.0

import "../."

BackgroundItem {
    width: parent.width
    height: width

    RemoteImage {
        id: remoteImage
        anchors.fill: parent

        source: {
            if (modelData.hasOwnProperty("image")) {
               return modelData["image"]["url1X1"].toString().replace("{width}", String(width))
            } else {
                return Global.applyDataToImageLink(modelData["_links"]["mt:image"]["href"].toString(), "1x1", width)
            }
        }

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
        }
    }
}
