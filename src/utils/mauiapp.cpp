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
#include "style.h"

#include <QDir>
#include <QStandardPaths>
#include <QQuickWindow>
#include <QQuickItem>
#include <QWindow>

#include <KLocalizedString>
#include <KCoreAddons>

#if defined BUNDLE_LUV_ICONS
#include <QIcon>
#endif

#include <QQuickStyle>

#include <MauiMan/thememanager.h>

#include "../mauikit_version.h"

MauiApp *MauiApp::m_instance = nullptr;

KAboutComponent MauiApp::aboutMauiKit()
{
    return KAboutComponent("MauiKit", i18n("Multi-adaptable user interfaces."), MauiApp::getMauikitVersion(), "https://mauikit.org", KAboutLicense::GPL_V3);
}


MauiApp::MauiApp()
    : QObject(nullptr)
    , m_controls(new CSDControls(this))
    ,m_themeSettings( new MauiMan::ThemeManager(this))

{
    qDebug() << "CREATING INSTANCE OF MAUI APP";
    connect(qApp, &QCoreApplication::aboutToQuit, []()
    {
        qDebug() << "Lets remove MauiApp singleton instance";
        delete m_instance;
        m_instance = nullptr;
    });
    
    KAboutData aboutData(KAboutData::applicationData());
    if (aboutData.translators().isEmpty())
    {
        aboutData.setTranslator(i18ndc(nullptr, "NAME OF TRANSLATORS", "Your names"), //
                                i18ndc(nullptr, "EMAIL OF TRANSLATORS", "Your emails"));

    }
    aboutData.addComponent("Qt", "", QT_VERSION_STR, "https://qt.io");

    aboutData.addComponent(i18n("KDE Frameworks"), "", KCoreAddons::versionString(), "https://kde.org");

    aboutData.addComponent(i18n("MauiKit Frameworks"), "", MauiApp::getMauikitVersion(), "https://mauikit.org", KAboutLicense::GPL_V3);

#if defined BUNDLE_LUV_ICONS
    aboutData.addComponent(i18n("Luv Icon Theme"), "", "", "https://github.com/Nitrux/luv-icon-theme", KAboutLicense::Artistic);

#endif

    KAboutData::setApplicationData(aboutData);

    setDefaultMauiStyle();
   if(MauiManUtils::isMauiSession())
   {
        QIcon::setThemeName(m_themeSettings->iconTheme());
   }
}

QString MauiApp::getMauikitVersion()
{
    return MAUIKIT_VERSION_STRING;
}

QString MauiApp::getIconName() const
{
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
    
    Q_INIT_RESOURCE(style);
    QQuickStyle::setStyle("maui-style");
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
  ,m_themeSettings( new MauiMan::ThemeManager(this))
{       
    connect(m_themeSettings, &MauiMan::ThemeManager::enableCSDChanged, [this](bool enabled)
    {
        qDebug() << "CSD ENABLED CHANGED<<<<" << enabled;
        
        getWindowControlsSettings();
    });
    
    connect(m_themeSettings, &MauiMan::ThemeManager::windowControlsThemeChanged, [this](QString style)
    {
        m_styleName = style;
        setStyle();
        
        Q_EMIT styleNameChanged();
        Q_EMIT sourceChanged();
    });
    
    getWindowControlsSettings();
}

void CSDControls::setStyle()
{
    auto confFile = QStandardPaths::locate (QStandardPaths::GenericDataLocation, QString("org.mauikit.controls/csd/%1/config.conf").arg(m_styleName));
    QFileInfo file(confFile);
    if(file.exists ())
    {
        const auto dir = QUrl::fromLocalFile (file.dir ().absolutePath ());
        
        QSettings conf (confFile, QSettings::IniFormat);
        conf.beginGroup ("Decoration");
        m_source = dir.toString()+"/"+ conf.value("Source").toString();
        conf.endGroup ();
    }
    
    qDebug() << "CSD QML SOURCXE" << m_source;
    m_rightWindowControls =  QStringList {"I", "A", "X"};
}

void CSDControls::getWindowControlsSettings()
{        
    if(m_enabledCSD_blocked)
        return;
    
    m_enableCSD = m_themeSettings->enableCSD();
    Q_EMIT enableCSDChanged();
    
    /*  #if (defined Q_OS_LINUX || defined Q_OS_FREEBSD) && !defined Q_OS_ANDROID

    #ifdef FORMFACTOR_FOUND
    
    if(m_formFactor->preferredMode() == 0)
    {
        m_enableCSD = m_themeSettings->enableCSD();
        Q_EMIT enableCSDChanged();
        
    }else
    {
        m_enableCSD = false;
        Q_EMIT enableCSDChanged();
        return;
    }
#else //Fallback in case FormFactor is not found. and then check for the env var QT_QUICK_CONTROLS_MOBILE
    if (qEnvironmentVariableIsSet("QT_QUICK_CONTROLS_MOBILE"))
    {
        if (QByteArrayList {"0", "false"}.contains(qgetenv("QT_QUICK_CONTROLS_MOBILE")))
        {
            m_enableCSD = m_themeSettings->enableCSD();
            Q_EMIT enableCSDChanged();
        }else
        {
            return;
        }
    }
    #endif  */
    
    m_styleName = m_themeSettings->windowControlsTheme();
    setStyle();
}

bool CSDControls::enableCSD() const
{
    return m_enableCSD;
}

void CSDControls::setEnableCSD(const bool &value)
{
    m_enabledCSD_blocked = true;
    if (m_enableCSD == value)
        return;
    
    m_enableCSD = value;
    Q_EMIT enableCSDChanged();
}

void CSDControls::resetEnableCSD()
{
    m_enabledCSD_blocked = false;
    getWindowControlsSettings();
}

QUrl CSDControls::source() const
{
    return m_source;
}

QString CSDControls::styleName() const
{
    return m_styleName;
}

CSDButton::CSDButton(QObject *parent): QObject(parent)
{
    connect(this, &CSDButton::typeChanged, this, &CSDButton::setSources);
    // connect(this, &CSDButton::styleChanged, this, &CSDButton::setSources);
    connect(this, &CSDButton::stateChanged, this, &CSDButton::requestCurrentSource);
    // connect(MauiApp::instance()->controls(), &CSDControls::styleNameChanged, this, &CSDButton::setSources);
    
    m_style = MauiApp::instance()->controls()->styleName();
    setSources();
}

void CSDButton::setStyle(const QString& style)
{
    if(m_style == style)
    {
        return;
    }
    
    m_style = style;
    Q_EMIT styleChanged();
}

QString CSDButton::style() const
{
    return m_style;
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

void CSDControls::applyRadius(QWindow *window, int radius)
{
    
    QRect r(QPoint(), window->geometry().size());
    QRect rb(0, 0, 2 * radius, 2 * radius);
    
    QRegion region(rb, QRegion::Ellipse);
    rb.moveRight(r.right());
    region += QRegion(rb, QRegion::Ellipse);
    rb.moveBottom(r.bottom());
    region += QRegion(rb, QRegion::Ellipse);
    rb.moveLeft(r.left());
    region += QRegion(rb, QRegion::Ellipse);
    region += QRegion(r.adjusted(radius, 0, -radius, 0), QRegion::Rectangle);
    region += QRegion(r.adjusted(0, radius, 0, -radius), QRegion::Rectangle);
    window->setMask(region);
}
