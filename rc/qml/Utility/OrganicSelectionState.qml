/*
 * Copyright (C) 2012 Canonical Ltd
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
 * Charles Lindsay <chaz@yorba.org>
 */

import QtQuick 2.0
import Gallery 1.0

// Holds all the state for selection between the Organic views.
Item {
  id: organicSelectionState

  property bool inSelectionMode: false
  property bool allowSelectionModeChange: true

  property var model: EventOverviewModel {
    monitored: true
  }

  //internal
  // HACK: this is used as a spurious extra QML condition in our isSelected
  // check so we can cause the function to be reevaluated whenever the
  // selection changes.  I couldn't see any easier way to trigger the model's
  // isSelected function to get reevaluated in QML whenever its internal
  // selection state changes.
  property int refresh: 1

  function isSelected(item) {
    return refresh > 0 && model.isSelected(item);
  }

  function toggleSelection(item) {
    if (tryEnterSelectionMode())
      model.toggleSelection(item);
  }

  function tryEnterSelectionMode() {
    if (allowSelectionModeChange)
      inSelectionMode = true;
    return inSelectionMode;
  }

  function leaveSelectionMode() {
    if (allowSelectionModeChange) {
      inSelectionMode = false;
      model.unselectAll();
    }
  }

  Connections {
    target: model
    onSelectedCountChanged: ++refresh
  }
}
