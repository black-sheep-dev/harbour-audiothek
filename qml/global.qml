pragma Singleton
import QtQuick 2.0

Item {
    readonly property string appId: "harbour-audiothek"
    readonly property string appVersion: "0.1.0"

    function applyDataToImageLink(link, ratio, width) {
        if (link === undefined) return ""
        return link.replace("{ratio}", ratio).replace("{width}", String(width))
    }

    function getDurationString(secs) {
        if (secs === undefined) secs = 0
        const mins = Math.floor(secs / 60)
        const hours = Math.floor(mins / 60)
        mins -= hours*60

        if (hours > 0) {
            //% "%n h"
            return qsTrId("id-hour-count", hours) + " "
                    //% ""%n min(s)"
                    + qsTrId("id-minute-count", mins)
        } else if (mins > 0) {
            //% "%n min(s)"
            return qsTrId("id-minute-count", mins)
        } else {
            //% "%n min(s)"
            return qsTrId("id-second-count", secs)
        }
    }

    function getTimeString(msecs) {
        if (msecs < 3600000) {
            return new Date(msecs).toISOString().substr(14, 5)
        } else {
            return new Date(msecs).toISOString().substr(11, 8)
        }
    }

    function convertPodcast(podcast) {
        if (!podcast.hasOwnProperty("_links")) return

        podcast["images"] = {
            url: podcast["_links"]["mt:image"]["href"].replace("{ratio}", "16x9"),
            url1X2: podcast["_links"]["mt:squareImage"]["href"]
        }

        podcast["sharingUrl"] = podcast["_links"]["mt:sharing"]["href"]
        podcast["audios"] = [
                    {
                        url: podcast["_links"]["mt:bestQualityPlaybackUrl"]["href"],
                        downloadUrl: podcast["_links"]["mt:downloadUrl"]["href"]
                    }
                   ]

        delete podcast["_links"]

        if (!podcast.hasOwnProperty("_embedded")) return

        podcast["programSet"] = podcast["_embedded"]["mt:programSet"]
        delete podcast["_embedded"]
    }
}
