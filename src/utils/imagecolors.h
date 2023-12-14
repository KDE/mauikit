/*
 *  Copyright 2020 Marco Martin <mart@kde.org>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  2.010-1301, USA.
 */

#pragma once

#include "colorutils.h"

#include <QColor>
#include <QFuture>
#include <QImage>
#include <QObject>
#include <QPointer>
#include <QQuickItem>
#include <QQuickItemGrabResult>
#include <QQuickWindow>

class QTimer;

struct ImageData {
    struct colorStat {
        QList<QRgb> colors;
        QRgb centroid = 0;
        qreal ratio = 0;
    };

    struct colorSet {
        QColor average;
        QColor text;
        QColor background;
        QColor highlight;
    };

    QList<QRgb> m_samples;
    QList<colorStat> m_clusters;
    QVariantList m_palette;

    bool m_darkPalette = true;
    QColor m_dominant = Qt::transparent;
    QColor m_dominantContrast;
    QColor m_average;
    QColor m_highlight;

    QColor m_closestToBlack;
    QColor m_closestToWhite;
};

/**
 * Extracts the dominant colors from an element or an image and exports it to a color palette.
 */
class ImageColors : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    /**
     * The source from which colors should be extracted from.
     *
     * `source` can be one of the following:
     * * Item
     * * QImage
     * * QIcon
     * * Icon name
     *
     * Note that an Item's color palette will only be extracted once unless you * call `update()`, regardless of how the item hanges.
     */
    Q_PROPERTY(QVariant source READ source WRITE setSource NOTIFY sourceChanged FINAL)

    /**
     * A list of colors and related information about then.
     *
     * Each list item has the following properties:
     * * `color`: The color of the list item.
     * * `ratio`: How dominant the color is in the source image.
     * * `contrastingColor`: The color from the source image that's closest to the inverse of `color`.
     *
     * The list is sorted by `ratio`; the first element is the most
     * dominant color in the source image and the last element is the
     * least dominant color of the image.
     *
     * \note K-means clustering is used to extract these colors; see https://en.wikipedia.org/wiki/K-means_clustering.
     */
    Q_PROPERTY(QVariantList palette READ palette NOTIFY paletteChanged FINAL)

    /**
     * Information whether the palette is towards a light or dark color
     * scheme, possible values are:
     * * ColorUtils.Light
     * * ColorUtils.Dark
     */
    Q_PROPERTY(ColorUtils::Brightness paletteBrightness READ paletteBrightness NOTIFY paletteChanged FINAL)

    /**
     * The average color of the source image.
     */
    Q_PROPERTY(QColor average READ average NOTIFY paletteChanged FINAL)

    /**
     * The dominant color of the source image.
     *
     * The dominant color of the image is the color of the largest
     * cluster in the image.
     *
     * \sa https://en.wikipedia.org/wiki/K-means_clustering
     */
    Q_PROPERTY(QColor dominant READ dominant NOTIFY paletteChanged FINAL)

    /**
     * Suggested "contrasting" color to the dominant one. It's the color in the palette nearest to the negative of the dominant
     */
    Q_PROPERTY(QColor dominantContrast READ dominantContrast NOTIFY paletteChanged FINAL)

    /**
     * An accent color extracted from the source image.
     *
     * The accent color is the color cluster with the highest CIELAB
     * chroma in the source image.
     *
     * \sa https://en.wikipedia.org/wiki/Colorfulness#Chroma
     */
    Q_PROPERTY(QColor highlight READ highlight NOTIFY paletteChanged FINAL)

    /**
     * A color suitable for rendering text and other foreground
     * over the source image.
     *
     * On dark items, this will be the color closest to white in
     * the image if it's light enough, or a bright gray otherwise.
     * On light items, this will be the color closest to black in
     * the image if it's dark enough, or a dark gray otherwise.
     */
    Q_PROPERTY(QColor foreground READ foreground NOTIFY paletteChanged FINAL)

    /**
     * A color suitable for rendering a background behind the
     * source image.
     *
     * On dark items, this will be the color closest to black in the
     * image if it's dark enough, or a dark gray otherwise.
     * On light items, this will be the color closest to white
     * in the image if it's light enough, or a bright gray otherwise.
     */
    Q_PROPERTY(QColor background READ background NOTIFY paletteChanged FINAL)

    /**
     * The lightest color of the source image.
     */
    Q_PROPERTY(QColor closestToWhite READ closestToWhite NOTIFY paletteChanged FINAL)

    /**
     * The darkest color of the source image.
     */
    Q_PROPERTY(QColor closestToBlack READ closestToBlack NOTIFY paletteChanged FINAL)

    /**
     * The value to return when palette is not available, e.g. when
     * ImageColors is still computing it or the source is invalid.
     */
    Q_PROPERTY(QVariantList fallbackPalette MEMBER m_fallbackPalette NOTIFY fallbackPaletteChanged FINAL)

    /**
     * The value to return when paletteBrightness is not available, e.g. when
     * ImageColors is still computing it or the source is invalid.
     */
    Q_PROPERTY(ColorUtils::Brightness fallbackPaletteBrightness MEMBER m_fallbackPaletteBrightness NOTIFY fallbackPaletteBrightnessChanged FINAL)

    /**
     * The value to return when average is not available, e.g. when
     * ImageColors is still computing it or the source is invalid.
     */
    Q_PROPERTY(QColor fallbackAverage MEMBER m_fallbackAverage NOTIFY fallbackAverageChanged FINAL)

    /**
     * The value to return when dominant is not available, e.g. when
     * ImageColors is still computing it or the source is invalid.
     */
    Q_PROPERTY(QColor fallbackDominant MEMBER m_fallbackDominant NOTIFY fallbackDominantChanged FINAL)

    /**
     * The value to return when dominantContrasting is not available, e.g. when
     * ImageColors is still computing it or the source is invalid.
     */
    Q_PROPERTY(QColor fallbackDominantContrasting MEMBER m_fallbackDominantContrasting NOTIFY fallbackDominantContrastingChanged FINAL)

    /**
     * The value to return when highlight is not available, e.g. when
     * ImageColors is still computing it or the source is invalid.
     */
    Q_PROPERTY(QColor fallbackHighlight MEMBER m_fallbackHighlight NOTIFY fallbackHighlightChanged FINAL)

    /**
     * The value to return when foreground is not available, e.g. when
     * ImageColors is still computing it or the source is invalid.
     */
    Q_PROPERTY(QColor fallbackForeground MEMBER m_fallbackForeground NOTIFY fallbackForegroundChanged FINAL)

    /**
     * The value to return when background is not available, e.g. when
     * ImageColors is still computing it or the source is invalid.
     */
    Q_PROPERTY(QColor fallbackBackground MEMBER m_fallbackBackground NOTIFY fallbackBackgroundChanged FINAL)

