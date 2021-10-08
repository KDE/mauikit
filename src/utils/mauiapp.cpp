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
#include <QQuickWindow>
#include <QQuickItem>

#if defined Q_OS_LINUX && !defined Q_OS_ANDROID
#include <KConfig>
#include <KConfigGroup>
#include <KSharedConfig>
#include <QFileSystemWatcher>
#endif

#if defined BUNDLE_LUV_ICONS
#include <QIcon>
#endif

#if defined BUNDLE_MAUI_STYLE
#include <QQuickStyle>
#endif

#include "../mauikit_version.h"

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
    
    setDefaultMauiStyle();
   
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

KAboutData MauiApp::getAbout() const
{
    return KAboutData::applicationData();
}

void MauiApp::setDefaultMauiStyle()
{
    #if defined BUNDLE_LUV_ICONS
    Q_INIT_RESOURCE(icons);
    QIcon::setThemeSearchPaths({":/icons/luv-icon-theme"});
    QIcon::setThemeName("Luv");
    #endif
    
#if defined BUNDLE_MAUI_STYLE
        Q_INIT_RESOURCE(style);
        QQuickStyle::setStyle("maui-style");
        qDebug() << QQuickStyle::name();
#endif
}

QQuickWindow * MauiApp::window() const
{
    return nullptr; //for now until figure out how ot get root window
}

QQuickItem * MauiApp::windowPage() const
{
    return nullptr;
}

bool MauiApp::translucencyAvailable() const
{
    return m_translucencyAvailable;
}

void MauiApp::setTranslucencyAvailable(const bool &value)
{
    if(value == m_translucencyAvailable)
    {
        return;
    }

    m_translucencyAvailable = value;
    emit this->translucencyAvailableChanged(m_translucencyAvailable);
}

MauiApp *MauiApp::qmlAttachedProperties(QObject *object)
{
    Q_UNUSED(object)
    return MauiApp::instance();
}

CSDControls::CSDControls(QObject *parent) : QObject (parent)
{
    this->setEnableCSD(UTIL::loadSettings("CSD", "GLOBAL", m_enableCSD, true).toBool());
}

void CSDControls::getWindowControlsSettings()
{    
    #if defined Q_OS_LINUX && !defined Q_OS_ANDROID
    
    m_styleName = UTIL::loadSettings("CSDStyle", "GLOBAL", "Nitrux", true).toString();
    auto confFile = QStandardPaths::locate (QStandardPaths::GenericDataLocation, QString("org.mauikit.controls/csd/%1/config.conf").arg(m_styleName));
    QFileInfo file(confFile);
    if(file.exists ())
    {
        const auto dir = QUrl::fromLocalFile (file.dir ().absolutePath ());
        
        QSettings conf (confFile, QSettings::IniFormat);
        conf.beginGroup ("Decoration");
        m_source = dir.toString()+"/"+ conf.value("Source").toString();
        m_borderRadius = conf.value ("BorderRadius", 8).toInt();
        conf.endGroup ();        
    }    
    
    qDebug() << "CSD QML SOURCXE" << m_source;
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
    //   m_rightWindowControls = QStringList {"I", "A", "X"};
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

QUrl CSDControls::source() const
{
    return m_source;
}

QString CSDControls::styleName() const
{
    return m_styleName;
}

int CSDControls::borderRadius() const
{
    return m_borderRadius;
}

CSDButton::CSDButton(QObject *parent): QObject(parent)
{
    connect(this, &CSDButton::typeChanged, this, &CSDButton::setSources);
    connect(this, &CSDButton::stateChanged, this, &CSDButton::requestCurrentSource);
    m_style = MauiApp::instance()->controls()->styleName();  
}

QUrl CSDButton::source() const
{
    return m_source;
}

void CSDButton::setSources()
{
    const auto confFile = QStandardPaths::locate (QStandardPaths::GenericDataLocation, QString("org.mauikit.controls/csd/%1/config.conf").arg(m_style));

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
       
    if(QFile::exists (res.toLocalFile ()))
    {
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

CSDButton::CSDButtonType CSDButton::mapType(const QString &value)
{
    if(value == "X") return  CSDButton::CSDButtonType::Close;
    if(value == "I")  return CSDButton::CSDButtonType::Minimize;
    if(value == "A")  return  CSDButton::CSDButtonType::Maximize;
    
    return CSDButtonType::None;
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
