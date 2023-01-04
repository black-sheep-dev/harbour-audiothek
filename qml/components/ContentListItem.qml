import QtQuick 2.0
import Sailfish.Silica 1.0

import "."

ListItem {
    property bool favorite: false
    property alias imageSource: remoteImage.source
    property alias info: labelInfo.text
    property alias subtitle: labelSubtitle.text
    property alias title: labelTitle.text


    width: parent.width
    contentHeight: Math.max(remoteImage.height, contentColumn.height) + 2*Theme.paddingSmall

    RemoteImage {
        id: remoteImage
        y: Theme.paddingSmall
        anchors.top: parent.top
        anchors.topMargin: Theme.paddingSmall
        anchors.left: parent.left
        anchors.leftMargin: Theme.horizontalPageMargin
        width: Theme.itemSizeLarge
        height: width 

        Icon {
            visible: favorite
            anchors.left: parent.left
            anchors.leftMargin: Theme.paddingSmall
            anchors.top: parent.top
            anchors.topMargin: Theme.paddingSmall
            source: "image://theme/icon-m-favorite-selected"
        }
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
            id: labelTitle
            width: parent.width
            font.bold: true
            font.pixelSize: Theme.fontSizeSmall
            wrapMode: Text.Wrap
        }
        Label {
            visible: subtitle.length > 0
            id: labelSubtitle
            width: parent.width
            font.pixelSize: Theme.fontSizeExtraSmall
            wrapMode: Text.Wrap
        }
        Label {
            id: labelInfo
            width: parent.width
            font.pixelSize: Theme.fontSizeExtraSmall
            wrapMode: Text.Wrap
        }
    }
}
