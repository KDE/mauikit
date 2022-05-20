/*
 * SPDX-FileCopyrightText: 2017 by Marco Martin <mart@kde.org>
 * SPDX-FileCopyrightText: 2021 Arjen Hiemstra <ahiemstra@heimr.nl>
 *
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

#include "basictheme_p.h"

#include <QFile>
#include <QGuiApplication>


namespace Maui
{
class CompatibilityThemeDefinition : public BasicThemeDefinition
{
    Q_OBJECT
public:
    CompatibilityThemeDefinition(QObject *component, QObject *parent = nullptr)
        : BasicThemeDefinition(parent)
    {
        m_object = component;

        connect(m_object, SIGNAL(textColorChanged()), this, SLOT(syncFromQml()));
        connect(m_object, SIGNAL(disabledTextColorChanged()), this, SLOT(syncFromQml()));
        connect(m_object, SIGNAL(highlightColorChanged()), this, SLOT(syncFromQml()));
        connect(m_object, SIGNAL(highlightedTextColorChanged()), this, SLOT(syncFromQml()));
        connect(m_object, SIGNAL(backgroundColorChanged()), this, SLOT(syncFromQml()));
        connect(m_object, SIGNAL(alternateBackgroundColorChanged()), this, SLOT(syncFromQml()));
        connect(m_object, SIGNAL(linkColorChanged()), this, SLOT(syncFromQml()));
        connect(m_object, SIGNAL(visitedLinkColorChanged()), this, SLOT(syncFromQml()));
        connect(m_object, SIGNAL(buttonTextColorChanged()), this, SLOT(syncFromQml()));
        connect(m_object, SIGNAL(buttonBackgroundColorChanged()), this, SLOT(syncFromQml()));
        connect(m_object, SIGNAL(buttonAlternateBackgroundColorChanged()), this, SLOT(syncFromQml()));
        connect(m_object, SIGNAL(buttonHoverColorChanged()), this, SLOT(syncFromQml()));
        connect(m_object, SIGNAL(buttonFocusColorChanged()), this, SLOT(syncFromQml()));
        connect(m_object, SIGNAL(viewTextColorChanged()), this, SLOT(syncFromQml()));
        connect(m_object, SIGNAL(viewBackgroundColorChanged()), this, SLOT(syncFromQml()));
        connect(m_object, SIGNAL(viewAlternateBackgroundColorChanged()), this, SLOT(syncFromQml()));
        connect(m_object, SIGNAL(viewHoverColorChanged()), this, SLOT(syncFromQml()));
        connect(m_object, SIGNAL(viewFocusColorChanged()), this, SLOT(syncFromQml()));
        connect(m_object, SIGNAL(complementaryTextColorChanged()), this, SLOT(syncFromQml()));
        connect(m_object, SIGNAL(complementaryBackgroundColorChanged()), this, SLOT(syncFromQml()));
        connect(m_object, SIGNAL(complementaryAlternateBackgroundColorChanged()), this, SLOT(syncFromQml()));
        connect(m_object, SIGNAL(complementaryHoverColorChanged()), this, SLOT(syncFromQml()));
        connect(m_object, SIGNAL(complementaryFocusColorChanged()), this, SLOT(syncFromQml()));
    }

    void syncToQml(PlatformTheme *object) override
    {
        BasicThemeDefinition::syncToQml(object);

        QMetaObject::invokeMethod(m_object, "__propagateColorSet", Q_ARG(QVariant, QVariant::fromValue(object->parent())), Q_ARG(QVariant, object->colorSet()));
        QMetaObject::invokeMethod(m_object,
                                  "__propagateTextColor",
                                  Q_ARG(QVariant, QVariant::fromValue(object->parent())),
                                  Q_ARG(QVariant, object->textColor()));
        QMetaObject::invokeMethod(m_object,
                                  "__propagateBackgroundColor",
                                  Q_ARG(QVariant, QVariant::fromValue(object->parent())),
                                  Q_ARG(QVariant, object->backgroundColor()));
        QMetaObject::invokeMethod(m_object,
                                  "__propagatePrimaryColor",
                                  Q_ARG(QVariant, QVariant::fromValue(object->parent())),
                                  Q_ARG(QVariant, object->highlightColor()));
        QMetaObject::invokeMethod(m_object,
                                  "__propagateAccentColor",
                                  Q_ARG(QVariant, QVariant::fromValue(object->parent())),
                                  Q_ARG(QVariant, object->highlightColor()));
    }

    Q_SLOT void syncFromQml()
    {
        textColor = m_object->property("textColor").value<QColor>();
        disabledTextColor = m_object->property("disabledTextColor").value<QColor>();
        highlightColor = m_object->property("highlightColor").value<QColor>();
        highlightedTextColor = m_object->property("highlightedTextColor").value<QColor>();
        backgroundColor = m_object->property("backgroundColor").value<QColor>();
        alternateBackgroundColor = m_object->property("alternateBackgroundColor").value<QColor>();
        linkColor = m_object->property("linkColor").value<QColor>();
        visitedLinkColor = m_object->property("visitedLinkColor").value<QColor>();
        buttonTextColor = m_object->property("buttonTextColor").value<QColor>();
        buttonBackgroundColor = m_object->property("buttonBackgroundColor").value<QColor>();
        buttonAlternateBackgroundColor = m_object->property("buttonAlternateBackgroundColor").value<QColor>();
        buttonHoverColor = m_object->property("buttonHoverColor").value<QColor>();
        buttonFocusColor = m_object->property("buttonFocusColor").value<QColor>();
        viewTextColor = m_object->property("viewTextColor").value<QColor>();
        viewBackgroundColor = m_object->property("viewBackgroundColor").value<QColor>();
        viewAlternateBackgroundColor = m_object->property("viewAlternateBackgroundColor").value<QColor>();
        viewHoverColor = m_object->property("viewHoverColor").value<QColor>();
        viewFocusColor = m_object->property("viewFocusColor").value<QColor>();
        complementaryTextColor = m_object->property("complementaryTextColor").value<QColor>();
        complementaryBackgroundColor = m_object->property("complementaryBackgroundColor").value<QColor>();
        complementaryAlternateBackgroundColor = m_object->property("complementaryAlternateBackgroundColor").value<QColor>();
        complementaryHoverColor = m_object->property("complementaryHoverColor").value<QColor>();
        complementaryFocusColor = m_object->property("complementaryFocusColor").value<QColor>();

        Q_EMIT changed();
    }

private:
    QObject *m_object;
};

BasicThemeDefinition::BasicThemeDefinition(QObject *parent)
    : QObject(parent)
{
    defaultFont = qGuiApp->font();

    smallFont = qGuiApp->font();
    smallFont.setPointSize(smallFont.pointSize() - 2);
}

void BasicThemeDefinition::syncToQml(PlatformTheme *object)
{
    auto item = qobject_cast<QQuickItem *>(object->parent());
    if (item && qmlAttachedPropertiesObject<PlatformTheme>(item, false) == object) {
        Q_EMIT sync(item);
    }
}

BasicThemeInstance::BasicThemeInstance(QObject *parent)
    : QObject(parent)
{
}

BasicThemeDefinition &BasicThemeInstance::themeDefinition(QQmlEngine *engine)
{
    if (m_themeDefinition) {
        return *m_themeDefinition;
    }

    m_themeDefinition = std::make_unique<BasicThemeDefinition>();

    connect(m_themeDefinition.get(), &BasicThemeDefinition::changed, this, &BasicThemeInstance::onDefinitionChanged);

    return *m_themeDefinition;
}

void BasicThemeInstance::onDefinitionChanged()
{
    for (auto watcher : std::as_const(watchers)) {
        watcher->sync();
    }
}

Q_GLOBAL_STATIC(BasicThemeInstance, basicThemeInstance)

BasicTheme::BasicTheme(QObject *parent)
    : PlatformTheme(parent)
{
    basicThemeInstance()->watchers.append(this);

    sync();
}

BasicTheme::~BasicTheme()
{
    basicThemeInstance()->watchers.removeOne(this);
}

void BasicTheme::sync()
{
    auto &definition = basicThemeInstance()->themeDefinition(qmlEngine(parent()));

    switch (colorSet()) {
    case BasicTheme::Button:
        setTextColor(tint(definition.buttonTextColor));
        setBackgroundColor(tint(definition.buttonBackgroundColor));
        setAlternateBackgroundColor(tint(definition.buttonAlternateBackgroundColor));
        setHoverColor(tint(definition.buttonHoverColor));
        setFocusColor(tint(definition.buttonFocusColor));
        break;
    case BasicTheme::View:
        setTextColor(tint(definition.viewTextColor));
        setBackgroundColor(tint(definition.viewBackgroundColor));
        setAlternateBackgroundColor(tint(definition.viewAlternateBackgroundColor));
        setHoverColor(tint(definition.viewHoverColor));
        setFocusColor(tint(definition.viewFocusColor));
        break;
    case BasicTheme::Selection:
        setTextColor(tint(definition.selectionTextColor));
        setBackgroundColor(tint(definition.selectionBackgroundColor));
        setAlternateBackgroundColor(tint(definition.selectionAlternateBackgroundColor));
        setHoverColor(tint(definition.selectionHoverColor));
        setFocusColor(tint(definition.selectionFocusColor));
        break;
    case BasicTheme::Tooltip:
        setTextColor(tint(definition.tooltipTextColor));
        setBackgroundColor(tint(definition.tooltipBackgroundColor));
        setAlternateBackgroundColor(tint(definition.tooltipAlternateBackgroundColor));
        setHoverColor(tint(definition.tooltipHoverColor));
        setFocusColor(tint(definition.tooltipFocusColor));
        break;
    case BasicTheme::Complementary:
        setTextColor(tint(definition.complementaryTextColor));
        setBackgroundColor(tint(definition.complementaryBackgroundColor));
        setAlternateBackgroundColor(tint(definition.complementaryAlternateBackgroundColor));
        setHoverColor(tint(definition.complementaryHoverColor));
        setFocusColor(tint(definition.complementaryFocusColor));
        break;
    case BasicTheme::Window:
    default:
        setTextColor(tint(definition.textColor));
        setBackgroundColor(tint(definition.backgroundColor));
        setAlternateBackgroundColor(tint(definition.alternateBackgroundColor));
        setHoverColor(tint(definition.hoverColor));
        setFocusColor(tint(definition.focusColor));
        break;
    }

    setDisabledTextColor(tint(definition.disabledTextColor));
    setHighlightColor(tint(definition.highlightColor));
    setHighlightedTextColor(tint(definition.highlightedTextColor));
    setActiveTextColor(tint(definition.activeTextColor));
    setActiveBackgroundColor(tint(definition.activeBackgroundColor));
    setLinkColor(tint(definition.linkColor));
    setLinkBackgroundColor(tint(definition.linkBackgroundColor));
    setVisitedLinkColor(tint(definition.visitedLinkColor));
    setVisitedLinkBackgroundColor(tint(definition.visitedLinkBackgroundColor));
    setNegativeTextColor(tint(definition.negativeTextColor));
    setNegativeBackgroundColor(tint(definition.negativeBackgroundColor));
    setNeutralTextColor(tint(definition.neutralTextColor));
    setNeutralBackgroundColor(tint(definition.neutralBackgroundColor));
    setPositiveTextColor(tint(definition.positiveTextColor));
    setPositiveBackgroundColor(tint(definition.positiveBackgroundColor));

    setDefaultFont(definition.defaultFont);
    setSmallFont(definition.smallFont);
}

bool BasicTheme::event(QEvent *event)
{
    if (event->type() == PlatformThemeEvents::DataChangedEvent::type) {
        sync();
    }

    if (event->type() == PlatformThemeEvents::ColorSetChangedEvent::type) {
        sync();
    }

    if (event->type() == PlatformThemeEvents::ColorGroupChangedEvent::type) {
        sync();
    }

    if (event->type() == PlatformThemeEvents::ColorChangedEvent::type) {
        basicThemeInstance()->themeDefinition(qmlEngine(parent())).syncToQml(this);
    }

    if (event->type() == PlatformThemeEvents::FontChangedEvent::type) {
        basicThemeInstance()->themeDefinition(qmlEngine(parent())).syncToQml(this);
    }

    return PlatformTheme::event(event);
}

QColor BasicTheme::tint(const QColor &color)
{
    switch (colorGroup()) {
    case PlatformTheme::Inactive:
        return QColor::fromHsvF(color.hueF(), color.saturationF() * 0.5, color.valueF());
    case PlatformTheme::Disabled:
        return QColor::fromHsvF(color.hueF(), color.saturationF() * 0.5, color.valueF() * 0.8);
    default:
        return color;
    }
}

}

#include "basictheme.moc"
