include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}/utils
    ${CMAKE_CURRENT_BINARY_DIR}/utils

    ${CMAKE_CURRENT_SOURCE_DIR}/utils/models
    ${CMAKE_CURRENT_BINARY_DIR}/utils/models

    ${CMAKE_CURRENT_SOURCE_DIR}/utils/model_template
    ${CMAKE_CURRENT_BINARY_DIR}/utils/model_template

    ${CMAKE_CURRENT_SOURCE_DIR}/kde
    ${CMAKE_CURRENT_BINARY_DIR}/kde
    )

set(mauikit_SRCS
    mauikit.cpp
    utils/fmstatic.cpp
    utils/mauiapp.cpp
    utils/handy.cpp
    utils/models/pathlist.cpp
    utils/model_template/mauilist.cpp
    utils/model_template/mauimodel.cpp
    )

set(mauikit_HDRS
    mauikit.h
    utils/fmstatic.h
    utils/fmh.h
    utils/utils.h
    utils/handy.h
    utils/models/pathlist.h
    utils/mauiapp.h
    utils/model_template/mauilist.h
    utils/model_template/mauimodel.h
    )

if(MYDEFS MATCHES "^COMPONENT_ACCOUNTS=ON" OR MYDEFS MATCHES ";COMPONENT_ACCOUNTS=ON")
    message(STATUS "INCLUDING ACCOUNTS COMPONENT")

    include_directories(
        ${CMAKE_CURRENT_SOURCE_DIR}/utils/accounts
        ${CMAKE_CURRENT_BINARY_DIR}/utils/accounts
        )

    set(accounts_SRCS
        utils/accounts/mauiaccounts.cpp
        utils/accounts/accountsdb.cpp
        )

    set(accounts_HDRS
        utils/accounts/mauiaccounts.h
        utils/accounts/accountsdb.h
        )
    qt5_add_resources(accounts_RESOURCES ${CMAKE_CURRENT_SOURCE_DIR}/utils/accounts/accounts.qrc)
endif()

if(MYDEFS MATCHES "^COMPONENT_EDITOR=ON" OR MYDEFS MATCHES ";COMPONENT_EDITOR=ON")
    message(STATUS "INCLUDING EDITOR COMPONENT")
    set(editor_SRCS
        utils/editor/documenthandler.cpp
        utils/editor/syntaxhighlighterutil.cpp
        )

    set(editor_HDRS
        utils/editor/documenthandler.h
        utils/editor/syntaxhighlighterutil.h
        )

    include_directories(
        ${CMAKE_CURRENT_SOURCE_DIR}/utils/editor
        ${CMAKE_CURRENT_BINARY_DIR}/utils/editor
        )
endif()

if(MYDEFS MATCHES "^COMPONENT_FM=ON" OR MYDEFS MATCHES ";COMPONENT_FM=ON")
    message(STATUS "INCLUDING FM COMPONENT")

    set(fm_SRCS
        fm/fm.cpp
        fm/fmlist.cpp
        fm/placeslist.cpp
        )

    set(fm_HDRS
        fm/fm.h
        fm/fmlist.h
        fm/placeslist.h
        )
    include_directories(
        ${CMAKE_CURRENT_SOURCE_DIR}/fm
        ${CMAKE_CURRENT_BINARY_DIR}/fm
        )
endif()

if(MYDEFS MATCHES "^COMPONENT_TAGGING=ON" OR MYDEFS MATCHES ";COMPONENT_TAGGING=ON")
    message(STATUS "INCLUDING TAGGING COMPONENT")
    set(tagging_SRCS
        utils/tagging/tagging.cpp
        utils/tagging/tagdb.cpp
        utils/tagging/tagsmodel.cpp
        utils/tagging/tagslist.cpp
        )

    set(tagging_HDRS
        utils/tagging/tag.h
        utils/tagging/tagging.h
        utils/tagging/tagdb.h
        utils/tagging/tagsmodel.h
        utils/tagging/tagslist.h
        )
    qt5_add_resources(tagging_RESOURCES ${CMAKE_CURRENT_SOURCE_DIR}/utils/tagging/tagging.qrc)
    include_directories(
        ${CMAKE_CURRENT_SOURCE_DIR}/utils/tagging
        ${CMAKE_CURRENT_BINARY_DIR}/utils/tagging
        )
endif()

