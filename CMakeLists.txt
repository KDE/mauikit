cmake_minimum_required(VERSION 3.16)

set(REQUIRED_QT_VERSION 5.14.0)
set(REQUIRED_KF5_VERSION 5.40.0)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(UNIX)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Werror")
endif()

#set(CMAKE_CXX_VISIBILITY_PRESET hidden)
#set(CMAKE_VISIBILITY_INLINES_HIDDEN TRUE)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(MAUIKIT_VERSION 2.1.1)

set(AUTOMOC_MOC_OPTIONS -Muri=org.mauikit.controls)

project(mauikit VERSION ${MAUIKIT_VERSION})

find_package(ECM ${REQUIRED_KF5_VERSION} NO_MODULE)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH} 
    ${ECM_KDE_MODULE_DIR})

#DEFAULT COMPONENTS DEFINITIONS
include(GenerateExportHeader)
include(ECMSetupVersion)
include(ECMGenerateHeaders)
include(CMakePackageConfigHelpers)
include(ECMPoQmTools)
include(ECMQMLModules)
include(KDEClangFormat)
include(KDEInstallDirs)
include(KDECMakeSettings)
include(ECMQtDeclareLoggingCategory)
include(ECMAddQch)
#include(KDECompilerSettings NO_POLICY_SCOPE)

option(QUICK_COMPILER "Use QtQuick compiler to improve performance. QML sources won't be installed in the file system." TRUE)
option(BUNDLE_MAUI_STYLE "Ship Maui Style bundled, maui-style won't be installed in the file system." OFF)
option(BUNDLE_LUV_ICONS "Ship Luv icon them bundled." OFF)

if(ANDROID OR WIN32 OR APPLE)
set(QUICK_COMPILER TRUE)
set(BUNDLE_MAUI_STYLE TRUE)
set(BUNDLE_LUV_ICONS TRUE)
endif()

find_package(Qt5 ${REQUIRED_QT_VERSION} REQUIRED NO_MODULE COMPONENTS Qml Core Widgets QuickControls2 Svg) #Qt5::Svg needed to render icons on android
    
ecm_find_qmlmodule(QtGraphicalEffects 1.0)
ecm_find_qmlmodule(QtQuick.Shapes 1.0)

if(ANDROID)
    find_package(Qt5 REQUIRED COMPONENTS AndroidExtras)
    find_package(Gradle REQUIRED)
elseif(UNIX AND NOT ANDROID)
    find_package(Qt5 ${REQUIRED_QT_VERSION} REQUIRED COMPONENTS X11Extras)
    find_package(KF5 ${REQUIRED_KF5_VERSION} REQUIRED COMPONENTS Config WindowSystem)
endif()

find_package(KF5 ${REQUIRED_KF5_VERSION} REQUIRED COMPONENTS I18n CoreAddons Notifications)

if(QUICK_COMPILER)
        find_package(Qt5QuickCompiler)
        set_package_properties(Qt5QuickCompiler PROPERTIES
                DESCRIPTION "Compile QML at build time"
                TYPE OPTIONAL
        )
endif()

add_subdirectory(src)

##CMAKE PARTS
set(CMAKECONFIG_INSTALL_DIR "${KDE_INSTALL_CMAKEPACKAGEDIR}/MauiKit")

ecm_setup_version(${MAUIKIT_VERSION}
    VARIABLE_PREFIX MAUIKIT
    VERSION_HEADER "${CMAKE_CURRENT_BINARY_DIR}/mauikit_version.h"
    PACKAGE_VERSION_FILE "${CMAKE_CURRENT_BINARY_DIR}/MauiKitConfigVersion.cmake"
    SOVERSION ${PROJECT_VERSION_MAJOR}
    )

configure_package_config_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/MauiKitConfig.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/MauiKitConfig.cmake"
    INSTALL_DESTINATION  ${CMAKECONFIG_INSTALL_DIR}
    PATH_VARS  KF5_INCLUDE_INSTALL_DIR CMAKE_INSTALL_PREFIX
    )

install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/MauiKitConfig.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/MauiKitConfigVersion.cmake"
    DESTINATION "${CMAKECONFIG_INSTALL_DIR}"
    COMPONENT Devel
    )

install(EXPORT MauiKitTargets
    DESTINATION "${CMAKECONFIG_INSTALL_DIR}"
    FILE MauiKitTargets.cmake
    )

file(GLOB_RECURSE ALL_CLANG_FORMAT_SOURCE_FILES *.cpp *.h)
kde_clang_format(${ALL_CLANG_FORMAT_SOURCE_FILES})