public:
    explicit ImageColors(QObject *parent = nullptr);
    ~ImageColors() override;

    void setSource(const QVariant &source);
    QVariant source() const;

    void setSourceImage(const QImage &image);
    QImage sourceImage() const;

    void setSourceItem(QQuickItem *source);
    QQuickItem *sourceItem() const;

    Q_INVOKABLE void update();

    QVariantList palette() const;
    ColorUtils::Brightness paletteBrightness() const;
    QColor average() const;
    QColor dominant() const;
    QColor dominantContrast() const;
    QColor highlight() const;
    QColor foreground() const;
    QColor background() const;
    QColor closestToWhite() const;
    QColor closestToBlack() const;

Q_SIGNALS:
    void sourceChanged();
    void paletteChanged();
    void fallbackPaletteChanged();
    void fallbackPaletteBrightnessChanged();
    void fallbackAverageChanged();
    void fallbackDominantChanged();
    void fallbackDominantContrastingChanged();
    void fallbackHighlightChanged();
    void fallbackForegroundChanged();
    void fallbackBackgroundChanged();

private:
    static inline void positionColor(QRgb rgb, QList<ImageData::colorStat> &clusters);
    static void positionColorMP(const decltype(ImageData::m_samples) &samples, decltype(ImageData::m_clusters) &clusters, int numCore = 0);
    ImageData generatePalette(const QImage &sourceImage) const;

    double getClusterScore(const ImageData::colorStat &stat) const;
    void postProcess(ImageData &imageData) const;

    // Arbitrary number that seems to work well
    static const int s_minimumSquareDistance = 32000;
    QPointer<QQuickWindow> m_window;
    QVariant m_source;
    QPointer<QQuickItem> m_sourceItem;
    QSharedPointer<QQuickItemGrabResult> m_grabResult;
    QImage m_sourceImage;
    QFutureWatcher<QImage> *m_futureSourceImageData = nullptr;

    QTimer *m_imageSyncTimer;

    QFutureWatcher<ImageData> *m_futureImageData = nullptr;
    ImageData m_imageData;

    QVariantList m_fallbackPalette;
    ColorUtils::Brightness m_fallbackPaletteBrightness;
    QColor m_fallbackAverage;
    QColor m_fallbackDominant;
    QColor m_fallbackDominantContrasting;
    QColor m_fallbackHighlight;
    QColor m_fallbackForeground;
    QColor m_fallbackBackground;
};
