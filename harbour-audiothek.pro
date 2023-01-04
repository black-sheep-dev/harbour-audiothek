# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-audiothek

QT += multimedia

CONFIG += sailfishapp_qml

PKGCONFIG += nemonotifications-qt5

DISTFILES += qml/harbour-audiothek.qml \
    qml/components/AudioPlayer.qml \
    qml/components/AudioPlayerWidget.qml \
    qml/components/CategoryItem.qml \
    qml/components/CollectionItem.qml \
    qml/components/CollectionsSlideView.qml \
    qml/components/ContentListItem.qml \
    qml/components/ContentPlaylistItem.qml \
    qml/components/CustomPlaylistItem.qml \
    qml/components/PageIndicator.qml \
    qml/components/PodcastItem.qml \
    qml/components/PodcastsSlideView.qml \
    qml/components/ProgramsetSlideView.qml \
    qml/components/ProgressIndicator.qml \
    qml/components/RemoteImage.qml \
    qml/cover/CoverPage.qml \
    qml/database.qml \
    qml/delegates/PlaylistDelegate.qml \
    qml/delegates/PodcastDelegate.qml \
    qml/models/PlaylistModel.qml \
    qml/pages/AboutPage.qml \
    qml/pages/BookmarksListPage.qml \
    qml/pages/CategoriesListPage.qml \
    qml/pages/CategoryDetailsPage.qml \
    qml/pages/CollectionDetailsPage.qml \
    qml/pages/MainPage.qml \
    qml/pages/PlayerPage.qml \
    qml/pages/PodcastDetailsPage.qml \
    qml/pages/RecentlyPlayedListPage.qml \
    qml/pages/SearchPage.qml \
    qml/pages/SettingsPage.qml \
    qml/global.qml \
    qml/api.qml \
    qml/qmldir \
    rpm/harbour-audiothek.changes \
    rpm/harbour-audiothek.changes.run.in \
    rpm/harbour-audiothek.spec \
    rpm/harbour-audiothek.yaml \
    translations/*.ts \
    harbour-audiothek.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172

include(translations/translations.pri)

icons.files = icons/*.svg
icons.path = $$INSTALL_ROOT/usr/share/harbour-audiothek/icons

images.files = images/*
images.path = $$INSTALL_ROOT/usr/share/harbour-audiothek/images

INSTALLS += icons images
