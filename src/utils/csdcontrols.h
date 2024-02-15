#pragma once

#include <QObject>
#include <QSettings>
#include <QQmlEngine>

namespace MauiMan
{
  class ThemeManager;
}

/**
 * @brief An abstraction for a client-side-decoration button.
 * 
 * This class is exposed as the type `CSDButton` to the QML engine, and it is used for creating the CSD window control themes.
 * 
 * CSDButton represents a button and its states. By reading the theme configuration, this class changes the images used as its state changes. The states need to be set manually.
 */
class CSDButton : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_DISABLE_COPY(CSDButton)
    
    /**
     * Whether the button is currently being hovered.
     * Uses the `Hover` config entry to read the image file asset.
     */
    Q_PROPERTY(bool isHovered READ isHovered WRITE setIsHovered NOTIFY isHoveredChanged)
    
    /**
     * Whether the window is currently maximized.
     * Uses the `Restore` config section to read the image file assets.
     */
    Q_PROPERTY(bool isMaximized READ isMaximized WRITE setIsMaximized NOTIFY isMaximizedChanged)
    
    /**
     * Whether the button is currently being pressed.
     * Uses the `Pressed` config entry to read the image file asset.
     */
    Q_PROPERTY(bool isPressed READ isPressed WRITE setIsPressed NOTIFY isPressedChanged)
    
    /**
     * Whether the window is currently focused.
     * Uses the `Normal` config entry to read the image file asset, if focused, other wise, the `Backdrop` entry.
     */
    Q_PROPERTY(bool isFocused READ isFocused WRITE setIsFocused NOTIFY isFocusedChanged)
    
    /**
     * The button type.
     * @see CSDButtonType
     */
    Q_PROPERTY(CSDButtonType type READ type WRITE setType NOTIFY typeChanged)
    
    /**
     * The source file path of the theme being used.
     */
    Q_PROPERTY(QUrl source READ source NOTIFY sourceChanged FINAL)
    
    /**
     * The style to be used for picking up the image assets and config.
     * By default this will be set to the current preferred window controls style preference from MauiMan.
     * However, this can be overridden to another existing style. 
     */
    Q_PROPERTY(QString style READ style WRITE setStyle NOTIFY styleChanged)
    
public:
    
    /**
     * @brief The states of a window control button.
     */
    enum CSDButtonState
    {
        /**
         * The window surface is focused
         */
        Normal,
        
        /**
         * The button is being hovered but has not been activated
         */
        Hover,
        
        /**
         * The button is being pressed and has not been released
         */
        Pressed,
        
        /**
         * The window surface is in not focused
         */
        Backdrop,
        
        /**
         * The window or the button are not enabled
         */
        Disabled
    }; Q_ENUM(CSDButtonState)
    
    /**
     * @brief The possible types of supported window control buttons
     */
    enum CSDButtonType
    {
        /**
         * Closes the window surface
         */
        Close,
        
        /**
         * Minimizes/hides the window surface
         */
        Minimize,
        
        /**
         * Maximizes the window surface
         */
        Maximize,
        
        /**
         * Restores the window surface to the previous geometry it had before being maximized
         */
        Restore,
        
        /**
         * Makes the window surface occupy the whole screen area
         */
        Fullscreen,
        
        /**
         * No button
         */
        None
    };Q_ENUM(CSDButtonType)
        
    explicit CSDButton(QObject *parent =nullptr);
    
    CSDButtonState state() const;
    void setState(const CSDButtonState &state);
    QUrl source() const;
    
    bool isHovered() const;
    void setIsHovered(bool newIsHovered);
    
    bool isMaximized() const;
    void setIsMaximized(bool newIsMaximized);
    
    bool isPressed() const;
    void setIsPressed(bool newIsPressed);
    
    bool isFocused() const;
    void setIsFocused(bool newIsFocused);
    
    CSDButton::CSDButtonType type() const;
    void setType(CSDButton::CSDButtonType newType);
    
    QString style() const;
    void setStyle(const QString &style);
    
