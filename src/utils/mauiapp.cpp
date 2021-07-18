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

#include "mauiapp.h"
#include "fmh.h"
#include "handy.h"
#include "utils.h"
#include <QDir>

#include <QStandardPaths>

#if defined Q_OS_LINUX && !defined Q_OS_ANDROID
#include <KConfig>
#include <KConfigGroup>
#include <KSharedConfig>
#include <QFileSystemWatcher>
#endif

#if defined Q_OS_ANDROID || defined Q_OS_MACOS || defined Q_OS_WIN
#include <QIcon>
#include <QQuickStyle>
#endif

#include "../mauikit_version.h"

static const QUrl CONF_FILE = QStandardPaths::writableLocation(QStandardPaths::ConfigLocation) + "/kwinrc";

MauiApp *MauiApp::m_instance = nullptr;

MauiApp::MauiApp()
  : QObject(nullptr)
  , m_controls(new CSDControls(this))
{
  connect(qApp, &QCoreApplication::aboutToQuit, []()
  {
      qDebug() << "Lets remove MauiApp singleton instance";
      delete m_instance;
      m_instance = nullptr;
    });

#if defined Q_OS_ANDROID || defined Q_OS_MACOS || defined Q_OS_WIN
  setDefaultMauiStyle();
#endif

  //    qputenv("QT_QUICK_CONTROLS_CONF",  "://qtquickcontrols2.conf");
}

QString MauiApp::getMauikitVersion()
{
  return MAUIKIT_VERSION_STRING;
}

QString MauiApp::getIconName() const
{
  qDebug() << "REQUESTING ICONNAME" << m_iconName << this;
  return m_iconName;
}

void MauiApp::setIconName(const QString &value)
{
  if (m_iconName == value)
    return;

  m_iconName = value;
  emit this->iconNameChanged();
}

QString MauiApp::getDonationPage() const
{
  return m_donationPage;
}

void MauiApp::setDonationPage(const QString &value)
{
  if (m_donationPage == value)
    return;

  m_donationPage = value;
  emit this->donationPageChanged();
}

void MauiApp::setDefaultMauiStyle()
{
#if defined QICON_H && defined QQUICKSTYLE_H
    qDebug() << "trying to set icon theme" << "Luv"<< QFileInfo(":/icons/luv-icon-theme").exists() << QFileInfo(":/android_rcc_bundle/icons/luv-icon-theme").exists() <<  QFileInfo(":/android_rcc_bundle/qml/QtQuick/Controls.2/maui-style/icons/luv-icon-theme/Luv").exists();
  QIcon::setThemeSearchPaths({":/icons/luv-icon-theme"});
  QIcon::setThemeName("Luv");
  qDebug() << QIcon::themeSearchPaths() << QIcon::hasThemeIcon("sidebar-expand");
  QQuickStyle::setStyle("maui-style");
#endif
}

MauiApp *MauiApp::qmlAttachedProperties(QObject *object)
{
  Q_UNUSED(object)
  return MauiApp::instance();
}

void MauiApp::notify(const QString &icon, const QString &title, const QString &body, const QJSValue &callback, const int &timeout, const QString &buttonText)
{
  emit this->sendNotification(icon, title, body, callback, timeout, buttonText);
}

CSDControls::CSDControls(QObject *parent) : QObject (parent)
{
  this->setEnableCSD(UTIL::loadSettings("CSD", "GLOBAL", m_enableCSD, true).toBool());

#if defined Q_OS_LINUX && !defined Q_OS_ANDROID
  auto configWatcher = new QFileSystemWatcher({CONF_FILE.toLocalFile()}, this);
  connect(configWatcher, &QFileSystemWatcher::fileChanged, [this](QString) {
    this->getWindowControlsSettings();
  });
#endif

  this->getWindowControlsSettings();
}


void CSDControls::getWindowControlsSettings()
{
#if defined Q_OS_LINUX && !defined Q_OS_ANDROID

  auto kconf = KSharedConfig::openConfig("kwinrc");
  const auto group = kconf->group("org.kde.kdecoration2");

  if (group.hasKey("ButtonsOnLeft")) {
      m_leftWindowControls = group.readEntry("ButtonsOnLeft", "").split("", Qt::SkipEmptyParts);
      emit this->leftWindowControlsChanged();
    }

  if (group.hasKey("ButtonsOnRight")) {
      m_rightWindowControls = group.readEntry("ButtonsOnRight", "").split("", Qt::SkipEmptyParts);
      emit this->rightWindowControlsChanged();
    }

#elif defined Q_OS_MACOS || defined Q_OS_ANDROID
  m_leftWindowControls = QStringList {"X", "I", "A"};
  emit this->leftWindowControlsChanged();

#elif defined Q_OS_WIN32
  m_rightWindowControls = QStringList {"I", "A", "X"};
  emit this->rightWindowControlsChanged();
#endif
}

bool CSDControls::enableCSD() const
{
  return m_enableCSD;
}

void CSDControls::setEnableCSD(const bool &value)
{
#if defined Q_OS_ANDROID || defined Q_OS_IOS // ignore csd for those
  Q_UNUSED(value)
  return;
#else

  if (qEnvironmentVariableIsSet("QT_QUICK_CONTROLS_MOBILE"))
    {
      if (QByteArrayList {"1", "true"}.contains(qgetenv("QT_QUICK_CONTROLS_MOBILE")))
        {
          m_enableCSD = false;
          return;
        }
    }else
    {

      if (m_enableCSD == value)
        return;

      m_enableCSD = value;
    }

  emit enableCSDChanged();

  if (m_enableCSD) {
      getWindowControlsSettings();
    }
#endif
}

