import QtQuick 2.0
import Sailfish.Silica 1.0

BackgroundItem {
    property string categoryId
    property alias imageSource: remoteImage.source
    property alias title: titleLabel.text
    property int numberOfEpisodes: 0

    width: parent.width
    height: width

    RemoteImage {
        id: remoteImage
        anchors.fill: parent

        source: {
            if (modelData.hasOwnProperty("image")) {
               return modelData["image"]["url1X1"].replace("{width}", String(width))
            } else {
                return modelData["_links"]["mt:squareImage"]["href"].replace("{width}", String(width))
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
                visible: modelData["numberOfElements"] > 0
                width: parent.width
                font.pixelSize: Theme.fontSizeTiny
                font.bold: true
                //% "%n Episodes"
                text: qsTrId("id-episode-count", modelData["numberOfElements"])
                truncationMode: TruncationMode.Fade
            }
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