if(MYDEFS MATCHES "^COMPONENT_SYNCING=ON" OR MYDEFS MATCHES ";COMPONENT_SYNCING=ON")
    message(STATUS "INCLUDING SYNCING COMPONENT")
    set(syncing_SRCS
        utils/syncing/syncing.cpp
        utils/syncing/libwebdavclient/lib/WebDAVClient.cpp
        utils/syncing/libwebdavclient/lib/dto/WebDAVItem.cpp
        utils/syncing/libwebdavclient/lib/utils/Environment.cpp
        utils/syncing/libwebdavclient/lib/utils/NetworkHelper.cpp
        utils/syncing/libwebdavclient/lib/utils/WebDAVReply.cpp
        utils/syncing/libwebdavclient/lib/utils/XMLHelper.cpp
        )

    set(syncing_HDRS
        utils/syncing/syncing.h
        utils/syncing/libwebdavclient/lib/WebDAVClient.hpp
        utils/syncing/libwebdavclient/lib/dto/WebDAVItem.hpp
        utils/syncing/libwebdavclient/lib/utils/Environment.hpp
        utils/syncing/libwebdavclient/lib/utils/NetworkHelper.hpp
        utils/syncing/libwebdavclient/lib/utils/WebDAVReply.hpp
        utils/syncing/libwebdavclient/lib/utils/XMLHelper.hpp
        )
    include_directories(
        ${CMAKE_CURRENT_SOURCE_DIR}/utils/syncing
        ${CMAKE_CURRENT_BINARY_DIR}/utils/syncing
        ${CMAKE_CURRENT_SOURCE_DIR}/utils/syncing/libwebdavclient/lib
        ${CMAKE_CURRENT_SOURCE_DIR}/utils/syncing/libwebdavclient/lib/utils
        ${CMAKE_CURRENT_SOURCE_DIR}/utils/syncing/libwebdavclient/lib/dto
        )
endif()

if(MYDEFS MATCHES "^COMPONENT_STORE=ON" OR MYDEFS MATCHES ";COMPONENT_STORE=ON")
    message(STATUS "INCLUDING STORE COMPONENT")
    set(store_SRCS
        utils/store/store.cpp
        utils/store/storemodel.cpp
        utils/store/storelist.cpp
        )

    set(store_HDRS
        utils/store/store.h
        utils/store/storemodel.h
        utils/store/storelist.h
        )

    qt5_add_resources(store_RESOURCES ${CMAKE_CURRENT_SOURCE_DIR}/utils/store/store.qrc)

    include_directories(
        ${CMAKE_CURRENT_SOURCE_DIR}/utils/store
        ${CMAKE_CURRENT_BINARY_DIR}/utils/store
        )
endif()
#use dbus on linux, bsd etc, but not andoid and apple stuff

#options - for the appimage
option(IS_APPIMAGE_PACKAGE "If set to true then the icons and styled is packaged as well")

