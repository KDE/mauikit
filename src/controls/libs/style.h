#pragma once

#include <QObject>
#include <QFont>
#include <QColor>
#include <QVariant>
#include <QQmlEngine>
#include <QFontMetrics>

namespace MauiMan
{
class ThemeManager;
class BackgroundManager;
}

class Units : public QObject
{
    Q_OBJECT
    Q_PROPERTY(uint gridUnit MEMBER m_gridUnit CONSTANT FINAL)
    Q_PROPERTY(uint veryLongDuration MEMBER m_veryLongDuration CONSTANT FINAL)
    Q_PROPERTY(uint longDuration MEMBER m_longDuration CONSTANT FINAL)
    Q_PROPERTY(uint shortDuration MEMBER m_shortDuration CONSTANT FINAL)
    Q_PROPERTY(uint veryShortDuration MEMBER m_veryShortDuration CONSTANT FINAL)
    Q_PROPERTY(uint humanMoment MEMBER m_humanMoment CONSTANT FINAL)
    Q_PROPERTY(uint toolTipDelay MEMBER m_toolTipDelay CONSTANT FINAL)

public:
    explicit Units(QObject *parent = nullptr);
    
private:
    QFontMetricsF m_fontMetrics;
    uint m_gridUnit;
    uint m_veryLongDuration;
    uint m_longDuration;
    uint m_shortDuration;
    uint m_veryShortDuration;
    uint m_humanMoment;
    uint m_toolTipDelay;
};

class GroupSizes : public QObject
{
    Q_OBJECT
    Q_PROPERTY(uint tiny MEMBER m_tiny NOTIFY sizesChanged  FINAL)
    Q_PROPERTY(uint small MEMBER m_small NOTIFY sizesChanged  FINAL)
    Q_PROPERTY(uint medium MEMBER m_medium NOTIFY sizesChanged  FINAL)
    Q_PROPERTY(uint big MEMBER m_big NOTIFY sizesChanged  FINAL)
    Q_PROPERTY(uint large MEMBER m_large NOTIFY sizesChanged  FINAL)
    Q_PROPERTY(uint huge MEMBER m_huge NOTIFY sizesChanged  FINAL)
    Q_PROPERTY(uint enormous MEMBER m_enormous NOTIFY sizesChanged  FINAL)

public:
    explicit GroupSizes(const uint tiny,const uint small, const uint medium, const uint big, const uint large, const uint huge, const uint enormous, QObject *parent = nullptr);
    GroupSizes(QObject *parent = nullptr);
    
    uint m_tiny;
    uint m_small;
    uint m_medium;
    uint m_big;
    uint m_large;
    uint m_huge;
    uint m_enormous;
    
signals:
    void sizesChanged();
};

class Style : public QObject
{
    Q_OBJECT
    Q_DISABLE_COPY(Style)
    Q_DISABLE_MOVE(Style)

    Q_PROPERTY(uint toolBarHeight MEMBER m_toolBarHeight CONSTANT FINAL)
    Q_PROPERTY(uint toolBarHeightAlt MEMBER m_toolBarHeightAlt CONSTANT FINAL)
    Q_PROPERTY(uint radiusV MEMBER m_radiusV NOTIFY radiusVChanged FINAL)
    Q_PROPERTY(uint iconSize READ iconSize NOTIFY iconSizeChanged FINAL)

    Q_PROPERTY(uint rowHeight MEMBER m_rowHeight CONSTANT FINAL)
    Q_PROPERTY(uint rowHeightAlt MEMBER m_rowHeightAlt CONSTANT FINAL)
    Q_PROPERTY(uint contentMargins MEMBER m_contentMargins  NOTIFY contentMarginsChanged)
    Q_PROPERTY(uint defaultFontSize MEMBER m_defaultFontSize CONSTANT FINAL)
    Q_PROPERTY(uint defaultPadding MEMBER m_defaultPadding NOTIFY defaultPaddingChanged)
    Q_PROPERTY(uint defaultSpacing MEMBER m_defaultSpacing NOTIFY defaultSpacingChanged)
    
    Q_PROPERTY(QFont defaultFont MEMBER m_defaultFont NOTIFY defaultFontChanged)
    Q_PROPERTY(QFont h1Font MEMBER m_h1Font NOTIFY h1FontChanged)
    Q_PROPERTY(QFont h2Font MEMBER m_h2Font NOTIFY h2FontChanged)
    Q_PROPERTY(QFont monospacedFont MEMBER m_monospacedFont NOTIFY monospacedFontChanged)
    
