/*
 * Copyright (C) 2013 Canonical Ltd
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.0
import Ubuntu.Components 0.1
import Gallery 1.0

/*! @brief AlbumViewerAnimated shows an album, and performs animations when opening and closing
  *
  * Set the album and origin properties befor calling open()
  * The first call of open() is slow, as the lazy loading is used for the album viewer which is a
  * big component.
  */
Item {
    id: root

    /// The album to be shown in that viewer
    property Album album
    /// Origin (rectangle) where this view is animated from when calling open()
    /// And where it is animated to when this view is closed
    property variant origin
    /// The preview item that was used to open the view, or null, if it was opend another way
    /// This item will be hidden when this view is opened. And shown again after closing this view
    property Item previewItem: null
    /// Is true if the opne or close animation is running
    property bool animationRunning: loader_albumViewer.status === Loader.Ready ?
                                        loader_albumViewer.item.albumViewerTransition.animationRunning ||
                                        loader_albumViewer.item.albumViewer.animationRunning
                                      : false
    /// Indicates if this view is open
    property bool isOpen: false

    /// Opens the album. If the origin is set, an animation is performed
    function open() {
        loader_albumViewer.load()
        if (album.currentPage < 0)
            album.currentPage = 1
        loader_albumViewer.item.albumViewer.album = album
        if (root.origin)
            loader_albumViewer.item.albumViewerTransition.transitionToAlbumViewer(root.album, root.origin);
        else
            loader_albumViewer.item.albumViewer.visible = true
        isOpen = true
        if (previewItem)
            previewItem.visible = false
    }

    Component {
        id: component_ViewerItem
        Item {
            property alias albumViewer: inner_albumViewer
            property alias albumViewerTransition: inner_albumViewerTransition

            Rectangle {
                id: overviewGlass
                anchors.fill: parent
                color: "black"
                opacity: 0.0
            }

            AlbumViewer {
                id: inner_albumViewer
                objectName: "albumViewer"

                anchors.fill: parent
                visible: false
                active: root.isOpen

                onCloseRequested: {
                    if (root.origin) {
                        inner_albumViewerTransition.transitionFromAlbumViewer(
                                    album, root.origin, stayOpen, viewingPage);
                    }
                    inner_albumViewer.visible = false
                    isOpen = false
                }
            }

            AlbumViewerTransition {
                id: inner_albumViewerTransition

                anchors.fill: inner_albumViewer
                backgroundGlass: overviewGlass
                isPortrait: application.isPortrait

                onTransitionToAlbumViewerCompleted: {
                    inner_albumViewer.visible = true
                }
                onTransitionFromAlbumViewerCompleted: {
                    if (previewItem)
                        previewItem.visible = true
                    loader_albumViewer.unload()
                }
            }
        }
    }
    Loader {
        id: loader_albumViewer
        anchors.fill: parent

        function load() {
            if (sourceComponent == undefined) {
                sourceComponent = component_ViewerItem
            }
        }
        function unload() {
            sourceComponent = undefined
        }
    }

    MouseArea {
        id: transitionClickBlocker
        anchors.fill: parent
        enabled: root.animationRunning
    }
}
