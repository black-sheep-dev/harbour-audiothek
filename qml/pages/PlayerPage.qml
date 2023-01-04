import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.6

import "."
import "../."
import "../components/"
import "../delegates/"

Page {
    id: page

    allowedOrientations: Orientation.All

    Connections {
        target: audioPlayer
        onPositionChanged: progressSlider.value = audioPlayer.position
    }

    SilicaFlickable {
        PullDownMenu {
            MenuItem {
                //% "Clear playlist"
                text: qsTrId("id-clear-playlist")
                onClicked: audioPlayer.clearPlaylist()
            }
        }

        anchors.fill: parent

        contentHeight: headerImage.height + progressSlider.height / 2 + progressLabel.height + controlsRow.height + contentColumn.height + Theme.paddingLarge

        RemoteImage {
            id: headerImage
            anchors.top: parent.top
            width: parent.width
            source: audioPlayer.currentContent.image.replace("{width}", String(width))

//            RemoteImage {
//                anchors.top: parent.top
//                anchors.topMargin: Theme.paddingMedium
//                anchors.right: parent.right
//                anchors.rightMargin: Theme.paddingMedium
//                width: Theme.itemSizeSmall
//                height: width

//                source: Global.applyDataToImageLink(audioPlayer.currentItem.serviceLogo, "1x1", width)
//            }
        }

        Slider {
            id: progressSlider

            anchors.topMargin: -height / 2

            anchors.top: headerImage.bottom
            anchors.horizontalCenter: parent.horizontalCenter

            width: parent.width + 5 * Theme.paddingLarge - 16

            minimumValue: 0
            maximumValue: audioPlayer.duration
            stepSize: 1000
            value: 0
            handleVisible: true

            onReleased: audioPlayer.seek(value)

            Connections {
                target: audioPlayer
                onPositionChanged: progressSlider.value = audioPlayer.position
            }
        }

        Label {
            id: progressLabel
            anchors.top: progressSlider.bottom
            anchors.left: parent.left
            anchors.leftMargin: Theme.horizontalPageMargin
            font.pixelSize: Theme.fontSizeSmall
            text: {
                if (audioPlayer.position > 3600000)
                    new Date(audioPlayer.position).toISOString().substr(11, 8)
                else
                    new Date(audioPlayer.position).toISOString().substr(14, 5)
            }
        }

        Label {
            anchors.top: progressSlider.bottom
            anchors.right: parent.right
            anchors.rightMargin: Theme.horizontalPageMargin
            font.pixelSize: Theme.fontSizeSmall
            text: {
                if (audioPlayer.duration > 3600000)
                    new Date(audioPlayer.duration).toISOString().substr(11, 8)
                else
                    new Date(audioPlayer.duration).toISOString().substr(14, 5)
            }
        }

        Row {
            id: controlsRow
            anchors.top: progressLabel.bottom
            anchors.topMargin: Theme.paddingSmall
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: Theme.paddingLarge

            IconButton {
                anchors.verticalCenter: parent.verticalCenter
                icon.source: "image://theme/icon-m-previous"
                onClicked: audioPlayer.previous()
            }

            IconButton {
                anchors.verticalCenter: parent.verticalCenter
                icon.source: "image://theme/icon-m-10s-back"
                onClicked: audioPlayer.stepBackwards()
            }

            IconButton {
                anchors.verticalCenter: parent.verticalCenter
                icon.width: Theme.itemSizeLarge
                icon.height: icon.width
                icon.source: audioPlayer.playbackState === MediaPlayer.PlayingState ? "image://theme/icon-m-pause" : "image://theme/icon-m-play"

                onClicked: audioPlayer.playbackState === MediaPlayer.PlayingState ? audioPlayer.pause() : audioPlayer.play()
            }

            IconButton {
                anchors.verticalCenter: parent.verticalCenter
                icon.source: "image://theme/icon-m-10s-forward"
                onClicked: audioPlayer.stepForward()
            }

            IconButton {
                anchors.verticalCenter: parent.verticalCenter
                icon.source: "image://theme/icon-m-next"
                onClicked: audioPlayer.next()
            }
        }


        Column {
            id: contentColumn
            anchors.top: controlsRow.bottom
            anchors.topMargin: Theme.paddingLarge
            width: parent.width
            spacing: Theme.paddingMedium

            BackgroundItem {
                width: parent.width
                height: headerColumn.height + 2*Theme.paddingSmall

                Column {
                    id: headerColumn
                    anchors.verticalCenter: parent.verticalCenter
                    x: Theme.horizontalPageMargin
                    width: parent.width - 2*x
                    spacing: Theme.paddingSmall

                    Label {
                        width: parent.width
                        font.bold: true
                        wrapMode: Text.Wrap
                        text: audioPlayer.currentPodcast.title
                    }

//                    Label {
//                        width: parent.width
//                        font.pixelSize: Theme.fontSizeExtraSmall
//                        wrapMode: Text.Wrap
//                        text: audioPlayer.currentPodcast.show + " - " + audioPlayer.currentPodcast.channel
//                    }
                }

                onClicked: pageStack.push(Qt.resolvedUrl("PodcastDetailsPage.qml"), {
                                                      podcastId: audioPlayer.currentPodcast.id
                                                  })
            }

            SectionHeader {
                font.pixelSize: Theme.fontSizeLarge
                //% "Playlist"
                text: qsTrId("id-playlist")
            }

            Column {
                width: parent.width

                Repeater {
                    model: audioPlayer.playlistModel

                    PlaylistDelegate {
                        id: playlistItem
                        playing: audioPlayer.playlist.currentIndex === index

                        menu: ContextMenu {
                            visible: audioPlayer.playlist.currentIndex !== index
                            MenuItem {
                                //% "Remove"
                                text: qsTrId("id-remove")
                                //% "Remove item"
                                onClicked: playlistItem.remorseAction(qsTrId("id-remove-item"), function() { audioPlayer.remove(index) })
                            }
                            MenuItem {
                                //% "Play"
                                text: qsTrId("id-play")
                                onClicked: audioPlayer.playIndex(index)
                            }
                        }
                    }
                }
            }

            Item {
                width: 1
                height: Theme.paddingMedium
            }
        }

        VerticalScrollDecorator {}
    }

    onStatusChanged: {
        switch (status) {
        case PageStatus.Activating:
            playerWidget.state = "hidden"
            break

        case PageStatus.Deactivating:
            if (audioPlayer.isPlaying) playerWidget.state = "visible"
            break


        default:
            break

        }
    }

    Component.onCompleted: progressSlider.value = audioPlayer.position
}
