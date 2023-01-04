import QtQuick 2.0
import Sailfish.Silica 1.0

import "../."
import "../components/"
import "../delegates/"
import "../models/"

Page {
    id: page
    allowedOrientations: Orientation.All

    PlaylistModel {
        id: playlistModel
        contentKey: "search"
        contentType: "searchlist"
        query: "/search?query=" + searchField.text + "&offset={offset}&limit=20"
    }

    PageBusyIndicator {
        running: playlistModel.loading

        Label {
            anchors {
                top: parent.bottom
                topMargin: Theme.paddingLarge
                horizontalCenter: parent.horizontalCenter
            }
            color: Theme.highlightColor
            //% "Searching content..."
            text: qsTrId("id-searching-content")
        }
    }

    SilicaFlickable {
        anchors.fill: parent

        Column {
            id: header
            width: parent.width

            PageHeader {
                //% "Search content"
                title: qsTrId("id-search-content")
                //% "%n element(s)"
                description: playlistModel.numberOfElements > 0 ? (listView.count + " / " + qsTrId("id-elements-count", playlistModel.numberOfElements)) : ""
            }

            SearchField {
                enabled: !playlistModel.loading
                id: searchField
                width: parent.width
                height: implicitHeight

                focus: true

                onTextChanged: {
                    if (searchField.text.length === 0) {
                       playlistModel.numberOfElements = 0
                       playlistModel.reset()
                    }
                }

                EnterKey.onClicked: {
                    focus = false
                    playlistModel.load()
                }
            }
        }

        SilicaListView {
            id: listView 
            anchors {
                bottom: parent.bottom
                top: header.bottom
            }
            width: parent.width
            clip: true

            spacing: Theme.paddingLarge

            model: playlistModel

            onAtYEndChanged: if (atYEnd) playlistModel.loadMore()

            delegate: PlaylistDelegate {
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
                            if (audioPlayer.contentId !== model.id) {
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

            ViewPlaceholder {
                enabled: listView.count === 0 && !playlistModel.loading
                //% "No content found"
                text: qsTrId("id-no-content-found")
                //% "Type in a search pattern to find content"
                hintText: qsTrId("id-no-content-found-hint")
            }

            VerticalScrollDecorator {}
        }
    }

    Item {
        id: spacer
        anchors {
            bottom: parent.bottom
        }

        width: 1
        height: playerWidget.visibleHeight
    }
}

