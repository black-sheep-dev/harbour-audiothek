import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.6

import "."
import "../."

Item {    
    readonly property int hiddenY: parent.height
    readonly property int visibleY: parent.height - Math.max(remoteImage.height, contentColumn.height)
    readonly property int maximizedY: parent.height - audioWidget.height
    readonly property int visibleHeight: {
        switch (state) {
        case "visible":
            return Math.max(remoteImage.height, contentColumn.height)

        case "maximized":
            return height

        default:
            return 0
        }
    }

    id: audioWidget

    y: hiddenY

    width: parent.width
    height: Math.max(remoteImage.height, contentColumn.height) + seekSlider.height + controlButtons.height

    Behavior on y { NumberAnimation {} }

    states: [
        State {
            name: "hidden"
            PropertyChanges {
                target: audioWidget
                y: hiddenY
                visible: false
            }
        },
        State {
            name: "visible"
            PropertyChanges {
                target: audioWidget
                y: visibleY
                visible: true
            }
        },
        State {
            name: "maximized"
            PropertyChanges {
                target: audioWidget
                y: maximizedY
                visible: true
            }
        }
    ]

    Connections {
        target: audioPlayer
        onPlaybackStateChanged: {
            switch (audioPlayer.playbackState) {
            case MediaPlayer.PlayingState:
            case MediaPlayer.PausedState:
                audioWidget.state = "visible"
                break

            default:
                audioWidget.state = "hidden"
            }
        }
        onPositionChanged: seekSlider.value = audioPlayer.position
    }

    MouseArea {
        anchors {
            top: parent.top
            left: parent.left
            right: progressCircle.left
            bottom: remoteImage.bottom
        }
        onClicked: audioWidget.state = "maximized"
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.overlayBackgroundColor
        opacity: Theme.opacityOverlay
    }

    RemoteImage {
        id: remoteImage
        anchors {
            left: parent.left
            top: parent.top
        }
        height: Theme.itemSizeLarge
        width: height
        source: audioPlayer.currentContent.image.replace("{width}", String(width))
    }

    Column {
        id: contentColumn
        anchors {
            topMargin: Theme.paddingSmall
            bottomMargin: Theme.paddingSmall
            left: remoteImage.right
            leftMargin: Theme.paddingMedium
            right: progressCircle.left
            rightMargin: Theme.paddingMedium
        }

        spacing: Theme.paddingSmall

        Label {
            width: parent.width
            font.pixelSize: Theme.fontSizeSmall
            wrapMode: Text.Wrap
            text: audioPlayer.currentContent.title
        }

        Row {
            width: parent.width
            spacing: Theme.paddingSmall

            Label {
                font.pixelSize: Theme.fontSizeTiny
                text: {
                    if (audioPlayer.duration < 3600000)
                        return new Date(seekSlider.value).toISOString().substr(14, 5)
                    else
                        return new Date(seekSlider.value).toISOString().substr(11, 8)
                }
            }

            Label {
                font.pixelSize: Theme.fontSizeTiny
                text: "/"
            }

            Label {
                font.pixelSize: Theme.fontSizeTiny
                text: Global.getTimeString(audioPlayer.duration)
            }
        }
    }

    ProgressCircle {
        id: progressCircle
        anchors {
            right: parent.right
            rightMargin: Theme.horizontalPageMargin
            verticalCenter: remoteImage.verticalCenter
        }
        width: playButton.width
        height: width
        borderWidth: Theme.paddingSmall

        progressValue: seekSlider.value / audioPlayer.duration

        IconButton {
            id: playButton
            anchors.centerIn: parent
            icon.source: audioPlayer.playbackState === MediaPlayer.PlayingState ? "image://theme/icon-m-pause" : "image://theme/icon-m-play"

            onClicked: audioPlayer.playbackState === MediaPlayer.PlayingState ? audioPlayer.pause() : audioPlayer.play()
        }
    }

    Slider {
        id: seekSlider
        anchors {
           top: remoteImage.height > contentColumn.height ? remoteImage.bottom : contentColumn.bottom
           horizontalCenter: parent.horizontalCenter
        }
        width: parent.width + 2*Theme.paddingLarge
        minimumValue: 0
        maximumValue: audioPlayer.duration
        stepSize: 1000
        onReleased: audioPlayer.seek(value)
    }

    Row {
        id: controlButtons
        anchors {
            top: seekSlider.bottom
            topMargin: -Theme.paddingMedium
            left: parent.left
            leftMargin: Theme.horizontalPageMargin
        }

        IconButton {
            id: buttonPrevious
            anchors.verticalCenter: parent.verticalCenter
            icon.source: "image://theme/icon-m-previous"
            onClicked: audioPlayer.previous()
        }

        IconButton {
            id: buttonRewind
            anchors.verticalCenter: parent.verticalCenter
            icon.source: "image://theme/icon-m-media-rewind"
            onClicked: audioPlayer.stepBackwards()
        }

        IconButton {
            id: buttonStop
            anchors.verticalCenter: parent.verticalCenter
            icon.source: "image://theme/icon-m-stop"
            onClicked: audioPlayer.stopPlayback()
        }

        IconButton {
            id: buttonForward
            anchors.verticalCenter: parent.verticalCenter
            icon.source: "image://theme/icon-m-media-forward"
            onClicked: audioPlayer.stepForwards()
        }

        IconButton {
            id: buttonNext
            anchors.verticalCenter: parent.verticalCenter
            icon.source: "image://theme/icon-m-next"
            onClicked: audioPlayer.next()
        }
    }

    Row {
        anchors {
            verticalCenter: controlButtons.verticalCenter
            right: parent.right
            rightMargin: Theme.horizontalPageMargin
        }

        IconButton {
            id: buttonShowPlaylist

            icon.source: "image://theme/icon-m-menu"
            onClicked: pageStack.push("../pages/PlayerPage.qml")
        }

        IconButton {
            id: buttonMinimize

            icon.source: "image://theme/icon-m-down"
            onClicked: audioWidget.state = "visible"
        }
    }

    Component.onCompleted: state = "hidden"
}
