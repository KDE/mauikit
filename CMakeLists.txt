cmake_minimum_required(VERSION 3.16)

set(QT_DEFAULT_MAJOR_VERSION 6)
set(REQUIRED_QT_VERSION 5.15.2)
set(REQUIRED_KF5_VERSION 5.90.0)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(MAUIKIT_VERSION 2.2.2)

set(AUTOMOC_MOC_OPTIONS -Muri=org.mauikit.controls)

project(mauikit VERSION ${MAUIKIT_VERSION})

################# Disallow in-source build #################

if("${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_BINARY_DIR}")
   message(FATAL_ERROR "MauiKit requires an out of source build. Please create a separate build directory and run 'cmake path_to_mauikit [options]' there.")
endif()

if(ANDROID)
    set(ANDROID_PACKAGE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src/platforms/android)
    set(ANDROID_ABIS "armeabi-v7a")
endif()

find_package(ECM ${REQUIRED_KF5_VERSION} NO_MODULE)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH})

#DEFAULT COMPONENTS DEFINITIONS
include(GenerateExportHeader)
include(ECMSetupVersion)
include(ECMGenerateHeaders)
include(CMakePackageConfigHelpers)
include(ECMFindQmlModule)
include(KDEClangFormat)
include(KDEInstallDirs)
include(KDECMakeSettings)
include(ECMQtDeclareLoggingCategory)
#include(KDECompilerSettings NO_POLICY_SCOPE)

option(QUICK_COMPILER "Use QtQuick compiler to improve performance. QML sources won't be installed in the file system." ON)
option(BUNDLE_LUV_ICONS "Ship Luv icon them bundled." OFF)

if(ANDROID OR WIN32 OR APPLE)
set(QUICK_COMPILER ON)
set(BUNDLE_LUV_ICONS ON)
endif()

find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Concurrent QuickControls2 Qml Svg Widgets REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Concurrent QuickControls2 Qml Svg Widgets REQUIRED)

find_package(MauiMan 1.0.1 REQUIRED )

ecm_find_qmlmodule(QtGraphicalEffects 1.0)
ecm_find_qmlmodule(QtQuick.Shapes 1.0)

if(ANDROID)
    find_package(Qt${QT_MAJOR} REQUIRED COMPONENTS AndroidExtras)
    find_package(Gradle REQUIRED)
elseif(UNIX AND NOT ANDROID)
    if(NOT APPLE)
        # Do not find X11 on macOS
        find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS X11Extras)
        find_package(KF5 ${REQUIRED_KF5_VERSION} REQUIRED COMPONENTS WindowSystem)
        find_package(XCB 1.10 REQUIRED COMPONENTS
    ICCCM
    SHAPE
    XCB
)
set_package_properties(XCB PROPERTIES TYPE REQUIRED)

# and the optional XCB dependencies
#if (XCB_ICCCM_VERSION VERSION_LESS "0.4")
    #set(XCB_ICCCM_FOUND FALSE)
#endif()
#add_feature_info("XCB-ICCCM" XCB_ICCCM_FOUND "Required for building test applications for KWin")

#find_package(X11_XCB)
#set_package_properties(X11_XCB PROPERTIES
    #PURPOSE "Required for building X11 windowed backend of kwin_wayland"
    #TYPE OPTIONAL)
    
    endif()
endif()

find_package(KF5 ${REQUIRED_KF5_VERSION} REQUIRED COMPONENTS I18n CoreAddons Notifications)

if(QUICK_COMPILER)
        find_package(Qt5QuickCompiler)
        set_package_properties(Qt5QuickCompiler PROPERTIES
                DESCRIPTION "Compile QML at build time"
                TYPE OPTIONAL
        )
endif()

    add_definitions(-DTRANSLATION_DOMAIN="mauikit")
    ki18n_install(po)
    
    add_compile_definitions(QT_DISABLE_DEPRECATED_UP_TO=0x050F00)
    
add_subdirectory(src)
# add_subdirectory(demo)

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
feature_summary(WHAT ALL INCLUDE_QUIET_PACKAGES FATAL_ON_MISSING_REQUIRED_PACKAGES)
