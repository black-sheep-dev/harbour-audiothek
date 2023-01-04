import QtQuick 2.0
import Sailfish.Silica 1.0

import "../."
import "../delegates/"
import "../models/"

Page {
    function load() {
        recentlyPlayedModel.setPodcastObjects(DB.getRecentlyPlayedPodcasts(new Date()))
    }

    function loadMore() {
        recentlyPlayedModel.addPodcastObjects(DB.getRecentlyPlayedPodcasts(recentlyPlayedModel.get(recentlyPlayedModel.count - 1).played_at))
    }

    id: page
    allowedOrientations: Orientation.All

    SilicaFlickable {
//        PullDownMenu {
//            MenuItem {
//                //% "Play all"
//                text: qsTrId("id-play-all")
//                onClicked: {
//                    if (audioPlayer.contentId !== 99999999) {
//                        audioPlayer.contentId = 99999999
//                        audioPlayer.contentType = "bookmarked_list"
//                        audioPlayer.playlistModel.setPodcastObjects(DB.getBookmarkedPodcasts())
//                    }

//                    audioPlayer.play()
//                }
//            }
//        }

        anchors.fill: parent
        contentHeight: contentColumn.height

        //onAtYEndChanged: if (recentlyPlayedModel.count > 0) loadMore()

        Behavior on opacity {
            FadeAnimation { }
        }

        Column {
            id: contentColumn
            width: parent.width
            spacing: Theme.paddingMedium

            PageHeader {
                //% "Recently played podcasts"
                title: qsTrId("id-recently-played-podcasts")
                //% "%n Element(s)"
                description: qsTrId("id-elements-count", recentlyPlayedModel.count)
            }  

            Repeater {
                model: PlaylistModel { id: recentlyPlayedModel }

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
                                    //DB
                                    recentlyPlayedModel.remove(index, 1)
                                })
                            }
                            MenuItem {
                                enabled: audioPlayer.currentUrl !== model.url || !audioPlayer.isPlaying
                                //% "Play"
                                text: qsTrId("id-play")
                                onClicked: audioPlayer.playPodcastObject(recentlyPlayedModel.get(index))
                            }
                        }

                        onClicked: pageStack.push(Qt.resolvedUrl("PodcastDetailsPage.qml"), {
                                                              contentId: model.id
                                                            })
                    }
                    Separator {
                        visible: index < recentlyPlayedModel.count - 1
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
            enabled: recentlyPlayedModel.count === 0
            //% "No recently played podcasts"
            text: qsTrId("id-no-recent-podcasts")
            //% "Play some podcasts and come back"
            hintText: qsTrId("id-no-recent-podcasts-hint")
        }

        VerticalScrollDecorator {}
    }

    Component.onCompleted: load()
}
