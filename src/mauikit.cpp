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
#include <QEvent>
#include <QCoreApplication>

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    #include "appview.h"
    #include "handy.h"
    #include "mauiapp.h"
    #include "csdcontrols.h"
    #include "mauilist.h"
    #include "mauimodel.h"
    #include "notify.h"
    #include "style.h"
    #include "tabview.h"
    #include "controls.h"

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
    #include "utils/fontpickermodel.h"
#endif

#include <QDebug>
#include <QQmlContext>

// we can't do this in the plugin object directly, as that can live in a different thread
// and event filters are only allowed in the same thread as the filtered object
class LanguageChangeEventFilter : public QObject
{
    Q_OBJECT
public:
    bool eventFilter(QObject *receiver, QEvent *event) override
    {
        if (event->type() == QEvent::LanguageChange && receiver == QCoreApplication::instance()) {
            Q_EMIT languageChangeEvent();
        }
        return QObject::eventFilter(receiver, event);
    }
    
Q_SIGNALS:
    void languageChangeEvent();
};

MauiKit::MauiKit(QObject *parent) : QQmlExtensionPlugin(parent)
{
    auto filter = new LanguageChangeEventFilter;
    filter->moveToThread(QCoreApplication::instance()->thread());
    QCoreApplication::instance()->installEventFilter(filter);
    connect(filter, &LanguageChangeEventFilter::languageChangeEvent, this, &MauiKit::languageChangeEvent);   
}

QUrl MauiKit::componentUrl(const QString &fileName) const
{
    return QUrl(resolveFileUrl(fileName));
}

void MauiKit::initializeEngine(QQmlEngine* engine, const char* uri)
{
    Q_UNUSED(uri);
    connect(this, &MauiKit::languageChangeEvent, engine, &QQmlEngine::retranslate);
}