    Q_PROPERTY(GroupSizes *fontSizes MEMBER m_fontSizes NOTIFY fontSizesChanged)
    Q_PROPERTY(GroupSizes *space MEMBER m_space CONSTANT FINAL)
    Q_PROPERTY(GroupSizes *iconSizes MEMBER m_iconSizes CONSTANT FINAL)
    Q_PROPERTY(Units *units MEMBER m_units CONSTANT FINAL)

    Q_PROPERTY(QColor accentColor READ accentColor WRITE setAccentColor NOTIFY accentColorChanged FINAL RESET unsetAccentColor)

    Q_PROPERTY(QVariant adaptiveColorSchemeSource READ adaptiveColorSchemeSource WRITE setAdaptiveColorSchemeSource NOTIFY adaptiveColorSchemeSourceChanged RESET unsetAdaptiveColorSchemeSource)

    Q_PROPERTY(StyleType styleType READ styleType WRITE setStyleType NOTIFY styleTypeChanged RESET unsetStyeType)

    Q_PROPERTY(bool enableEffects READ enableEffects NOTIFY enableEffectsChanged FINAL)

    Q_PROPERTY(QString currentIconTheme READ currentIconTheme NOTIFY currentIconThemeChanged)

    Q_PROPERTY(bool menusHaveIcons READ menusHaveIcons CONSTANT FINAL)
    
    Q_PROPERTY(bool trueBlack READ trueBlack WRITE setTrueBlack NOTIFY trueBlackChanged)
    
public:
    enum StyleType : uint
    {
        Light = 0,
        Dark,
        Adaptive,
        Auto
    }; Q_ENUM(StyleType)

    static Style *qmlAttachedProperties(QObject *object);

    static Style *instance()
    {
        if (m_instance)
            return m_instance;

        m_instance = new Style;
        return m_instance;
    }

    QVariant adaptiveColorSchemeSource() const;
    void setAdaptiveColorSchemeSource(const QVariant &source);
    void unsetAdaptiveColorSchemeSource();

    QColor accentColor() const;
    void setAccentColor(const QColor &color);
    void unsetAccentColor();

    StyleType styleType() const;
    void setStyleType(const StyleType &type);
    void unsetStyeType();

    void setRadiusV(const uint &radius);

    bool enableEffects() const;

    uint iconSize() const;

    QString currentIconTheme() const;
    
    bool menusHaveIcons();
    
    bool trueBlack() const;
    void setTrueBlack(bool value);

public Q_SLOTS:
    int mapToIconSizes(const int &size);

private:
    explicit Style(QObject *parent = nullptr);
    static Style *m_instance;
    QFont m_defaultFont;
    QFont m_h1Font = QFont {};
    QFont m_h2Font = QFont {};
    QFont m_monospacedFont = QFont {};
    
    GroupSizes *m_iconSizes;
    GroupSizes *m_space;
    GroupSizes *m_fontSizes;
    Units *m_units;

    uint m_defaultFontSize;

    uint m_toolBarHeight = 42;
    uint m_toolBarHeightAlt = 38;
    uint m_radiusV = 4;
    uint m_iconSize = 22;
    uint m_rowHeight = 32;
    uint m_rowHeightAlt = 28;
    
    uint m_contentMargins;
    uint m_defaultPadding;
    uint m_defaultSpacing;

    QColor m_accentColor;
    bool m_accentColor_blocked = false;

    QVariant m_adaptiveColorSchemeSource;
    bool m_adaptiveColorSchemeSource_blocked = false;

    StyleType m_styleType;
    bool m_styleType_blocked = false;

    MauiMan::ThemeManager *m_themeSettings;
    MauiMan::BackgroundManager *m_backgroundSettings;

    bool m_enableEffects = true;

    QString m_currentIconTheme;
    
    bool m_trueBlack = false;
    bool m_trueBlack_clocked = false;

    void setFontSizes();
    void styleChanged();
    
Q_SIGNALS:
    void defaultFontChanged();
    void h1FontChanged();
    void h2FontChanged();
    void monospacedFontChanged();
    void fontSizesChanged();
    
    void adaptiveColorSchemeSourceChanged(QVariant source);
    void accentColorChanged(QColor color);
    void colorSchemeChanged();
    void styleTypeChanged(StyleType type);
    void radiusVChanged(uint radius);
    void iconSizeChanged(uint size);
    void enableEffectsChanged(bool enableEffects);
    void defaultPaddingChanged();
    void contentMarginsChanged();
    void currentIconThemeChanged(QString currentIconTheme);
    void defaultSpacingChanged();
    void trueBlackChanged(bool value);
};

QML_DECLARE_TYPEINFO(Style, QML_HAS_ATTACHED_PROPERTIES)

