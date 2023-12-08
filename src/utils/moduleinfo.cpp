#include "moduleinfo.h"
#include "../mauikit_version.h"

QString MauiKitCore::versionString()
{
    return QStringLiteral(MAUIKIT_VERSION_STRING);
}

QString MauiKitCore::buildVersion()
{
    return GIT_BRANCH+QStringLiteral("/")+GIT_COMMIT_HASH;
}

KAboutComponent MauiKitCore::aboutData()
{
    return KAboutComponent(QStringLiteral("MauiKit Core"),
                         QStringLiteral("Maui convergent controls."),
                         QStringLiteral(MAUIKIT_VERSION_STRING),
                         QStringLiteral("http://mauikit.org"),
                         KAboutLicense::LicenseKey::LGPL_V3);
}

KAboutComponent MauiKitCore::aboutLuv()
{
    return KAboutComponent(QStringLiteral("Lüv Icon Theme"),
                         QStringLiteral("Lüv is the spiritual successor to Flattr, a flat but complex icon theme for freedesktop environments."),
                         QStringLiteral("1.0"),
                         QStringLiteral("https://github.com/Nitrux/luv-icon-theme"),
                         KAboutLicense::LicenseKey::Artistic);
}
