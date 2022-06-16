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

#include "controls/libs/style.h"
#include "imagecolors.h"

namespace Maui
{
    
    BasicThemeDefinition::BasicThemeDefinition(QObject *parent)
    : QObject(parent)
    ,m_imgColors(new ImageColors(this))
    {
        defaultFont = qGuiApp->font();
        
        smallFont = qGuiApp->font();
        smallFont.setPointSize(smallFont.pointSize() - 2);
        
        auto style = Style::instance();
        connect(style, &Style::styleTypeChanged, [this, style](Style::StyleType type)
        {            
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
        
        disabledTextColor = QColor{"#9931363b"};
        
        activeBackgroundColor = QColor{"#0176D3"};
        linkColor = QColor{"#2980B9"};
        linkBackgroundColor = QColor{"#2980B9"};
        visitedLinkColor = QColor{"#7F8C8D"};
        visitedLinkBackgroundColor = QColor{"#2196F3"};
        negativeTextColor = QColor{"#DA4453"};
        negativeBackgroundColor = QColor{"#DA4453"};
        neutralTextColor = QColor{"#F67400"};
        neutralBackgroundColor = QColor{"#F67400"};
        positiveTextColor = QColor{"#27AE60"};
        positiveBackgroundColor = QColor{"#27AE60"};        
        
        tooltipTextColor = QColor{"#fafafa"};
        tooltipBackgroundColor = QColor{"#333"};
        tooltipAlternateBackgroundColor = tooltipBackgroundColor.darker();
        tooltipHoverColor = QColor{"#000"};
        tooltipFocusColor = QColor{"#000"};        
        
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
            case Style::StyleType::Auto:
            default:
            {
                setSystemPaletteColors();
                break;                    
            }    
        }
    }
    
    void BasicThemeDefinition::setSystemPaletteColors()
    {
        auto palette = QGuiApplication::palette();
        textColor = palette.color(QPalette::ColorRole::WindowText);
        
        highlightColor = palette.color(QPalette::ColorRole::Highlight);
        highlightedTextColor = palette.color(QPalette::ColorRole::HighlightedText);      
        
        backgroundColor = palette.color(QPalette::ColorRole::Window);        
        alternateBackgroundColor = palette.color(QPalette::ColorRole::AlternateBase).lighter(104);
        hoverColor = palette.color(QPalette::ColorRole::Midlight);        
        focusColor = highlightColor;
        
        activeTextColor = highlightColor;    
        
        buttonTextColor = palette.color(QPalette::ColorRole::ButtonText);
        buttonBackgroundColor = palette.color(QPalette::ColorRole::Button);
        buttonAlternateBackgroundColor =palette.color(QPalette::ColorRole::Midlight);
        buttonHoverColor = palette.color(QPalette::ColorRole::Mid); 
        buttonFocusColor = highlightColor;
        
        viewTextColor = palette.color(QPalette::ColorRole::Text);
        viewBackgroundColor = palette.color(QPalette::ColorRole::Base);
        viewAlternateBackgroundColor =palette.color(QPalette::ColorRole::AlternateBase);
        viewHoverColor = palette.color(QPalette::ColorRole::Midlight);
        viewFocusColor = highlightColor;
        
        selectionTextColor = palette.color(QPalette::ColorRole::HighlightedText);
        selectionBackgroundColor = highlightColor;
        selectionAlternateBackgroundColor = highlightColor.lighter();
        selectionHoverColor = highlightColor.darker();
        selectionFocusColor = highlightColor;
        
        complementaryTextColor = palette.color(QPalette::ColorRole::BrightText);
        complementaryBackgroundColor = palette.color(QPalette::ColorRole::Dark);
        complementaryAlternateBackgroundColor = palette.color(QPalette::ColorRole::Mid);
        complementaryHoverColor = palette.color(QPalette::ColorRole::Midlight);
        complementaryFocusColor = highlightColor;
        
        headerTextColor = textColor;
        headerBackgroundColor =palette.color(QPalette::ColorRole::Window);
        headerAlternateBackgroundColor =palette.color(QPalette::ColorRole::AlternateBase);
        headerHoverColor =palette.color(QPalette::ColorRole::Light);
        headerFocusColor = highlightColor;
    }
    
    void BasicThemeDefinition::setDarkColors()
    {
        ColorUtils cu;
        
        textColor = QColor{"#f4f5f6"};
        
        highlightColor = Style::instance()->accentColor();        
        const auto isDark = cu.brightnessForColor(highlightColor) == ColorUtils::Dark;
        
        highlightedTextColor = isDark ? QColor{"#eff0f1"} : QColor{"#232323"};
                
        backgroundColor =  cu.tintWithAlpha(DarkColor::backgroundColor, highlightColor, 0.02);
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
        viewBackgroundColor =  cu.tintWithAlpha(DarkColor::viewBackgroundColor, highlightColor, 0.02); 
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
        headerBackgroundColor = cu.tintWithAlpha(QColor{"#2b2c31"}, highlightColor, 0.04);
        headerAlternateBackgroundColor = headerBackgroundColor.darker();
        headerHoverColor = headerBackgroundColor.lighter();
        headerFocusColor = highlightColor;        
    }
    
    void BasicThemeDefinition::setLightColors()
    {
        ColorUtils cu;
        
        textColor = QColor{"#31363b"};
        
        highlightColor = Style::instance()->accentColor();
        //         backgroundColor = QColor{"#efefef"};        
        const auto isDark = cu.brightnessForColor(highlightColor) == ColorUtils::Dark;        
        highlightedTextColor = isDark ? QColor{"#eff0f1"} : QColor{"#232323"};       
        
        backgroundColor = cu.tintWithAlpha(LightColor::backgroundColor, highlightColor, 0.02);        
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
        headerBackgroundColor = cu.tintWithAlpha(LightColor::headerBackgroundColor, highlightColor, 0.03);
        headerAlternateBackgroundColor = cu.tintWithAlpha(LightColor::headerAlternateBackgroundColor, highlightColor, 0.02);
        headerHoverColor = headerBackgroundColor.lighter(120);
        headerFocusColor = highlightColor;
    }
    
    void BasicThemeDefinition::setAdaptiveColors()
    {
        ColorUtils cu;
        
        textColor = m_imgColors->foreground();        
        highlightColor = m_imgColors->highlight();
        
        const auto isDark = m_imgColors->paletteBrightness() == ColorUtils::Dark;
        const auto bgColor = cu.tintWithAlpha(isDark ? DarkColor::backgroundColor : LightColor::backgroundColor, m_imgColors->background(), 0.1);
       const auto btnColor =  cu.tintWithAlpha(isDark ? DarkColor::buttonBackgroundColor : LightColor::buttonBackgroundColor, highlightColor, 0.06);
        
        highlightedTextColor = cu.brightnessForColor(highlightColor) ==  ColorUtils::Dark ? m_imgColors->closestToWhite() : m_imgColors->closestToBlack();
//         backgroundColor = cu.tintWithAlpha(m_imgColors->background(), bgColor, 0.8);
        backgroundColor =  cu.tintWithAlpha(bgColor, highlightColor, 0.03);
        alternateBackgroundColor = cu.tintWithAlpha(isDark ? DarkColor::alternateBackgroundColor : LightColor::alternateBackgroundColor, highlightColor, 0.03);
        hoverColor =  cu.tintWithAlpha(isDark ? DarkColor::hoverColor : LightColor::hoverColor, highlightColor, 0.02);
        
        focusColor = highlightColor;
        
        activeTextColor = highlightColor;    
        
        buttonTextColor = textColor;
        buttonBackgroundColor = btnColor;
        buttonAlternateBackgroundColor = cu.tintWithAlpha(isDark ? DarkColor::buttonBackgroundColor : LightColor::buttonBackgroundColor, highlightColor, 0.03);
        buttonHoverColor = cu.tintWithAlpha(isDark ? DarkColor::buttonHoverColor : LightColor::buttonHoverColor, highlightColor, 0.03);
        buttonFocusColor = highlightColor;
        
        viewTextColor = textColor;
        viewBackgroundColor = cu.tintWithAlpha(isDark ? DarkColor::viewBackgroundColor : LightColor::viewBackgroundColor, highlightColor, 0.03);
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
        headerHoverColor = headerBackgroundColor.lighter();
        headerFocusColor = highlightColor;
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
        for (auto watcher : std::as_const(watchers))
        {
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
            case BasicTheme::Header:
                setTextColor(tint(definition.headerTextColor));
                setBackgroundColor(tint(definition.headerBackgroundColor));
                setAlternateBackgroundColor(tint(definition.headerAlternateBackgroundColor));
                setHoverColor(tint(definition.headerHoverColor));
                setFocusColor(tint(definition.headerFocusColor));
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
