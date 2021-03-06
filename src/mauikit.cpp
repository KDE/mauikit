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

#include "mauikit.h"

#include <QDebug>

#include "appsettings.h"

#include "appview.h"
#include "tabview.h"

#include "handy.h"
#include "mauiapp.h"
#include "mauilist.h"
#include "mauimodel.h"

#ifdef Q_OS_ANDROID
#include "platforms/android/mauiandroid.h"
#elif defined Q_OS_LINUX
#include "platforms/linux/mauilinux.h"
#endif

#include "platform.h"

#include <KI18n/KLocalizedContext>
#include <KI18n/KLocalizedString>

#include <QQmlContext>

QUrl MauiKit::componentUrl(const QString &fileName) const
{
    return QUrl(resolveFileUrl(fileName));
}

void MauiKit::initializeEngine(QQmlEngine *engine, const char *uri)
{
    Q_UNUSED(uri);
    this->initResources();

    KLocalizedString::setApplicationDomain("mauikit");
    engine->rootContext()->setContextObject(new KLocalizedContext(engine));
}

void MauiKit::registerTypes(const char *uri)
{
//     Q_ASSERT(uri == QLatin1String(MAUIKIT_URI));

    qmlRegisterSingletonType(componentUrl(QStringLiteral("Style.qml")), uri, 1, 0, "Style");
    qmlRegisterType(componentUrl(QStringLiteral("ToolBar.qml")), uri, 1, 0, "ToolBar");
    qmlRegisterType(componentUrl(QStringLiteral("ApplicationWindow.qml")), uri, 1, 0, "ApplicationWindow");
    qmlRegisterType(componentUrl(QStringLiteral("Page.qml")), uri, 1, 0, "Page");
    qmlRegisterType(componentUrl(QStringLiteral("ShareDialog.qml")), uri, 1, 0, "ShareDialog");
    qmlRegisterType(componentUrl(QStringLiteral("PieButton.qml")), uri, 1, 0, "PieButton");
    qmlRegisterType(componentUrl(QStringLiteral("SideBar.qml")), uri, 1, 0, "SideBar");
    qmlRegisterType(componentUrl(QStringLiteral("AbstractSideBar.qml")), uri, 1, 0, "AbstractSideBar");
    qmlRegisterType(componentUrl(QStringLiteral("Holder.qml")), uri, 1, 0, "Holder");
    qmlRegisterType(componentUrl(QStringLiteral("GlobalDrawer.qml")), uri, 1, 0, "GlobalDrawer");
    qmlRegisterType(componentUrl(QStringLiteral("ListDelegate.qml")), uri, 1, 0, "ListDelegate");
    qmlRegisterType(componentUrl(QStringLiteral("ListBrowserDelegate.qml")), uri, 1, 0, "ListBrowserDelegate");
    qmlRegisterType(componentUrl(QStringLiteral("SwipeItemDelegate.qml")), uri, 1, 0, "SwipeItemDelegate");
    qmlRegisterType(componentUrl(QStringLiteral("SwipeBrowserDelegate.qml")), uri, 1, 0, "SwipeBrowserDelegate");
    qmlRegisterType(componentUrl(QStringLiteral("ItemDelegate.qml")), uri, 1, 0, "ItemDelegate");
    qmlRegisterType(componentUrl(QStringLiteral("GridBrowserDelegate.qml")), uri, 1, 0, "GridBrowserDelegate");
    qmlRegisterType(componentUrl(QStringLiteral("SelectionBar.qml")), uri, 1, 0, "SelectionBar");
    qmlRegisterType(componentUrl(QStringLiteral("LabelDelegate.qml")), uri, 1, 0, "LabelDelegate");
    qmlRegisterType(componentUrl(QStringLiteral("NewDialog.qml")), uri, 1, 0, "NewDialog");
    qmlRegisterType(componentUrl(QStringLiteral("Dialog.qml")), uri, 1, 0, "Dialog");
    qmlRegisterType(componentUrl(QStringLiteral("Popup.qml")), uri, 1, 0, "Popup");
    qmlRegisterType(componentUrl(QStringLiteral("TextField.qml")), uri, 1, 0, "TextField");
    qmlRegisterType(componentUrl(QStringLiteral("Badge.qml")), uri, 1, 0, "Badge");
    qmlRegisterType(componentUrl(QStringLiteral("ListBrowser.qml")), uri, 1, 0, "ListBrowser");
    qmlRegisterType(componentUrl(QStringLiteral("GridView.qml")), uri, 1, 0, "GridView");
    qmlRegisterType(componentUrl(QStringLiteral("TabBar.qml")), uri, 1, 0, "TabBar");
    qmlRegisterType(componentUrl(QStringLiteral("TabButton.qml")), uri, 1, 0, "TabButton");
    qmlRegisterType(componentUrl(QStringLiteral("ActionSideBar.qml")), uri, 1, 0, "ActionSideBar");
    qmlRegisterType(componentUrl(QStringLiteral("ToolActions.qml")), uri, 1, 0, "ToolActions");
    qmlRegisterType(componentUrl(QStringLiteral("ToolButtonMenu.qml")), uri, 1, 0, "ToolButtonMenu");
    qmlRegisterType(componentUrl(QStringLiteral("ListItemTemplate.qml")), uri, 1, 0, "ListItemTemplate");
    qmlRegisterType(componentUrl(QStringLiteral("GridItemTemplate.qml")), uri, 1, 0, "GridItemTemplate");

    qmlRegisterType(componentUrl(QStringLiteral("FloatingButton.qml")), uri, 1, 0, "FloatingButton");

    /** Shapes **/
    qmlRegisterType(componentUrl(QStringLiteral("private/shapes/X.qml")), uri, 1, 0, "X");
    qmlRegisterType(componentUrl(QStringLiteral("private/shapes/PlusSign.qml")), uri, 1, 0, "PlusSign");
    qmlRegisterType(componentUrl(QStringLiteral("private/shapes/Arrow.qml")), uri, 1, 0, "Arrow");
    qmlRegisterType(componentUrl(QStringLiteral("private/shapes/Triangle.qml")), uri, 1, 0, "Triangle");
    qmlRegisterType(componentUrl(QStringLiteral("private/shapes/CheckMark.qml")), uri, 1, 0, "CheckMark");
    qmlRegisterType(componentUrl(QStringLiteral("private/shapes/Rectangle.qml")), uri, 1, 0, "Rectangle");

    /** 1.1 **/
    qmlRegisterType(componentUrl(QStringLiteral("labs/ShareDialog.qml")), uri, 1, 1, "ShareDialog");
    qmlRegisterType(componentUrl(QStringLiteral("labs/ActionToolBar.qml")), uri, 1, 1, "ActionToolBar");
    qmlRegisterType(componentUrl(QStringLiteral("labs/ToolButtonAction.qml")), uri, 1, 1, "ToolButtonAction");
    qmlRegisterType(componentUrl(QStringLiteral("AppViews.qml")), uri, 1, 1, "AppViews");
    qmlRegisterType(componentUrl(QStringLiteral("AppViewLoader.qml")), uri, 1, 1, "AppViewLoader");
    qmlRegisterType(componentUrl(QStringLiteral("AltBrowser.qml")), uri, 1, 1, "AltBrowser");

    qmlRegisterType(componentUrl(QStringLiteral("labs/TabsBrowser.qml")), uri, 1, 1, "TabsBrowser");
    qmlRegisterType(componentUrl(QStringLiteral("labs/SettingsDialog.qml")), uri, 1, 1, "SettingsDialog");
    qmlRegisterType(componentUrl(QStringLiteral("labs/SettingsSection.qml")), uri, 1, 1, "SettingsSection");

    /** 1.2 **/
    qmlRegisterType(componentUrl(QStringLiteral("labs/SettingTemplate.qml")), uri, 1, 2, "SettingTemplate");
    qmlRegisterType(componentUrl(QStringLiteral("labs/AlternateListItem.qml")), uri, 1, 2, "AlternateListItem");
    qmlRegisterType(componentUrl(QStringLiteral("labs/Separator.qml")), uri, 1, 2, "Separator");
    qmlRegisterType(componentUrl(QStringLiteral("private/BasicToolButton.qml")), uri, 1, 2, "BasicToolButton");

    /** 1.3 **/
    qmlRegisterType(componentUrl(QStringLiteral("labs/GalleryRollItem.qml")), uri, 1, 3, "GalleryRollItem");
    qmlRegisterType(componentUrl(QStringLiteral("labs/CollageItem.qml")), uri, 1, 3, "CollageItem");
    qmlRegisterType(componentUrl(QStringLiteral("labs/FileListingDialog.qml")), uri, 1, 3, "FileListingDialog");
    qmlRegisterType(componentUrl(QStringLiteral("labs/SectionDropDown.qml")), uri, 1, 3, "SectionDropDown");
    qmlRegisterType(componentUrl(QStringLiteral("labs/IconItem.qml")), uri, 1, 3, "IconItem");
    qmlRegisterType(componentUrl(QStringLiteral("labs/DoodleCanvas.qml")), uri, 1, 3, "DoodleCanvas");
    qmlRegisterType(componentUrl(QStringLiteral("labs/Doodle.qml")), uri, 1, 3, "Doodle");
    qmlRegisterType(componentUrl(QStringLiteral("labs/FlexListItem.qml")), uri, 1, 3, "FlexListItem");
    qmlRegisterType(componentUrl(QStringLiteral("labs/Chip.qml")), uri, 1, 3, "Chip");
    qmlRegisterType(componentUrl(QStringLiteral("labs/ContextualMenu.qml")), uri, 1, 3, "ContextualMenu");
    qmlRegisterType(componentUrl(QStringLiteral("labs/ComboBox.qml")), uri, 1, 3, "ComboBox");
    qmlRegisterType(componentUrl(QStringLiteral("labs/TabView.qml")), uri, 1, 3, "TabView");
    qmlRegisterType(componentUrl(QStringLiteral("CloseButton.qml")), uri, 1, 3, "CloseButton");
    qmlRegisterType(componentUrl(QStringLiteral("labs/ColorsRow.qml")), uri, 1, 3, "ColorsRow");
    qmlRegisterType(componentUrl(QStringLiteral("SplitView.qml")), uri, 1, 3, "SplitView");
    qmlRegisterType(componentUrl(QStringLiteral("SplitViewItem.qml")), uri, 1, 3, "SplitViewItem");
    qmlRegisterType(componentUrl(QStringLiteral("ProgressIndicator.qml")), uri, 1, 3, "ProgressIndicator");

    /// NON UI CONTROLS
    qmlRegisterUncreatableType<AppView>(uri, 1, 1, "AppView", "Cannot be created AppView");
    qmlRegisterUncreatableType<TabViewInfo>(uri, 1, 3, "TabViewInfo", "Cannot be created TabView");

    qmlRegisterType<SettingSection>(uri, 1, 2, "SettingSection");
//     qmlRegisterSingletonInstance<Platform>(uri, 1, 2, "Platform", Platform::instance());
    qmlRegisterSingletonType<Platform>(uri, 1, 2, "Platform", [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject * {
        Q_UNUSED(scriptEngine)
        auto platform = Platform::instance();
        engine->setObjectOwnership(platform, QQmlEngine::CppOwnership);
        return platform;
    });

    /** Experimental **/
#ifdef Q_OS_WIN32
    qmlRegisterType(componentUrl(QStringLiteral("labs/WindowControlsWindows.qml")), uri, 1, 1, "WindowControls");
#elif defined Q_OS_MAC
    qmlRegisterType(componentUrl(QStringLiteral("labs/WindowControlsMac.qml")), uri, 1, 1, "WindowControls");
#elif defined Q_OS_ANDROID
    qmlRegisterType(componentUrl(QStringLiteral("labs/WindowControlsWindows.qml")), uri, 1, 1, "WindowControls");
#elif defined Q_OS_LINUX && !defined Q_OS_ANDROID

    #if defined Q_PROCESSOR_ARM
    qmlRegisterType(componentUrl(QStringLiteral("labs/WindowControlsWindows.qml")), uri, 1, 1, "WindowControls");
#else
    qmlRegisterType(componentUrl(QStringLiteral("labs/CSDControls.qml")), uri, 1, 1, "CSDControls");
    qmlRegisterType(componentUrl(QStringLiteral("labs/WindowControlsLinux.qml")), uri, 1, 1, "WindowControls");
#endif

#endif

    /** PLATFORMS SPECIFIC CONTROLS **/
#if defined Q_OS_LINUX || defined Q_OS_MACOS
    qmlRegisterType(componentUrl(QStringLiteral("Terminal.qml")), uri, 1, 0, "Terminal");
#endif

#ifdef Q_OS_ANDROID
    qmlRegisterSingletonType<MAUIAndroid>(uri, 1, 0, "Android", [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject * {
        Q_UNUSED(engine)
        Q_UNUSED(scriptEngine)
        return new MAUIAndroid;
    });
#elif defined Q_OS_LINUX
    qmlRegisterUncreatableType<MAUIKDE>(uri, 1, 0, "KDE", "Cannot be created KDE");

#elif defined Q_OS_WIN32
    // here window platform integration interfaces
#elif defined Q_OS_MACOS

#endif

    /** DATA MODELING TEMPLATED INTERFACES **/
    qmlRegisterAnonymousType<MauiList>(uri, 1); // ABSTRACT BASE LIST
    qmlRegisterType<MauiModel>(uri, 1, 0, "BaseModel"); // BASE MODEL


    /** MAUI APPLICATION SPECIFIC PROPS **/
    /** HELPERS **/
    qmlRegisterAnonymousType<CSDControls>(uri, 1);
    qmlRegisterType<CSDButton>(uri, 1, 3, "CSDButton");
    qmlRegisterUncreatableType<MauiApp>(uri, 1, 0, "App", "Cannot be created App");
    qmlRegisterSingletonType<Handy>(uri, 1, 0, "Handy", [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject * {
        Q_UNUSED(engine)
        Q_UNUSED(scriptEngine)
        return new Handy;
    });

    /** MAUI PLUGIN SUPPORT **/
#ifdef SUPPORT_PLUGINS
    qmlRegisterType(componentUrl(QStringLiteral("AppViewsPlugin.qml")), uri, 1, 2, "AppViewsPlugin");
    qmlRegisterType(componentUrl(QStringLiteral("PagePlugin.qml")), uri, 1, 2, "PagePlugin");
    qmlRegisterType(componentUrl(QStringLiteral("PluginManager.qml")), uri, 1, 2, "PluginManager");
    qmlRegisterType(componentUrl(QStringLiteral("PluginsInfo.qml")), uri, 1, 2, "PluginsInfo");
#endif

    qmlProtectModule(uri, 1);
}

void MauiKit::initResources()
{
#if defined Q_OS_ANDROID || defined Q_OS_MACOS || defined Q_OS_WIN
    Q_INIT_RESOURCE(mauikit);
    Q_INIT_RESOURCE(style);
    Q_INIT_RESOURCE(icons);
#endif
}

//#include "moc_mauikit.cpp"
