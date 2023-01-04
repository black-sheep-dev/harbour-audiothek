import QtQuick 2.0
import Sailfish.Silica 1.0

import "../."
import "../components/"

Item {
    property alias title: header.text
    property alias model: slideshowView.model
    property string contentType: "programsets"

    width: parent.width
    height: separator.height + header.height + slideshowView.height + 2*Theme.paddingLarge

    Separator {
        visible: title.length > 0
        id: separator
        anchors.top: parent.top
        width: parent.width
        color: Theme.primaryColor
    }

    Label {
        visible: title.length > 0
        id: header
        anchors{
            top: separator.top
            topMargin: Theme.paddingLarge
        }
        x: Theme.horizontalPageMargin
        width: parent.width - 2*x
        wrapMode: Text.Wrap
        font.pixelSize: Theme.fontSizeLarge
        color: Theme.highlightColor
        truncationMode: TruncationMode.Fade
    }

    SlideshowView {
        id: slideshowView
        anchors {
            top: header.bottom
            topMargin: Theme.paddingLarge
        }
        width: parent.width
        height: itemHeight
        clip: true

        itemWidth: 3*Theme.itemSizeExtraLarge
        itemHeight: 3*Theme.itemSizeExtraLarge

        delegate: CollectionItem {
            width: parent.itemWidth - 2*Theme.paddingSmall
            height: parent.itemHeight

            onClicked: {
                switch (contentType) {
                case "editorialcollections":
                    pageStack.push(Qt.resolvedUrl("../pages/CollectionDetailsPage.qml"), {
                                                    contentId: modelData["id"],
                                                    contentKey: "editorialCollection",
                                                    contentType: "editorialcollections"
                                                })
                    break
                case "programsets":
                    pageStack.push(Qt.resolvedUrl("../pages/CollectionDetailsPage.qml"), {
                                                    contentId: modelData["id"],
                                                    contentKey: "programSet",
                                                    contentType: "programsets"
                                                })
                    break

                default:
                    break
                }


            }
        }
    }
}
