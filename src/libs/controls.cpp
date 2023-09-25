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
