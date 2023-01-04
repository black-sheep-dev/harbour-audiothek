import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: pageIndicator
    property int count: 0
    property int currentIndex: 0

    anchors.horizontalCenter: parent.horizontalCenter
    width: parent.width

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        //width: count * Theme.itemSizeExtraSmall + count * Theme.paddingMedium
        spacing: Theme.paddingMedium

        Repeater {
            model: pageIndicator.count

            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                width: index === currentIndex ? Theme.itemSizeExtraSmall / 3 : Theme.itemSizeExtraSmall / 4
                height: width

                Behavior on width { NumberAnimation { duration: 200 } }

                radius: width / 2
                opacity: index === currentIndex ? 1.0 : Theme.opacityLow
                color: index === currentIndex ? Theme.highlightColor : Theme.primaryColor
            }
        }
    }
}
