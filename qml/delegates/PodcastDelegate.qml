import QtQuick 2.0
import Sailfish.Silica 1.0

import "../."
import "../components/"

ListItem {
    property bool bookmarked: false
    property bool downloaded: false
    property alias image: remoteImage.source
    property alias info: infoLabel.text
    property string podcastId
    property alias subtitle: subtitleLabel.text
    property alias title: titleLabel.text

    width: parent.width
    contentHeight: Math.max(remoteImage.height, contentColumn.height) + 2*Theme.paddingSmall

    Separator {
        x: Theme.horizontalPageMargin
        width: parent.width - 2*x
        color: Theme.primaryColor
    }

    Row {
        id: headerRow
        x: Theme.horizontalPageMargin
        width: parent.width - 2*x
        spacing: Theme.paddingMedium

        RemoteImage {
            id: remoteImage
            width: Theme.itemSizeExtraLarge
            height: width
        }

        Column {
            id: contentColumn
            width: parent.width - remoteImage.width - parent.spacing
            spacing: Theme.paddingSmall

            Label {
                id: titleLabel
                width: parent.width
                font.pixelSize: Theme.fontSizeSmall
                font.bold: true
                color: Theme.primaryColor
                wrapMode: Text.Wrap
            }
            Label {
                visible: subtitleLabel.text.length > 0
                id: subtitleLabel
                width: parent.width
                font.pixelSize: Theme.fontSizeTiny
                wrapMode: Text.Wrap
                color: Theme.primaryColor
            }

            Label {
                visible: infoLabel.text.length > 0
                id: infoLabel
                width: parent.width
                font.pixelSize: Theme.fontSizeTiny
                wrapMode: Text.Wrap
                color: Theme.primaryColor
            }
        }
    }
}

