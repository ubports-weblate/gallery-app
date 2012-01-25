/*
 * Copyright (C) 2011 Canonical Ltd
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

Rectangle {
  id: dummyMenu

  property string itemTitle: ""

  signal itemChosen()

  states: [
    State { name: "shown";
      PropertyChanges { target: dummyMenu; opacity: 1; } },

    State { name: "hidden";
      PropertyChanges { target: dummyMenu; opacity: 0; } }
  ]

  transitions: [
    Transition { from: "*"; to: "*";
      NumberAnimation { properties: "opacity"; easing.type:
                        Easing.InQuad; duration: 200; } }
  ]

  state: "hidden"

  function flipVisibility() {
    if (this.state == "shown")
      this.state = "hidden";
    else
      this.state = "shown";
  }

  color: "transparent"

  width: 140
  height: 68

  Rectangle {
    color: "white"
    border.color: "#a7a9ac"
    border.width: 2

    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: popupArrow.top
    height: parent.height - popupArrow.height

    Text {
      color: "#313233"

      text: dummyMenu.itemTitle

      anchors.centerIn: parent
    }

    MouseArea {
      anchors.fill: parent

      onClicked: {
        dummyMenu.state = "hidden";

        dummyMenu.itemChosen();
      }
    }
  }

  Image {
    id: popupArrow

    width: 39
    height: 25

    anchors.bottom: parent.bottom
    anchors.right: parent.right

    source: "../img/popup-arrow.png"
  }
}
