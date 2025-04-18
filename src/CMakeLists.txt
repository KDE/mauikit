# SPDX-FileCopyrightText: 2020 Camilo Higuita <milo.h@aol.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later

include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}/utils
    ${CMAKE_CURRENT_BINARY_DIR}/utils

    ${CMAKE_CURRENT_SOURCE_DIR}/utils/models
    ${CMAKE_CURRENT_BINARY_DIR}/utils/models

    ${CMAKE_CURRENT_SOURCE_DIR}/utils/model_template
    ${CMAKE_CURRENT_BINARY_DIR}/utils/model_template

    ${CMAKE_CURRENT_SOURCE_DIR}/libs
    ${CMAKE_CURRENT_BINARY_DIR}/libs

    ${CMAKE_CURRENT_SOURCE_DIR}/platforms
    ${CMAKE_CURRENT_BINARY_DIR}/platforms)

add_library(MauiKit${MAUI_MAJOR_VERSION})

if (ANDROID)
    set(_extra_options ${_extra_options} OPTIONAL_IMPORTS org.mauikit.style)
endif()

ecm_add_qml_module(MauiKit${MAUI_MAJOR_VERSION}
    VERSION 1.3
    URI "org.mauikit.controls"
    CLASS_NAME MauiKit
    DEPENDENCIES
    "QtQuick"
    "QtQuick.Controls"
    "QtMultimedia"
    NO_PLUGIN_OPTIONAL
    NO_GENERATE_PLUGIN_SOURCE
    ${_extra_options})

set_target_properties(MauiKit${MAUI_MAJOR_VERSION} PROPERTIES
    VERSION     ${PROJECT_VERSION}
    SOVERSION   ${MAUI_MAJOR_VERSION}
    EXPORT_NAME "MauiKit${MAUI_MAJOR_VERSION}")

add_library(MauiKit${MAUI_MAJOR_VERSION}::Controls ALIAS MauiKit${MAUI_MAJOR_VERSION})

target_sources(MauiKit${MAUI_MAJOR_VERSION}
    PRIVATE
    libs/style.cpp
    libs/style.h

    libs/controls.cpp
    libs/controls.h

    utils/icon.cpp
    utils/icon.h

    utils/fmh.cpp
    utils/fmh.h

    utils/mauiapp.cpp
    utils/mauiapp.h

    utils/csdcontrols.cpp
    utils/csdcontrols.h

    utils/handy.cpp
    utils/handy.h

    utils/notify.cpp
    utils/notify.h

    utils/platformtheme.cpp
    utils/platformtheme.h

    utils/basictheme.cpp

    utils/imagecolors.cpp
    utils/imagecolors.h

    utils/colorutils.cpp
    utils/colorutils.h

    utils/wheelhandler.cpp
    utils/wheelhandler.h

    utils/model_template/mauilist.cpp
    utils/model_template/mauilist.h

    utils/model_template/mauimodel.cpp
    utils/model_template/mauimodel.h

    platforms/abstractplatform.cpp
    platforms/abstractplatform.h

    platforms/platform.cpp
    platforms/platform.h

    utils/managedtexturenode.cpp
    utils/managedtexturenode.h

    utils/moduleinfo.cpp
    utils/moduleinfo.h

    utils/fontpickermodel.cpp
    utils/fontpickermodel.h

    utils/appsettings.cpp
    utils/appsettings.h

    assets.qrc)

set(mauikit_HDRS
    platforms/abstractplatform.h
    utils/fmh.h
    utils/handy.h
    utils/notify.h
    utils/mauiapp.h
    utils/imagecolors.h
    utils/colorutils.h
    utils/appsettings.h
    utils/model_template/mauilist.h
    utils/moduleinfo.h)

target_sources(MauiKit${MAUI_MAJOR_VERSION}plugin
    PRIVATE
    mauikit.cpp
    mauikit.h
    ${mauikit_QML_QRC})

if(${SUPPORT_PLUGINS})
    message(STATUS "INCLUDING PLUGINS SUPPORT")
    set(mauikitplugin_SRCS
        utils/plugin/pluginmanager.cpp)

    set(mauikitplugin_HDRS
        utils/plugin/pluginmanager.h)

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
    qt_add_resources(icons_QML_QRC icons.qrc)
    target_sources(MauiKit${MAUI_MAJOR_VERSION} PRIVATE ${icons_QML_QRC})
