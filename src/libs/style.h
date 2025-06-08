#pragma once

#include <QObject>
#include <QFont>
#include <QColor>
#include <QEvent>
#include <QVariant>
#include <QQmlEngine>
#include <QFontMetrics>

namespace MauiMan
{
class ThemeManager;
class BackgroundManager;
class AccessibilityManager;
}

/**
 * @brief The Unit group properties.
 * These properties are standard values meant to be used across the UI elements for a cohesive look and feel.
 *
 * @note This object can not be instantiated. It only exists as part of the Style::units implementation, which ca be accessed via the global Style singleton.
 */
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

/**
 * @brief The sizes group for some Style properties, such as Style::iconSize, Style::space, etc.
 *
 * @note This object can not be instantiated. It only exists as part of some of the Style property implementations, which ca be accessed via the global Style singleton.
 */
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
    
Q_SIGNALS:
    void sizesChanged();
};

/**
 * @brief The MauiKit Style preferences singleton object.
 *
 */
class Style : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_ATTACHED(Style)
    QML_UNCREATABLE("Cannot be created Style")
    Q_DISABLE_COPY(Style)

    /**
     * The standard height size for the toolbars, such as ToolBar, TabBar, etc. Usually this is used as the minimum height fo those bars.
     * @note This property is read only.
     */
    Q_PROPERTY(uint toolBarHeight MEMBER m_toolBarHeight CONSTANT FINAL)
    
    /**
     * An alternative size for the tab bars, this is a bit smaller then the `toolBarHeight`.
     * @see toolBarHeight
     *
     */
    Q_PROPERTY(uint toolBarHeightAlt MEMBER m_toolBarHeightAlt CONSTANT FINAL)
    
    /**
     * The preferred radius for the border corners of the UI elements.
     * @note This property is read only. It can only be modified from the MauiMan global preferences.
     */
    Q_PROPERTY(uint radiusV MEMBER m_radiusV NOTIFY radiusVChanged FINAL)
    
    /**
     * The preferred size for painting the icons in places, such as menus, buttons and delegates.
     * @note This property is read only. It can only be modified from the MauiMan global preferences.
     */
    Q_PROPERTY(uint iconSize READ iconSize NOTIFY iconSizeChanged FINAL)

    /**
     * The standard size for the height of elements represented as a row. Such as items in lists.
     * This can be used for keeping a coherent look, when an implicit height is not desired, or as the minimum height.
     */
    Q_PROPERTY(uint rowHeight MEMBER m_rowHeight CONSTANT FINAL)
    
    /**
     * An alternative height to the `rowHeight`, this size is a bit smaller.
     */
    Q_PROPERTY(uint rowHeightAlt MEMBER m_rowHeightAlt CONSTANT FINAL)
    
    /**
     * The preferred size for the margins in the browsing views, such as the ListBrowser and GridBrowser, but also for the margins in menus.
     * @note This property is read only. It can only be modified from the MauiMan global preferences.
     */
    Q_PROPERTY(uint contentMargins MEMBER m_contentMargins NOTIFY contentMarginsChanged)
    
    /**
     * The preferred font size for the text labels in the UI elements.
     * @note This property is read only. It can only be modified from the MauiMan global preferences.
     */
    Q_PROPERTY(int defaultFontSize MEMBER m_defaultFontSize CONSTANT FINAL)
    
    /**
     * The preferred padding size for the UI elements, such a menu entries, buttons, bars, etc.
     * The padding refers to the outer-space around the visible background area of the elements.
     * @note This property is read only. It can only be modified from the MauiMan global preferences.
     */
    Q_PROPERTY(uint defaultPadding MEMBER m_defaultPadding NOTIFY defaultPaddingChanged)
    
    /**
     * The preferred spacing size between elements in rows or columns, etc.
     * @note This property is read only. It can only be modified from the MauiMan global preferences.
     */
    Q_PROPERTY(uint defaultSpacing MEMBER m_defaultSpacing NOTIFY defaultSpacingChanged)
    
    /**
     * The preferred font for the text in labels.
     * @note This property is read only. It can only be modified from the MauiMan global preferences.
     */
    Q_PROPERTY(QFont defaultFont MEMBER m_defaultFont NOTIFY defaultFontChanged)
    
    /**
     * The preferred font for titles and headers.
     */
    Q_PROPERTY(QFont h1Font MEMBER m_h1Font NOTIFY h1FontChanged)
    
    /**
     * The preferred font for subtitles.
     */
    Q_PROPERTY(QFont h2Font MEMBER m_h2Font NOTIFY h2FontChanged)
    
    /**
     * The preferred mono spaced font.
     * @note This property is read only. It can only be modified from the MauiMan global preferences.
     */
    Q_PROPERTY(QFont monospacedFont MEMBER m_monospacedFont NOTIFY monospacedFontChanged)
    
    /**
     * The group of different standard font sizes for the MauiKit applications.
     * @see GroupSizes
     */
    Q_PROPERTY(GroupSizes *fontSizes MEMBER m_fontSizes NOTIFY fontSizesChanged)
    
    /**
     * The group of different standard spacing values for consistency in the MauiKit apps.
     * @see GroupSizes
     */
    Q_PROPERTY(GroupSizes *space MEMBER m_space CONSTANT FINAL)
    
    /**
     * The group of different standard icon sizes for consistency in the MauiKit apps.
     * @see GroupSizes
     * Values are the standard: 16, 22, 32 ,48, 64, 128 [pixels]
     */
    Q_PROPERTY(GroupSizes *iconSizes MEMBER m_iconSizes CONSTANT FINAL)
    
    /**
     * The standard units group. See the Units documentation for more information.
     */
    Q_PROPERTY(Units *units MEMBER m_units CONSTANT FINAL)

    /**
     * Sets the color to be used for highlighted, active, checked and such states of the UI elements.
     * By default this color is set to the global preferences via MauiMan.
     * This can be overridden by each application to a custom color. To reset it back to the system preference set the property to `undefined`.
     */
    Q_PROPERTY(QColor accentColor READ accentColor WRITE setAccentColor NOTIFY accentColorChanged FINAL RESET unsetAccentColor)

    /**
     * The source for picking up the application color palette when the style type is set to Style.Adaptive.
     * The source can be an image URL, and QQC2 Image, or a QQC2 Item, or even an icon name.
     * By default the source for this is set to the MauiMan wallpaper source preference.
     */
    Q_PROPERTY(QVariant adaptiveColorSchemeSource READ adaptiveColorSchemeSource WRITE setAdaptiveColorSchemeSource NOTIFY adaptiveColorSchemeSourceChanged RESET unsetAdaptiveColorSchemeSource)

    /**
     * The preferred style type for setting the color scheme of the application.
     * @see StyleType
     * By default this is set to the MauiMan global preference.
     * It can be overridden by the application, and to reset it - back to the original system preference - by setting this to `undefined`.
     */
    Q_PROPERTY(StyleType styleType READ styleType WRITE setStyleType NOTIFY styleTypeChanged RESET unsetStyeType)

    /**
     * Whether special effects are desired. This can be tweaked in the MauiMan system preferences in cases where the resources need to be preserved.
     * Consider using this property when using special effects in your applications.
     * @note This property is read-only. It can only be modified from the MauiMan global preferences.
     */
    Q_PROPERTY(bool enableEffects READ enableEffects NOTIFY enableEffectsChanged FINAL)

    /**
     * The current system icon theme picked up by the user.
     * @note This property is read-only. It can only be modified from the MauiMan global preferences.
     * @warning This only works when using the Maui Shell ecosystem. There is not support for Plasma or GNOME desktops.
     */
    Q_PROPERTY(QString currentIconTheme READ currentIconTheme NOTIFY currentIconThemeChanged)

    /**
     * Whether the menu entries should display the icon image.
     * @note This property is read-only. This is picked by from the QPA Qt Theme integration platform, so its default value will depend on the desktop shell being used.
     */
    Q_PROPERTY(bool menusHaveIcons READ menusHaveIcons CONSTANT FINAL)
    
    /**
     * The preferred scroll bars policy for displaying them or not.
     * @note This property is read-only. This is picked by from the QPA Qt Theme integration platform, so its default value will depend on the desktop shell being used.
     */
    Q_PROPERTY(uint scrollBarPolicy READ scrollBarPolicy NOTIFY scrollBarPolicyChanged FINAL)
    
    /**
     * Whether the user desires for the application to play sounds or not.
     * @note This property is read-only. It can only be modified from the MauiMan global preferences.
     */
    Q_PROPERTY(bool playSounds READ playSounds NOTIFY playSoundsChanged FINAL)

    /**
     * Whether the application window surface should be transparent and request the compositor to blur the background area of the window surface.
     * By default this is set to `false`.
     */
    Q_PROPERTY(bool translucencyAvailable READ translucencyAvailable NOTIFY translucencyAvailableChanged)

