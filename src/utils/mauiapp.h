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

#ifndef MAUIAPP_H
#define MAUIAPP_H
#include <QObject>
#include <QQmlEngine>


#include "fmh.h"

#include "mauikit_export.h"

#include <QColor>
#include <QSettings>

#if defined Q_OS_LINUX && !defined Q_OS_ANDROID
#include <KAboutData>
#else
#include <KCoreAddons/KAboutData>
#endif

/**
 * @brief The MauiApp class
 * The MauiApp is a global instance and is declared to QML as an attached property, so it can be used widely by importing the org.kde.maui namespace
 * Example:
 * import org.mauikit.controls 1.2 as Maui
 *
 * Maui.ApplicationWindow
 * {
 *      title: Maui.App.name
 * }
 */

class QQuickWindow;
class QQuickItem;
class CSDButton : public QObject
{
  Q_OBJECT
  Q_PROPERTY(bool isHovered READ isHovered WRITE setIsHovered NOTIFY isHoveredChanged)
  Q_PROPERTY(bool isMaximized READ isMaximized WRITE setIsMaximized NOTIFY isMaximizedChanged)
  Q_PROPERTY(bool isPressed READ isPressed WRITE setIsPressed NOTIFY isPressedChanged)
  Q_PROPERTY(bool isFocused READ isFocused WRITE setIsFocused NOTIFY isFocusedChanged)
  Q_PROPERTY(CSDButtonType type READ type WRITE setType NOTIFY typeChanged)
  Q_PROPERTY(QUrl source READ source NOTIFY sourceChanged FINAL)
  
public:
  enum CSDButtonState
  {
    Normal,
    Hover,
    Pressed,
    Backdrop,
    Disabled
  }; Q_ENUM(CSDButtonState)

  enum CSDButtonType
  {
    Close,
        Minimize,
        Maximize,
        Restore,
        Fullscreen,
        None
  };Q_ENUM(CSDButtonType)

  typedef  QHash<CSDButtonState, QUrl> CSDButtonSources;

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

private:
  CSDButtonType m_type = CSDButtonType::None;
  QUrl m_source;
  QUrl m_dir;
  CSDButtonState m_state = CSDButtonState::Normal;

  CSDButtonSources m_sources; //the state and the source associated

  bool m_isHovered;

  bool m_isMaximized;

  bool m_isPressed;

  bool m_isFocused;

  QString mapButtonType(const CSDButtonType &type);
  QString mapButtonState(const CSDButtonState &type);
  QUrl extractStateValue(QSettings &settings, const CSDButton::CSDButtonState &state);
  void setSources();
  void requestCurrentSource();

  QString m_style;

signals:
  void stateChanged();
  void sourceChanged();
  void isHoveredChanged();
  void isMaximizedChanged();
  void isPressedChanged();
  void isFocusedChanged();
  void typeChanged();
};

class CSDControls : public QObject
{
  Q_OBJECT

  Q_PROPERTY(bool enableCSD READ enableCSD WRITE setEnableCSD NOTIFY enableCSDChanged)
  Q_PROPERTY(QUrl source READ source CONSTANT FINAL)
  Q_PROPERTY(int borderRadius READ borderRadius CONSTANT FINAL)
  Q_PROPERTY(QString styleName READ styleName CONSTANT FINAL)
  Q_PROPERTY(QStringList leftWindowControls MEMBER m_leftWindowControls NOTIFY leftWindowControlsChanged FINAL)
  Q_PROPERTY(QStringList rightWindowControls MEMBER m_rightWindowControls NOTIFY rightWindowControlsChanged FINAL)

public:
  typedef QHash<CSDButton::CSDButtonType, CSDButton*> CSDButtons;

  explicit CSDControls(QObject *parent =nullptr);

  /**
     * @brief enableCSD
     * If the apps supports CSD (client side decorations) the window controls are drawn within the app main header, following the system buttons order, and allows to drag to move windows and resizing.
     * @return
     * If the application has been marked manually to use CSD or if in the mauiproject.conf file the CSD field has been set
     */
  bool enableCSD() const;

  /**
     * @brief setEnableCSD
     * Manually enable CSD for this single application ignoreing the system wide mauiproject.conf CSD field value
     * @param value
     */
  void setEnableCSD(const bool &value);
  int borderRadius() const;
  QUrl source() const;
  QString styleName() const;

private:
  bool m_enableCSD = false;
  QUrl m_source;
  int m_borderRadius;
  QString m_styleName = "Nitrux";
  QStringList m_leftWindowControls;
  QStringList m_rightWindowControls;

  void getWindowControlsSettings();

signals:
  void leftWindowControlsChanged();
  void rightWindowControlsChanged();
  void enableCSDChanged();

};

class Notify;
class MAUIKIT_EXPORT MauiApp : public QObject
{
  Q_OBJECT
  Q_PROPERTY(KAboutData about READ getAbout CONSTANT FINAL)
  Q_PROPERTY(QString iconName READ getIconName WRITE setIconName NOTIFY iconNameChanged)
  Q_PROPERTY(QString donationPage READ getDonationPage WRITE setDonationPage NOTIFY donationPageChanged)
  Q_PROPERTY(CSDControls * controls READ controls CONSTANT FINAL)
  Q_PROPERTY(QString mauikitVersion READ getMauikitVersion CONSTANT FINAL)
//   Q_PROPERTY(QQuickWindow *window READ window WRITE setWindow NOTIFY windowChanged)
//   Q_PROPERTY(QQuickItem *windowPage READ windowPage WRITE setWindowPage NOTIFY windowPageChanged)
  
public:
  static MauiApp *qmlAttachedProperties(QObject *object);

  static MauiApp *instance()
  {
    if (m_instance)
      return m_instance;

    m_instance = new MauiApp;
    return m_instance;
  }

  MauiApp(const MauiApp &) = delete;
  MauiApp &operator=(const MauiApp &) = delete;
  MauiApp(MauiApp &&) = delete;
  MauiApp &operator=(MauiApp &&) = delete;

  /**
     * @brief getMauikitVersion
     * MauiKit string version
     * @return
     */
  static QString getMauikitVersion();

  /**
     * @brief getIconName
     * Application icon name as a URL to the image asset
     * @return
     */
  QString getIconName() const;

  /**
     * @brief setIconName
     * Set URL to the image asset to be set as the application icon
     * @param value
     */
  void setIconName(const QString &value);

  /**
     * @brief getDonationPage
     * Application donation web page link
     * @return
     */
  QString getDonationPage() const;

  /**
     * @brief setDonationPage
     * Set application web page link
     * @param value
     */
  void setDonationPage(const QString &value);

  /**
     * @brief getCredits
     * Returns a model of the credits represented as a QVariantList, some of the fields used are: name, email, year.
     * @return
     */
  KAboutData getAbout() const
  {
    return KAboutData::applicationData();
  }

  static void setDefaultMauiStyle();

  CSDControls *controls() const;
  
  QQuickWindow *window() const;  
  QQuickItem *windowPage() const;
  
private:
  static MauiApp *m_instance;
  MauiApp();
  CSDControls * m_controls;
  QString m_iconName;
  QString m_donationPage;
  
signals:
  void iconNameChanged();
  void donationPageChanged();
};

QML_DECLARE_TYPEINFO(MauiApp, QML_HAS_ATTACHED_PROPERTIES)

#endif // MAUIAPP_H
