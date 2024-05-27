#include "csdcontrols.h"

#include <QUrl>
#include <QFile>
#include <QFileInfo>
#include <QDir>
#include <QStandardPaths>

#include <MauiMan4/thememanager.h>

Q_GLOBAL_STATIC(CSDControls, csdInstance)

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

static const QString CSDLookupPath = "org.mauikit.controls/csd.6/%1/config.conf";

void CSDControls::setStyle()
{
    auto confFile = QStandardPaths::locate (QStandardPaths::GenericDataLocation, QString(CSDLookupPath).arg(m_styleName));
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
    
    m_style = CSDControls::instance()->styleName();
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
    const auto confFile = QStandardPaths::locate (QStandardPaths::GenericDataLocation, QString(CSDLookupPath).arg(m_style));

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
    m_source = this->m_sources.value (this->m_state);
    Q_EMIT this->sourceChanged ();
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
    Q_EMIT stateChanged();
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
    Q_EMIT typeChanged();
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
        this->setState (m_isFocused ? CSDButtonState::Normal : CSDButtonState::Backdrop);
    }
    Q_EMIT isHoveredChanged();
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
    Q_EMIT isMaximizedChanged();
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
    Q_EMIT isPressedChanged();
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
    Q_EMIT isFocusedChanged();
}

CSDControls *CSDControls::qmlAttachedProperties(QObject *object)
{
    Q_UNUSED(object)
    return CSDControls::instance();
}

CSDControls *CSDControls::instance()
{
    return csdInstance();
}
