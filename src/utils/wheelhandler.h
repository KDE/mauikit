/* SPDX-FileCopyrightText: 2019 Marco Martin <mart@kde.org>
 * SPDX-FileCopyrightText: 2021 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

#pragma once

#include <QGuiApplication>
#include <QObject>
#include <QPoint>
#include <QQuickItem>
#include <QStyleHints>
#include <QtQml>

class QWheelEvent;
class WheelHandler;

/**
 * Describes the mouse wheel event
 */
class KirigamiWheelEvent : public QObject
{
    Q_OBJECT

    /**
     * x: real
     *
     * X coordinate of the mouse pointer
     */
    Q_PROPERTY(qreal x READ x CONSTANT)

    /**
     * y: real
     *
     * Y coordinate of the mouse pointer
     */
    Q_PROPERTY(qreal y READ y CONSTANT)

    /**
     * angleDelta: point
     *
     * The distance the wheel is rotated in degrees.
     * The x and y coordinates indicate the horizontal and vertical wheels respectively.
     * A positive value indicates it was rotated up/right, negative, bottom/left
     * This value is more likely to be set in traditional mice.
     */
    Q_PROPERTY(QPointF angleDelta READ angleDelta CONSTANT)

    /**
     * pixelDelta: point
     *
     * provides the delta in screen pixels available on high resolution trackpads
     */
    Q_PROPERTY(QPointF pixelDelta READ pixelDelta CONSTANT)

    /**
     * buttons: int
     *
     * it contains an OR combination of the buttons that were pressed during the wheel, they can be:
     * Qt.LeftButton, Qt.MiddleButton, Qt.RightButton
     */
    Q_PROPERTY(int buttons READ buttons CONSTANT)

    /**
     * modifiers: int
     *
     * Keyboard mobifiers that were pressed during the wheel event, such as:
     * Qt.NoModifier (default, no modifiers)
     * Qt.ControlModifier
     * Qt.ShiftModifier
     * ...
     */
    Q_PROPERTY(int modifiers READ modifiers CONSTANT)

    /**
     * inverted: bool
     *
     * Whether the delta values are inverted
     * On some platformsthe returned delta are inverted, so positive values would mean bottom/left
     */
    Q_PROPERTY(bool inverted READ inverted CONSTANT)

    /**
     * accepted: bool
     *
     * If set, the event shouldn't be managed anymore,
     * for instance it can be used to block the handler to manage the scroll of a view on some scenarios
     * @code
     * // This handler handles automatically the scroll of
     * // flickableItem, unless Ctrl is pressed, in this case the
     * // app has custom code to handle Ctrl+wheel zooming
     * Kirigami.WheelHandler {
     *   target: flickableItem
     *   blockTargetWheel: true
     *   scrollFlickableTarget: true
     *   onWheel: {
     *        if (wheel.modifiers & Qt.ControlModifier) {
     *            wheel.accepted = true;
     *            // Handle scaling of the view
     *       }
     *   }
     * }
     * @endcode
     *
     */
    Q_PROPERTY(bool accepted READ isAccepted WRITE setAccepted)

public:
    KirigamiWheelEvent(QObject *parent = nullptr);
    ~KirigamiWheelEvent() override;

    void initializeFromEvent(QWheelEvent *event);

    qreal x() const;
    qreal y() const;
    QPointF angleDelta() const;
    QPointF pixelDelta() const;
    int buttons() const;
    int modifiers() const;
    bool inverted() const;
    bool isAccepted();
    void setAccepted(bool accepted);

private:
    qreal m_x = 0;
    qreal m_y = 0;
    QPointF m_angleDelta;
    QPointF m_pixelDelta;
    Qt::MouseButtons m_buttons = Qt::NoButton;
    Qt::KeyboardModifiers m_modifiers = Qt::NoModifier;
    bool m_inverted = false;
    bool m_accepted = false;
};

class WheelFilterItem : public QQuickItem
{
    Q_OBJECT
public:
    WheelFilterItem(QQuickItem *parent = nullptr);
};