endif()

if (ANDROID)

    #    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/platforms/android/version.gradle.in ${CMAKE_BINARY_DIR}/version.gradle)
    include_directories(
        ${CMAKE_CURRENT_SOURCE_DIR}/platforms/android/shadowhelper)

    add_subdirectory(platforms/android)

    set(mauikit_HDRS ${mauikit_HDRS}
        platforms/android/mauiandroid.h)

    target_sources(MauiKit${MAUI_MAJOR_VERSION}
        PRIVATE
        platforms/android/mauiandroid.cpp
        platforms/android/mauiandroid.h

        platforms/android/blurhelper/windowblur.cpp
        platforms/android/shadowhelper/boxshadowrenderer.cpp
        platforms/android/shadowhelper/tileset.cpp
        platforms/android/shadowhelper/windowshadow.cpp
        platforms/android/shadowhelper/windowshadow.h)

    #    kde_enable_exceptions(MauiKit PRIVATE)
elseif(UNIX AND NOT APPLE)

    set(kwin_XCB_LIBS
        XCB::ICCCM
        XCB::SHAPE
        XCB::XCB)

    include_directories(
        ${CMAKE_CURRENT_SOURCE_DIR}/platforms/linux/blurhelper
        ${CMAKE_CURRENT_BINARY_DIR}/platforms/linux/blurhelper

        ${CMAKE_CURRENT_SOURCE_DIR}/platforms/linux/shadowhelper
        ${CMAKE_CURRENT_BINARY_DIR}/platforms/linux/shadowhelper)

    set(mauikit_PLATFORM_HDRS
        platforms/linux/mauilinux.h)

    target_sources(MauiKit${MAUI_MAJOR_VERSION}

        PRIVATE
        platforms/linux/mauilinux.cpp
        platforms/linux/mauilinux.h

        platforms/linux/blurhelper/windowblur.cpp
        platforms/linux/blurhelper/windowblur.h

        platforms/linux/shadowhelper/boxshadowrenderer.cpp
        platforms/linux/shadowhelper/boxshadowrenderer.h

        platforms/linux/shadowhelper/tileset.cpp
        platforms/linux/shadowhelper/tileset.h

        platforms/linux/shadowhelper/windowshadow.cpp
        platforms/linux/shadowhelper/windowshadow.h)

elseif(APPLE)
    #    set(CMAKE_CXX_FLAGS "-x objective-c++")

    set(mauikit_PLATFORM_SRCS
        platforms/macos/mauimacos.cpp)

    set(mauikit_PLATFORM_HDRS
        platforms/macos/mauimacos.h)
    # Temporarily share blur, shawdow implementation for Windows
    set(window_PLATFORM_SRCS
        platforms/windows/blurhelper/windowblur.cpp
        platforms/windows/shadowhelper/boxshadowrenderer.cpp
        platforms/windows/shadowhelper/tileset.cpp
        platforms/windows/shadowhelper/windowshadow.cpp)
    set(window_PLATFORM_HDRS
        platforms/windows/blurhelper/windowblur.h
        platforms/windows/shadowhelper/boxshadowrenderer.h
        platforms/windows/shadowhelper/tileset.h
        platforms/windows/shadowhelper/windowshadow.h)
elseif(WIN32)
    set(mauikit_PLATFORM_SRCS
        platforms/windows/mauiwindows.cpp)

    set(mauikit_PLATFORM_HDRS
        platforms/windows/mauiwindows.h)

    set(window_PLATFORM_SRCS
        platforms/windows/blurhelper/windowblur.cpp
        platforms/windows/shadowhelper/boxshadowrenderer.cpp
        platforms/windows/shadowhelper/tileset.cpp
        platforms/windows/shadowhelper/windowshadow.cpp)

    set(window_PLATFORM_HDRS
        platforms/windows/blurhelper/windowblur.h
        platforms/windows/shadowhelper/boxshadowrenderer.h
        platforms/windows/shadowhelper/tileset.h
        platforms/windows/shadowhelper/windowshadow.h)
endif()