if(ANDROID OR IS_APPIMAGE_PACKAGE OR MAUIKIT_STYLE)
    qt5_add_resources(MauiIcon_RESOURCES ${CMAKE_SOURCE_DIR}/android/icons.qrc)
    qt5_add_resources(MauiStyle_RESOURCES ${CMAKE_SOURCE_DIR}/maui-style/style.qrc)

    if (NOT EXISTS ${CMAKE_SOURCE_DIR}/android/icons/luv-icon-theme/.git)
        find_package(Git REQUIRED)
        execute_process(COMMAND ${GIT_EXECUTABLE} clone --depth 1 https://github.com/milohr/luv-icon-theme.git ${CMAKE_SOURCE_DIR}/android/icons/luv-icon-theme)
    endif()

    set(mauikit_style_QRCS
        ${MauiIcon_RESOURCES}
        ${MauiStyle_RESOURCES}
        )
endif()

if (ANDROID)
    find_package(Gradle REQUIRED)
    add_subdirectory(android)

    find_package(Qt5 REQUIRED COMPONENTS AndroidExtras WebView)

    set(mauikit_Android_SRCS
        android/mauiandroid.cpp
    )

    kde_enable_exceptions(MauiKit PRIVATE)
else()
    find_package(Qt5 REQUIRED COMPONENTS WebEngine)

    set(mauikit_KDE_SRCS
        kde/mauikde.cpp
        kde/kdeconnect.cpp
        )

    set(mauikit_KDE_HDRS
        kde/mauikde.h
        kde/kdeconnect.h
        )
endif()

qt5_add_resources(mauikit_ASSETS ${CMAKE_SOURCE_DIR}/assets.qrc)
qt5_add_resources(mauikit_RESOURCES ${CMAKE_SOURCE_DIR}/mauikit.qrc)

add_library(MauiKit

    ${fm_HDRS}
    ${fm_SRCS}

    ${accounts_HDRS}
    ${accounts_SRCS}
    ${accounts_RESOURCES}

    ${editor_HDRS}
    ${editor_SRCS}

    ${syncing_HDRS}
    ${syncing_SRCS}

    ${store_SRCS}
    ${store_HDRS}
    ${store_RESOURCES}

    ${tagging_HDRS}
    ${tagging_SRCS}
    ${tagging_RESOURCES}

    ${mauikit_HDRS}
    ${mauikit_SRCS}
    ${mauikit_RESOURCES}
    ${mauikit_ASSETS}

    ${MauiIcon_RESOURCES}
    ${MauiStyle_RESOURCES}

    ${mauikit_Android_SRCS}

    ${mauikit_KDE_HDRS}
    ${mauikit_KDE_SRCS}
)

find_package(KF5 ${REQUIRED_KF5_VERSION} REQUIRED COMPONENTS I18n Notifications Config Service KIO ConfigWidgets)

if(ANDROID)
    target_link_libraries(MauiKit PRIVATE Qt5::AndroidExtras Qt5::WebView jnigraphics)

    target_include_directories(MauiKit PRIVATE android)
    install(FILES android/mauiandroid.h DESTINATION ${KDE_INSTALL_INCLUDEDIR}/MauiKit COMPONENT Devel)

    install(DIRECTORY android/ DESTINATION ${KDE_INSTALL_DATAROOTDIR}/MauiKitAndroid COMPONENT Devel)

    install(FILES MauiKit-android-dependencies.xml DESTINATION ${KDE_INSTALL_LIBDIR})

else()
    target_link_libraries(MauiKit PRIVATE Qt5::WebEngine)
endif()

target_link_libraries(MauiKit
    PUBLIC
    Qt5::Core
    Qt5::Sql
    Qt5::Gui
    KF5::Notifications
    KF5::I18n
    KF5::ConfigCore
    KF5::KIOCore
    KF5::KIOWidgets
    KF5::KIOFileWidgets

    PRIVATE
    Qt5::Qml
    Qt5::Quick
    Qt5::QuickControls2
    Qt5::Svg
    Qt5::Network
    Qt5::Xml
    KF5::Service
    KF5::KIONTLM
    KF5::ConfigWidgets
    )

if(MYDEFS MATCHES "^COMPONENT_EDITOR=ON" OR MYDEFS MATCHES ";COMPONENT_EDITOR=ON")
    find_package(KF5 ${REQUIRED_KF5_VERSION} REQUIRED COMPONENTS SyntaxHighlighting)
    target_link_libraries(MauiKit PRIVATE KF5::SyntaxHighlighting)
endif()

if(MYDEFS MATCHES "^COMPONENT_STORE=ON" OR MYDEFS MATCHES ";COMPONENT_STORE=ON")
    find_package(KF5 ${REQUIRED_KF5_VERSION} REQUIRED COMPONENTS Attica)
    target_link_libraries(MauiKit PUBLIC KF5::Attica)
endif()

if(IS_APPIMAGE_PACKAGE)
    target_compile_definitions(MauiKit PUBLIC APPIMAGE_PACKAGE)
endif()

generate_export_header(MauiKit BASE_NAME MauiKit)
install(TARGETS MauiKit EXPORT MauiKitTargets ${INSTALL_TARGETS_DEFAULT_ARGS})

target_include_directories(MauiKit
    INTERFACE "$<INSTALL_INTERFACE:${KDE_INSTALL_INCLUDEDIR}/MauiKit>")

add_custom_target(copy)

file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/bin/org/kde/mauikit)
add_custom_command(TARGET copy PRE_BUILD COMMAND ${CMAKE_COMMAND}
    -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/controls
    ${CMAKE_BINARY_DIR}/bin/org/kde/mauikit/)

add_dependencies(MauiKit copy)

install(DIRECTORY controls/ DESTINATION
    ${KDE_INSTALL_QMLDIR}/org/kde/mauikit)

install(TARGETS MauiKit DESTINATION
    ${KDE_INSTALL_QMLDIR}/org/kde/mauikit)

install(FILES
    ${mauikit_HDRS}
    ${mauikit_KDE_HDRS}
    ${tagging_HDRS}
    ${fm_HDRS}
    ${syncing_HDRS}
    ${store_HDRS}
    ${accounts_HDRS}
    ${CMAKE_CURRENT_BINARY_DIR}/mauikit_export.h
    DESTINATION ${KDE_INSTALL_INCLUDEDIR}/MauiKit
    COMPONENT Devel)

##INSTALL MAUI STYLE
install(DIRECTORY ${CMAKE_SOURCE_DIR}/maui-style DESTINATION ${KDE_INSTALL_QMLDIR}/QtQuick/Controls.2)