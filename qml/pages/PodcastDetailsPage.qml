import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.6

import "../."
import "../components/"
import "../delegates/"

Page {
    property bool bookmarked: false
    property bool completed: false

    property var content
    property string contentId
    readonly property string contentType: "podcast"

    property bool loading: false

    readonly property bool isCurrentContent: audioPlayer.contentType === contentType && audioPlayer.contentId === contentId

    function bookmark() {
        DB.addPodcast(content)
        if (!DB.bookmarkPodcast(contentId, !bookmarked)) return
        bookmarked = !bookmarked
    }

    function load() {
        loading = true
        Api.request("/items/" + contentId, function(data, status) {
            loading = false
            console.log(contentId)
            if (status !== 200) {
                //% "Failed to fetch data"
                notify.show(qsTrId("id-failed-to-fetch-data"))
                return
            }

            content = data["data"]["item"]
        })
    }

    id: page

    allowedOrientations: Orientation.All 

    PageBusyIndicator {
        running: loading && content === undefined

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
            busy: loading
            MenuItem {
                //% "Share"
                text: qsTrId("id-share")
                onClicked: {
                    if (settings.shareMode === 0) {
                        Clipboard.text = content["sharingUrl"]
                    } else {
                        Clipboard.text = content["audios"][0]["url"]
                    }
                    //% "Link copied to clipboard"
                    notification.show(qsTrId("id-copied-to-clipboard"))

                }
            }
            MenuItem {

                text: bookmarked ?
                          //% "Remove bookmark"
                          qsTrId("id-remove-bookmark") :
                          //% "Add bookmark"
                          qsTrId("id-add-bookmark")
                onClicked: bookmark()
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

                    audioPlayer.contentId = contentId
                    audioPlayer.contentType = contentType
                    audioPlayer.playPodcast(content)
                }
            }
        }

        anchors.fill: parent
        contentHeight: headerImage.height + contentColumn.height + contentColumn.anchors.topMargin

        RemoteImage {
            id: headerImage
            anchors.top: parent.top
            width: parent.width  
            source: content["image"]["url"].toString().replace("{width}", String(width))

            RemoteImage {
                anchors {
                    top: parent.top
                    topMargin: Theme.paddingLarge
                    right: parent.right
                    rightMargin: Theme.horizontalPageMargin
                }
                width: Theme.itemSizeSmall
                height: width
                source: content["programSet"]["publicationService"]["image"]["url1X1"].toString().replace("{width}", String(width))
            }

            Icon {
                visible: bookmarked
                id: bookmarkedIcon
                anchors {
                    top: parent.top
                    left: parent.left
                    leftMargin: 2 * Theme.paddingLarge
                }
                width: Theme.iconSizeMedium
                height: width
                smooth: true
                source: "/usr/share/harbour-audiothek/icons/badge-bookmark.svg"
            }

            Icon {
                visible: completed
                anchors {
                    top: parent.top
                    left: bookmarked ? bookmarkedIcon.right : parent.left
                    leftMargin: bookmarked ? Theme.paddingSmall : 2 * Theme.paddingLarge
                }
                width: Theme.iconSizeMedium
                height: width
                smooth: true
                source: "/usr/share/harbour-audiothek/icons/badge-completed.svg"
            }
        }

        ProgressIndicator {
            //visible: false
            id: progressIndicator
            anchors {
                top: headerImage.bottom
                left: parent.left
                right: parent.right
            }
            labelMargin: Theme.horizontalPageMargin
            position: audioPlayer.contentId === contentId && audioPlayer.playbackState === Audio.PlayingState ? audioPlayer.position : DB.getPodcastPosition(contentId)

            duration: content["duration"] * 1000
        }

        Column {
            id: contentColumn
            anchors {
                top: progressIndicator.bottom
                topMargin: Theme.paddingLarge
            }
            width: parent.width
            spacing: Theme.paddingLarge

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2*x
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeLarge
                font.bold: true
                color: Theme.highlightColor
                text: content["title"]
            }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2*x
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeTiny
                text: content["tracking"]["play"]["show"] + " - " + content["tracking"]["play"]["channel"]
            }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2*x
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeTiny
                font.bold: true
                text: new Date(content["publicationStartDateAndTime"]).toLocaleDateString() + " - " + Global.getDurationString(content["duration"])
            }

            LinkedLabel {
                x: Theme.horizontalPageMargin
                width: parent.width - 2*x
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.primaryColor
                linkColor: Theme.highlightColor
                plainText: content["synopsis"]

                onLinkActivated: Qt.openUrlExternally(link)
            }

            SectionHeader {
                //% "This episode is part of"
                text: qsTrId("id-episode-part-of")
            }

            BackgroundItem {
                width: parent.width
                height: Math.max(image.height, column.height + 2*Theme.paddingSmall)

                Rectangle {
                    anchors.fill: parent
                    color: Theme.primaryColor
                    opacity: 0.1
                }

                RemoteImage {
                    id: image
                    anchors {
                        left: parent.left
                        top: parent.top
                    }

                    width: Theme.itemSizeHuge
                    height: width
                    source: content["programSet"]["image"]["url1X1"].toString().replace("{width}", String(width))
                }

                Column {
                    id: column
                    anchors {
                        left: image.right
                        leftMargin: Theme.paddingMedium
                        top: parent.top
                        topMargin: Theme.paddingSmall
                        right: parent.right
                        rightMargin: Theme.horizontalPageMargin
                    }
                    spacing: Theme.paddingMedium

                    Label {
                        width: parent.width
                        wrapMode: Text.Wrap
                        font.pixelSize: Theme.fontSizeSmall
                        font.bold: true
                        text: content["programSet"]["synopsis"]
                    }

                    Label {
                        width: parent.width
                        wrapMode: Text.Wrap
                        font.pixelSize: Theme.fontSizeSmall
                        //% "%n Episodes"
                        text: qsTrId("id-episode-count", content["programSet"]["numberOfElements"])
                    }

                    Item {
                        width: 1
                        height: Theme.paddingSmall
                    }
                }
                onClicked: pageStack.push(Qt.resolvedUrl("CollectionDetailsPage.qml"), {
                                              contentId: content["programSet"]["id"],
                                              contentKey: "programSet",
                                              contentType: "programsets"
                                          })
            }

            Item {
                width: 1
                height: Theme.paddingMedium + playerWidget.visibleHeight
            }
        }

        VerticalScrollDecorator {}
    }

    Component.onCompleted: {
        if (contentId.length === 0) return
        load()
        bookmarked = DB.isPodcastBookmarked(contentId)
        //bookmarked = true
        console.log(bookmarked)
    }
}
