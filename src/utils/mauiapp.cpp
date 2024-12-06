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
#include <QWindow>

#include <KLocalizedString>
#include <KCoreAddons>

#if defined BUNDLE_LUV_ICONS
#include <QIcon>
#endif

#include <QQuickStyle>

#include "../mauikit_version.h"
#include "moduleinfo.h"

Q_GLOBAL_STATIC(MauiApp, appInstance)

KAboutComponent MauiApp::aboutMauiKit()
{
    return KAboutComponent("MauiKit", i18n("Multi-adaptable user interfaces."), MauiApp::getMauikitVersion(), "https://mauikit.org", KAboutLicense::GPL_V3);
}

MauiApp::MauiApp(QObject *parent)
    : QObject(parent)
{
    qDebug() << "CREATING INSTANCE OF MAUI APP";

    KAboutData aboutData(KAboutData::applicationData());
    if (aboutData.translators().isEmpty())
    {
        aboutData.setTranslator(i18ndc(nullptr, "NAME OF TRANSLATORS", "Your names"), //
                                i18ndc(nullptr, "EMAIL OF TRANSLATORS", "Your emails"));

    }

    const auto MauiData = MauiKitCore::aboutData();
    aboutData.addComponent(MauiData.name(),
                           MauiKitCore::buildVersion(),
                           MauiData.version(),
                           MauiData.webAddress(),
                           MauiData.license().key());

    aboutData.addComponent("Qt", "", QT_VERSION_STR, "https://qt.io");

    aboutData.addComponent(QStringLiteral("KDE Frameworks"), "", KCoreAddons::versionString(), "https://kde.org");


#if defined BUNDLE_LUV_ICONS
    const auto luvData = MauiKitCore::aboutLuv();
    aboutData.addComponent(luvData.name(),
                           "",
                           luvData.version(),
                           luvData.webAddress(),
                           luvData.license().key());
#endif

    KAboutData::setApplicationData(aboutData);
    setDefaultMauiStyle();
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
    Q_EMIT this->iconNameChanged();
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
    Q_EMIT this->donationPageChanged();
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
    
    if (!qEnvironmentVariableIsSet("QT_QUICK_CONTROLS_STYLE"))
    {
        QQuickStyle::setStyle(QStringLiteral("org.mauikit.style"));
    }
}

MauiApp *MauiApp::qmlAttachedProperties(QObject *object)
{
    Q_UNUSED(object)
    return MauiApp::instance();
}

MauiApp *MauiApp::instance()
{
    return appInstance();
}

void MauiApp::setRootComponent(QObject *item)
{
    qDebug() << "Setting the MauiApp root component" << item;
    if(m_rootComponent == item)
        return;
    
    m_rootComponent = item;
    Q_EMIT rootComponentChanged();
}

QObject * MauiApp::rootComponent()
{
    return m_rootComponent;
}

void MauiApp::aboutDialog()
{
    if(!m_rootComponent)
        return;
    
    QMetaObject::invokeMethod(m_rootComponent, "about");
}
