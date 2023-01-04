import QtQuick 2.0
import Sailfish.Silica 1.0

import "../."
import "../delegates/"
import "../models/"

Page {
    function load() {
        bookmarksModel.setPodcastObjects(DB.getBookmarkedPodcasts())
    }

    id: page
    allowedOrientations: Orientation.All

    SilicaFlickable {
        PullDownMenu {
            MenuItem {
                //% "Play all"
                text: qsTrId("id-play-all")
                onClicked: {
                    if (audioPlayer.contentId !== 99999999) {
                        audioPlayer.contentId = 99999999
                        audioPlayer.contentType = "bookmarked_list"
                        audioPlayer.playlistModel.setPodcastObjects(DB.getBookmarkedPodcasts())
                    }

                    audioPlayer.play()
                }
            }
        }

        anchors.fill: parent
        contentHeight: contentColumn.height

        Behavior on opacity {
            FadeAnimation { }
        }

        Column {
            id: contentColumn
            width: parent.width
            spacing: Theme.paddingMedium

            PageHeader {
                //% "Bookmarked Podcasts"
                title: qsTrId("id-bookmarked-podcasts")
                //% "%n Element(s)"
                description: qsTrId("id-elements-count", bookmarksModel.count)
            }  

            Repeater {
                model: PlaylistModel { id: bookmarksModel }

                Item {
                    width: parent.width
                    height: separator.y + separator.height + Theme.paddingMedium

                    PlaylistDelegate {
                        id: delegate
                        playing: audioPlayer.currentUrl === model.url

                        menu: ContextMenu {
                            MenuItem {
                                //% "Remove"
                                text: qsTrId("id-remove")
                                //% "Removing podcast"
                                onClicked: delegate.remorseAction(qsTrId("id-remove-remorse"), function() {
                                    DB.bookmarkPodcast(model.id, false)
                                    bookmarksModel.remove(index, 1)
                                })
                            }
                            MenuItem {
                                enabled: audioPlayer.currentUrl !== model.url || !audioPlayer.isPlaying
                                //% "Play"
                                text: qsTrId("id-play")
                                onClicked: audioPlayer.playPodcastObject(bookmarksModel.get(index))
                            }
                        }

                        onClicked: pageStack.push(Qt.resolvedUrl("PodcastDetailsPage.qml"), {
                                                              contentId: model.id
                                                            })
                    }
                    Separator {
                        visible: index < bookmarksModel.count - 1
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

            Item {
                width: 1
                height: Theme.paddingMedium + playerWidget.visibleHeight
            }
        }

        ViewPlaceholder {
            enabled: bookmarksModel.count === 0
            //% "No bookmarked podcasts"
            text: qsTrId("id-no-bookmarks")
            //% "Add bookmarks to podcasts first"
            hintText: qsTrId("id-no-bookmarks-hint")
        }

        VerticalScrollDecorator {}
    }

    onStatusChanged: if (status === PageStatus.Active) pageStack.pushAttached(Qt.resolvedUrl("RecentlyPlayedListPage.qml"))

    Component.onCompleted: load()
}
