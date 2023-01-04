import QtQuick 2.0
import Sailfish.Silica 1.0

import "../."

Item {
    property int position: 0
    property int duration: 0
    property int labelMargin: 0
    property bool showTimeInfo: true

    width: parent.width
    height: showTimeInfo ? timeLabel.y + timeLabel.height : progressBar.height

    Rectangle {
        id: progressBar
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        height: Theme.paddingMedium
        color: Theme.primaryColor
        opacity: Theme.opacityFaint

        Rectangle {
            anchors {
                left: parent.left
            }

            height: parent.height
            color: Theme.highlightColor
            width: Math.round(position / duration * parent.width)
        }
    }

    Label {
        visible: showTimeInfo
        id: timeLabel
        anchors {
            right: parent.right
            rightMargin: labelMargin
            top: progressBar.bottom
            topMargin: Theme.paddingSmall
        }
        font.pixelSize: Theme.fontSizeSmall
        text: Global.getTimeString(position) + " / " + Global.getTimeString(duration)
    }
}