ecm_target_qml_sources(MauiKit${MAUI_MAJOR_VERSION} SOURCES

    controls.${QT_MAJOR_VERSION}/AltBrowser.qml
    controls.${QT_MAJOR_VERSION}/AnimatedImageViewer.qml
    controls.${QT_MAJOR_VERSION}/ApplicationWindow.qml

    controls.${QT_MAJOR_VERSION}/Badge.qml

    controls.${QT_MAJOR_VERSION}/CollageItem.qml

    controls.${QT_MAJOR_VERSION}/ColorsRow.qml
    controls.${QT_MAJOR_VERSION}/ContextualMenu.qml
    controls.${QT_MAJOR_VERSION}/Chip.qml
    controls.${QT_MAJOR_VERSION}/CloseButton.qml
    controls.${QT_MAJOR_VERSION}/CSDControls.qml

    controls.${QT_MAJOR_VERSION}/DialogWindow.qml
    controls.${QT_MAJOR_VERSION}/Doodle.qml
    controls.${QT_MAJOR_VERSION}/DoodleCanvas.qml

    controls.${QT_MAJOR_VERSION}/FlexListItem.qml
    controls.${QT_MAJOR_VERSION}/FlexSectionItem.qml
    controls.${QT_MAJOR_VERSION}/FloatingButton.qml
    controls.${QT_MAJOR_VERSION}/FontsComboBox.qml
    controls.${QT_MAJOR_VERSION}/FontPicker.qml
    controls.${QT_MAJOR_VERSION}/FontPickerDialog.qml

    controls.${QT_MAJOR_VERSION}/GalleryRollTemplate.qml
    controls.${QT_MAJOR_VERSION}/GalleryRollItem.qml
    controls.${QT_MAJOR_VERSION}/GridBrowser.qml
    controls.${QT_MAJOR_VERSION}/GridBrowserDelegate.qml
    controls.${QT_MAJOR_VERSION}/GridItemTemplate.qml

    controls.${QT_MAJOR_VERSION}/Holder.qml

    controls.${QT_MAJOR_VERSION}/Icon.qml
    controls.${QT_MAJOR_VERSION}/IconItem.qml
    controls.${QT_MAJOR_VERSION}/IconLabel.qml
    controls.${QT_MAJOR_VERSION}/ImageViewer.qml
    controls.${QT_MAJOR_VERSION}/InfoDialog.qml
    controls.${QT_MAJOR_VERSION}/InputDialog.qml
    controls.${QT_MAJOR_VERSION}/ItemDelegate.qml

    controls.${QT_MAJOR_VERSION}/LabelDelegate.qml
    controls.${QT_MAJOR_VERSION}/ListBrowser.qml
    controls.${QT_MAJOR_VERSION}/ListBrowserDelegate.qml
    controls.${QT_MAJOR_VERSION}/ListDelegate.qml
    controls.${QT_MAJOR_VERSION}/ListItemTemplate.qml

    controls.${QT_MAJOR_VERSION}/Notification.qml

    controls.${QT_MAJOR_VERSION}/MenuItemActionRow.qml

    controls.${QT_MAJOR_VERSION}/Page.qml
    controls.${QT_MAJOR_VERSION}/PageLayout.qml
    controls.${QT_MAJOR_VERSION}/PasswordField.qml
    controls.${QT_MAJOR_VERSION}/PieButton.qml
    controls.${QT_MAJOR_VERSION}/Popup.qml
    controls.${QT_MAJOR_VERSION}/PopupPage.qml
    controls.${QT_MAJOR_VERSION}/ProgressIndicator.qml

    controls.${QT_MAJOR_VERSION}/ScrollColumn.qml

    controls.${QT_MAJOR_VERSION}/SearchField.qml

    controls.${QT_MAJOR_VERSION}/SectionHeader.qml
    controls.${QT_MAJOR_VERSION}/SectionItem.qml
    controls.${QT_MAJOR_VERSION}/SectionGroup.qml
    controls.${QT_MAJOR_VERSION}/SelectionBar.qml
    controls.${QT_MAJOR_VERSION}/Separator.qml
    controls.${QT_MAJOR_VERSION}/SettingsDialog.qml
    controls.${QT_MAJOR_VERSION}/SettingsPage.qml
    controls.${QT_MAJOR_VERSION}/SideBarView.qml
    controls.${QT_MAJOR_VERSION}/ShadowedRectangle.qml
    controls.${QT_MAJOR_VERSION}/SplitView.qml
    controls.${QT_MAJOR_VERSION}/SplitViewItem.qml
    controls.${QT_MAJOR_VERSION}/SwipeBrowserDelegate.qml
    controls.${QT_MAJOR_VERSION}/SwipeItemDelegate.qml    
    controls.${QT_MAJOR_VERSION}/SwipeView.qml
    controls.${QT_MAJOR_VERSION}/SwipeViewLoader.qml

    controls.${QT_MAJOR_VERSION}/TabBar.qml
    controls.${QT_MAJOR_VERSION}/TabButton.qml
    controls.${QT_MAJOR_VERSION}/TabView.qml
    controls.${QT_MAJOR_VERSION}/TabViewItem.qml
    controls.${QT_MAJOR_VERSION}/TabViewButton.qml
    controls.${QT_MAJOR_VERSION}/TextField.qml
    controls.${QT_MAJOR_VERSION}/TextFieldPopup.qml
    controls.${QT_MAJOR_VERSION}/ToolActions.qml
    controls.${QT_MAJOR_VERSION}/ToolBar.qml
    controls.${QT_MAJOR_VERSION}/ToolButtonMenu.qml)