public Q_SLOTS:
    
    /**
     * @brief Maps a based string value convention representing a button type to a CSDButton::CSDButtonType
     * 
     * Usually each window control button is represented as a single letter, and the order of the window control buttons are an array of those string values. 
     * 
     * An example would be the following array `{"I", "A", "X"}`, which represents the following order: minimize, maximize, close
     * 
     */
    CSDButton::CSDButtonType mapType(const QString &value);
    
private:
    typedef QHash<CSDButtonState, QUrl> CSDButtonSources;

    CSDButtonType m_type = CSDButtonType::None;
    QUrl m_source;
    QUrl m_dir;
    CSDButtonState m_state = CSDButtonState::Normal;
    
    CSDButtonSources m_sources; //the state and the source associated
    QString m_style;
    
    bool m_isHovered;
    
    bool m_isMaximized;
    
    bool m_isPressed;
    
    bool m_isFocused;
    
    QString mapButtonType(const CSDButtonType &type);
    QString mapButtonState(const CSDButtonState &type);
    QUrl extractStateValue(QSettings &settings, const CSDButton::CSDButtonState &state);
    void setSources();
    void requestCurrentSource();
    
Q_SIGNALS:
    void stateChanged();
    void sourceChanged();
    void isHoveredChanged();
    void isMaximizedChanged();
    void isPressedChanged();
    void isFocusedChanged();
    void typeChanged();
    void styleChanged();
};

/**
 * @brief The client-side-decorations manager for the MauiKit application.
 */
class CSDControls : public QObject
{
    Q_OBJECT
    // QML_SINGLETON
    QML_NAMED_ELEMENT(CSD)
    QML_ATTACHED(CSDControls)
    QML_UNCREATABLE("Cannot be created CSDControls")
    Q_DISABLE_COPY(CSDControls)
    
    /**
     * Whether the application shall use CSD (client side decorations).
     * 
     * @note This property by default uses the MauiMan global preference, but can it be overridden. To reset it back to the original system preference value set it to `undefined`.
     */
    Q_PROPERTY(bool enabled READ enableCSD WRITE setEnableCSD RESET resetEnableCSD NOTIFY enableCSDChanged)
    
    /**
     * The source file path of the style being used.
     */
    Q_PROPERTY(QUrl source READ source NOTIFY sourceChanged FINAL)
    
    /**
     * The name of the style/theme being used.
     * This is picked up from the global MauiMan preferences and can not be overridden by the application.
     * This preference is exposed to the end user in the Maui Settings.
     */
    Q_PROPERTY(QString styleName READ styleName NOTIFY styleNameChanged FINAL)
    
    /**
     * The model of the window control buttons to be shown, and the order in which they should appear in the right side.
     * Although the WindowControlsLinux type can be placed arbitrary, it is strongly suggested to always placed them in a right-side area
     */
    Q_PROPERTY(QStringList rightWindowControls MEMBER m_rightWindowControls FINAL CONSTANT)
    
public:    
    explicit CSDControls(QObject *parent =nullptr);
    
    bool enableCSD() const;
    
    void setEnableCSD(const bool &value);
    void resetEnableCSD();
    
    QUrl source() const;
    QString styleName() const;
    
    /**
     * @private
     */
    static CSDControls *qmlAttachedProperties(QObject *object);
    
     /**
     * @brief Retrieves the single instance of MauiApp. 
     */
    static CSDControls *instance();
    
    QObject * qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine) {
    Q_UNUSED(engine);
    Q_UNUSED(scriptEngine);
    // C++ and QML instance they are the same instance
    return CSDControls::instance();
    }
    
private:
    typedef QHash<CSDButton::CSDButtonType, CSDButton*> CSDButtons;

    MauiMan::ThemeManager *m_themeSettings;
    
    bool m_enableCSD = false;
    bool m_enabledCSD_blocked = false;
    
    QUrl m_source;
    QString m_styleName = QStringLiteral("Nitrux");
    QStringList m_rightWindowControls;
    
    void getWindowControlsSettings();
    void setStyle();
    
Q_SIGNALS:
    void enableCSDChanged();
    void styleNameChanged();
    void sourceChanged();
};

QML_DECLARE_TYPEINFO(CSDControls, QML_HAS_ATTACHED_PROPERTIES)

