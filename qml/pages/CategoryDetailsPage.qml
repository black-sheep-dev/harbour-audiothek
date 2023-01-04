import QtQuick 2.0
import Sailfish.Silica 1.0

import "../."
import "../components/"

Page {
    property var category
    property string contentId
    property bool loading: false

    id: page

    allowedOrientations: Orientation.All

    function load() {
        loading = true
        console.log(contentId)
        Api.request("/editorialcategories/" + contentId, function(data, status) {
            loading = false
            if (status !== 200) {
                //% "Failed to fetch data"
                notify.show(qsTrId("id-failed-to-fetch-data"))
                return
            }

            category = data["data"]["editorialCategory"]
        })
    }

    function refreshContent() {
        for(var i = contentColumn.children.length; i > 0; i--) {
            contentColumn.children[i-1].destroy()
        }

        category["sections"].forEach(function(item) {
            var component

            const itemsKey
            const contentType = "podcasts"

            switch (item["type"]) {

            case "featured_programset":
                component = Qt.createComponent("../components/CollectionsSlideView.qml")
                itemsKey = "nodes"
                contentType = "programsets"
                break

            case "GRID_LIST":
                if (item["key"] !== "mt:featuredProgramSets") break
                component = Qt.createComponent("../components/CollectionsSlideView.qml")
                itemsKey = "nodes"
                contentType = "editorialcollections"
                break

            case "STAGE":
            case "featured_item":
                component = Qt.createComponent("../components/PodcastsSlideView.qml")
                itemsKey = "nodes"
                break

            case "newest_episodes":
                component = Qt.createComponent("../components/PodcastsSlideView.qml")
                itemsKey = "items"
                break

            case "program_sets":
                component = Qt.createComponent("../components/CollectionsSlideView.qml")
                itemsKey = "programSets"
                contentType = "programsets"
                break

            default:
                break
            }

            if (component !== undefined) {
                var obj = component.createObject(contentColumn, {
                                                     title: item["title"],
                                                     model: item[itemsKey],
                                                     contentType: contentType })
            }
        })
    }

    onCategoryChanged: refreshContent()

    PageBusyIndicator {
        running: loading && category === undefined
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
                onClicked: Qt.openUrlExternally(category["sharingUrl"])
            }

        }

        anchors.fill: parent
        contentHeight: headerImage.height + contentColumn.height

        opacity: category === undefined ? 0.0 : 1.0

        Behavior on opacity {
            FadeAnimation { }
        }

        RemoteImage {
            id: headerImage
            anchors.top: parent.top
            width: parent.width
            source: Global.applyDataToImageLink(category["image"]["url"].toString(), "16x9", parent.width)

            Rectangle {
                anchors.fill: parent
                color: "black"
                opacity: 0.4
            }

            Label {
                anchors.left: parent.left
                anchors.leftMargin: Theme.horizontalPageMargin
                anchors.bottom: parent.bottom
                anchors.bottomMargin: Theme.paddingMedium
                font.bold: true
                wrapMode: Text.Wrap
                text: category["title"]
            }
        }

        Column {
            id: contentColumn
            anchors.top: headerImage.bottom
            anchors.topMargin: Theme.paddingMedium
            width: parent.width
            spacing: Theme.paddingLarge
        }

        Item {
            width: 1
            height: Theme.paddingMedium + playerWidget.visibleHeight
        }

        VerticalScrollDecorator {}
    } 

    Component.onCompleted: if (contentId.length > 0) load()
}
