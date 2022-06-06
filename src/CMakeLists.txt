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
    utils/model_template/mauilist.cpp
    utils/model_template/mauimodel.cpp
    platforms/abstractplatform.cpp
    platforms/platform.cpp
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
    utils/model_template/mauilist.h
    utils/model_template/mauimodel.h
    controls/libs/appview.h
    controls/libs/tabview.h
    controls/libs/style.h
    platforms/abstractplatform.h
    platforms/platform.h
    )

if(QUICK_COMPILER)
        qtquick_compiler_add_resources(mauikit_QML_QRC mauikit.qrc maui-style/style.qrc)
else()
        qt5_add_resources(mauikit_QML_QRC mauikit.qrc maui-style/style.qrc)
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
    #   add_subdirectory(platforms/android)

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

add_library(MauiKit

    SHARED
    ${mauikit_HDRS}
    ${mauikit_SRCS}

    ${mauikit_PLATFORM_HDRS}
    ${mauikit_PLATFORM_SRCS}

    ${window_PLATFORM_HDRS}
    ${window_PLATFORM_SRCS}

    assets.qrc
    ${mauikit_QML_QRC}
    )

if(QUICK_COMPILER)
    add_definitions(-DQUICK_COMPILER)
    target_compile_definitions(MauiKit PUBLIC QUICK_COMPILER)
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

#    add_subdirectory(platforms/android)

    target_link_libraries(MauiKit PRIVATE Qt5::AndroidExtras jnigraphics)

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
        MauiMan
        KF5::WindowSystem
        Qt5::X11Extras
        )
    endif()
    target_link_libraries(MauiKit PRIVATE KF5::ConfigCore)
endif()

target_link_libraries(MauiKit
    PUBLIC
    Qt5::Core
    KF5::I18n
    KF5::CoreAddons

    PRIVATE
    KF5::Notifications
    Qt5::Qml
    Qt5::Svg
    Qt5::Widgets
    Qt5::Concurrent
    Qt5::QuickControls2
    )

generate_export_header(MauiKit BASE_NAME MauiKit)
install(TARGETS MauiKit EXPORT MauiKitTargets ${INSTALL_TARGETS_DEFAULT_ARGS})

target_include_directories(MauiKit
    INTERFACE "$<INSTALL_INTERFACE:${KDE_INSTALL_INCLUDEDIR}/MauiKit/Core>")

add_custom_target(copy)

file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/bin/org/mauikit/controls)
add_custom_command(TARGET copy PRE_BUILD COMMAND ${CMAKE_COMMAND}
    -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/controls
    ${CMAKE_BINARY_DIR}/bin/org/mauikit/controls)

add_dependencies(MauiKit copy)

if(QUICK_COMPILER AND NOT ANDROID)
    install(FILES controls/qmldir DESTINATION ${KDE_INSTALL_QMLDIR}/org/mauikit/controls)
else()
    install(DIRECTORY controls/ DESTINATION ${KDE_INSTALL_QMLDIR}/org/mauikit/controls)
endif()

install(TARGETS MauiKit DESTINATION ${KDE_INSTALL_QMLDIR}/org/mauikit/controls)

install(FILES
    ${mauikit_HDRS}
    ${mauikit_PLATFORM_HDRS}
    ${CMAKE_CURRENT_BINARY_DIR}/mauikit_export.h
    DESTINATION ${KDE_INSTALL_INCLUDEDIR}/MauiKit/Core
    COMPONENT Devel)

##INSTALL THE DECO FOR CSD
install(DIRECTORY csd DESTINATION ${DATA_INSTALL_DIR}/org.mauikit.controls)
