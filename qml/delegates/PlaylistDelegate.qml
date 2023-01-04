import QtQuick 2.0
import Sailfish.Silica 1.0

import "../."
import "../components/"

ListItem {
    property bool playing: false

    width: parent.width
    contentHeight: descriptionLabel.y + descriptionLabel.height + 2*Theme.paddingMedium

    Rectangle {
        visible: playing
        anchors.fill: parent
        color: Theme.highlightBackgroundColor
        opacity: Theme.opacityFaint
    }

    ProgressIndicator {
        visible: model.position > 0
        id: progressIndicator
        anchors.top: remoteImage.height > contentColumn.height ? remoteImage.bottom : contentColumn.bottom
        x: Theme.horizontalPageMargin
        width: parent.width - 2*x

        showTimeInfo: false
        position: (audioPlayer.currentUrl === model.url && audioPlayer.isPlaying) ? audioPlayer.position : DB.getPodcastPosition(model.id)
        duration: model.duration * 1000
    }

    RemoteImage {
        id: remoteImage
        y: Theme.paddingSmall
        anchors {
            top: parent.top
            topMargin: Theme.paddingSmall
            left: parent.left
            leftMargin: Theme.horizontalPageMargin
        }
        width: playing ? Theme.itemSizeExtraLarge : Theme.itemSizeMedium
        height: width

        Behavior on width { NumberAnimation { easing.type: Easing.Linear } }

        source: model.image.toString().replace("{width}", String(Theme.itemSizeExtraLarge))

        Icon {
            visible: model.bookmarked
            id: bookmarkedIcon
            anchors {
                top: parent.top
                left: parent.left
                leftMargin: Theme.paddingSmall
            }
            width: Theme.iconSizeExtraSmall
            height: Theme.iconSizeExtraSmall
            smooth: true
            source: "/usr/share/harbour-audiothek/icons/badge-bookmark.svg"
        }

        Icon {
            visible: model.completed
            anchors {
                top: parent.top
                left: model.bookmarked ? bookmarkedIcon.right : parent.left
                leftMargin: model.bookmarked ? 0 : Theme.paddingSmall
            }
            width: Theme.iconSizeExtraSmall
            height: Theme.iconSizeExtraSmall
            smooth: true
            source: "/usr/share/harbour-audiothek/icons/badge-completed.svg"
        }
    }

    Column {
        id: contentColumn
        anchors {
            left: remoteImage.right
            right: parent.right
            top: remoteImage.top
            leftMargin: Theme.paddingMedium
            rightMargin: Theme.horizontalPageMargin
            bottomMargin: Theme.paddingSmall
        }
        spacing: Theme.paddingSmall

        Label {
            id: titleLabel
            width: parent.width
            font.pixelSize: Theme.fontSizeSmall
            font.bold: true
            color: Theme.highlightColor
            wrapMode: Text.Wrap
            text: model.title
        }
        Label {
            width: parent.width
            font.pixelSize: Theme.fontSizeTiny
            wrapMode: Text.Wrap
            color: Theme.highlightColor
            text: Global.getDurationString(model.duration)
        }
    }

    Label {
        id: descriptionLabel
        anchors {
            top: progressIndicator.bottom
            topMargin: Theme.paddingMedium
            left: parent.left
            leftMargin: Theme.horizontalPageMargin
            right: parent.right
            rightMargin: Theme.horizontalPageMargin
        }
        wrapMode: Text.Wrap
        font.pixelSize: Theme.fontSizeSmall

        text: model.synopsis
    }
}

