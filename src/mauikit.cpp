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

#include "appsettings.h"
#include "appview.h"

#include "handy.h"
#include "mauiapp.h"
#include "mauilist.h"
#include "mauimodel.h"
#include "notify.h"
#include "style.h"
#include "tabview.h"

#ifdef Q_OS_ANDROID
#include "platforms/android/mauiandroid.h"
#elif (defined Q_OS_LINUX || defined Q_OS_FREEBSD)
#include "platforms/linux/mauilinux.h"
#endif

#include "shadowhelper/windowshadow.h"
#include "blurhelper/windowblur.h"

#include "platform.h"

#include "utils/basictheme_p.h"
#include "utils/platformtheme.h"
#include "utils/colorutils.h"
#include "utils/imagecolors.h"
#include "utils/wheelhandler.h"
#include "utils/icon.h"

#include <QDebug>
#include <QQmlContext>

QUrl MauiKit::componentUrl(const QString &fileName) const
{
    return QUrl(resolveFileUrl(fileName));
}

void MauiKit::registerTypes(const char *uri)
{
    qmlRegisterType(componentUrl(QStringLiteral("ToolBar.qml")), uri, 1, 0, "ToolBar");
    qmlRegisterType(componentUrl(QStringLiteral("ApplicationWindow.qml")), uri, 1, 0, "ApplicationWindow");
    qmlRegisterType(componentUrl(QStringLiteral("Page.qml")), uri, 1, 0, "Page");
    qmlRegisterType(componentUrl(QStringLiteral("ShareDialog.qml")), uri, 1, 0, "ShareDialog");
    qmlRegisterType(componentUrl(QStringLiteral("PieButton.qml")), uri, 1, 0, "PieButton");
    qmlRegisterType(componentUrl(QStringLiteral("SideBar.qml")), uri, 1, 0, "SideBar");
    qmlRegisterType(componentUrl(QStringLiteral("SideBarView.qml")), uri, 1, 0, "SideBarView");
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
    qmlRegisterType(componentUrl(QStringLiteral("GridBrowser.qml")), uri, 1, 0, "GridBrowser");
    qmlRegisterType(componentUrl(QStringLiteral("TabBar.qml")), uri, 1, 0, "TabBar");
    qmlRegisterType(componentUrl(QStringLiteral("TabButton.qml")), uri, 1, 0, "TabButton");
    qmlRegisterType(componentUrl(QStringLiteral("ToolActions.qml")), uri, 1, 0, "ToolActions");
    qmlRegisterType(componentUrl(QStringLiteral("ToolButtonMenu.qml")), uri, 1, 0, "ToolButtonMenu");
    qmlRegisterType(componentUrl(QStringLiteral("ListItemTemplate.qml")), uri, 1, 0, "ListItemTemplate");
    qmlRegisterType(componentUrl(QStringLiteral("GridItemTemplate.qml")), uri, 1, 0, "GridItemTemplate");

    qmlRegisterType(componentUrl(QStringLiteral("FloatingButton.qml")), uri, 1, 0, "FloatingButton");
    
    
    //Kirigami aliases to be replaced later on
    //TODO
    qmlRegisterType(componentUrl(QStringLiteral("Icon.qml")), uri, 1, 0, "Icon"); //to be remove later
    qmlRegisterType(componentUrl(QStringLiteral("ShadowedRectangle.qml")), uri, 1, 0, "ShadowedRectangle"); //to be remove later
    
    /** Shapes **/
    qmlRegisterType(componentUrl(QStringLiteral("private/shapes/X.qml")), uri, 1, 0, "X");
    qmlRegisterType(componentUrl(QStringLiteral("private/shapes/PlusSign.qml")), uri, 1, 0, "PlusSign");
    qmlRegisterType(componentUrl(QStringLiteral("private/shapes/Arrow.qml")), uri, 1, 0, "Arrow");
    qmlRegisterType(componentUrl(QStringLiteral("private/shapes/Triangle.qml")), uri, 1, 0, "Triangle");
    qmlRegisterType(componentUrl(QStringLiteral("private/shapes/CheckMark.qml")), uri, 1, 0, "CheckMark");
    qmlRegisterType(componentUrl(QStringLiteral("private/shapes/Rectangle.qml")), uri, 1, 0, "Rectangle");
    qmlRegisterType(componentUrl(QStringLiteral("private/CheckBoxItem.qml")), uri, 1, 0, "CheckBoxItem");

    /** 1.1 **/
    qmlRegisterType(componentUrl(QStringLiteral("ActionToolBar.qml")), uri, 1, 1, "ActionToolBar");
    qmlRegisterType(componentUrl(QStringLiteral("ToolButtonAction.qml")), uri, 1, 1, "ToolButtonAction");
    qmlRegisterType(componentUrl(QStringLiteral("AppViews.qml")), uri, 1, 1, "AppViews");
    qmlRegisterType(componentUrl(QStringLiteral("AppViewLoader.qml")), uri, 1, 1, "AppViewLoader");
    qmlRegisterType(componentUrl(QStringLiteral("AltBrowser.qml")), uri, 1, 1, "AltBrowser");
    qmlRegisterType(componentUrl(QStringLiteral("SettingsDialog.qml")), uri, 1, 1, "SettingsDialog");
    qmlRegisterType(componentUrl(QStringLiteral("SectionGroup.qml")), uri, 1, 1, "SectionGroup");
    qmlRegisterType(componentUrl(QStringLiteral("ImageViewer.qml")), uri, 1, 1, "ImageViewer");
    qmlRegisterType(componentUrl(QStringLiteral("AnimatedImageViewer.qml")), uri, 1, 1, "AnimatedImageViewer");

    /** 1.2 **/
    qmlRegisterType(componentUrl(QStringLiteral("SectionItem.qml")), uri, 1, 2, "SectionItem");
    qmlRegisterType(componentUrl(QStringLiteral("Separator.qml")), uri, 1, 2, "Separator");
    qmlRegisterType(componentUrl(QStringLiteral("private/BasicToolButton.qml")), uri, 1, 2, "BasicToolButton");

    /** 1.3 **/
    qmlRegisterType(componentUrl(QStringLiteral("GalleryRollItem.qml")), uri, 1, 3, "GalleryRollItem");
    qmlRegisterType(componentUrl(QStringLiteral("CollageItem.qml")), uri, 1, 3, "CollageItem");
    qmlRegisterType(componentUrl(QStringLiteral("FileListingDialog.qml")), uri, 1, 3, "FileListingDialog");
    qmlRegisterType(componentUrl(QStringLiteral("SectionHeader.qml")), uri, 1, 3, "SectionHeader");
    qmlRegisterType(componentUrl(QStringLiteral("IconItem.qml")), uri, 1, 3, "IconItem");
    qmlRegisterType(componentUrl(QStringLiteral("DoodleCanvas.qml")), uri, 1, 3, "DoodleCanvas");
    qmlRegisterType(componentUrl(QStringLiteral("Doodle.qml")), uri, 1, 3, "Doodle");
    qmlRegisterType(componentUrl(QStringLiteral("FlexListItem.qml")), uri, 1, 3, "FlexListItem");
    qmlRegisterType(componentUrl(QStringLiteral("Chip.qml")), uri, 1, 3, "Chip");
    qmlRegisterType(componentUrl(QStringLiteral("ContextualMenu.qml")), uri, 1, 3, "ContextualMenu");
    qmlRegisterType(componentUrl(QStringLiteral("ComboBox.qml")), uri, 1, 3, "ComboBox");
    qmlRegisterType(componentUrl(QStringLiteral("FontsComboBox.qml")), uri, 1, 3, "FontsComboBox");
    qmlRegisterType(componentUrl(QStringLiteral("TabView.qml")), uri, 1, 3, "TabView");
    qmlRegisterType(componentUrl(QStringLiteral("TabViewButton.qml")), uri, 1, 3, "TabViewButton");
    qmlRegisterType(componentUrl(QStringLiteral("CloseButton.qml")), uri, 1, 3, "CloseButton");
    qmlRegisterType(componentUrl(QStringLiteral("ColorsRow.qml")), uri, 1, 3, "ColorsRow");
    qmlRegisterType(componentUrl(QStringLiteral("SplitView.qml")), uri, 1, 3, "SplitView");
    qmlRegisterType(componentUrl(QStringLiteral("SplitViewItem.qml")), uri, 1, 3, "SplitViewItem");
    qmlRegisterType(componentUrl(QStringLiteral("ProgressIndicator.qml")), uri, 1, 3, "ProgressIndicator");

    qmlRegisterType(componentUrl(QStringLiteral("MenuItemActionRow.qml")), uri, 1, 3, "MenuItemActionRow");
    qmlRegisterType(componentUrl(QStringLiteral("GalleryRollTemplate.qml")), uri, 1, 3, "GalleryRollTemplate");

    //backwars compatible
    qmlRegisterType(componentUrl(QStringLiteral("SearchField.qml")), uri, 1, 0, "SearchField");
    qmlRegisterType(componentUrl(QStringLiteral("PasswordField.qml")), uri, 1, 0, "PasswordField");
    qmlRegisterType(componentUrl(QStringLiteral("ScrollView.qml")), uri, 1, 0, "ScrollView");
    qmlRegisterType(componentUrl(QStringLiteral("StackView.qml")), uri, 1, 0, "StackView");
    qmlRegisterType(componentUrl(QStringLiteral("ColorTransition.qml")), uri, 1, 0, "ColorTransition");
    qmlRegisterType(componentUrl(QStringLiteral("private/EdgeShadow.qml")), uri, 1, 0, "EdgeShadow");
    
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

    qmlRegisterUncreatableType<Maui::PlatformTheme>(uri, 1, 0, "Theme", QStringLiteral("Cannot create objects of type Theme, use it as an attached property"));
    qmlRegisterSingletonType<ColorUtils>(uri, 1, 3, "ColorUtils", [](QQmlEngine *, QJSEngine *) -> QObject*
    {
        return new ColorUtils;
    });
    qmlRegisterType<ImageColors>(uri, 1, 3, "ImageColors");
    qmlRegisterType<WheelHandler>(uri, 1, 3, "WheelHandler");
    qmlRegisterType<Icon>(uri, 1, 0, "PrivateIcon");

    /** Experimental **/
#ifdef Q_OS_WIN32
    qmlRegisterType(componentUrl(QStringLiteral("WindowControlsWindows.qml")), uri, 1, 1, "WindowControls");
#elif defined Q_OS_MAC
    qmlRegisterType(componentUrl(QStringLiteral("WindowControlsMac.qml")), uri, 1, 1, "WindowControls");
#elif defined Q_OS_ANDROID
    qmlRegisterType(componentUrl(QStringLiteral("WindowControlsWindows.qml")), uri, 1, 1, "WindowControls");
#elif (defined Q_OS_LINUX || defined Q_OS_FREEBSD) && !defined Q_OS_ANDROID
    qmlRegisterType(componentUrl(QStringLiteral("CSDControls.qml")), uri, 1, 1, "CSDControls");
#if defined Q_PROCESSOR_ARM
    qmlRegisterType(componentUrl(QStringLiteral("WindowControlsLinux.qml")), uri, 1, 1, "WindowControls");
#else
    qmlRegisterType(componentUrl(QStringLiteral("WindowControlsLinux.qml")), uri, 1, 1, "WindowControls");
#endif

#endif

#ifdef Q_OS_ANDROID
    qmlRegisterSingletonType<MAUIAndroid>(uri, 1, 0, "Android", [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject * {
        Q_UNUSED(engine)
        Q_UNUSED(scriptEngine)
        return new MAUIAndroid;
    });
#elif (defined Q_OS_LINUX || defined Q_OS_FREEBSD)
    qmlRegisterUncreatableType<MAUIKDE>(uri, 1, 0, "KDE", "Cannot be created KDE");
#elif defined Q_OS_WIN32
    // here window platform integration interfaces
#elif defined Q_OS_MACOS

#endif

    qmlRegisterType<WindowShadow>(uri, 1, 0, "WindowShadow");
    qmlRegisterType<WindowBlur>(uri, 1, 0, "WindowBlur");

    /** DATA MODELING TEMPLATED INTERFACES **/
    qmlRegisterAnonymousType<MauiList>(uri, 1); // ABSTRACT BASE LIST
    qmlRegisterType<MauiModel>(uri, 1, 0, "BaseModel"); // BASE MODEL


    /** MAUI APPLICATION SPECIFIC PROPS **/
    /** HELPERS **/
    qmlRegisterAnonymousType<CSDControls>(uri, 1);
    qmlRegisterType<CSDButton>(uri, 1, 3, "CSDButton");
    qmlRegisterType<Notify>(uri, 1, 3, "Notify");
    qmlRegisterType<NotifyAction>(uri, 1, 3, "NotifyAction");

    qmlRegisterUncreatableType<Style>(uri, 1, 0, "Style", "Cannot be created Style");
    qmlRegisterUncreatableType<MauiApp>(uri, 1, 0, "App", "Cannot be created App");
    qmlRegisterSingletonType<Handy>(uri, 1, 2, "Handy", [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject * {
        Q_UNUSED(scriptEngine)
        auto handy = Handy::instance();
        engine->setObjectOwnership(handy, QQmlEngine::CppOwnership);
        return handy;
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

//#include "moc_mauikit.cpp"
