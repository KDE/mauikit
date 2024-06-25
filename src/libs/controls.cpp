#include "controls.h"

Controls::Controls(QObject *parent)
    : QObject{parent}
{

}

Controls *Controls::qmlAttachedProperties(QObject *object)
{
    Q_UNUSED(object)

    return new Controls(object);
}

bool Controls::showCSD() const
{
    return m_showCSD;
}

void Controls::setShowCSD(bool newShowCSD)
{
    if (m_showCSD == newShowCSD)
        return;
    m_showCSD = newShowCSD;
    Q_EMIT showCSDChanged();
}

QString Controls::title() const
{
    return m_title;
}

void Controls::setTitle(const QString &title)
{
    if (m_title == title)
        return;
    m_title = title;
    Q_EMIT titleChanged();
}

QString Controls::iconName() const
{
    return m_iconName;
}

void Controls::setIconName(const QString &newIconName)
{
    if (m_iconName == newIconName)
        return;
    m_iconName = newIconName;
    Q_EMIT iconNameChanged();
}

QString Controls::badgeText() const
{
    return m_badgeText;
}

void Controls::setBadgeText(const QString &newBadgeText)
{
    if (m_badgeText == newBadgeText)
        return;
    m_badgeText = newBadgeText;
    Q_EMIT badgeTextChanged();
}

QString Controls::toolTipText() const
{
    return m_toolTipText;
}

void Controls::setToolTipText(const QString &newToolTipText)
{
    if (m_toolTipText == newToolTipText)
        return;
    m_toolTipText = newToolTipText;
    Q_EMIT toolTipTextChanged();
}

QString Controls::color() const
{
    return m_color;
}

void Controls::setColor(const QString &newColor)
{
    if (m_color == newColor)
        return;
    m_color = newColor;
    Q_EMIT colorChanged();
}
