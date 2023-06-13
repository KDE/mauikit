
include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}/utils
    ${CMAKE_CURRENT_BINARY_DIR}/utils

    ${CMAKE_CURRENT_SOURCE_DIR}/utils/models
    ${CMAKE_CURRENT_BINARY_DIR}/utils/models

    ${CMAKE_CURRENT_SOURCE_DIR}/utils/model_template
    ${CMAKE_CURRENT_BINARY_DIR}/utils/model_template

    ${CMAKE_CURRENT_SOURCE_DIR}/controls/libs
    ${CMAKE_CURRENT_BINARY_DIR}/controls/libs

    ${CMAKE_CURRENT_SOURCE_DIR}/platforms
    ${CMAKE_CURRENT_BINARY_DIR}/platforms
)

ecm_add_qml_module(MauiKit URI "org.mauikit.controls" VERSION 3.0)
#ecm_add_qml_module_dependencies(MauiKit DEPENDS
#    "QtQuick.Controls 2.15"
#    "QtGraphicalEffects 1.0"
#)

set(mauikit_SRCS
    mauikit.cpp
    controls/libs/style.cpp
    utils/appsettings.cpp
    utils/fmh.cpp
    utils/mauiapp.cpp
    utils/handy.cpp
    utils/notify.cpp
    utils/platformtheme.cpp
    utils/basictheme.cpp
    utils/imagecolors.cpp
    utils/colorutils.cpp
    utils/wheelhandler.cpp
    utils/model_template/mauilist.cpp
    utils/model_template/mauimodel.cpp
    platforms/abstractplatform.cpp
    platforms/platform.cpp
    utils/icon.cpp
    utils/managedtexturenode.cpp
    utils/fontpickermodel.cpp
)

set(mauikit_HDRS
    mauikit.h
    utils/appsettings.h
    utils/fmh.h
    utils/utils.h
    utils/handy.h
    utils/notify.h
    utils/mauiapp.h
    utils/platformtheme.h
    utils/basictheme_p.h
    utils/imagecolors.h
    utils/colorutils.h
    utils/wheelhandler.h
    utils/model_template/mauilist.h
    utils/model_template/mauimodel.h
    controls/libs/appview.h
    controls/libs/tabview.h
    controls/libs/style.h
    platforms/abstractplatform.h
    platforms/platform.h
)

if (QT_MAJOR_VERSION STREQUAL "5")
    if(QUICK_COMPILER)
        qtquick_compiler_add_resources(mauikit_QML_QRC mauikit.qrc maui-style/style.qrc)
    else()
        qt5_add_resources(mauikit_QML_QRC mauikit.qrc maui-style/style.qrc)
    endif()
endif()

if(${SUPPORT_PLUGINS})
    message(STATUS "INCLUDING PLUGINS SUPPORT")
    set(mauikitplugin_SRCS
        utils/plugin/pluginmanager.cpp
    )

set(mauikitplugin_HDRS
    utils/plugin/pluginmanager.h
)

include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}/utils/plugin/
    ${CMAKE_CURRENT_BINARY_DIR}/utils/plugin )
add_definitions(-DSUPPORT_PLUGINS)
endif()