CSDButton::CSDButton(QObject *parent): QObject(parent)
{
  connect(this, &CSDButton::typeChanged, this, &CSDButton::setSources);
  connect(this, &CSDButton::stateChanged, this, &CSDButton::requestCurrentSource);
}

QUrl CSDButton::source() const
{
  return m_source;
}

void CSDButton::setSources()
{
  qDebug( )<< "Looking for CSD CONTROLS STYLE BUTTONS" << m_type;
  auto confFile = QStandardPaths::locate (QStandardPaths::GenericDataLocation, "org.mauikit.controls/csd/Nitrux/config.conf");
  qDebug( )<< "Looking for CSD CONTROLS STYLE BUTTONS" << confFile;
  QFileInfo file(confFile);
  if(file.exists ())
    {
      m_dir = QUrl::fromLocalFile (file.dir ().absolutePath ());
      QSettings conf (confFile, QSettings::IniFormat);
      m_sources.insert (CSDButtonState::Normal, extractStateValue (conf, CSDButtonState::Normal));
      m_sources.insert (CSDButtonState::Hover, extractStateValue (conf, CSDButtonState::Hover));
      m_sources.insert (CSDButtonState::Pressed, extractStateValue (conf, CSDButtonState::Pressed));
      m_sources.insert (CSDButtonState::Backdrop, extractStateValue (conf, CSDButtonState::Backdrop));
      m_sources.insert (CSDButtonState::Disabled, extractStateValue (conf, CSDButtonState::Disabled));
    }

  this->requestCurrentSource ();
}

CSDButton::CSDButtonState CSDButton::state() const
{
  return m_state;
}

QUrl CSDButton::extractStateValue(QSettings &settings, const CSDButton::CSDButtonState &state)
{
  QUrl res;

  settings.beginGroup (mapButtonType (m_type));
  res =  m_dir.toString ()+"/"+settings.value (mapButtonState (state)).toString ();
  settings.endGroup ();

  qDebug() << "CSD Buttons is" << m_type << mapButtonType (m_type) << mapButtonState (state) << settings.value (mapButtonState (state));

  if(QFile::exists (res.toLocalFile ()))
    {
      qDebug() << "CSD Buttons is" << res;
      return res;
    }else
    {
      return QUrl("dialog-close"); //put here a fallback button
    }
}

void CSDButton::requestCurrentSource()
{
  this->m_source = this->m_sources.value (this->m_state);
  emit this->sourceChanged ();
}

QString CSDButton::mapButtonType(const CSDButtonType &type)
{
  switch(type)
    {
    case Close: return "Close";
    case Maximize: return "Maximize";
    case Minimize: return "Minimize";
    case Restore: return "Restore";
    case Fullscreen: return "Fullscreen";
    default: return "";
    }
}

QString CSDButton::mapButtonState(const CSDButtonState &type)
{
  switch(type)
    {
    case Normal: return "Normal";
    case Hover: return "Hover";
    case Pressed: return "Pressed";
    case Backdrop: return "Backdrop";
    case Disabled: return "Disabled";
    default: return "";
    }
}

void CSDButton::setState(const CSDButtonState &newState)
{
  if (m_state == newState)
    return;
  m_state = newState;
  emit stateChanged();
}

CSDControls *MauiApp::controls() const
{
  return m_controls;
}

CSDButton::CSDButtonType CSDButton::type() const
{
  return m_type;
}

void CSDButton::setType(CSDButtonType newType)
{
  if (m_type == newType)
    return;

  m_type = newType;
  emit typeChanged();
}

bool CSDButton::isHovered() const
{
  return m_isHovered;
}

void CSDButton::setIsHovered(bool newIsHovered)
{
  if (m_isHovered == newIsHovered)
    return;
  m_isHovered = newIsHovered;
  if(m_isHovered)
    {
      this->setState (CSDButtonState::Hover);
    }else
    {
      this->setState (CSDButtonState::Normal);
    }
  emit isHoveredChanged();
}

bool CSDButton::isMaximized() const
{
  return m_isMaximized;
}

void CSDButton::setIsMaximized(bool newIsMaximized)
{
  if (m_isMaximized == newIsMaximized)
    return;
  m_isMaximized = newIsMaximized;
  if(m_type == CSDButtonType::Maximize && m_isMaximized)
    {
      this->setType (CSDButtonType::Restore);
    }else if(m_type == CSDButtonType::Restore && !m_isMaximized)
    {
      this->setType (CSDButtonType::Maximize);
    }
  emit isMaximizedChanged();
}

bool CSDButton::isPressed() const
{
  return m_isPressed;
}

void CSDButton::setIsPressed(bool newIsPressed)
{
  if (m_isPressed == newIsPressed)
    return;
  m_isPressed = newIsPressed;
  if(m_isPressed)
    {
      this->setState (CSDButtonState::Pressed);
    }else
    {
      this->setState (CSDButtonState::Normal);
    }
  emit isPressedChanged();
}

bool CSDButton::isFocused() const
{
  return m_isFocused;
}

void CSDButton::setIsFocused(bool newIsFocused)
{
  if (m_isFocused == newIsFocused)
    return;
  m_isFocused = newIsFocused;

  if(m_isFocused)
    {
      this->setState (CSDButtonState::Normal);
    }
  else
    {
      this->setState (CSDButtonState::Backdrop);
    }
  emit isFocusedChanged();
}
