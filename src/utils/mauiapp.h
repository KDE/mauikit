/*
 * <one line to give the program's name and a brief idea of what it does.>
 * Copyright (C) 2019  camilo <chiguitar@unal.edu.co>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#pragma once

#include <QObject>
#include <QQmlEngine>

#include "mauikit_export.h"

#include <QSettings>

#include <KAboutData>

class QQuickWindow;
class QQuickItem;
class QWindow;

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
    QML_ANONYMOUS
    Q_DISABLE_COPY(CSDControls)
    
    /**
     * Whether the application shall use CSD (client side decorations).
     * 
     * @note This property by default uses the MauiMan global preference, but can it be overridden. To reset it back to the original system preference value set it to `undefined`.
     */
    Q_PROPERTY(bool enableCSD READ enableCSD WRITE setEnableCSD RESET resetEnableCSD NOTIFY enableCSDChanged)
    
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

class Notify;
class KAboutComponent;


/**
 * @brief The MauiApp class
 * The MauiApp is a global singleton instance, can be accessed from QML as an attached property, so it can be used by importing `org.mauikit.controls`
 *
 * @warning It is needed that the first instance creation is made on the application main entry point before the QML engine creates the window surface, so the style and other parts are correctly loaded.
 * 
 * Example:
 * @code
 * import org.mauikit.controls as Maui
 *
 * Maui.ApplicationWindow
 * {
 *      title: Maui.App.about.name
 *      Maui.App.controls.enableCSD: true
 * }
 * @endcode
 */
class MAUIKIT_EXPORT MauiApp : public QObject
{
    Q_OBJECT
    QML_NAMED_ELEMENT(App)
    QML_ATTACHED(MauiApp)
    QML_UNCREATABLE("Cannot be created MauiApp")
    Q_DISABLE_COPY(MauiApp)
    
    /**
     * The information metadata about the application.
     * See the KAboutData documentation for more details.
     * @note This is the information parsed for feeding the ApplicationWindow's about dialog.
     */
    Q_PROPERTY(KAboutData about READ getAbout CONSTANT FINAL)
    
    /**
     * The URL to the image asset for the application icon.
     */
    Q_PROPERTY(QString iconName READ getIconName WRITE setIconName NOTIFY iconNameChanged)
    
    /**
     * An URL link to the application donation page.
     */
    Q_PROPERTY(QString donationPage READ getDonationPage WRITE setDonationPage NOTIFY donationPageChanged)
    
    /**
     * The client-side-decorations manager.
     * @see CSDControls
     */
    Q_PROPERTY(CSDControls * controls READ controls CONSTANT FINAL)
    
    /**
     * The formatted MauiKit string version.
     */
    Q_PROPERTY(QString mauikitVersion READ getMauikitVersion CONSTANT FINAL)
    
public:
    /**
     * @brief Retrieves information of the MauiKit framework wrapped into a KAboutComponent object.
     */
    static KAboutComponent aboutMauiKit();
    
    /**
     * @private
     */
    static MauiApp *qmlAttachedProperties(QObject *object);
    
    /**
     * @brief Retrieves the single instance of MauiApp. 
     */
    static MauiApp *instance()
    {
        if (m_instance)
            return m_instance;
        
        m_instance = new MauiApp;
        return m_instance;
    }
    
    /**
     * @brief The formatted MauiKit version string
     */
    static QString getMauikitVersion();
    
    /**
     * @brief The file URL to the application icon
     */
    QString getIconName() const;
    
    /**
     * @brief Set the file URL to the application icon.
     * Usually it is a self contained URL
     */
    void setIconName(const QString &value);
    
    /**
     * @brief Donation web page link
     * @return URL link
     */
    QString getDonationPage() const;
    
    /**
     * @brief Set the donation web page link
     * @param value the URL link
     */
    void setDonationPage(const QString &value);

    /**
     * @brief Gather information about this module.
     * @return
     */
    KAboutData getAbout() const;
    
    CSDControls *controls() const;
    
private:
    static MauiApp *m_instance;
    MauiMan::ThemeManager *m_themeSettings;
    
    MauiApp();
    CSDControls * m_controls;
    QString m_iconName;
    QString m_donationPage;
    
    static void setDefaultMauiStyle();
    
Q_SIGNALS:
    void iconNameChanged();
    void donationPageChanged();
    void currentIconThemeChanged(QString currentIconTheme);
};

QML_DECLARE_TYPEINFO(MauiApp, QML_HAS_ATTACHED_PROPERTIES)

