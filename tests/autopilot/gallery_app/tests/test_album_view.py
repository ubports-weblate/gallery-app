# -*- Mode: Python; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-
# Copyright 2013 Canonical
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 3, as published
# by the Free Software Foundation.


"""Tests the album view of the gallery app"""

from __future__ import absolute_import

from testtools.matchers import Equals
from autopilot.matchers import Eventually

from gallery_app.emulators.album_view import AlbumView
from gallery_app.emulators.albums_view import AlbumsView
from gallery_app.emulators.media_selector import MediaSelector
from gallery_app.emulators import album_editor
from gallery_app.tests import GalleryTestCase


class TestAlbumView(GalleryTestCase):
    """Tests the album view of the gallery app"""

    @property
    def album_view(self):
        return AlbumView(self.app)

    @property
    def albums_view(self):
        return AlbumsView(self.app)

    @property
    def media_selector(self):
        return MediaSelector(self.app)

    def setUp(self):
        self.ARGS = []
        super(TestAlbumView, self).setUp()
        self.switch_to_albums_tab()

    def ensure_media_selector_is_fully_open(self):
        media_selector = self.media_selector.get_media_selector()
        self.assertThat(media_selector.opacity, Eventually(Equals(1.0)))

    def ensure_media_selector_is_fully_closed(self):
        loader = self.album_view.media_selector_loader()
        self.assertThat(loader.status, Eventually(Equals(0)))

    def test_album_view_open_photo(self):
        self.open_first_album()
        photo = self.album_view.get_first_photo()
        # workaround lp:1247698
        self.main_view.close_toolbar()
        self.click_item(photo)
        photo_view = self.album_view.get_album_photo_view()
        self.assertThat(photo_view.visible, Eventually(Equals(True)))
        self.assertThat(photo_view.isPoppedUp, Eventually(Equals(True)))

    def test_add_photo(self):
        self.open_first_album()
        num_photos_start = self.album_view.number_of_photos()
        self.assertThat(num_photos_start, Equals(1))

        # open media selector but cancel
        self.main_view.open_toolbar().click_button("addButton")
        self.ensure_media_selector_is_fully_open()

        self.main_view.get_toolbar().click_custom_button("cancelButton")
        self.ensure_media_selector_is_fully_closed()

        num_photos = self.album_view.number_of_photos()
        self.assertThat(num_photos, Equals(num_photos_start))

        # open media selector and add a photo
        self.main_view.open_toolbar().click_button("addButton")
        self.ensure_media_selector_is_fully_open()

        photo = self.media_selector.get_second_photo()
        self.click_item(photo)
        self.main_view.get_toolbar().click_custom_button("addButton")

        self.assertThat(
            lambda: self.album_view.number_of_photos(),
            Eventually(Equals(num_photos_start + 1)))

    def test_add_photo_to_new_album(self):
        self.main_view.open_toolbar().click_button("addButton")
        self.ui_update()

        editor = self.app.select_single(album_editor.AlbumEditorAnimated)
        editor.ensure_fully_open()
        editor.close()

        self.open_first_album()
        num_photos_start = self.album_view.number_of_photos()
        self.assertThat(num_photos_start, Equals(0))

        plus = self.album_view.get_plus_icon_empty_album()
        # workaround lp:1247698
        self.main_view.close_toolbar()
        self.click_item(plus)
        self.ensure_media_selector_is_fully_open()

        photo = self.media_selector.get_second_photo()
        self.click_item(photo)
        self.main_view.get_toolbar().click_custom_button("addButton")

        self.assertThat(
            lambda: self.album_view.number_of_photos(),
            Eventually(Equals(num_photos_start + 1)))
