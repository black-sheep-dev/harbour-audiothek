import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.6

import "../components"
import "../."

CoverBackground {
    Image {
        visible: coverImage.status === Image.Error || audioPlayer.contentId.length === 0
        anchors {
            top: parent.top
        }
        opacity: 0.1

        sourceSize{
            height: parent.width
            width: parent.width
        }
        source: "/usr/share/harbour-audiothek/images/cover-background.svg"
    }
    RemoteImage {
        id: coverImage
        visible: status !== Image.Error && audioPlayer.contentId.length > 0
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        source: audioPlayer.currentContent.image.replace("{width}", String(width))

        Rectangle {
            anchors.fill: parent
            color: "black"
            opacity: 0.4
        }

        Column {
            anchors.topMargin: Theme.paddingLarge
            anchors.top: parent.top
            x: Theme.horizontalPageMargin
            width: parent.width - 2*x
            spacing: Theme.paddingSmall

            Label {
                id: label
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: Theme.fontSizeLarge
                color: Theme.highlightColor
                //% "Audiothek"
                text: qsTrId("id-app-name")
            }

            Label {
                width: parent.width
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeSmall
                font.bold: true
                text: audioPlayer.currentContent.title
            }
        }
    }

    CoverActionList {
        id: coverAction
        CoverAction {
            iconSource: audioPlayer.playbackState === MediaPlayer.PlayingState ? "image://theme/icon-cover-pause" : "image://theme/icon-cover-play"
            onTriggered: audioPlayer.playbackState === MediaPlayer.PlayingState ? audioPlayer.pause() : audioPlayer.play()
        }

        CoverAction {
            iconSource: "image://theme/icon-cover-next-song"
            onTriggered: if (audioPlayer.playlist.count > 1) audioPlayer.playlist.next()
        }
    }
}