/**
 * @brief Handles scrolling for a Flickable and 2 attached ScrollBars.
 *
 * WheelHandler filters events from a Flickable, a vertical ScrollBar and a horizontal ScrollBar.
 * Wheel and KeyPress events (when `keyNavigationEnabled` is true) are used to scroll the Flickable.
 * When `filterMouseEvents` is true, WheelHandler blocks mouse button input from reaching the Flickable
 * and sets the `interactive` property of the scrollbars to false when touch input is used.
 *
 * Wheel event handling behavior:
 *
 * - Pixel delta is ignored unless angle delta is not available because pixel delta scrolling is too slow. Qt Widgets doesn't use pixel delta either, so the default scroll speed should be consistent with Qt Widgets.
 * - When using angle delta, scroll using the step increments defined by `verticalStepSize` and `horizontalStepSize`.
 * - When one of the keyboard modifiers in `pageScrollModifiers` is used, scroll by pages.
 * - When using a device that doesn't use 120 angle delta unit increments such as a touchpad, the `verticalStepSize`, `horizontalStepSize` and page increments (if using page scrolling) will be multiplied by `angle delta / 120` to keep scrolling smooth.
 * - If scrolling has happened in the last 400ms, use an internal QQuickItem stacked over the Flickable's contentItem to catch wheel events and use those wheel events to scroll, if possible. This prevents controls inside the Flickable's contentItem that allow scrolling to change the value (e.g., Sliders, SpinBoxes) from conflicting with scrolling the page.
 *
 * Common usage with a Flickable:
 *
 * @include wheelhandler/FlickableUsage.qml
 *
 * Common usage inside of a ScrollView template:
 *
 * @include wheelhandler/ScrollViewUsage.qml
 *
 */
class WheelHandler : public QObject
{
    Q_OBJECT

    /**
     * @brief This property holds the Qt Quick Flickable that the WheelHandler will control.
     */
    Q_PROPERTY(QQuickItem *target READ target WRITE setTarget NOTIFY targetChanged FINAL)

    /**
     * @brief This property holds the vertical step size.
     *
     * The default value is equivalent to `20 * Qt.styleHints.wheelScrollLines`. This is consistent with the default increment for QScrollArea.
     *
     * @sa horizontalStepSize
     *
     * @since KDE Frameworks 5.89
     */
    Q_PROPERTY(qreal verticalStepSize READ verticalStepSize
               WRITE setVerticalStepSize RESET resetVerticalStepSize
               NOTIFY verticalStepSizeChanged FINAL)

    /**
     * @brief This property holds the horizontal step size.
     *
     * The default value is equivalent to `20 * Qt.styleHints.wheelScrollLines`. This is consistent with the default increment for QScrollArea.
     *
     * @sa verticalStepSize
     *
     * @since KDE Frameworks 5.89
     */
    Q_PROPERTY(qreal horizontalStepSize READ horizontalStepSize
               WRITE setHorizontalStepSize RESET resetHorizontalStepSize
               NOTIFY horizontalStepSizeChanged FINAL)

    /**
     * @brief This property holds the keyboard modifiers that will be used to start page scrolling.
     *
     * The default value is equivalent to `Qt.ControlModifier | Qt.ShiftModifier`. This matches QScrollBar, which uses QAbstractSlider behavior.
     *
     * @since KDE Frameworks 5.89
     */
    Q_PROPERTY(Qt::KeyboardModifiers pageScrollModifiers READ pageScrollModifiers
               WRITE setPageScrollModifiers RESET resetPageScrollModifiers
               NOTIFY pageScrollModifiersChanged FINAL)

    /**
     * @brief This property holds whether the WheelHandler filters mouse events like a Qt Quick Controls ScrollView would.
     *
     * Touch events are allowed to flick the view and they make the scrollbars not interactive.
     *
     * Mouse events are not allowed to flick the view and they make the scrollbars interactive.
     *
     * Hover events on the scrollbars and wheel events on anything also make the scrollbars interactive when this property is set to true.
     *
     * The default value is `false`.
     *
     * @since KDE Frameworks 5.89
     */
    Q_PROPERTY(bool filterMouseEvents READ filterMouseEvents
               WRITE setFilterMouseEvents NOTIFY filterMouseEventsChanged FINAL)

    /**
     * @brief This property holds whether the WheelHandler handles keyboard scrolling.
     *
     * - Left arrow scrolls a step to the left.
     * - Right arrow scrolls a step to the right.
     * - Up arrow scrolls a step upwards.
     * - Down arrow scrolls a step downwards.
     * - PageUp scrolls to the previous page.
     * - PageDown scrolls to the next page.
     * - Home scrolls to the beginning.
     * - End scrolls to the end.
     * - When Alt is held, scroll horizontally when using PageUp, PageDown, Home or End.
     *
     * The default value is `false`.
     *
     * @since KDE Frameworks 5.89
     */
    Q_PROPERTY(bool keyNavigationEnabled READ keyNavigationEnabled
               WRITE setKeyNavigationEnabled NOTIFY keyNavigationEnabledChanged FINAL)

    /**
     * @brief This property holds whether the WheelHandler blocks all wheel events from reaching the Flickable.
     *
     * When this property is false, scrolling the Flickable with WheelHandler will only block an event from reaching the Flickable if the Flickable is actually scrolled by WheelHandler.
     *
     * NOTE: Wheel events created by touchpad gestures with pixel deltas will always be accepted no matter what. This is because they will cause the Flickable to jump back to where scrolling started unless the events are always accepted before they reach the Flickable.
     *
     * The default value is true.
     */
    Q_PROPERTY(bool blockTargetWheel MEMBER m_blockTargetWheel NOTIFY blockTargetWheelChanged)

