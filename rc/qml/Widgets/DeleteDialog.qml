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
import Ubuntu.Components.Popups 0.1

/*!
  Dialog specialiced for the question to delete
  */
Dialog {
    id: dialogue
    objectName: "deleteDialog"

    /// Emitted if delete should be performed
    signal deleteClicked()

    title: "Delete"

    Button {
        objectName: "deleteDialogYes"
        text: "Yes"
        color: "#c94212"
        onClicked: {
            dialogue.deleteClicked()
            PopupUtils.close(dialogue);
        }
    }
    Button {
        objectName: "deleteDialogNo"
        text: "No"
        onClicked: PopupUtils.close(dialogue);
    }
}