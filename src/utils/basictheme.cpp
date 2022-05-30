/*
 * SPDX-FileCopyrightText: 2017 by Marco Martin <mart@kde.org>
 * SPDX-FileCopyrightText: 2021 Arjen Hiemstra <ahiemstra@heimr.nl>
 *
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

#include "basictheme_p.h"

#include <QFile>
#include <QGuiApplication>
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
            }
            
            Q_EMIT this->changed();
        });
        
        connect(style, &Style::accentColorChanged, [this, style](QColor color)
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
        }
    }
    
    void BasicThemeDefinition::setDarkColors()
    {
        ColorUtils cu;
        
        textColor = QColor{"#f4f5f6"};
        highlightedTextColor = QColor{"#eff0f1"};
        
        highlightColor = Style::instance()->accentColor();
        
        backgroundColor =  cu.tintWithAlpha(QColor{"#3a3f41"}, highlightColor, 0.05);
        //         backgroundColor = QColor{"#3a3f41"};
        alternateBackgroundColor = backgroundColor.darker();
        
        focusColor = highlightColor;
        hoverColor = backgroundColor.lighter();
        
        activeTextColor = highlightColor;    
        
        buttonTextColor = textColor;
        buttonBackgroundColor = backgroundColor.lighter();
        buttonAlternateBackgroundColor = buttonBackgroundColor.darker();
        buttonHoverColor = buttonBackgroundColor.lighter();
        buttonFocusColor = highlightColor;
        
        viewTextColor = textColor;
        viewBackgroundColor = backgroundColor.darker();
        viewAlternateBackgroundColor = viewBackgroundColor.darker();
        viewHoverColor = viewBackgroundColor.lighter();
        viewFocusColor = highlightColor;
        
        selectionTextColor = QColor{"#fcfcfc"};
        selectionBackgroundColor = highlightColor;
        selectionAlternateBackgroundColor = selectionBackgroundColor.darker();
        selectionHoverColor = selectionBackgroundColor.lighter();
        selectionFocusColor = highlightColor;
        
        complementaryTextColor = QColor{"#eff0f1"};
        complementaryBackgroundColor = QColor{"#31363b"};
        complementaryAlternateBackgroundColor = complementaryBackgroundColor.darker();
        complementaryHoverColor = complementaryBackgroundColor.lighter();
        complementaryFocusColor = highlightColor;
        
        headerTextColor = textColor;
        headerBackgroundColor = QColor{"#2b2c31"};
        headerAlternateBackgroundColor = headerBackgroundColor.darker();
        headerHoverColor = headerBackgroundColor.lighter();
        headerFocusColor = highlightColor;
        
    }
    
    void BasicThemeDefinition::setLightColors()
    {
        ColorUtils cu;
        
        textColor = QColor{"#31363b"};
        highlightedTextColor = QColor{"#eff0f1"};
        
        highlightColor = Style::instance()->accentColor();
        //         backgroundColor = QColor{"#efefef"};
        backgroundColor =  cu.tintWithAlpha(QColor{"#efefef"}, highlightColor, 0.05);
        
        alternateBackgroundColor = backgroundColor.darker();
        
        focusColor = highlightColor;
        hoverColor = backgroundColor.lighter();
        
        activeTextColor = highlightColor;    
        
        buttonTextColor = textColor;
        buttonBackgroundColor = backgroundColor.darker();
        buttonAlternateBackgroundColor = buttonBackgroundColor.darker();
        buttonHoverColor = buttonBackgroundColor.lighter();
        buttonFocusColor = highlightColor;
        
        viewTextColor = textColor;
        viewBackgroundColor = backgroundColor.lighter();
        viewAlternateBackgroundColor = viewBackgroundColor.darker();
        viewHoverColor = viewBackgroundColor.lighter();
        viewFocusColor = highlightColor;
        
        selectionTextColor = QColor{"#eff0f1"};
        selectionBackgroundColor = highlightColor;
        selectionAlternateBackgroundColor = selectionBackgroundColor.darker();
        selectionHoverColor = selectionBackgroundColor.lighter();
        selectionFocusColor = highlightColor;
        
        complementaryTextColor = QColor{"#fafafa"};
        complementaryBackgroundColor = QColor{"#333"};
        complementaryAlternateBackgroundColor = complementaryBackgroundColor.darker();
        complementaryHoverColor = complementaryBackgroundColor.lighter();
        complementaryFocusColor = highlightColor;
        
        headerTextColor = textColor;
        headerBackgroundColor = QColor{"#eceff1"};
        headerAlternateBackgroundColor = headerBackgroundColor.darker();
        headerHoverColor = headerBackgroundColor.lighter();
        headerFocusColor = highlightColor;
    }
    
    void BasicThemeDefinition::setAdaptiveColors()
    {
        ColorUtils cu;
        const auto isDark = m_imgColors->paletteBrightness() == ColorUtils::Dark;
        const auto bgColor = isDark ?  QColor{"#3a3f41"} : QColor{"#efefef"};
        textColor = m_imgColors->foreground();
        
        highlightColor = m_imgColors->highlight();
        highlightedTextColor = cu.brightnessForColor(m_imgColors->highlight()) ==  ColorUtils::Dark ? m_imgColors->closestToWhite() : m_imgColors->closestToBlack();
//         backgroundColor = cu.tintWithAlpha(m_imgColors->background(), bgColor, 0.8);
                backgroundColor =  cu.tintWithAlpha(bgColor, m_imgColors->background(), 0.1);

        alternateBackgroundColor = backgroundColor.darker();
        
        focusColor = highlightColor;
        hoverColor = backgroundColor.lighter();
        
        activeTextColor = highlightColor;    
        
        buttonTextColor = textColor;
        buttonBackgroundColor =  isDark ? backgroundColor.darker() :  backgroundColor.lighter();
        buttonAlternateBackgroundColor = buttonBackgroundColor.darker();
        buttonHoverColor = buttonBackgroundColor.lighter();
        buttonFocusColor = highlightColor;
        
        viewTextColor = textColor;
        viewBackgroundColor = isDark ? backgroundColor.darker() :  backgroundColor.lighter();
        viewAlternateBackgroundColor = viewBackgroundColor.darker();
        viewHoverColor = viewBackgroundColor.lighter();
        viewFocusColor = highlightColor;
        
        selectionTextColor = QColor{"#fcfcfc"};
        selectionBackgroundColor = highlightColor;
        selectionAlternateBackgroundColor = selectionBackgroundColor.darker();
        selectionHoverColor = selectionBackgroundColor.lighter();
        selectionFocusColor = highlightColor;
        
        complementaryTextColor = QColor{"#eff0f1"};
        complementaryBackgroundColor = QColor{"#31363b"};
        complementaryAlternateBackgroundColor = complementaryBackgroundColor.darker();
        complementaryHoverColor = complementaryBackgroundColor.lighter();
        complementaryFocusColor = highlightColor;
        
        headerTextColor = textColor;
        headerBackgroundColor = QColor{"#2b2c31"};
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