    /**
     * @brief This property holds whether the WheelHandler can use wheel events to scroll the Flickable.
     *
     * The default value is true.
     */
    Q_PROPERTY(bool scrollFlickableTarget MEMBER m_scrollFlickableTarget NOTIFY scrollFlickableTargetChanged)

public:
    explicit WheelHandler(QObject *parent = nullptr);
    ~WheelHandler() override;

    QQuickItem *target() const;
    void setTarget(QQuickItem *target);

    qreal verticalStepSize() const;
    void setVerticalStepSize(qreal stepSize);
    void resetVerticalStepSize();

    qreal horizontalStepSize() const;
    void setHorizontalStepSize(qreal stepSize);
    void resetHorizontalStepSize();

    Qt::KeyboardModifiers pageScrollModifiers() const;
    void setPageScrollModifiers(Qt::KeyboardModifiers modifiers);
    void resetPageScrollModifiers();

    bool filterMouseEvents() const;
    void setFilterMouseEvents(bool enabled);

    bool keyNavigationEnabled() const;
    void setKeyNavigationEnabled(bool enabled);

    /**
     * Scroll up one step. If the stepSize parameter is less than 0, the verticalStepSize will be used.
     *
     * returns true if the contentItem was moved.
     *
     * @since KDE Frameworks 5.89
     */
    Q_INVOKABLE bool scrollUp(qreal stepSize = -1);

    /**
     * Scroll down one step. If the stepSize parameter is less than 0, the verticalStepSize will be used.
     *
     * returns true if the contentItem was moved.
     *
     * @since KDE Frameworks 5.89
     */
    Q_INVOKABLE bool scrollDown(qreal stepSize = -1);

    /**
     * Scroll left one step. If the stepSize parameter is less than 0, the horizontalStepSize will be used.
     *
     * returns true if the contentItem was moved.
     *
     * @since KDE Frameworks 5.89
     */
    Q_INVOKABLE bool scrollLeft(qreal stepSize = -1);

    /**
     * Scroll right one step. If the stepSize parameter is less than 0, the horizontalStepSize will be used.
     *
     * returns true if the contentItem was moved.
     *
     * @since KDE Frameworks 5.89
     */
    Q_INVOKABLE bool scrollRight(qreal stepSize = -1);

Q_SIGNALS:
    void targetChanged();
    void verticalStepSizeChanged();
    void horizontalStepSizeChanged();
    void pageScrollModifiersChanged();
    void filterMouseEventsChanged();
    void keyNavigationEnabledChanged();
    void blockTargetWheelChanged();
    void scrollFlickableTargetChanged();

    /**
     * @brief This signal is emitted when a wheel event reaches the event filter, just before scrolling is handled.
     *
     * Accepting the wheel event in the `onWheel` signal handler prevents scrolling from happening.
     */
    void wheel(KirigamiWheelEvent *wheel);

protected:
    bool eventFilter(QObject *watched, QEvent *event) override;

private:
    void setScrolling(bool scrolling);
    bool scrollFlickable(QPointF pixelDelta,
                         QPointF angleDelta = {},
                         Qt::KeyboardModifiers modifiers = Qt::NoModifier);

    QPointer<QQuickItem> m_flickable;
    QPointer<QQuickItem> m_verticalScrollBar;
    QPointer<QQuickItem> m_horizontalScrollBar;
    QPointer<QQuickItem> m_filterItem;
    // Matches QScrollArea and QTextEdit
    qreal m_defaultPixelStepSize = 20 * QGuiApplication::styleHints()->wheelScrollLines();
    qreal m_verticalStepSize = m_defaultPixelStepSize;
    qreal m_horizontalStepSize = m_defaultPixelStepSize;
    bool m_explicitVStepSize = false;
    bool m_explicitHStepSize = false;
    bool m_wheelScrolling = false;
    constexpr static qreal m_wheelScrollingDuration = 400;
    bool m_filterMouseEvents = false;
    bool m_keyNavigationEnabled = false;
    bool m_wasTouched = false;
    bool m_blockTargetWheel = true;
    bool m_scrollFlickableTarget = true;
    // Same as QXcbWindow.
    constexpr static Qt::KeyboardModifiers m_defaultHorizontalScrollModifiers = Qt::AltModifier;
    // Same as QScrollBar/QAbstractSlider.
    constexpr static Qt::KeyboardModifiers m_defaultPageScrollModifiers = Qt::ControlModifier | Qt::ShiftModifier;
    Qt::KeyboardModifiers m_pageScrollModifiers = m_defaultPageScrollModifiers;
    QTimer m_wheelScrollingTimer;
    KirigamiWheelEvent m_kirigamiWheelEvent;
};
