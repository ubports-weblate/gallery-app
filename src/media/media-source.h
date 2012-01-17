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
 * Jim Nelson <jim@yorba.org>
 */

#ifndef GALLERY_MEDIA_SOURCE_H_
#define GALLERY_MEDIA_SOURCE_H_

#include <QObject>
#include <QFileInfo>
#include <QUrl>
#include <QVariant>
#include <QtDeclarative>

#include "core/data-source.h"
#include "photo/photo-metadata.h"

typedef DataObjectNumber MediaNumber;

class MediaSource : public DataSource {
  Q_OBJECT
  Q_PROPERTY(QUrl path READ path NOTIFY path_altered)
  Q_PROPERTY(QUrl previewPath READ preview_path NOTIFY preview_path_altered)
  Q_PROPERTY(int orientation READ orientation NOTIFY orientation_altered)
  Q_PROPERTY(float orientationRotation READ orientation_rotation NOTIFY orientation_altered)
  Q_PROPERTY(bool orientationMirrored READ orientation_mirrored NOTIFY orientation_altered)
  Q_PROPERTY(bool isRotated READ is_rotated NOTIFY orientation_altered)
  
 signals:
  void path_altered();
  void preview_path_altered();
  void orientation_altered();
  
 public:
  MediaSource();
  virtual ~MediaSource();
  
  static void RegisterType();
  
  void Init(const QFileInfo& file);
  
  const QFileInfo& file() const;
  QUrl path() const;
  const QFileInfo& preview_file() const;
  QUrl preview_path() const;
  
  virtual Orientation orientation() const;
  float orientation_rotation() const;
  bool orientation_mirrored() const;
  bool is_rotated() const;
  
 protected:
  virtual void DestroySource(bool delete_backing, bool as_orphan);
  
  virtual bool MakePreview(const QFileInfo& original, const QFileInfo& dest);
  
 private:
  QFileInfo file_;
  QFileInfo* preview_file_;
};

QML_DECLARE_TYPE(MediaSource);

#endif  // GALLERY_MEDIA_SOURCE_H_