void MauiKit::registerTypes(const char *uri)
{    
    qDebug() << "REGISTER MAUIKIT TYPES <<<<<<<<<<<<<<<<<<<<<<";
    #if defined(Q_OS_ANDROID)
    QResource::registerResource(QStringLiteral("assets:/android_rcc_bundle.rcc"));
    #endif
    
    Q_ASSERT(QLatin1String(uri) == QLatin1String("org.mauikit.controls"));
    
    // @uri org.mauikit.controls
    qmlRegisterType(componentUrl(QStringLiteral("ToolBar.qml")), uri, 1, 0, "ToolBar");
    qmlRegisterType(componentUrl(QStringLiteral("ApplicationWindow.qml")), uri, 1, 0, "ApplicationWindow");
    qmlRegisterType(componentUrl(QStringLiteral("Page.qml")), uri, 1, 0, "Page");
    qmlRegisterType(componentUrl(QStringLiteral("PageLayout.qml")), uri, 1, 0, "PageLayout");
    //    qmlRegisterType(componentUrl(QStringLiteral("ShareDialog.qml")), uri, 1, 0, "ShareDialog");
    qmlRegisterType(componentUrl(QStringLiteral("PieButton.qml")), uri, 1, 0, "PieButton");
    qmlRegisterType(componentUrl(QStringLiteral("SideBarView.qml")), uri, 1, 0, "SideBarView");
    qmlRegisterType(componentUrl(QStringLiteral("Holder.qml")), uri, 1, 0, "Holder");
    
    qmlRegisterType(componentUrl(QStringLiteral("ListDelegate.qml")), uri, 1, 0, "ListDelegate");
    qmlRegisterType(componentUrl(QStringLiteral("ListBrowserDelegate.qml")), uri, 1, 0, "ListBrowserDelegate");
    qmlRegisterType(componentUrl(QStringLiteral("SwipeItemDelegate.qml")), uri, 1, 0, "SwipeItemDelegate");
    qmlRegisterType(componentUrl(QStringLiteral("SwipeBrowserDelegate.qml")), uri, 1, 0, "SwipeBrowserDelegate");
    qmlRegisterType(componentUrl(QStringLiteral("ItemDelegate.qml")), uri, 1, 0, "ItemDelegate");
    qmlRegisterType(componentUrl(QStringLiteral("GridBrowserDelegate.qml")), uri, 1, 0, "GridBrowserDelegate");
    qmlRegisterType(componentUrl(QStringLiteral("SelectionBar.qml")), uri, 1, 0, "SelectionBar");
    qmlRegisterType(componentUrl(QStringLiteral("LabelDelegate.qml")), uri, 1, 0, "LabelDelegate");
    qmlRegisterType(componentUrl(QStringLiteral("InputDialog.qml")), uri, 1, 0, "InputDialog");
    qmlRegisterType(componentUrl(QStringLiteral("PopupPage.qml")), uri, 1, 0, "PopupPage");
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
    
    //    //Kirigami aliases to be replaced later on
    qmlRegisterType(componentUrl(QStringLiteral("Icon.qml")), uri, 1, 0, "Icon"); 
    qmlRegisterType(componentUrl(QStringLiteral("ShadowedRectangle.qml")), uri, 1, 0, "ShadowedRectangle"); //to be removed later
    
    //    /** Shapes **/
    qmlRegisterType(componentUrl(QStringLiteral("private/Rectangle.qml")), uri, 1, 0, "Rectangle");
    qmlRegisterType(componentUrl(QStringLiteral("private/CheckBoxItem.qml")), uri, 1, 0, "CheckBoxItem");
    
    //    /** 1.1 **/
    qmlRegisterType(componentUrl(QStringLiteral("AppViews.qml")), uri, 1, 1, "AppViews");
    qmlRegisterType(componentUrl(QStringLiteral("AppViewLoader.qml")), uri, 1, 1, "AppViewLoader");
    qmlRegisterType(componentUrl(QStringLiteral("AltBrowser.qml")), uri, 1, 1, "AltBrowser");
    qmlRegisterType(componentUrl(QStringLiteral("SettingsDialog.qml")), uri, 1, 1, "SettingsDialog");
    qmlRegisterType(componentUrl(QStringLiteral("SectionGroup.qml")), uri, 1, 1, "SectionGroup");
    qmlRegisterType(componentUrl(QStringLiteral("ImageViewer.qml")), uri, 1, 1, "ImageViewer");
    qmlRegisterType(componentUrl(QStringLiteral("AnimatedImageViewer.qml")), uri, 1, 1, "AnimatedImageViewer");
    
    //    /** 1.2 **/
    qmlRegisterType(componentUrl(QStringLiteral("SectionItem.qml")), uri, 1, 2, "SectionItem");
    qmlRegisterType(componentUrl(QStringLiteral("FlexSectionItem.qml")), uri, 1, 2, "FlexSectionItem");
    qmlRegisterType(componentUrl(QStringLiteral("Separator.qml")), uri, 1, 2, "Separator");
    
    //    /** 1.3 **/
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
    qmlRegisterType(componentUrl(QStringLiteral("ScrollColumn.qml")), uri, 1, 3, "ScrollColumn");
    qmlRegisterType(componentUrl(QStringLiteral("TabViewItem.qml")), uri, 1, 3, "TabViewItem");
    qmlRegisterType(componentUrl(QStringLiteral("SettingsPage.qml")), uri, 1, 3, "SettingsPage");
    qmlRegisterType(componentUrl(QStringLiteral("IconLabel.qml")), uri, 1, 3, "IconLabel");
    qmlRegisterType(componentUrl(QStringLiteral("InfoDialog.qml")), uri, 1, 3, "InfoDialog");
    qmlRegisterType(componentUrl(QStringLiteral("FontPicker.qml")), uri, 1, 3, "FontPicker");
    qmlRegisterType(componentUrl(QStringLiteral("FontPickerDialog.qml")), uri, 1, 3, "FontPickerDialog");
    qmlRegisterType(componentUrl(QStringLiteral("TextFieldPopup.qml")), uri, 1, 3, "TextFieldPopup");
    qmlRegisterType(componentUrl(QStringLiteral("DialogWindow.qml")), uri, 1, 3, "DialogWindow");
    
    //    //backwars compatible
    qmlRegisterType(componentUrl(QStringLiteral("SearchField.qml")), uri, 1, 0, "SearchField");
    qmlRegisterType(componentUrl(QStringLiteral("PasswordField.qml")), uri, 1, 0, "PasswordField");
    qmlRegisterType(componentUrl(QStringLiteral("private/ColorTransition.qml")), uri, 1, 0, "ColorTransition");
    qmlRegisterType(componentUrl(QStringLiteral("private/EdgeShadow.qml")), uri, 1, 0, "EdgeShadow");
    
    #if QT_VERSION < QT_VERSION_CHECK(6, 0, 0) //For MauiKit4 these types are registered inline using macros
    /// NON UI CONTROLS
        qmlRegisterUncreatableType<AppView>(uri, 1, 1, "AppView", "Cannot be created AppView");
        qmlRegisterUncreatableType<TabViewInfo>(uri, 1, 3, "TabViewInfo", "Cannot be created TabView");
        qmlRegisterUncreatableType<Controls>(uri, 1, 3, "Controls", "Attached properties for different purposes.");
        
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
        
        qmlRegisterType<FontPickerModel>(uri, 1, 3, "FontPickerModel");
        
        qmlRegisterType<WindowShadow>(uri, 1, 0, "WindowShadow");
        qmlRegisterType<WindowBlur>(uri, 1, 0, "WindowBlur");
        
        /** DATA MODELING TEMPLATED INTERFACES **/
        qmlRegisterAnonymousType<MauiList>(uri, 1); 
        qmlRegisterType<MauiModel>(uri, 1, 0, "BaseModel"); 
        
        /** MAUI APPLICATION SPECIFIC PROPS **/
        /** HELPERS **/
        qmlRegisterType<CSDButton>(uri, 1, 3, "CSDButton");
        qmlRegisterType<Notify>(uri, 1, 3, "Notify");
        qmlRegisterType<NotifyAction>(uri, 1, 3, "NotifyAction");
        
        qmlRegisterUncreatableType<Style>(uri, 1, 0, "Style", "Cannot be created Style");
        qmlRegisterUncreatableType<MauiApp>(uri, 1, 0, "App", "Cannot be created App");
        qmlRegisterUncreatableType<CSDControls>(uri, 1, 0, "CSD", "Cannot be created CSDControls");
        qmlRegisterSingletonType<Handy>(uri, 1, 2, "Handy", [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject * {
            Q_UNUSED(scriptEngine)
            auto handy = Handy::instance();
            engine->setObjectOwnership(handy, QQmlEngine::CppOwnership);
            return handy;
        });    
        
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
    
    //    /** MAUI PLUGIN SUPPORT **/
    //#ifdef SUPPORT_PLUGINS
    //    qmlRegisterType(componentUrl(QStringLiteral("AppViewsPlugin.qml")), uri, 1, 2, "AppViewsPlugin");
    //    qmlRegisterType(componentUrl(QStringLiteral("PagePlugin.qml")), uri, 1, 2, "PagePlugin");
    //    qmlRegisterType(componentUrl(QStringLiteral("PluginManager.qml")), uri, 1, 2, "PluginManager");
    //    qmlRegisterType(componentUrl(QStringLiteral("PluginsInfo.qml")), uri, 1, 2, "PluginsInfo");
    //#endif
    #endif
    
    //    /** Experimental **/
    #ifdef Q_OS_WIN32
        qmlRegisterType(componentUrl(QStringLiteral("private/WindowControlsWindows.qml")), uri, 1, 1, "WindowControls");
    #elif defined Q_OS_MAC
        qmlRegisterType(componentUrl(QStringLiteral("private/WindowControlsMac.qml")), uri, 1, 1, "WindowControls");
    #elif defined Q_OS_ANDROID
        qmlRegisterType(componentUrl(QStringLiteral("private/WindowControlsWindows.qml")), uri, 1, 1, "WindowControls");
    #elif (defined Q_OS_LINUX || defined Q_OS_FREEBSD) && !defined Q_OS_ANDROID
        qmlRegisterType(componentUrl(QStringLiteral("CSDControls.qml")), uri, 1, 1, "CSDControls");
        qmlRegisterType(componentUrl(QStringLiteral("private/WindowControlsLinux.qml")), uri, 1, 1, "WindowControls");
    #endif
    
    // qmlProtectModule(uri, 3);
}

#include "mauikit.moc"
#include "moc_mauikit.cpp"