ecm_target_qml_sources(MauiKit${MAUI_MAJOR_VERSION} PATH private SOURCES

    controls.${QT_MAJOR_VERSION}/private/AboutDialog.qml
    controls.${QT_MAJOR_VERSION}/private/ActionGroup.qml

    controls.${QT_MAJOR_VERSION}/private/BaseWindow.qml

    controls.${QT_MAJOR_VERSION}/private/CheckBoxItem.qml
    controls.${QT_MAJOR_VERSION}/private/ColorTransition.qml

    controls.${QT_MAJOR_VERSION}/private/DropDownIndicator.qml
    controls.${QT_MAJOR_VERSION}/private/EdgeShadow.qml

    controls.${QT_MAJOR_VERSION}/private/ToastArea.qml
    controls.${QT_MAJOR_VERSION}/private/ToolBarSection.qml

    controls.${QT_MAJOR_VERSION}/private/Rectangle.qml
    controls.${QT_MAJOR_VERSION}/private/ShareDialog.qml
    controls.${QT_MAJOR_VERSION}/private/ShareDialogLinux.qml
    controls.${QT_MAJOR_VERSION}/private/SideBar.qml
    controls.${QT_MAJOR_VERSION}/private/WindowResizeHandlers.qml)

if(ANDROID)
    ecm_target_qml_sources(MauiKit${MAUI_MAJOR_VERSION} PATH private/android SOURCES
        controls.${QT_MAJOR_VERSION}/private/android/WindowControls.qml)
elseif(LINUX)
    ecm_target_qml_sources(MauiKit${MAUI_MAJOR_VERSION} PATH private/linux SOURCES
        controls.${QT_MAJOR_VERSION}/private/linux/WindowControls.qml)
endif()

add_definitions(-DBUNDLE_MAUI_STYLE)
target_compile_definitions(MauiKit${MAUI_MAJOR_VERSION} PUBLIC BUNDLE_MAUI_STYLE)

if(BUNDLE_LUV_ICONS)
    add_definitions(-DBUNDLE_LUV_ICONS)
    target_compile_definitions(MauiKit${MAUI_MAJOR_VERSION} PUBLIC BUNDLE_LUV_ICONS)
endif()

if(ANDROID)
    include_directories(
        ${CMAKE_CURRENT_SOURCE_DIR}/platforms/android
        ${CMAKE_CURRENT_BINARY_DIR}/platforms/android)

    target_include_directories(MauiKit${MAUI_MAJOR_VERSION} PRIVATE platforms/android)

elseif(WIN32)
    include_directories(
        ${CMAKE_CURRENT_SOURCE_DIR}/platforms/windows
        ${CMAKE_CURRENT_BINARY_DIR}/platforms/windows )
    target_include_directories(MauiKit${MAUI_MAJOR_VERSION} PRIVATE platforms/windows)
elseif(UNIX AND NOT APPLE)
    include_directories(
        ${CMAKE_CURRENT_SOURCE_DIR}/platforms/linux
        ${CMAKE_CURRENT_BINARY_DIR}/platforms/linux)
    target_include_directories(MauiKit${MAUI_MAJOR_VERSION} PRIVATE platforms/linux)