if(BUNDLE_LUV_ICONS)
    if (NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/icons/luv-icon-theme/.git)
        find_package(Git REQUIRED)
        execute_process(COMMAND ${GIT_EXECUTABLE} clone --depth 1 https://github.com/Nitrux/luv-icon-theme.git ${CMAKE_CURRENT_SOURCE_DIR}/icons/luv-icon-theme)
    endif()

    list(APPEND mauikit_SRCS icons.qrc)
endif()

if (ANDROID)
    add_subdirectory(platforms/android)

    set(mauikit_PLATFORM_SRCS
        platforms/android/mauiandroid.cpp
        platforms/android/qtquickcontrols2.conf
        platforms/android/android.qrc
    )

set(mauikit_PLATFORM_HDRS
    platforms/android/mauiandroid.h
)

set(window_PLATFORM_SRCS
    platforms/android/blurhelper/windowblur.cpp
    platforms/android/shadowhelper/boxshadowrenderer.cpp
    platforms/android/shadowhelper/tileset.cpp
    platforms/android/shadowhelper/windowshadow.cpp
)

set(window_PLATFORM_HDRS
    platforms/android/blurhelper/windowblur.h
    platforms/android/shadowhelper/boxshadowrenderer.h
    platforms/android/shadowhelper/tileset.h
    platforms/android/shadowhelper/windowshadow.h
)

#    kde_enable_exceptions(MauiKit PRIVATE)
elseif(UNIX AND NOT APPLE)

    set(kwin_XCB_LIBS
        XCB::ICCCM
        XCB::SHAPE
        XCB::XCB
    )

set(mauikit_PLATFORM_SRCS
    platforms/linux/mauilinux.cpp
)

set(mauikit_PLATFORM_HDRS
    platforms/linux/mauilinux.h
)

set(window_PLATFORM_SRCS
    platforms/linux/blurhelper/windowblur.cpp
    platforms/linux/shadowhelper/boxshadowrenderer.cpp
    platforms/linux/shadowhelper/tileset.cpp
    platforms/linux/shadowhelper/windowshadow.cpp
)

set(window_PLATFORM_HDRS
    platforms/linux/blurhelper/windowblur.h
    platforms/linux/shadowhelper/boxshadowrenderer.h
    platforms/linux/shadowhelper/tileset.h
    platforms/linux/shadowhelper/windowshadow.h
)
elseif(APPLE)
    #    set(CMAKE_CXX_FLAGS "-x objective-c++")

    set(mauikit_PLATFORM_SRCS
        platforms/macos/mauimacos.cpp
    )

set(mauikit_PLATFORM_HDRS
    platforms/macos/mauimacos.h
)
# Temporarily share blur, shawdow implementation for Windows
set(window_PLATFORM_SRCS
    platforms/windows/blurhelper/windowblur.cpp
    platforms/windows/shadowhelper/boxshadowrenderer.cpp
    platforms/windows/shadowhelper/tileset.cpp
    platforms/windows/shadowhelper/windowshadow.cpp
)
set(window_PLATFORM_HDRS
    platforms/windows/blurhelper/windowblur.h
    platforms/windows/shadowhelper/boxshadowrenderer.h
    platforms/windows/shadowhelper/tileset.h
    platforms/windows/shadowhelper/windowshadow.h
)
elseif(WIN32)
    set(mauikit_PLATFORM_SRCS
        platforms/windows/mauiwindows.cpp
    )

set(mauikit_PLATFORM_HDRS
    platforms/windows/mauiwindows.h
)

set(window_PLATFORM_SRCS
    platforms/windows/blurhelper/windowblur.cpp
    platforms/windows/shadowhelper/boxshadowrenderer.cpp
    platforms/windows/shadowhelper/tileset.cpp
    platforms/windows/shadowhelper/windowshadow.cpp
)

set(window_PLATFORM_HDRS
    platforms/windows/blurhelper/windowblur.h
    platforms/windows/shadowhelper/boxshadowrenderer.h
    platforms/windows/shadowhelper/tileset.h
    platforms/windows/shadowhelper/windowshadow.h
)
endif()

ecm_target_qml_sources(MauiKit SOURCES

    controls.6/AltBrowser.qml
    controls.6/AnimatedImageViewer.qml
    controls.6/ApplicationWindow.qml
    controls.6/AppViews.qml
    controls.6/AppViewLoader.qml

    controls.6/Badge.qml

    controls.6/CollageItem.qml
    controls.6/ColorTransition.qml
    controls.6/ColorsRow.qml
    controls.6/ContextualMenu.qml
    controls.6/Chip.qml
    controls.6/CloseButton.qml
    controls.6/CSDControls.qml

    controls.6/EdgeShadow.qml

    controls.6/FlexListItem.qml
    controls.6/FloatingButton.qml

    controls.6/GalleryRollTemplate.qml
    controls.6/GalleryRollItem.qml
    controls.6/GridBrowser.qml
    controls.6/GridBrowserDelegate.qml
    controls.6/GridItemTemplate.qml

    controls.6/Holder.qml

    controls.6/Icon.qml
    controls.6/IconItem.qml
    controls.6/IconLabel.qml
    controls.6/ImageViewer.qml
    controls.6/InfoDialog.qml
    controls.6/InputDialog.qml
    controls.6/ItemDelegate.qml

    controls.6/LabelDelegate.qml
    controls.6/ListBrowser.qml
    controls.6/ListBrowserDelegate.qml
    controls.6/ListDelegate.qml
    controls.6/ListItemTemplate.qml

    controls.6/MenuItemActionRow.qml

    controls.6/Page.qml
    controls.6/PasswordField.qml
    controls.6/PopupPage.qml
    controls.6/ProgressIndicator.qml

    controls.6/ScrollColumn.qml

    controls.6/SearchField.qml

    controls.6/SectionHeader.qml
    controls.6/SectionItem.qml
    controls.6/SectionGroup.qml    
    controls.6/Separator.qml
    controls.6/SettingsDialog.qml
    controls.6/SettingsPage.qml
    controls.6/SideBarView.qml
    controls.6/ShadowedRectangle.qml
    controls.6/SplitView.qml
    controls.6/SplitViewItem.qml

    controls.6/TabBar.qml
    controls.6/TabButton.qml
    controls.6/TabView.qml
    controls.6/TabViewItem.qml
    controls.6/TabViewButton.qml
    controls.6/ToolActions.qml
    controls.6/ToolBar.qml
    controls.6/ToolButtonMenu.qml

    controls.6/WindowControlsLinux.qml
)

ecm_target_qml_sources(MauiKit PATH private SOURCES

    controls.6/private/AboutDialog.qml
    controls.6/private/ActionGroup.qml

    controls.6/private/CheckBoxItem.qml

    controls.6/private/ToastArea.qml
    controls.6/private/ToolBarSection.qml

    controls.6/private/Rectangle.qml
    controls.6/private/SideBar.qml
)

target_sources(MauiKit

    PRIVATE

    ${mauikit_HDRS}
    ${mauikit_SRCS}

    ${mauikit_PLATFORM_HDRS}
    ${mauikit_PLATFORM_SRCS}

    ${window_PLATFORM_HDRS}
    ${window_PLATFORM_SRCS}

    assets.qrc
)

if (QT_MAJOR_VERSION STREQUAL "5")
    target_sources(MauiKit  PRIVATE  ${mauikit_QML_QRC})

    if(QUICK_COMPILER)
        add_definitions(-DQUICK_COMPILER)
        target_compile_definitions(MauiKit PUBLIC QUICK_COMPILER)
    endif()
endif()

add_definitions(-DBUNDLE_MAUI_STYLE)
target_compile_definitions(MauiKit PUBLIC BUNDLE_MAUI_STYLE)

if(BUNDLE_LUV_ICONS)
    add_definitions(-DBUNDLE_LUV_ICONS)
    target_compile_definitions(MauiKit PUBLIC BUNDLE_LUV_ICONS)
endif()

if(ANDROID)
    include_directories(
        ${CMAKE_CURRENT_SOURCE_DIR}/platforms/android
        ${CMAKE_CURRENT_BINARY_DIR}/platforms/android
    )
target_include_directories(MauiKit PRIVATE platforms/android)
elseif(WIN32)
    include_directories(
        ${CMAKE_CURRENT_SOURCE_DIR}/platforms/windows
        ${CMAKE_CURRENT_BINARY_DIR}/platforms/windows
    )
target_include_directories(MauiKit PRIVATE platforms/windows)
elseif(UNIX AND NOT APPLE)
    include_directories(
        ${CMAKE_CURRENT_SOURCE_DIR}/platforms/linux
        ${CMAKE_CURRENT_BINARY_DIR}/platforms/linux
    )
target_include_directories(MauiKit PRIVATE platforms/linux)
elseif(APPLE)
    # Temporarily share blur, shawdow implementation for Windows
    include_directories(
        ${CMAKE_CURRENT_SOURCE_DIR}/platforms/windows
        ${CMAKE_CURRENT_BINARY_DIR}/platforms/windows
    )
# include_directories(
#     ${CMAKE_CURRENT_SOURCE_DIR}/platforms/macos
#     ${CMAKE_CURRENT_BINARY_DIR}/platforms/macos
#     )
target_include_directories(MauiKit PRIVATE platforms/macos)
endif()

if(ANDROID)
    #   add_subdirectory(platforms/android)
    target_link_libraries(MauiKit PRIVATE Qt${QT_VERSION_MAJOR}::AndroidExtras jnigraphics)

    install(FILES platforms/android/mauiandroid.h DESTINATION ${KDE_INSTALL_INCLUDEDIR}/MauiKit COMPONENT Devel)

    install(DIRECTORY platforms/android/ DESTINATION ${KDE_INSTALL_DATAROOTDIR}/MauiKitAndroid COMPONENT Devel)

    if (Qt5Core_VERSION VERSION_LESS 5.14.0)
        install(FILES MauiKit-android-dependencies.xml DESTINATION ${KDE_INSTALL_LIBDIR})
    else()
        install(FILES MauiKit-android-dependencies.xml DESTINATION ${KDE_INSTALL_LIBDIR} RENAME MauiKit_${CMAKE_ANDROID_ARCH_ABI}-android-dependencies.xml)
    endif()
elseif(UNIX AND NOT ANDROID)
    if(NOT APPLE)
        target_link_libraries(MauiKit
            PRIVATE
            KF${KF_MAJOR_VERSION}::WindowSystem
        )
    if (QT_MAJOR_VERSION STREQUAL "5")
        target_link_libraries(MauiKit PRIVATE Qt5::X11Extras)
    endif()
endif()
endif()

target_link_libraries(MauiKit
    PUBLIC
    Qt${QT_MAJOR_VERSION}::Core
    KF${KF_MAJOR_VERSION}::CoreAddons

    PRIVATE
    ${kwin_XCB_LIBS}
    MauiMan::MauiMan
    KF${KF_MAJOR_VERSION}::Notifications
    KF${KF_MAJOR_VERSION}::I18n
    Qt${QT_MAJOR_VERSION}::Qml
    Qt${QT_MAJOR_VERSION}::Svg
    Qt${QT_MAJOR_VERSION}::Widgets
    Qt${QT_MAJOR_VERSION}::Concurrent
    Qt${QT_MAJOR_VERSION}::QuickControls2
)

ecm_finalize_qml_module(MauiKit DESTINATION ${KDE_INSTALL_QMLDIR})
ecm_generate_qmltypes(org.mauikit.controls 3.0 DESTINATION ${KDE_INSTALL_QMLDIR}/org/mauikit/controls)

generate_export_header(MauiKit BASE_NAME MauiKit)
install(TARGETS MauiKit EXPORT MauiKitTargets ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})

target_include_directories(MauiKit
    INTERFACE "$<INSTALL_INTERFACE:${KDE_INSTALL_INCLUDEDIR}/MauiKit/Core>")

install(FILES
    ${mauikit_HDRS}
    ${mauikit_PLATFORM_HDRS}
    ${CMAKE_CURRENT_BINARY_DIR}/mauikit_export.h
    DESTINATION ${KDE_INSTALL_INCLUDEDIR}/MauiKit/Core
    COMPONENT Devel)

##INSTALL MAUI STYLE
if (QT_MAJOR_VERSION STREQUAL "5")
    install(DIRECTORY maui-style DESTINATION ${KDE_INSTALL_QMLDIR}/QtQuick/Controls.2)

    ##INSTALL THE DECO FOR CSD
    install(DIRECTORY csd DESTINATION ${KDE_INSTALL_DATADIR}/org.mauikit.controls)

else()
    add_subdirectory(style.6)
    ##INSTALL THE DECO FOR CSD
    install(DIRECTORY csd.6 DESTINATION ${KDE_INSTALL_DATADIR}/org.mauikit.controls)
endif()

