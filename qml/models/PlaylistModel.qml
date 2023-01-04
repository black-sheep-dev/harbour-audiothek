import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.6

import "../."

ListModel {
    property var content
    property string contentKey
    property string contentType
    property bool loading: false
    property int numberOfElements: 0

    property string query

    function load() {
        if (query.length === 0) return

        loading = true

        Api.request(query.replace("{offset}", String(0)), function(data, status) {
            loading = false
            if (status !== 200) {
                //% "Failed to fetch data"
                notify.show(qsTrId("id-failed-to-fetch-data"))
                return
            }
            //console.log(JSON.stringify(data["data"][contentKey]))
            clear()
            content = data["data"][contentKey]
            if (data["data"][contentKey].hasOwnProperty("numberOfElements")) {
                numberOfElements = data["data"][contentKey]["numberOfElements"]
            } else if (data["data"][contentKey]["items"].hasOwnProperty("numberOfElements")) {
                numberOfElements = data["data"][contentKey]["items"]["numberOfElements"]
            }

            addPodcasts(data["data"][contentKey]["items"]["nodes"])
        })
    }

    function loadMore() {
        if (query.length === 0) return
        if (count === numberOfElements || count === 0) return
        loading = true
        Api.request(query.replace("{offset}", String(count)), function(data, status) {
            loading = false
            if (status !== 200) {
                //% "Failed to fetch data"
                notify.show(qsTrId("id-failed-to-fetch-data"))
                return
            }

            var obj = content
            obj["items"]["nodes"] = content["items"]["nodes"].concat(data["data"][contentKey]["items"]["nodes"])
            content = obj

            addPodcasts(data["data"][contentKey]["items"]["nodes"])
        })
    }

    function addPodcast(item) {
        var obj = new Object
        obj["duration"] = item["duration"]
        obj["id"] = item["id"]
        obj["image"] = item["image"]["url1X1"]
        //obj["publicationStartDateAndTime"] = item["publicationStartDateAndTime"]
        obj["sharingUrl"] = item["sharingUrl"]
        obj["synopsis"] = item["synopsis"]
        obj["title"] = item["title"]
        obj["url"] = item["audios"][0]["url"]
//        obj["bookmarked"] = DB.isPodcastBookmarked(item["id"])
//        obj["completed"] = DB.isPodcastCompleted(item["id"])
//        obj["position"] = DB.getPodcastPosition(item["id"])
        DB.getPodcastStatus(obj)
        listModel.append(obj)
    }

    function addPodcasts(items) {
        items.forEach(function(item) {
            addPodcast(item)
        })
    }

    function setPodcasts(items) {
        reset()
        addPodcasts(items)
    }

    function addPodcastObject(obj) {
        listModel.append(obj)
    }

    function addPodcastObjects(objs) {
        objs.forEach(function(obj) { listModel.append(obj) })
    }

    function setPodcastObjects(objs) {
        reset()
        addPodcastObjects(objs)
    }

    function reset() {
        listModel.clear()
    }

    id: listModel
}
