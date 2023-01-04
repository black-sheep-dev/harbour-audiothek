import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0
import QtGraphicalEffects 1.0

import "../."
import "../components/"
import "../delegates/"
import "../models/"

Page {
    property string contentId
    property alias contentKey: playlistModel.contentKey
    property alias contentType: playlistModel.contentType

    readonly property bool isCurrentContent: audioPlayer.contentType === contentType && audioPlayer.contentId === contentId

    id: page

    allowedOrientations: Orientation.All

    PlaylistModel {
        id: playlistModel
        query: "/" + contentType + "/" + contentId + "?offset={offset}&limit=20"
    }

    PageBusyIndicator {
        running: playlistModel.loading && playlistModel.count === 0

        Label {
            anchors {
                top: parent.bottom
                topMargin: Theme.paddingLarge
                horizontalCenter: parent.horizontalCenter
            }
            color: Theme.highlightColor
            //% "Loading data..."
            text: qsTrId("id-loading-data")
        }
    }

    SilicaFlickable {
        PullDownMenu {
            busy: playlistModel.loading
            MenuItem {
                //% "Share"
                text: qsTrId("id-share")
                onClicked: {
                    Clipboard.text = playlistModel.content["shareUrl"]
                    //% "Link copied to clipboard"
                    notification.show(qsTrId("id-copied-to-clipboard"))
                }
            }
            MenuItem {
                text: {
                    if (audioPlayer.isPlaying && isCurrentContent) {
                        //% "Pause"
                        return qsTrId("id-pause")
                    }
                    //% "Play"
                    return qsTrId("id-play")
                }
                onClicked: {
                    if (audioPlayer.isPlaying && isCurrentContent) {
                        audioPlayer.pause()
                        return
                    }

                    if (!isCurrentContent) {
                        audioPlayer.contentId = contentId
                        audioPlayer.contentType = contentType

                        audioPlayer.playlistModel.query = playlistModel.query
                        audioPlayer.playlistModel.numberOfElements = playlistModel.numberOfElements
                        audioPlayer.playlistModel.content = playlistModel.content

                        audioPlayer.playlistModel.setPodcasts(playlistModel.content["items"]["nodes"])
                    }

                    audioPlayer.play()
                }
            }
        }

        anchors.fill: parent
        contentHeight: contentColumn.y + contentColumn.height

        onAtYEndChanged: if (atYEnd) playlistModel.loadMore()

        RemoteImage {
            id: backgroundImage
            anchors.top: parent.top
            width: parent.width
            height: headerImage.height * 2
            source: playlistModel.content["image"]["url1X1"].toString().replace("{width}", String(width))
            opacity: 0.2
        }

        FastBlur {
            anchors.fill: backgroundImage
            source: backgroundImage
            radius: 100
        }

        PageHeader {
            id: pageHeader
            anchors.top: parent.top

            title: {
                switch (contentType) {
                case "editorialcollections":
                    //% "Collection"
                    return qsTrId("id-collection")

                default:
                    //% "Programset"
                    return qsTrId("id-programset")
                }
            }
            //% "%n episode(s)"
            //description: qsTrId("id-episode-count",  numberOfElements)
            titleColor: Theme.primaryColor
        }

        RemoteImage {
            id: headerImage
            anchors {
                top: pageHeader.bottom
                topMargin: Theme.paddingLarge
                horizontalCenter: parent.horizontalCenter
            }
            width: Math.min(parent.width / 2, 512)
            height: width
            source: playlistModel.content["image"]["url1X1"].toString().replace("{width}", String(width))
        }

        Column {
            id: contentColumn
            anchors {
                top: backgroundImage.bottom
                topMargin: Theme.paddingLarge
            }

            width: parent.width
            spacing: Theme.paddingLarge

            opacity: (playlistModel.loading && playlistModel.count === 0) ? 0.0 : 1.0

            Behavior on opacity {
                FadeAnimation { }
            }

            Label {
                id: titleLabel
                x: Theme.horizontalPageMargin
                width: parent.width - 2*x
                wrapMode: Text.Wrap
                font.bold: true
                font.pixelSize: Theme.fontSizeLarge
                color: Theme.highlightColor
                text: playlistModel.content["title"]
            }

            Label {
                visible: playlistModel.content["broadcastDuration"] > 0
                x: Theme.horizontalPageMargin
                width: parent.width - 2*x
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeExtraSmall
                text: Global.getDurationString(playlistModel.content["broadcastDuration"])
            }

            Label {
                id: descriptionLabel
                x: Theme.horizontalPageMargin
                width: parent.width - 2*x
                wrapMode: Text.Wrap
                color: Theme.primaryColor
                text: playlistModel.content["synopsis"]
            }

            SectionHeader {
                //% "%n Episodes"
                text: qsTrId("id-episode-count", playlistModel.numberOfElements)
                font.pixelSize: Theme.fontSizeMedium
            }

            Column {
                width: parent.width

                Repeater {
                    model: playlistModel

                    Item {
                        width: parent.width
                        height: separator.y + separator.height + Theme.paddingMedium

                        PlaylistDelegate {
                            id: delegate
                            playing: audioPlayer.currentUrl === model.url

                            menu: ContextMenu {
                                MenuItem {
                                    text: model.bookmarked ?
                                              //% "Remove bookmark"
                                              qsTrId("id-remove-bookmark") :
                                              //% "Add bookmark"
                                              qsTrId("id-add-bookmark")
                                    onClicked: {
                                        if (model.bookmarked) {
                                            DB.bookmarkPodcast(model.id, false)
                                            playlistModel.setProperty(index, "bookmarked", false)
                                        } else {
                                            DB.addPodcast(playlistModel.content["items"]["nodes"][index])
                                            DB.bookmarkPodcast(model.id, true)
                                            playlistModel.setProperty(index, "bookmarked", true)
                                        }
                                    }
                                }
                                MenuItem {
                                    //% "Play"
                                    text: qsTrId("id-play")
                                    onClicked: {
                                        if (!isCurrentContent) {
                                            audioPlayer.playPodcast(playlistModel.content["items"]["nodes"][index])
                                        } else {
                                            audioPlayer.playlist.currentIndex = index
                                        }
                                    }
                                }
                            }

                            onClicked: pageStack.push(Qt.resolvedUrl("PodcastDetailsPage.qml"), {
                                                                  contentId: model.id
                                                                })
                        }
                        Separator {
                            visible: index < playlistModel.count - 1
                            id: separator
                            anchors {
                                top: delegate.bottom
                                topMargin: Theme.paddingMedium
                                left: parent.left
                                leftMargin: Theme.horizontalPageMargin
                                right: parent.right
                                rightMargin: Theme.horizontalPageMargin
                            }
                            color: Theme.primaryColor
                        }
                    }
                }
            }

            Item {
                width: 1
                height: Theme.paddingMedium + playerWidget.visibleHeight
            }
        }

        VerticalScrollDecorator {}
    }

    Component.onCompleted: playlistModel.load()
}
