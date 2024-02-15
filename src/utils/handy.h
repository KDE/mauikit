/*
 *   Copyright 2018 Camilo Higuita <milo.h@aol.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

#pragma once
#include <QObject>
#include <QQmlEngine>

#include <QVariantMap>

namespace MauiMan
{
    class FormFactorManager;
    class AccessibilityManager;
}

/**
 * @brief The Handy class.
 * 
 * Contains useful static methods to be used in the MauiKit application.
 * 
 * @note This class is exposed as the singleton type `Handy` to the QML engine.
 * 
 */
class Handy : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
    Q_DISABLE_COPY(Handy)
    
    /**
     * Whether the host platform is set as mobile. Either by the `QT_QUICK_CONTROLS_MOBILE` environment variable on, or from the MauiMan form factor mode to mobile.
     */
    Q_PROPERTY(bool isMobile READ isMobile NOTIFY isMobileChanged)
    
    /**
     * Whether the target device has a touch screen
     */
    Q_PROPERTY(bool isTouch READ isTouch NOTIFY isTouchChanged)
    
    /**
     * Whether the target device has a physical mouse attached
     */
    Q_PROPERTY(bool hasMouse READ hasMouse NOTIFY hasMouseChanged)
    
    /**
     * Whether the target device has a physical keyboard attached
     */
    Q_PROPERTY(bool hasKeyboard READ hasKeyboard NOTIFY hasKeyboardChanged)
    
    /**
     * Whether the current press input has been received from a touch screen
     */
    Q_PROPERTY(bool hasTransientTouchInput READ hasTransientTouchInput NOTIFY hasTransientTouchInputChanged)
        
    /**
     * Whether the host platform is an Android device
     */
    Q_PROPERTY(bool isAndroid READ isAndroid CONSTANT FINAL)
    
    /**
     * Whether the host platform is a GNU/Linux distribution
     */
    Q_PROPERTY(bool isLinux READ isLinux CONSTANT FINAL)
    
    /**
     * Whether the host platform is running Windows OS
     */
    Q_PROPERTY(bool isWindows READ isWindows CONSTANT FINAL)
    
    /**
     * Whether the host platform is running MacOS
     */
    Q_PROPERTY(bool isMac READ isMac CONSTANT FINAL)
    
    /**
     * Whether the host platform is running IOS
     */
    Q_PROPERTY(bool isIOS READ isIOS CONSTANT FINAL)

    /**
     * Whether the system preference is to open/trigger items with a single click
     * @note This preference is taken from MauiMan global preference. 
     */
    Q_PROPERTY(bool singleClick MEMBER m_singleClick NOTIFY singleClickChanged)
    
    /**
     * The current preferred from factor the user has selected.
     * @note This preference can be set using MauiMan, and it is exposed to the end user via the Maui Settings.
     * 
     * This property allows the user to manually pick between a mobile, tablet or desktop mode.  This can be consumed by the applications to position elements in a fitting manner.
     */
    Q_PROPERTY(FFactor formFactor READ formFactor NOTIFY formFactorChanged)

public:
        Handy(QObject *parent = nullptr);    

    /**
     * @brief The different form factor options.
     */
    enum FFactor
    {
        /**
         * Desktop form factor assumes there is a physical mouse and keyboard, and the screen area is wide and spacious.
         */
        Desktop = 0,
        
        /**
         * Tablet form factor assumes a hand held device with touch screen, maybe there is a physical keyboard attached. The screen area is spacious enough still, not as wide as a desktop or as narrow as a mobile phone.
         */
        Tablet,
        
        /**
         * Mobile form factor mode assumes a phone is the target device. A small touch screen and not mouse or keyboard attached.
         */
        Phone
    }; Q_ENUM(FFactor)
    
    /**
     * @private
     */
    static Handy *qmlAttachedProperties(QObject *object);
    
    /**
     * @private
     */
    static Handy *instance();

    /**
     * @private
     */
    static QObject * qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine) {
        Q_UNUSED(engine);
        Q_UNUSED(scriptEngine);

        return Handy::instance();
    }
    
    void setTransientTouchInput(bool touch);
    bool hasTransientTouchInput() const;    
    
protected:
    
    /**
     * @private
     */
    bool eventFilter(QObject *watched, QEvent *event) override;
    
private:    

    MauiMan::FormFactorManager *m_formFactor;
    MauiMan::AccessibilityManager *m_accessibility;
    
    FFactor m_ffactor = FFactor::Desktop;
    bool m_isTouch = false;
    bool m_singleClick = true;
    bool m_mobile = 1;
    bool m_hasTransientTouchInput = 1;

public Q_SLOTS:
    
    /**
     * @brief Returns the major version of the current OS
     *
     * This function is static.
     * @return Major OS version number
     */
    static int version();

    /**
     * @brief Returns a key-value map containing basic information about the current user
     *
     * The pairs keys for the information returned are:
     * - name
     * 
     * @return with user info map
     */
    static QVariantMap userInfo();

    /**
     * @brief Returns the text contained in the clipboard
     * @return text string
     */
    static QString getClipboardText();
    
    /**
     * @brief Retrieves the data in the clipboard into a key-value map.
     * The possible keys available are [only if there is any metadata]:
     * - text
     * - urls
     * - image
     * - cut
     * 
     * @note This can invoked from QML and the data extracted as `Handy.getClipboard().text` for example.
     */
    static QVariantMap getClipboard();

    /**
     * @brief Copies a text string to the clipboard
     * @param text text to be copied to the clipboard
     * @return whether the operation was successful
     */
    static bool copyTextToClipboard(const QString &text);

    /**
     * @brief Adds a key-value map to the clipboard.
     * Possible keys can be:
     * - text
     * - urls
     * - image
     * 
     * There can be more than one.
     * @param value the data
     * @param cut whether to add the metadata information necessary for it to be read as a cut operation by third party.
     * @return whether the operation was successful
     */
    static bool copyToClipboard(const QVariantMap &value, const bool &cut = false);

    bool hasKeyboard();
    
    bool hasMouse();

    static bool isAndroid();

    static bool isWindows();

    static bool isMac();

    static bool isLinux();

    static bool isIOS();

    bool isMobile() const;   
    
    bool isTouch();
    
    FFactor formFactor();
    
    /**
     * @brief Format a size value to the a readable locale size format.
     * @param size the size value in bits
     * @return Formatted into a readable string using the preferred locale settings.
     */
    static QString formatSize(quint64 size);
    
    /**
     * @brief Format a milliseconds value to a readable format
     * @param value milliseconds
     * @return readable formatted value
     */
    static QString formatTime(const qint64 &value);
    
    /**
     * @brief Given a date string, its original format and an intended format, return a readable string
     * @param dateStr date string
     * @param format Intended format, by default `"dd/MM/yyyy"`
     * @param initFormat the original date format. This is optional and by default it will try to be auto determined.
     * @return
     */
    static QString formatDate(const QString &dateStr, const QString &format = QString("dd/MM/yyyy"), const QString &initFormat = QString());   
    
Q_SIGNALS:
    
    void singleClickChanged();
    void hasKeyboardChanged();
    void hasMouseChanged();
    void isMobileChanged();
    void hasTransientTouchInputChanged();
    void formFactorChanged();
    void isTouchChanged();
};

