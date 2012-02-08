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
 * Charles Lindsay <chaz@yorba.org>
 */

import QtQuick 1.1

// Fades in the fadeInTarget while fading out the fadeOutTarget.
SequentialAnimation {
  id: dissolveAnimation
  objectName: "dissolveAnimation"

  property variant fadeInTarget
  property variant fadeOutTarget
  property int duration: 200

  ParallelAnimation {
    FadeInAnimation {
      target: fadeInTarget
      duration: dissolveAnimation.duration
    }

    NumberAnimation {
      target: fadeOutTarget
      property: "opacity"
      to: 0
      duration: dissolveAnimation.duration
      easing.type: Easing.OutQuad
    }
  }

  PropertyAction {
    target: fadeOutTarget
    property: "visible"
    value: false
  }

  PropertyAction {
    target: fadeOutTarget
    property: "opacity"
    value: 1
  }
}
