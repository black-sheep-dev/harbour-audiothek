import QtQuick 2.0
import Sailfish.Silica 1.0

import "../."

Page {
    id: page

    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent

        contentHeight: contentColumn.height

        Column {
            id: contentColumn
            width: parent.width
            spacing: Theme.paddingLarge

            PageHeader {
                //% "Settings"
                title: qsTrId("id-settings")
            }

            RemorsePopup { id: remorse }

            SectionHeader {
                //% "Database"
                text: qsTrId("Database")
            }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2*x
                color: Theme.highlightColor
                wrapMode: Text.Wrap
                //% "You can reset the local database here. All bookmarks and playing state are deleted!"
                text: qsTrId("id-settings-database-desc")
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                //% "Reset"
                text: qsTrId("id-reset")
                //% "Resetting database"
                onClicked: remorse.execute(qsTrId("id-reset-database"), DB.reset())
            }

//            SectionHeader {
//                //% "Player"
//                text: qsTrId("id-player")
//            }

//            Label {
//                x: Theme.horizontalPageMargin
//                width: parent.width - 2*x
//                wrapMode: Text.Wrap
//                color: Theme.highlightColor
//                //% "Choose the behaviour when play button is pressed."
//                text: qsTrId("id-play-button-behaviour")
//            }

//            ComboBox {
//                width: parent.width
//                //% "Mode"
//                label: qsTrId("id-mode")
//                menu: ContextMenu {
//                    MenuItem {
//                        //% "Instant playback"
//                        text: qsTrId("id-instant-playback")
//                    }
//                    MenuItem {
//                        //% "Enqueue next"
//                        text: qsTrId("id-enqueue-next")
//                    }
//                    MenuItem {
//                        //% "Enqueue last"
//                        text: qsTrId("id-enqueue-last")
//                    }
//                }

//                onCurrentIndexChanged: settings.playbackMode = currentIndex

//                Component.onCompleted: currentIndex = settings.playbackMode
//            }

            Item {
                width: 1
                height: Theme.paddingMedium
            }
        }
    }
}
