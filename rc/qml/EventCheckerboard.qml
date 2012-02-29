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
 * Jim Nelson <jim@yorba.org>
 */

import QtQuick 1.1
import Gallery 1.0
import "GalleryUtility.js" as GalleryUtility

Checkerboard {
  id: eventCheckerboard
  
  function getVisibleMediaSources() {
    var vd = getVisibleDelegates();
    
    // return the objects, not the items, to the caller
    var vo = [];
    for (var ctr = 0; ctr < vd.length; ctr++) {
      var item = vd[ctr];
      
      if (!item.event)
        vo[vo.length] = item.mediaSource;
    }
    
    return vo;
  }
  
  function getRectOfObject(object) {
    var index = model.indexOf(object);
    
    return (index >= 0) ? getRectOfItemAt(index, eventCheckerboard) : undefined;
  }
  
  model: EventOverviewModel {
    monitored: true
  }
  
  delegate: EventCheckerboardDelegate {
    ownerName: "EventCheckerboard"
  }
}
