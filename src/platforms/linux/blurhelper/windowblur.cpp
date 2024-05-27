/*
 * Copyright (C) 2021 CutefishOS Team.
 *
 * Author:     cutefish <cutefishos@foxmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "windowblur.h"

#include <QApplication>
#include <QPainterPath>
#include <QScreen>

#include <xcb/xcb.h>
#include <xcb/shape.h>
#include <xcb/xcb_icccm.h>
#include <KWindowSystem>
#include <KWindowEffects>
#include "style.h"

WindowBlur::WindowBlur(QObject *parent) noexcept
: QObject(parent)
, m_view(nullptr)
, m_enabled(false)
, m_windowRadius(0.0)
{
}

WindowBlur::~WindowBlur()
{
}

void WindowBlur::classBegin()
{
}

void WindowBlur::componentComplete()
{
    Style::instance()->setTranslucencyAvailable(m_enabled);
    updateBlur();
}

void WindowBlur::setView(QWindow *view)
{
    if (view != m_view) {
        m_view = view;
        updateBlur();
        Q_EMIT viewChanged();
        
        connect(m_view, &QWindow::visibleChanged, this, &WindowBlur::onViewVisibleChanged);
    }
}

QWindow* WindowBlur::view() const
{
    return m_view;
}

void WindowBlur::setGeometry(const QRect &rect)
{
    if (rect != m_rect) {
        m_rect = rect;
        
       
            updateBlur();
        
        Q_EMIT geometryChanged();
    }
}

QRect WindowBlur::geometry() const
{
    return m_rect;
}

void WindowBlur::setEnabled(bool enabled)
{
    if (enabled != m_enabled) {
        m_enabled = enabled;
        updateBlur();
        Q_EMIT enabledChanged();
    }
}

bool WindowBlur::enabled() const
{
    return m_enabled;
}

void WindowBlur::setWindowRadius(qreal radius)
{
    if (radius != m_windowRadius) {
        m_windowRadius = radius;
        
            updateBlur();
        
        Q_EMIT windowRadiusChanged();
    }
}

qreal WindowBlur::windowRadius() const
{
    return m_windowRadius;
}

void WindowBlur::onViewVisibleChanged(bool visible)
{
    if (visible)
        updateBlur();
}

void WindowBlur::updateBlur()
{
    if (!m_view)
        return;

    if(KWindowSystem::isPlatformWayland())
    {
        qDebug() << "SETTING BLURRED WINDOW BG WAYLAND KDE;" << m_enabled << m_view;
        KWindowEffects::enableBlurBehind(m_view, m_enabled, m_rect);
        KWindowEffects::enableBackgroundContrast(m_view, m_enabled);
    }
}
