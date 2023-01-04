import QtQuick 2.0
import QtMultimedia 5.6
import Nemo.Configuration 1.0

import "../."
import "../models/"

Audio {
    property string contentId
    property string contentType: "podcasts"
    property var currentContent
    readonly property PlaylistModel playlistModel: PlaylistModel {
        id: mainModel
        onCountChanged: {
            if (content !== undefined) DB.addPodcasts(content["items"]["nodes"])

            queue.clear()
            for (var i = 0; i < playlistModel.count; ++i) {
                const item = playlistModel.get(i)

                queue.addItem(item.url)
            }
        }
    }

    readonly property string currentUrl: playlist.currentItemSource
    readonly property bool isPlaying: playbackState === MediaPlayer.PlayingState

    playlist: Playlist {
        id: queue
        onCurrentIndexChanged: {
            saveCurrentPodcastStatus()

            currentContent = playlistModel.get(currentIndex)

            if (currentIndex >= (mainModel.count - 5) && mainModel.numberOfElements !== mainModel.count) mainModel.loadMore()
        }
    }

    //onCurrentContentChanged: if (currentContent !== undefined) loadCurrentPodcastStatus()
    onPlaybackStateChanged: {
        switch (playbackState) {
        case Audio.PlayingState:
            break

        case Audio.PausedState:
            saveCurrentPodcastStatus()
            break

        case Audio.StoppedState:
            currentContent = undefined
            break

        default:
            break
        }
    }

    Component.onDestruction: saveCurrentPodcastStatus()

    function loadCurrentPodcastStatus() {
        if (currentContent === undefined) return
        const pos = DB.getPodcastPosition(currentContent.id)
        console.log("Position loaded: " + pos)
        seek(pos)
    }

    function saveCurrentPodcastStatus() {
        if (currentContent === undefined) return
        console.log("Saved current position: " + position + " / " + DB.setPodcastPosition(currentContent.id, position))
        console.log("Saved completed status: " + DB.setPodcastCompleted(currentContent.id, position > (duration - 10000)))
    }

    function clearPlaylist() {
        stop()
        playlistModel.clear()
        queue.clear()
    }

    function playPodcast(podcast) {
        DB.addPodcast(podcast)

        clearPlaylist()
        playlistModel.clear()

        contentId = podcast["id"]
        contentType = "podcast"

        playlistModel.addPodcast(podcast)
        const pos = DB.getPodcastPosition(podcast["id"])
        console.log("Position loaded: " + pos)
        play()
        seek(pos)
    }

    function playPodcastObject(podcast) {
        clearPlaylist()
        playlistModel.clear()

        contentId = podcast.id
        contentType = "podcast"

        playlistModel.addPodcastObject(podcast)
        play()

        if (!podcast.completed) seek(podcast.position)
    }

    // controls
    function next() {
        if (playlist.currentIndex < (playlist.itemCount - 1)) playlist.next()
    }
    function stepForwards() { seek(position + 10000) }
    function stepBackwards() { seek(position - 10000) }
    function previous() {
        if (position < 3000)
            playlist.previous()
        else
            seek(0)
    }
    function startPlayback() {
        play()
        const pos = DB.getPodcastPosition(currentContent.id)
        seek(pos)
    }

    function stopPlayback() {
        saveCurrentPodcastStatus()
        stop()
    }
}
