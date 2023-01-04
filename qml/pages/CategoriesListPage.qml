import QtQuick 2.0
import Sailfish.Silica 1.0

import "../."
import "../components/"

Page {
    property bool loading: false
    property var categoryItems: []

    function load() {
        loading = true
        Api.request("/editorialcategories", function(data, status) {
            loading = false

            if (status !== 200) {
                //% "Failed to fetch data"
                notify.show(qsTrId("id-failed-to-fetch-data"))
                return
            }

            categoryItems = data["data"]["editorialCategories"]["nodes"]
        })
    }

    id: page
    allowedOrientations: Orientation.All

    PageBusyIndicator {
        running: loading && categoryItems.length === 0
    }

    SilicaFlickable {
        PullDownMenu {
            busy: loading
            MenuItem {
                //% "Reload"
                text: qsTrId("id-reload")
                onClicked: load()
            }
        }

        anchors.fill: parent
        contentHeight: contentColumn.height

        opacity: (loading && categoryItems.length === 0) ? 0.0 : 1.0

        Behavior on opacity {
            FadeAnimation { }
        }

        Column {
            id: contentColumn
            width: parent.width
            spacing: Theme.paddingMedium

            PageHeader {
                //% "Categories"
                title: qsTrId("id-categories")
                //% "%n Element(s)"
                description: qsTrId("id-elements-count", categoryItems.length)
            }

            Flow {
                visible: !loading
                x: Theme.horizontalPageMargin
                width: parent.width - 2*x
                spacing: Theme.paddingMedium

                Repeater {
                    model: categoryItems

                    CategoryItem {
                        width: page.orientation === Orientation.Portrait ? (parent.width - Theme.paddingMedium) / 2 : (parent.width - 3*Theme.paddingMedium) / 4

                        onClicked: pageStack.push(Qt.resolvedUrl("CategoryDetailsPage.qml"), { contentId: modelData["id"] })
                    }
                }
            }

            Item {
                width: 1
                height: Theme.paddingMedium + playerWidget.visibleHeight
            }
        }

        VerticalScrollDecorator {}
    }

    onStatusChanged: if (status === PageStatus.Active) pageStack.pushAttached(Qt.resolvedUrl("BookmarksListPage.qml"))

    Component.onCompleted: load()
}
