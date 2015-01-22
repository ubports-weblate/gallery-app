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

#ifndef MEDIA_OBJECT_FACTORY_H_
#define MEDIA_OBJECT_FACTORY_H_

// media
#include "media-source.h"

// utils
#include "resource.h"
#include <orientation.h>

#include <QDateTime>
#include <QFileInfo>
#include <QObject>
#include <QSize>
#include <QThread>

class MediaTable;
class MediaObjectFactoryWorker;

/*!
 * \brief The MediaObjectFactory creates phot and video objects
 */
class MediaObjectFactory : public QObject
{
    Q_OBJECT

public:
    explicit MediaObjectFactory(bool desktopMode, Resource *res);
    virtual ~MediaObjectFactory();

    void setMediaTable(MediaTable *mediaTable);
    void enableContentLoadFilter(MediaSource::MediaType filterType);
    void clear();
    void create(const QFileInfo& file, bool desktopMode, Resource *res);
    void loadMediasFromDB();

signals:
    void mediaObjectCreated(MediaSource *newMediaObject);
    void mediasFromDBLoaded(QSet<DataObject *> mediasFromDB);

private:    
    MediaObjectFactoryWorker* m_worker;
    QThread m_workerThread;

    friend class tst_MediaObjectFactory;
};

/*!
 * \brief The MediaObjectFactoryWorker class does the actual object factory, but is
 * supposed to to it in a thread
 */
class MediaObjectFactoryWorker : public QObject
{
    Q_OBJECT

public:
    MediaObjectFactoryWorker(QObject *parent=0);
    virtual ~MediaObjectFactoryWorker();

public slots:
    void setMediaTable(MediaTable *mediaTable);
    void enableContentLoadFilter(MediaSource::MediaType filterType);
    void clear();
    void create(const QString& path);
    void mediasFromDB();

signals:
    void mediaObjectCreated(MediaSource *newMediaObject);
    void mediasFromDBLoaded(QSet<DataObject *> mediasFromDB);

private slots:
    void addMedia(qint64 mediaId, const QString& filename, const QSize& size,
                  const QDateTime& timestamp, const QDateTime& exposureTime,
                  Orientation originalOrientation, qint64 filesize);

private:
    void clearMetadata();
    bool readPhotoMetadata(const QFileInfo &file);
    bool readVideoMetadata(const QFileInfo &file);

    MediaTable *m_mediaTable;
    MediaSource::MediaType m_filterType;
    QDateTime m_timeStamp;
    QDateTime m_exposureTime;
    Orientation m_orientation;
    qint64 m_fileSize;
    QSize m_size;

    QSet<DataObject*> m_mediasFromDB;
};

#endif  // MEDIA_OBJECT_FACTORY_H_