elseif(APPLE)
    # Temporarily share blur, shawdow implementation for Windows
    include_directories(
        ${CMAKE_CURRENT_SOURCE_DIR}/platforms/windows
        ${CMAKE_CURRENT_BINARY_DIR}/platforms/windows)
    # include_directories(
    #     ${CMAKE_CURRENT_SOURCE_DIR}/platforms/macos
    #     ${CMAKE_CURRENT_BINARY_DIR}/platforms/macos
    #     )
    target_include_directories(MauiKit${MAUI_MAJOR_VERSION} PRIVATE platforms/macos)
endif()

if(ANDROID)
    # target_link_libraries(MauiKit${MAUI_MAJOR_VERSION} PRIVATE Qt${QT_VERSION_MAJOR}::AndroidExtras jnigraphics)

    install(FILES platforms/android/mauiandroid.h DESTINATION ${KDE_INSTALL_INCLUDEDIR}/MauiKit${MAUI_MAJOR_VERSION} COMPONENT Devel)

    # install(DIRECTORY platforms/android/ DESTINATION ${KDE_INSTALL_DATAROOTDIR}/MauiKit${MAUI_MAJOR_VERSION}Android COMPONENT Devel)

    install(FILES MauiKit-android-dependencies.xml DESTINATION ${KDE_INSTALL_LIBDIR} RENAME MauiKit${MAUI_MAJOR_VERSION}-android-dependencies.xml)


    target_link_libraries(MauiKit${MAUI_MAJOR_VERSION}
        PRIVATE
        Qt${QT_MAJOR_VERSION}::CorePrivate)

elseif(UNIX AND NOT ANDROID)
    if(NOT APPLE)
        target_link_libraries(MauiKit${MAUI_MAJOR_VERSION}
            PRIVATE
            KF${KF_MAJOR_VERSION}::WindowSystem)
    endif()
endif()

target_link_libraries(MauiKit${MAUI_MAJOR_VERSION}
    PUBLIC
    Qt${QT_MAJOR_VERSION}::Core
    KF${KF_MAJOR_VERSION}::CoreAddons

    PRIVATE
    ${kwin_XCB_LIBS}
    MauiMan${MAUI_MAJOR_VERSION}::MauiMan${MAUI_MAJOR_VERSION}
    KF${KF_MAJOR_VERSION}::Notifications
    KF${KF_MAJOR_VERSION}::I18n
    Qt${QT_MAJOR_VERSION}::Multimedia
    Qt${QT_MAJOR_VERSION}::Qml
    Qt${QT_MAJOR_VERSION}::Svg
    Qt${QT_MAJOR_VERSION}::Widgets
    Qt${QT_MAJOR_VERSION}::Concurrent
    Qt${QT_MAJOR_VERSION}::QuickControls2)

#if (HAVE_OpenMP)
#    target_link_libraries(MauiKit${MAUI_MAJOR_VERSION} PUBLIC omp PRIVATE OpenMP::OpenMP_CXX)
#endif()

ecm_finalize_qml_module(MauiKit${MAUI_MAJOR_VERSION} DESTINATION ${KDE_INSTALL_QMLDIR})

# ecm_generate_qmltypes(org.mauikit.controls 1.3 DESTINATION ${KDE_INSTALL_QMLDIR}/org/mauikit/controls)

generate_export_header(MauiKit${MAUI_MAJOR_VERSION} BASE_NAME MauiKit)
install(TARGETS MauiKit${MAUI_MAJOR_VERSION} EXPORT MauiKit${MAUI_MAJOR_VERSION}Targets ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})

target_include_directories(MauiKit${MAUI_MAJOR_VERSION}
    INTERFACE "$<INSTALL_INTERFACE:${KDE_INSTALL_INCLUDEDIR}/MauiKit${MAUI_MAJOR_VERSION}/Core>")

target_include_directories(MauiKit${MAUI_MAJOR_VERSION} PUBLIC "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR};${CMAKE_CURRENT_BINARY_DIR};>")

install(FILES
    ${mauikit_HDRS}
    ${mauikit_PLATFORM_HDRS}
    ${CMAKE_CURRENT_BINARY_DIR}/mauikit_export.h
    DESTINATION ${KDE_INSTALL_INCLUDEDIR}/MauiKit${MAUI_MAJOR_VERSION}/Core
    COMPONENT Devel)

##INSTALL MAUI STYLE
add_subdirectory(style.6)

install(DIRECTORY csd.${QT_MAJOR_VERSION} DESTINATION ${KDE_INSTALL_DATADIR}/org.mauikit.controls)
