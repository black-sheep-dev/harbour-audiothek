import QtQuick 2.0
import Sailfish.Silica 1.0

import "../."

ListItem {
    property int duration: 0
    property string image
    property bool playing: false
    property alias title: titleLabel.text

    width: parent.width
    contentHeight: Math.max(remoteImage.height, contentColumn.height) + 2*Theme.paddingSmall

    Rectangle {
        visible: playing
        anchors.fill: parent
        color: Theme.highlightBackgroundColor
        opacity: Theme.opacityFaint
    }

    Rectangle {
        visible: playing
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        height: Theme.paddingSmall
        color: Theme.secondaryHighlightColor
        opacity: Theme.opacityFaint
        width: Math.round(audioPlayer.position / audioPlayer.duration * parent.width)
    }

    RemoteImage {
        id: remoteImage
        y: Theme.paddingSmall
        anchors.top: parent.top
        anchors.topMargin: Theme.paddingSmall
        anchors.left: parent.left
        anchors.leftMargin: Theme.horizontalPageMargin
        width: playing ? Theme.itemSizeExtraLarge : Theme.itemSizeMedium
        height: width
        source: Global.applyDataToImageLink(image, "1x1", width)
    }

    Column {
        id: contentColumn
        anchors.left: remoteImage.right
        anchors.right: parent.right
        anchors.top: remoteImage.top
        anchors.leftMargin: Theme.paddingMedium
        anchors.rightMargin: Theme.horizontalPageMargin
        anchors.bottomMargin: Theme.paddingSmall
        spacing: Theme.paddingSmall

        Label {
            id: titleLabel
            width: parent.width
            font.pixelSize: Theme.fontSizeSmall
            font.bold: true
            color: playing ? Theme.highlightColor : Theme.primaryColor
            wrapMode: Text.Wrap
        }
        Label {
            width: parent.width
            font.pixelSize: Theme.fontSizeTiny
            wrapMode: Text.Wrap
            color: playing ? Theme.highlightColor : Theme.primaryColor
            text: Global.getDurationString(duration)
        }
    }
}
