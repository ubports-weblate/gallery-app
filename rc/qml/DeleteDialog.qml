/*
 * Copyright (C) 2011-2012 Canonical Ltd
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
 *
 * Authors:
 * Lucas Beeler <lucas@yorba.org>
 */

import QtQuick 1.1
import "GalleryUtility.js" as GalleryUtility
import "../Capetown"

PopupActionCancelDialog {
  id: deleteDialog

  signal deleteRequested()

  explanatoryText: "Selecting Delete will permanently delete this photo " +
                   "from your tablet and from any albums that it appears " +
                   "in."

  actionTitle: "Delete"

  onActionRequested: deleteRequested()
}