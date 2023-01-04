import QtQuick 2.0
import Sailfish.Silica 1.0
import QtGraphicalEffects 1.0

Image {
    property int gradientPos: 1

    id: remoteImage
    width: parent.width
    height: 9 / 16 * parent.width
    sourceSize.width: width
    sourceSize.height: height

    fillMode: Image.PreserveAspectCrop

    asynchronous: true
    cache: true

    Rectangle {
        id: overlay
        visible: parent.status !== Image.Ready || parent.status === Image.Error
        anchors.fill: parent
        color: Theme.backgroundGlowColor
        opacity: Theme.opacityOverlay

        Icon {
            anchors.centerIn: parent
            width: parent.width * 0.4
            height: width / sourceSize.width * sourceSize.height
            opacity: 0.4
            source: "image://theme/icon-l-image"
        }

        SequentialAnimation {
            running: parent.status !== Image.Ready
            loops: Animation.Infinite
            ColorAnimation {
                target: overlay
                property: "color"
                duration: 1500
                from: Theme.backgroundGlowColor
                to: Theme.secondaryHighlightColor
            }
            ColorAnimation {
                target: overlay
                property: "color"
                duration: 1500
                to: Theme.backgroundGlowColor
                from: Theme.secondaryHighlightColor
            }
        }
    }
}
