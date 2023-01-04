pragma Singleton

import QtQuick 2.0
import QtQuick.LocalStorage 2.0

Item {
    property var db

    function addPodcast(podcast) {
        if (!podcast.hasOwnProperty("id") || !podcast.hasOwnProperty("duration")) return

        try {
            db.transaction(function(tx) {
                tx.executeSql('INSERT INTO podcasts(id, duration, image, sharingUrl, synopsis, title, url, created_at)
                               VALUES(?, ?, ?, ?, ?, ?, ?, ?)
                               ON CONFLICT(id) DO UPDATE SET
                               duration=excluded.duration,
                               image=excluded.image,
                               sharingUrl=excluded.sharingUrl,
                               synopsis=excluded.synopsis,
                               title=excluded.title,
                               url=excluded.url,
                               updated_at=excluded.created_at',
                              [podcast["id"],
                               podcast["duration"],
                               podcast["image"]["url1X1"],
                               podcast["sharingUrl"],
                               podcast["synopsis"],
                               podcast["title"],
                               podcast["audios"][0]["url"],
                               new Date()])
            })

        } catch(err) {
            console.log("Could not add podcast: " + podcast["id"] + " | " + err)
            return false
        }

        return true
    }

    function addPodcasts(podcasts) {
        try {
            db.transaction(function(tx) {
                podcasts.forEach(function(podcast) {
                    tx.executeSql('INSERT INTO podcasts(id, duration, image, sharingUrl, synopsis, title, url, created_at)
                                   VALUES(?, ?, ?, ?, ?, ?, ?, ?)
                                   ON CONFLICT(id) DO UPDATE SET
                                   duration=excluded.duration,
                                   image=excluded.image,
                                   sharingUrl=excluded.sharingUrl,
                                   synopsis=excluded.synopsis,
                                   title=excluded.title,
                                   url=excluded.url,
                                   updated_at=excluded.created_at',
                                  [podcast["id"],
                                   podcast["duration"],
                                   podcast["image"]["url1X1"],
                                   podcast["sharingUrl"],
                                   podcast["synopsis"],
                                   podcast["title"],
                                   podcast["audios"][0]["url"],
                                   new Date()])
                })
            })

        } catch(err) {
            console.log("Could not add podcasts: " + podcasts.length + " | " + err)
            return false
        }

        return true
    }

    function bookmarkPodcast(podcastId, bookmarked) {
        if (podcastId.length === 0) return false

        try {
            db.transaction(function(tx) {
                tx.executeSql('UPDATE podcasts SET bookmarked=?, updated_at=? WHERE id=?',
                              [bookmarked, new Date(), podcastId])
            })

        } catch(err) {
            console.log("Could not bookmark podcast: " + podcastId + " | " + err)
            return false
        }

        return true
    }

    function removePodcast(podcastId) {
        if (podcastId.length === 0) return false

        try {
            db.transaction(function(tx) {
                tx.executeSql('DELETE FROM podcasts SET WHERE id=? AND bookmarked=0',
                              [podcastId])
            })

        } catch(err) {
            console.log("Could not bookmark podcast: " + podcastId + " | " + err)
            return false
        }

        return true
    }

    function getBookmarkedPodcasts() {
        var items = []

        try {
            db.readTransaction(function(tx) {
                var rs = tx.executeSql('SELECT * FROM podcasts WHERE bookmarked = 1')
                for (var i = 0; i < rs.rows.length; i++) {
                    var obj = new Object
                    obj["duration"] = rs.rows.item(i).duration
                    obj["id"] = rs.rows.item(i).id
                    obj["image"] = rs.rows.item(i).image
                    //obj["publicationStartDateAndTime"] = item["publicationStartDateAndTime"]
                    obj["sharingUrl"] = rs.rows.item(i).sharingUrl
                    obj["synopsis"] = rs.rows.item(i).synopsis
                    obj["title"] = rs.rows.item(i).title
                    obj["url"] = rs.rows.item(i).url
                    obj["bookmarked"] = rs.rows.item(i).bookmarked
                    obj["completed"] = rs.rows.item(i).completed
                    obj["position"] = rs.rows.item(i).position
                    obj["playedAt"] = rs.rows.item(i).played_at
                    items.push(obj)
                }
            })
        } catch(err) {
            console.log("Could not fetch bookmarked podcasts from database | " + err)
        }

        return items
    }

    function getRecentlyPlayedPodcasts(start) {
        if (start === undefined) start = new Date()

        var items = []

        try {
            db.readTransaction(function(tx) {
                var rs = tx.executeSql('SELECT * FROM podcasts WHERE played_at < ? AND played_at > 0 ORDER BY played_at DESC LIMIT 50', [start])
                for (var i = 0; i < rs.rows.length; i++) {
                    var obj = new Object
                    obj["duration"] = rs.rows.item(i).duration
                    obj["id"] = rs.rows.item(i).id
                    obj["image"] = rs.rows.item(i).image
                    //obj["publicationStartDateAndTime"] = item["publicationStartDateAndTime"]
                    obj["sharingUrl"] = rs.rows.item(i).sharingUrl
                    obj["synopsis"] = rs.rows.item(i).synopsis
                    obj["title"] = rs.rows.item(i).title
                    obj["url"] = rs.rows.item(i).url
                    obj["bookmarked"] = rs.rows.item(i).bookmarked
                    obj["completed"] = rs.rows.item(i).completed
                    obj["position"] = rs.rows.item(i).position
                    obj["playedAt"] = rs.rows.item(i).played_at
                    items.push(obj)
                }
            })
        } catch(err) {
            console.log("Could not fetch recently played podcasts from database | " + err)
        }

        return items
    }

    function getPodcastPosition(podcastId) {
        if (podcastId.length === 0) return 0
        const position = 0

        try {
            db.readTransaction(function(tx) {
                var rs = tx.executeSql('SELECT position FROM podcasts WHERE id="' + String(podcastId) + '"')
                for (var i = 0; i < rs.rows.length; i++) {
                    position = rs.rows.item(i).position
                }
            })
        } catch(err) {
            console.log("Could not get position of podcast: " + podcastId + " | " + err)
        }

        return position
    }

    function getPodcastStatus(podcast) {
        if (podcast === undefined) return

        try {
            db.readTransaction(function(tx) {
                var rs = tx.executeSql('SELECT bookmarked, completed, position, played_at FROM podcasts WHERE id="' + String(podcast.id) + '"')
                for (var i = 0; i < rs.rows.length; i++) {
                    podcast.bookmarked = rs.rows.item(i).bookmarked
                    podcast.completed = rs.rows.item(i).completed
                    podcast.position = rs.rows.item(i).position
                    podcast.playedAt = rs.rows.item(i).playedAt
                }
            })
        } catch(err) {
            console.log("Could not update podcast status: " + podcast.id + " | " + err)
        }
    }

    function isPodcastBookmarked(podcastId) {
        const bookmarked = false

        try {
            db.readTransaction(function(tx) {
                var rs = tx.executeSql('SELECT bookmarked FROM podcasts WHERE id="' + String(podcastId) + '"')
                for (var i = 0; i < rs.rows.length; i++) {
                    bookmarked = rs.rows.item(i).bookmarked === 1
                }
            })
        } catch(err) {
            console.log("Could not check bookmarked status of podcast: " + podcastId + " | " + err)
        }

        return bookmarked
    }

    function isPodcastCompleted(podcastId) {
        const completed = false

        try {
            db.readTransaction(function(tx) {
                var rs = tx.executeSql('SELECT completed FROM podcasts WHERE id="' + String(podcastId) + '"')
                for (var i = 0; i < rs.rows.length; i++) {
                    completed = rs.rows.item(i).completed === 1
                }
            })
        } catch(err) {
            console.log("Could not check completed status of podcast: " + podcastId + " | " + err)
        }

        return completed
    }

    function setPodcastCompleted(podcastId, completed) {
        if (podcastId.length === 0) return false

        try {
            db.transaction(function(tx) {
                tx.executeSql('UPDATE podcasts SET completed=?, played_at=? WHERE id=?',
                              [completed, new Date(), podcastId])
            })

        } catch(err) {
            console.log("Could set completed status of podcast: " + podcastId + " | " + err)
            return false
        }

        return true
    }

    function setPodcastPosition(podcastId, position) {
        if (podcastId.length === 0 || position < 0) return false

        try {
            db.transaction(function(tx) {
                tx.executeSql('UPDATE podcasts SET position=?, played_at=? WHERE id=?',
                              [position, new Date(), podcastId])
            })

        } catch(err) {
            console.log("Could set position of podcast: " + podcastId + " | " + err)
            return false
        }

        return true
    }

    // basic functions

    function init() {
        try {

            db.transaction(function(tx) {
                tx.executeSql('PRAGMA auto_vacuum = FULL')

                tx.executeSql('CREATE TABLE IF NOT EXISTS podcasts(
                               id INTEGER UNIQUE NOT NULL,
                               duration INTEGER DEFAULT 0,
                               image TEXT,
                               sharingUrl TEXT,
                               synopsis TEXT,
                               title TEXT,
                               url TEXT,
                               bookmarked INTEGER DEFAULT 0,
                               position INTEGER DEFAULT 0,
                               completed INTEGER DEFAULT 0,
                               played_at INTEGER DEFAULT 0,
                               updated_at INTEGER DEFAULT 0,
                               created_at INTEGER NOT NULL)')
            })
        } catch(err) {
            console.log("Error creating table in database: " + err)
        }
    }

    function reset() {
        try {
            db.transaction(function(tx) {
                tx.executeSql('DROP TABLE IF EXISTS podcasts')
            })
        } catch(err) {
            console.log("Failed to reset database: " + err)
            return
        }
        init()
    }

    Component.onCompleted: {
        db = LocalStorage.openDatabaseSync("audiothek.db", 1, "Content Data")
        init()
    }
}