public:

    /**
     * @private
     */
    explicit Style(QObject *parent = nullptr);

    /**
     * @brief The different options for the color scheme style.
     */
    enum StyleType : uint
    {
        /**
         * A light variant designed for Maui.
         */
        Light = 0,
        
        /**
         * A dark variant designed for Maui.
         */
        Dark,
        
        /**
         * Picks the color scheme based on an source input, such as an image. The generated color palette determines if it is a dark or light scheme, and also its accent color.
         */
        Adaptive,
        
        /**
         * Picks the colors from the system palette, usually from Plasma color-scheme files.
         * @note Use this type when mixing MauiKit with Kirigami controls, so both frameworks pick up the color palette from the same source.
         */
        Auto,
        
        /**
         * A fully black color palette with a full white accent color. This is might be useful as a accessibility enhance or for performance on E-Ink and AMOLED displays.
         */
        TrueBlack,
        
        /**
         * A fully white color palette with a true black accent color. This is the inverted version of the TrueBlack type.
         */
        Inverted
    }; Q_ENUM(StyleType)

    /**
     * @brief The possible scrollbar values
     * The policy for showing the scroll bars. The possible values are:
     * - 0 Always visible
     * - 1 Visible when needed
     * - 2 Auto Hide
     * - 3 Always hidden
     */
    enum ScrollBarPolicy : uint
    {
                               AlwaysOn =0,
                               AsNeeded,
                               AutoHide,
                               AlwaysOff
}; Q_ENUM(ScrollBarPolicy)
    
    /**
     * @private
     */
    static Style *qmlAttachedProperties(QObject *object);

    /**
     * @private
     */
    static Style *instance();

    /**
     * @private
     */
    static QObject * qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine) {
        Q_UNUSED(engine);
        Q_UNUSED(scriptEngine);

        return Style::instance();
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
    
    bool menusHaveIcons() const;
    bool playSounds() const;
    uint scrollBarPolicy() const;

    bool translucencyAvailable() const;
    void setTranslucencyAvailable(const bool &value);

public Q_SLOTS:
    /**
     * @brief Given a `size` as argument this function will return the best fitted icon size from the standard icon sizes.
     * For example for the a size of 36, this function should return a size of 32.
     */
    int mapToIconSizes(const int &size);

private:
    
    QFont m_defaultFont;
    QFont m_h1Font = QFont {};
    QFont m_h2Font = QFont {};
    QFont m_monospacedFont = QFont {};
    
    GroupSizes *m_iconSizes;
    GroupSizes *m_space;
    GroupSizes *m_fontSizes;
    Units *m_units;

    int m_defaultFontSize;

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
    MauiMan::AccessibilityManager *m_accessibilitySettings;
    
    bool m_enableEffects = true;
    bool m_translucencyAvailable = false;

    QString m_currentIconTheme;
    
    void setFontSizes();
    void styleChanged();
    
protected:
    bool eventFilter(QObject *watched, QEvent *event) override;
    
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
    void scrollBarPolicyChanged(uint);
    void playSoundsChanged(bool);
    void translucencyAvailableChanged(bool translucencyAvailable);
};

QML_DECLARE_TYPEINFO(Style, QML_HAS_ATTACHED_PROPERTIES)

