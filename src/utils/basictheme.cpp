/*
 * SPDX-FileCopyrightText: 2017 by Marco Martin <mart@kde.org>
 * SPDX-FileCopyrightText: 2021 Arjen Hiemstra <ahiemstra@heimr.nl>
 *
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

#include "basictheme_p.h"

#include <QFile>
#include <QGuiApplication>
#include <QPalette>

#include "libs/style.h"
#include "imagecolors.h"

namespace Maui
{
BasicThemeDefinition::BasicThemeDefinition(PlatformTheme::StyleType type, QObject *parent)
    : QObject(parent)
    ,m_initialType(type)
    , m_imgColors(new ImageColors(this))
{
    auto style = Style::instance();
    connect(style, &Style::styleTypeChanged, [this, style](Style::StyleType type)
            {
                if(m_initialType != PlatformTheme::Undefined)
                    return;

                switch(type)
                {
                case Style::StyleType::Light:
                {
                    setLightColors();
                    break;
                }
                case Style::StyleType::Dark:
                {
                    setDarkColors();
                    break;
                }
                case Style::StyleType::TrueBlack:
                {
                    setTrueBlackColors();
                    break;
                }
                case Style::StyleType::Inverted:
                {
                    setTrueBlackColors(true);
                    break;
                }
                case Style::StyleType::Adaptive:
                {
                    m_imgColors->setSource(style->adaptiveColorSchemeSource());
                    break;
                }
                case Style::StyleType::Auto:
                default:
                {
                    setSystemPaletteColors();
                    break;
                }
                }

                Q_EMIT this->changed();
            });

    connect(style, &Style::accentColorChanged, [this, style](QColor)
            {
                switch(style->styleType())
                {
                case Style::StyleType::Light:
                {
                    setLightColors();
                    break;
                }
                case Style::StyleType::Dark:
                {
                    setDarkColors();
                    break;
                }
                case Style::StyleType::TrueBlack:
                case Style::StyleType::Inverted:
                case Style::StyleType::Auto:
                case Style::StyleType::Adaptive:
                default:
                {
                    break;
                }
                }

                Q_EMIT this->changed();
            });

    connect(style, &Style::adaptiveColorSchemeSourceChanged, [this, style](QVariant source)
            {
                if(style->styleType() == Style::StyleType::Adaptive)
                {
                    m_imgColors->setSource(source);
                }
            });

    connect(m_imgColors, &ImageColors::paletteChanged, [this, style]()
            {
                if(style->styleType() == Style::StyleType::Adaptive)
                {
                    setAdaptiveColors();
                    Q_EMIT this->changed();
                }
            });

    connect(qGuiApp, &QGuiApplication::paletteChanged, [this, style](QPalette)
            {
                if(style->styleType() == Style::StyleType::Auto)
                {
                    setSystemPaletteColors();
                    Q_EMIT this->changed();
                }
            });

    switch(type)
    {
    case PlatformTheme::StyleType::Light:
    {
        setLightColors();
        break;
    }
    case PlatformTheme::StyleType::Dark:
    {
        setDarkColors();
        break;
    }
    case PlatformTheme::StyleType::Adaptive:
    {
        m_imgColors->setSource(style->adaptiveColorSchemeSource());
        break;
    }
    default:
    case PlatformTheme::StyleType::Undefined:
    {
        switch(style->styleType())
        {
        case Style::StyleType::Light:
        {
            setLightColors();
            break;
        }
        case Style::StyleType::Dark:
        {
            setDarkColors();
            break;
        }
        case Style::StyleType::Adaptive:
        {
            m_imgColors->setSource(style->adaptiveColorSchemeSource());
            break;
        }

        case Style::StyleType::TrueBlack:
        {
            setTrueBlackColors();
            break;
        }
        case Style::StyleType::Inverted:
        {
            setTrueBlackColors(true);
            break;
        }
        case Style::StyleType::Auto:
        default:
        {
            setSystemPaletteColors();
            break;
        }
        }
    }
    }
}

       // const char *colorProperty = "KDE_COLOR_SCHEME_PATH";
void BasicThemeDefinition::setSystemPaletteColors()
{
    auto palette = QGuiApplication::palette();

    textColor = palette.color(QPalette::ColorRole::WindowText);
    disabledTextColor = palette.color(QPalette::ColorRole::PlaceholderText);

    highlightColor = palette.color(QPalette::ColorRole::Highlight);
    highlightedTextColor = palette.color(QPalette::ColorRole::HighlightedText);

    backgroundColor = palette.color(QPalette::ColorRole::Window);

    ColorUtils cu;
    const auto isDark = cu.brightnessForColor(backgroundColor) == ColorUtils::Dark;

    activeBackgroundColor = highlightColor;
    alternateBackgroundColor = isDark ? palette.color(QPalette::ColorRole::AlternateBase).lighter(104) : palette.color(QPalette::ColorRole::AlternateBase).darker(104);

    hoverColor = palette.color(isDark ? QPalette::ColorRole::Midlight : QPalette::ColorRole::Mid);
    focusColor = highlightColor;

    activeTextColor = highlightColor;

    buttonTextColor = palette.color(QPalette::ColorRole::ButtonText);
    buttonBackgroundColor = palette.color(QPalette::ColorRole::Button);
    buttonAlternateBackgroundColor = isDark ? buttonBackgroundColor.lighter(104) : buttonBackgroundColor.darker(104);
    buttonHoverColor = palette.color(isDark ? QPalette::ColorRole::Midlight : QPalette::ColorRole::Mid);
    buttonFocusColor = highlightColor;

    viewTextColor = palette.color(QPalette::ColorRole::Text);
    viewBackgroundColor = palette.color(QPalette::ColorRole::Base);
    viewAlternateBackgroundColor = isDark ? viewBackgroundColor.lighter(104) : viewBackgroundColor.darker(104);
    viewHoverColor = palette.color(isDark ? QPalette::ColorRole::Midlight : QPalette::ColorRole::Mid);
    viewFocusColor = highlightColor;

    selectionTextColor = palette.color(QPalette::ColorRole::HighlightedText);
    selectionBackgroundColor = highlightColor;
    selectionAlternateBackgroundColor = isDark ? highlightColor.lighter() : highlightColor.darker();
    selectionHoverColor = isDark ? highlightColor.darker() : highlightColor.lighter();
    selectionFocusColor = highlightColor;

    bool useDefaultColors = true;
    //         #ifndef Q_OS_ANDROID
    //         if (qApp && qApp->property(colorProperty).isValid())
    //         {
    //             auto path = qApp->property(colorProperty).toString();
    //             auto config = KSharedConfig::openConfig(path);
    //
    //             auto active = KColorScheme(QPalette::Active, KColorScheme::Header, config);
    //
    //             headerTextColor = active.foreground().color();
    //             headerBackgroundColor = active.background().color();
    //             headerAlternateBackgroundColor = active.background(KColorScheme::AlternateBackground).color();
    //             headerHoverColor = active.decoration(KColorScheme::HoverColor).color();
    //             headerFocusColor = active.decoration(KColorScheme::HoverColor).color();
    //             useDefaultColors = false;
    //         }
    //         #endif

    if(useDefaultColors)
    {
        headerTextColor = textColor;
        headerBackgroundColor = palette.color(QPalette::ColorRole::Window);
        headerAlternateBackgroundColor =palette.color(QPalette::ColorRole::AlternateBase);
        headerHoverColor =palette.color(QPalette::ColorRole::Light);
        headerFocusColor = highlightColor;
    }


    complementaryTextColor = palette.color(QPalette::ColorRole::BrightText);
    complementaryBackgroundColor = palette.color(QPalette::ColorRole::Shadow);
    complementaryAlternateBackgroundColor = palette.color(QPalette::ColorRole::Dark);
    complementaryHoverColor = palette.color(QPalette::ColorRole::Mid);
    complementaryFocusColor = highlightColor;

    linkColor = palette.color(QPalette::ColorRole::Link);
    linkBackgroundColor =  palette.color(QPalette::ColorRole::Light);
    visitedLinkColor =  palette.color(QPalette::ColorRole::LinkVisited);
    visitedLinkBackgroundColor =  palette.color(QPalette::ColorRole::Light);

    negativeTextColor = QColor{"#dac7cb"};
    negativeBackgroundColor = QColor{"#DA4453"};
    neutralTextColor = QColor{"#fafafa"};
    neutralBackgroundColor = QColor{"#F67400"};
    positiveTextColor = QColor{"#fafafa"};
    positiveBackgroundColor = QColor{"#27AE60"};

    tooltipTextColor = QColor{"#fafafa"};
    tooltipBackgroundColor = QColor{"#333"};
    tooltipAlternateBackgroundColor = tooltipBackgroundColor.darker();
    tooltipHoverColor = QColor{"#000"};
    tooltipFocusColor = QColor{"#000"};
}

void BasicThemeDefinition::setTrueBlackColors( bool inverted )
{
    QColor color1{"#ffffff"};
    QColor color2{"#000000"};

    textColor = inverted ? color2 : color1;
    disabledTextColor = textColor;

    highlightColor = inverted ? color2 : color1;
    highlightedTextColor = inverted ? color1 : color2;

    backgroundColor = inverted ? color1 : color2;
    activeBackgroundColor = highlightColor;
    alternateBackgroundColor = backgroundColor;
    hoverColor = backgroundColor;
    focusColor = highlightColor;

    activeTextColor = highlightColor;

    buttonTextColor = textColor;
    buttonBackgroundColor = backgroundColor;
    buttonAlternateBackgroundColor = buttonBackgroundColor;
    buttonHoverColor = buttonBackgroundColor;
    buttonFocusColor = buttonBackgroundColor;

    viewTextColor = textColor;
    viewBackgroundColor = backgroundColor;
    viewAlternateBackgroundColor = viewBackgroundColor;
    viewHoverColor = viewBackgroundColor;
    viewFocusColor = highlightColor;

    selectionTextColor = highlightedTextColor;
    selectionBackgroundColor = highlightColor;
    selectionAlternateBackgroundColor = selectionBackgroundColor;
    selectionHoverColor = selectionBackgroundColor;
    selectionFocusColor = highlightColor;

    complementaryTextColor = highlightedTextColor;
    complementaryBackgroundColor = highlightColor;
    complementaryAlternateBackgroundColor = complementaryBackgroundColor;
    complementaryHoverColor = complementaryBackgroundColor;
    complementaryFocusColor = highlightColor;

    headerTextColor = textColor;
    headerBackgroundColor = backgroundColor;
    headerAlternateBackgroundColor = headerBackgroundColor;
    headerHoverColor = headerBackgroundColor;
    headerFocusColor = highlightColor;

    linkColor = QColor{"#21b9ff"};
    linkBackgroundColor = QColor{"#21b9ff"};
    visitedLinkColor = QColor{"#ff17d4"};
    visitedLinkBackgroundColor = QColor{"#ff17d4"};

    negativeTextColor = QColor{"#DA4453"};
    negativeBackgroundColor = backgroundColor;
    neutralTextColor = QColor{"#F67400"};
    neutralBackgroundColor = backgroundColor;
    positiveTextColor = QColor{"#27AE60"};
    positiveBackgroundColor = backgroundColor;

    tooltipTextColor = textColor;
    tooltipBackgroundColor = backgroundColor;
    tooltipAlternateBackgroundColor = tooltipBackgroundColor;
    tooltipHoverColor = tooltipBackgroundColor;
    tooltipFocusColor = tooltipBackgroundColor;
}

void BasicThemeDefinition::setDarkColors()
{
    ColorUtils cu;

    textColor = DarkColor::textColor;
    disabledTextColor = DarkColor::disabledTextColor;

    highlightColor = Style::instance()->accentColor();
    const auto isDark = cu.brightnessForColor(highlightColor) == ColorUtils::Dark;

    highlightedTextColor = isDark ? QColor{"#eff0f1"} : QColor{"#232323"};

    backgroundColor = cu.tintWithAlpha(DarkColor::backgroundColor, highlightColor, 0.02);
    activeBackgroundColor = highlightColor;
    alternateBackgroundColor = cu.tintWithAlpha(DarkColor::alternateBackgroundColor, highlightColor, 0.02);
    hoverColor = cu.tintWithAlpha(DarkColor::hoverColor, highlightColor, 0.02);
    focusColor = highlightColor;

    activeTextColor = highlightColor;

    buttonTextColor = textColor;
    buttonBackgroundColor = cu.tintWithAlpha(DarkColor::buttonBackgroundColor, highlightColor, 0.02);
    buttonAlternateBackgroundColor = cu.tintWithAlpha(DarkColor::buttonAlternateBackgroundColor, highlightColor, 0.02);
    buttonHoverColor =  cu.tintWithAlpha(DarkColor::buttonHoverColor, highlightColor, 0.02);
    buttonFocusColor = highlightColor;

    viewTextColor = textColor;
    viewBackgroundColor = cu.tintWithAlpha(DarkColor::viewBackgroundColor, highlightColor, 0.02);
    viewAlternateBackgroundColor = cu.tintWithAlpha(DarkColor::viewAlternateBackgroundColor, highlightColor, 0.02);
    viewHoverColor =  cu.tintWithAlpha(DarkColor::viewHoverColor, highlightColor, 0.02);
    viewFocusColor = highlightColor;

    selectionTextColor = QColor{"#fcfcfc"};
    selectionBackgroundColor = highlightColor;
    selectionAlternateBackgroundColor = selectionBackgroundColor.darker();
    selectionHoverColor = selectionBackgroundColor.lighter();
    selectionFocusColor = highlightColor;

    complementaryTextColor = QColor{"#eff0f1"};
    complementaryBackgroundColor = cu.tintWithAlpha(QColor{"#31363b"}, highlightColor, 0.03);
    complementaryAlternateBackgroundColor = complementaryBackgroundColor.darker();
    complementaryHoverColor = complementaryBackgroundColor.lighter();
    complementaryFocusColor = highlightColor;

    headerTextColor = textColor;
    headerBackgroundColor =  cu.tintWithAlpha(DarkColor::headerBackgroundColor, highlightColor, 0.04);
    headerAlternateBackgroundColor = cu.tintWithAlpha(DarkColor::headerAlternateBackgroundColor, highlightColor, 0.02);
    headerHoverColor = DarkColor::hoverColor;
    headerFocusColor = highlightColor;

    linkColor = QColor{"#21b9ff"};
    linkBackgroundColor = QColor{"#21b9ff"};
    visitedLinkColor = QColor{"#ff17d4"};
    visitedLinkBackgroundColor = QColor{"#ff17d4"};

    negativeTextColor = QColor{"#fafafa"};
    negativeBackgroundColor = QColor{"#DA4453"};
    neutralTextColor = QColor{"#fafafa"};
    neutralBackgroundColor = QColor{"#F67400"};
    positiveTextColor = QColor{"#fafafa"};
    positiveBackgroundColor = QColor{"#27AE60"};

    tooltipTextColor = QColor{"#fafafa"};
    tooltipBackgroundColor = QColor{"#333"};
    tooltipAlternateBackgroundColor = tooltipBackgroundColor.darker();
    tooltipHoverColor = QColor{"#000"};
    tooltipFocusColor = QColor{"#000"};
}

void BasicThemeDefinition::setLightColors()
{
    ColorUtils cu;

    textColor = LightColor::textColor;
    disabledTextColor = LightColor::disabledTextColor;

    highlightColor = Style::instance()->accentColor();
    //         backgroundColor = QColor{"#efefef"};
    const auto isDark = cu.brightnessForColor(highlightColor) == ColorUtils::Dark;
    highlightedTextColor = isDark ? QColor{"#eff0f1"} : QColor{"#232323"};

    backgroundColor = cu.tintWithAlpha(LightColor::backgroundColor, highlightColor, 0.02);
    activeBackgroundColor = highlightColor;
    alternateBackgroundColor = cu.tintWithAlpha(LightColor::alternateBackgroundColor, highlightColor, 0.02);

    hoverColor = LightColor::hoverColor;
    focusColor = highlightColor;

    activeTextColor = highlightColor;

    buttonTextColor = textColor;
    buttonBackgroundColor = cu.tintWithAlpha(LightColor::buttonBackgroundColor, highlightColor, 0.03);
    buttonAlternateBackgroundColor = LightColor::buttonAlternateBackgroundColor;
    buttonHoverColor = cu.tintWithAlpha(LightColor::buttonHoverColor, highlightColor, 0.02);
    buttonFocusColor = highlightColor;

    viewTextColor = QColor{"#333333"};
    viewBackgroundColor = cu.tintWithAlpha(LightColor::viewBackgroundColor, highlightColor, 0.02);
    viewAlternateBackgroundColor =cu.tintWithAlpha(LightColor::viewAlternateBackgroundColor, highlightColor, 0.02);
    viewHoverColor = cu.tintWithAlpha(LightColor::viewHoverColor, highlightColor, 0.02);
    viewFocusColor = highlightColor;

    selectionTextColor = QColor{"#eff0f1"};
    selectionBackgroundColor = highlightColor;
    selectionAlternateBackgroundColor = selectionBackgroundColor.darker(120);
    selectionHoverColor = selectionBackgroundColor.lighter(120);
    selectionFocusColor = highlightColor;

    complementaryTextColor = QColor{"#eff0f1"};
    complementaryBackgroundColor = cu.tintWithAlpha(QColor{"#31363b"}, highlightColor, 0.03);
    complementaryAlternateBackgroundColor = complementaryBackgroundColor.darker(120);
    complementaryHoverColor = complementaryBackgroundColor.lighter(120);
    complementaryFocusColor = highlightColor;

    headerTextColor = textColor;
    headerBackgroundColor = cu.tintWithAlpha(LightColor::headerBackgroundColor, highlightColor, 0.04);
    headerAlternateBackgroundColor = cu.tintWithAlpha(LightColor::headerAlternateBackgroundColor, highlightColor, 0.02);
    headerHoverColor = LightColor::hoverColor;
    headerFocusColor = highlightColor;

    linkColor = QColor{"#21b9ff"};
    linkBackgroundColor = QColor{"#21b9ff"};
    visitedLinkColor = QColor{"#ff17d4"};
    visitedLinkBackgroundColor = QColor{"#ff17d4"};

    negativeTextColor = QColor{"#fafafa"};
    negativeBackgroundColor = QColor{"#DA4453"};
    neutralTextColor = QColor{"#fafafa"};
    neutralBackgroundColor = QColor{"#F67400"};
    positiveTextColor = QColor{"#fafafa"};
    positiveBackgroundColor = QColor{"#27AE60"};

    tooltipTextColor = QColor{"#fafafa"};
    tooltipBackgroundColor = QColor{"#333"};
    tooltipAlternateBackgroundColor = tooltipBackgroundColor.darker();
    tooltipHoverColor = QColor{"#000"};
    tooltipFocusColor = QColor{"#000"};
}

void BasicThemeDefinition::setAdaptiveColors()
{
    ColorUtils cu;

    textColor = m_imgColors->foreground();
    disabledTextColor = textColor.lighter(120);

    highlightColor = m_imgColors->highlight();

    const auto isDark = m_imgColors->paletteBrightness() == ColorUtils::Dark;
    const auto bgColor = cu.tintWithAlpha(isDark ? DarkColor::backgroundColor : LightColor::backgroundColor, m_imgColors->background(), 0.1);
    const auto btnColor =  cu.tintWithAlpha(isDark ? DarkColor::buttonBackgroundColor : LightColor::buttonBackgroundColor, highlightColor, 0.06);

    highlightedTextColor = cu.brightnessForColor(highlightColor) ==  ColorUtils::Dark ? m_imgColors->closestToWhite() : m_imgColors->closestToBlack();
    //         backgroundColor = cu.tintWithAlpha(m_imgColors->background(), bgColor, 0.8);
    backgroundColor =  cu.tintWithAlpha(bgColor, highlightColor, 0.03);
    activeBackgroundColor = highlightColor;
    alternateBackgroundColor = cu.tintWithAlpha(backgroundColor, highlightColor, 0.02);

    hoverColor =  cu.tintWithAlpha(isDark ? DarkColor::hoverColor : LightColor::hoverColor, highlightColor, 0.02);

    focusColor = highlightColor;

    activeTextColor = highlightColor;

    buttonTextColor = textColor;
    buttonBackgroundColor = btnColor;
    buttonAlternateBackgroundColor = cu.tintWithAlpha(isDark ? DarkColor::buttonBackgroundColor : LightColor::buttonBackgroundColor, highlightColor, 0.03);
    buttonHoverColor = cu.tintWithAlpha(isDark ? DarkColor::buttonHoverColor : LightColor::buttonHoverColor, highlightColor, 0.03);
    buttonFocusColor = highlightColor;

    viewTextColor = textColor;
    viewBackgroundColor = cu.tintWithAlpha(isDark ? DarkColor::viewBackgroundColor : LightColor::viewBackgroundColor, highlightColor, 0.07);
    viewAlternateBackgroundColor =  cu.tintWithAlpha(isDark ? DarkColor::viewAlternateBackgroundColor : LightColor::viewAlternateBackgroundColor, highlightColor, 0.03);
    viewHoverColor = cu.tintWithAlpha(isDark ? DarkColor::viewHoverColor : LightColor::viewHoverColor, highlightColor, 0.03);
    viewFocusColor = highlightColor;

    selectionTextColor = QColor{"#fcfcfc"};
    selectionBackgroundColor = highlightColor;
    selectionAlternateBackgroundColor = selectionBackgroundColor.darker();
    selectionHoverColor = selectionBackgroundColor.lighter();
    selectionFocusColor = highlightColor;

    complementaryTextColor = QColor{"#eff0f1"};
    complementaryBackgroundColor = cu.tintWithAlpha(QColor{"#31363b"}, highlightColor, 0.03);
    complementaryAlternateBackgroundColor = complementaryBackgroundColor.darker();
    complementaryHoverColor = complementaryBackgroundColor.lighter();
    complementaryFocusColor = highlightColor;

    headerTextColor = textColor;
    headerBackgroundColor = cu.tintWithAlpha(bgColor, highlightColor, 0.05);
    headerAlternateBackgroundColor = headerBackgroundColor.darker();
    headerAlternateBackgroundColor = cu.tintWithAlpha(bgColor, highlightColor, 0.02);

    headerHoverColor = headerBackgroundColor.lighter();
    headerFocusColor = highlightColor;

    linkColor = QColor{"#2980B9"};
    linkBackgroundColor = QColor{"#2980B9"};
    visitedLinkColor = QColor{"#7F8C8D"};
    visitedLinkBackgroundColor = QColor{"#2196F3"};

    negativeTextColor = QColor{"#dac7cb"};
    negativeBackgroundColor = QColor{"#DA4453"};
    neutralTextColor = QColor{"#fafafa"};
    neutralBackgroundColor = QColor{"#F67400"};
    positiveTextColor = QColor{"#fafafa"};
    positiveBackgroundColor = QColor{"#27AE60"};

    tooltipTextColor = QColor{"#fafafa"};
    tooltipBackgroundColor = QColor{"#333"};
    tooltipAlternateBackgroundColor = tooltipBackgroundColor.darker();
    tooltipHoverColor = QColor{"#000"};
    tooltipFocusColor = QColor{"#000"};
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

BasicThemeDefinition &BasicThemeInstance::themeDefinition(PlatformTheme::StyleType type)
{
    switch(type)
    {
    case PlatformTheme::Light:
    {
        if (m_themeDefinitionLight) {
            return *m_themeDefinitionLight;
        }

        m_themeDefinitionLight = std::make_unique<BasicThemeDefinition>(type);
        return *m_themeDefinitionLight;
    }        
    case Maui::PlatformTheme::Dark:
    {
        if (m_themeDefinitionDark) {
            return *m_themeDefinitionDark;
        }

        m_themeDefinitionDark = std::make_unique<BasicThemeDefinition>(type);
        return *m_themeDefinitionDark;
    }
    case PlatformTheme::Undefined:
    default:
    {
        if (m_themeDefinition) {
            return *m_themeDefinition;
        }

        m_themeDefinition = std::make_unique<BasicThemeDefinition>(type);
        connect(m_themeDefinition.get(), &BasicThemeDefinition::changed, this, &BasicThemeInstance::onDefinitionChanged);
        return *m_themeDefinition;
    }
    }
}

void BasicThemeInstance::onDefinitionChanged()
{
    for (auto watcher : std::as_const(watchers))
    {
        if(watcher->styleType() == PlatformTheme::StyleType::Undefined)
        {
            watcher->sync();
            watcher->resetColors();

        }
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

QColor BasicTheme::getColor(StyleType style, ColorRole role, ColorSet set, ColorGroup group)
{
    auto &definition = basicThemeInstance()->themeDefinition(style);
    auto otherRole = [&](ColorRole role) -> QColor
    {
        switch(role)
        {
        case PlatformTheme::DisabledTextColor: return tint(definition.disabledTextColor, group);
        case PlatformTheme::HighlightedTextColor: return tint(definition.highlightedTextColor, group);
        case PlatformTheme::ActiveTextColor:return tint(definition.activeTextColor, group);
        case PlatformTheme::LinkColor:return tint(definition.linkColor, group);
        case PlatformTheme::VisitedLinkColor:return tint(definition.visitedLinkColor, group);
        case PlatformTheme::NegativeTextColor:return tint(definition.negativeTextColor, group);
        case PlatformTheme::NeutralTextColor:return tint(definition.neutralTextColor, group);
        case PlatformTheme::PositiveTextColor:return tint(definition.positiveTextColor, group);
        case PlatformTheme::HighlightColor:return tint(definition.highlightColor, group);
        case PlatformTheme::ActiveBackgroundColor:return tint(definition.activeBackgroundColor, group);
        case PlatformTheme::LinkBackgroundColor:return tint(definition.linkBackgroundColor, group);
        case PlatformTheme::VisitedLinkBackgroundColor:return tint(definition.visitedLinkBackgroundColor, group);
        case PlatformTheme::NegativeBackgroundColor:return tint(definition.negativeBackgroundColor, group);
        case PlatformTheme::NeutralBackgroundColor:return tint(definition.neutralBackgroundColor, group);
        case PlatformTheme::PositiveBackgroundColor:return tint(definition.positiveBackgroundColor, group);
        }
    };

    switch (set)
    {
    case BasicTheme::Button:
        switch(role)
        {
        case BasicTheme::TextColor: return tint(definition.buttonTextColor, group);
        case BasicTheme::BackgroundColor: return tint(definition.buttonBackgroundColor, group);
        case BasicTheme::AlternateBackgroundColor: return tint(definition.buttonAlternateBackgroundColor, group);
        case BasicTheme::HoverColor : return tint(definition.buttonHoverColor, group);
        case BasicTheme::FocusColor: return tint(definition.buttonFocusColor, group);
        default: return otherRole(role);
        }
        break;
    case BasicTheme::View:
        switch(role)
        {
        case BasicTheme::TextColor: return tint(definition.viewTextColor, group);
        case BasicTheme::BackgroundColor: return tint(definition.viewBackgroundColor, group);
        case BasicTheme::AlternateBackgroundColor: return tint(definition.viewAlternateBackgroundColor, group);
        case BasicTheme::HoverColor : return tint(definition.viewHoverColor, group);
        case BasicTheme::FocusColor: return tint(definition.viewFocusColor, group);
        default: return otherRole(role);
        }
        break;
    case BasicTheme::Selection:
        switch(role)
        {
        case BasicTheme::TextColor: return tint(definition.selectionTextColor, group);
        case BasicTheme::BackgroundColor: return tint(definition.selectionBackgroundColor, group);
        case BasicTheme::AlternateBackgroundColor: return tint(definition.selectionAlternateBackgroundColor, group);
        case BasicTheme::HoverColor : return tint(definition.selectionHoverColor, group);
        case BasicTheme::FocusColor: return tint(definition.selectionFocusColor, group);
        default: return otherRole(role);
        }
        break;
    case BasicTheme::Tooltip:
        switch(role)
        {
        case BasicTheme::TextColor: return tint(definition.tooltipTextColor, group);
        case BasicTheme::BackgroundColor: return tint(definition.tooltipBackgroundColor, group);
        case BasicTheme::AlternateBackgroundColor: return tint(definition.tooltipAlternateBackgroundColor, group);
        case BasicTheme::HoverColor : return tint(definition.tooltipHoverColor, group);
        case BasicTheme::FocusColor: return tint(definition.tooltipFocusColor, group);
        default: return otherRole(role);
        }
        break;
    case BasicTheme::Complementary:
        switch(role)
        {
        case BasicTheme::TextColor: return tint(definition.complementaryTextColor, group);
        case BasicTheme::BackgroundColor: return tint(definition.complementaryBackgroundColor, group);
        case BasicTheme::AlternateBackgroundColor: return tint(definition.complementaryAlternateBackgroundColor, group);
        case BasicTheme::HoverColor : return tint(definition.complementaryHoverColor, group);
        case BasicTheme::FocusColor: return tint(definition.complementaryFocusColor, group);
        default: return otherRole(role);
        }
        break;
    case BasicTheme::Header:
        switch(role)
        {
        case BasicTheme::TextColor: return tint(definition.headerTextColor, group);
        case BasicTheme::BackgroundColor: return tint(definition.headerBackgroundColor, group);
        case BasicTheme::AlternateBackgroundColor: return tint(definition.headerAlternateBackgroundColor, group);
        case BasicTheme::HoverColor : return tint(definition.headerHoverColor, group);
        case BasicTheme::FocusColor: return tint(definition.headerFocusColor, group);
        default: return otherRole(role);
        }
        break;
    case BasicTheme::Window:
    default:
        switch(role)
        {
        case BasicTheme::TextColor: return tint(definition.textColor, group);
        case BasicTheme::BackgroundColor: return tint(definition.backgroundColor, group);
        case BasicTheme::AlternateBackgroundColor: return tint(definition.alternateBackgroundColor, group);
        case BasicTheme::HoverColor : return tint(definition.hoverColor, group);
        case BasicTheme::FocusColor: return tint(definition.focusColor, group);
        default: return otherRole(role);
        }
        break;
    }

}

void BasicTheme::sync()
{
    setTextColor(getColor(styleType(), PlatformTheme::TextColor, colorSet(), colorGroup()));
    setBackgroundColor(getColor(styleType(), PlatformTheme::BackgroundColor, colorSet(), colorGroup()));
    setAlternateBackgroundColor(getColor(styleType(), PlatformTheme::AlternateBackgroundColor, colorSet(), colorGroup()));
    setHoverColor(getColor(styleType(), PlatformTheme::HoverColor, colorSet(), colorGroup()));
    setFocusColor(getColor(styleType(), PlatformTheme::FocusColor, colorSet(), colorGroup()));
    setDisabledTextColor(getColor(styleType(), PlatformTheme::DisabledTextColor, colorSet(), colorGroup()));
    setHighlightColor(getColor(styleType(), PlatformTheme::HighlightColor, colorSet(), colorGroup()));
    setHighlightedTextColor(getColor(styleType(), PlatformTheme::HighlightedTextColor, colorSet(), colorGroup()));
    setActiveTextColor(getColor(styleType(), PlatformTheme::ActiveTextColor, colorSet(), colorGroup()));
    setActiveBackgroundColor(getColor(styleType(), PlatformTheme::ActiveBackgroundColor, colorSet(), colorGroup()));
    setLinkColor(getColor(styleType(), PlatformTheme::LinkColor, colorSet(), colorGroup()));
    setLinkBackgroundColor(getColor(styleType(), PlatformTheme::LinkBackgroundColor, colorSet(), colorGroup()));
    setVisitedLinkColor(getColor(styleType(), PlatformTheme::VisitedLinkColor, colorSet(), colorGroup()));
    setVisitedLinkBackgroundColor(getColor(styleType(), PlatformTheme::VisitedLinkBackgroundColor, colorSet(), colorGroup()));
    setNegativeTextColor(getColor(styleType(), PlatformTheme::NegativeTextColor, colorSet(), colorGroup()));
    setNegativeBackgroundColor(getColor(styleType(), PlatformTheme::NegativeBackgroundColor, colorSet(), colorGroup()));
    setNeutralTextColor(getColor(styleType(), PlatformTheme::NeutralTextColor, colorSet(), colorGroup()));
    setNeutralBackgroundColor(getColor(styleType(), PlatformTheme::NeutralBackgroundColor, colorSet(), colorGroup()));
    setPositiveTextColor(getColor(styleType(), PlatformTheme::PositiveTextColor, colorSet(), colorGroup()));
    setPositiveBackgroundColor(getColor(styleType(), PlatformTheme::PositiveBackgroundColor, colorSet(), colorGroup()));
}

bool BasicTheme::event(QEvent *event)
{
    if (event->type() == PlatformThemeEvents::DataChangedEvent::type) {
        sync();
    }

    if (event->type() == PlatformThemeEvents::ColorSetChangedEvent::type) {
        sync();
    }

    if (event->type() == PlatformThemeEvents::StyleTypeChangedEvent::type) {
        sync();
    }

    if (event->type() == PlatformThemeEvents::ColorGroupChangedEvent::type) {
        sync();
    }

    if (event->type() == PlatformThemeEvents::ColorChangedEvent::type) {
        basicThemeInstance()->themeDefinition(styleType()).syncToQml(this);
    }

    if (event->type() == PlatformThemeEvents::FontChangedEvent::type) {
        basicThemeInstance()->themeDefinition(styleType()).syncToQml(this);
    }

    return PlatformTheme::event(event);
}

QColor BasicTheme::tint(const QColor &color, PlatformTheme::ColorGroup group)
{
    switch (group)
    {
    case PlatformTheme::Inactive:
        return QColor::fromHsvF(color.hueF(), color.saturationF() * 0.5, color.valueF());
    case PlatformTheme::Disabled:
        return QColor::fromHsvF(color.hueF(), color.saturationF() * 0.5, color.valueF() * 0.8);
    default:
        return color;
    }
}
}
