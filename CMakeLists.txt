cmake_minimum_required(VERSION 3.16)

# set(QT_DEFAULT_MAJOR_VERSION 6)
set(QT_MAJOR_VERSION 6)

if (QT_MAJOR_VERSION STREQUAL "6")
    set(REQUIRED_QT_VERSION 6.4)
    set(REQUIRED_KF_VERSION 5.240.0)
    set(KF_MAJOR_VERSION 6)
else()
    set(REQUIRED_KF_VERSION 5.90.0)
    set(KF_MAJOR_VERSION 5)
endif()

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(MAUIKIT_VERSION 3.0.1)
set(MAUIKIT_URI org.mauikit.controls)

set(AUTOMOC_MOC_OPTIONS -Muri=${MAUIKIT_URI})

project(mauikit VERSION ${MAUIKIT_VERSION})

################# Disallow in-source build #################

# if("${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_BINARY_DIR}")
#    message(FATAL_ERROR "MauiKit requires an out of source build. Please create a separate build directory and run 'cmake path_to_mauikit [options]' there.")
# endif()

if(ANDROID)
    set(ANDROID_PACKAGE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src/platforms/android)
    set(ANDROID_ABIS "armeabi-v7a")
endif()

find_package(ECM ${REQUIRED_KF_VERSION} NO_MODULE)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH})

#DEFAULT COMPONENTS DEFINITIONS
include(GenerateExportHeader)
include(CMakePackageConfigHelpers)

include(ECMSetupVersion)
include(ECMGenerateHeaders)
include(ECMFindQmlModule)
include(ECMQmlModule)
include(ECMGenerateQmlTypes)
include(KDEClangFormat)
include(KDEInstallDirs)
include(KDECMakeSettings)

##option to be removed in qt6 migration
option(QUICK_COMPILER "Use QtQuick compiler to improve performance. QML sources won't be installed in the file system." ON)
option(BUNDLE_LUV_ICONS "Ship Luv icon bundled." OFF)

if(ANDROID OR WIN32 OR APPLE)
set(QUICK_COMPILER ON)
set(BUNDLE_LUV_ICONS ON)
endif()

find_package(Qt${QT_MAJOR_VERSION} REQUIRED COMPONENTS
    Core
    Concurrent
    Qml
    Quick
    QuickControls2
    Svg
    Widgets
)

find_package(KF${KF_MAJOR_VERSION} REQUIRED COMPONENTS
    I18n
    CoreAddons
    Notifications
)

find_package(MauiMan 1.0.1 REQUIRED)
set_package_properties(MauiMan PROPERTIES
    TYPE REQUIRED
    DESCRIPTION "MauiMan is a server and API for syncing global system setting preferences."
    URL "https://invent.kde.org/maui/mauiman"
    PURPOSE "Sync to system setting preferences."
)

ecm_find_qmlmodule(QtQuick.Effects 1.0)
ecm_find_qmlmodule(QtQuick.Shapes 1.0)

if(ANDROID)
    find_package(Qt${QT_MAJOR_VERSION} REQUIRED COMPONENTS AndroidExtras)
    find_package(Gradle REQUIRED)
elseif(UNIX AND NOT ANDROID)
    if(NOT APPLE)
        # Do not find X11 on macOS
         if (QT_MAJOR_VERSION STREQUAL "5")
        find_package(Qt5 REQUIRED COMPONENTS X11Extras)
    endif()
        find_package(KF${KF_MAJOR_VERSION} ${REQUIRED_KF_VERSION} REQUIRED COMPONENTS WindowSystem)
        
        find_package(XCB 1.10 REQUIRED COMPONENTS
    ICCCM
    SHAPE
    XCB
)
set_package_properties(XCB PROPERTIES TYPE REQUIRED)   
    endif()
endif()

if (QT_MAJOR_VERSION STREQUAL "5")
    if(QUICK_COMPILER)
            find_package(Qt5QuickCompiler)
            set_package_properties(Qt5QuickCompiler PROPERTIES
                    DESCRIPTION "Compile QML at build time"
                    TYPE OPTIONAL
            )
    endif()
endif()

##Translations stuff with KI18n
    add_definitions(-DTRANSLATION_DOMAIN="mauikit")
    ki18n_install(po)
    
#    add_compile_definitions(QT_DISABLE_DEPRECATED_UP_TO=0x050F00)
    
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
    PATH_VARS CMAKE_INSTALL_PREFIX
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
##Clang formatting
    file(GLOB_RECURSE ALL_CLANG_FORMAT_SOURCE_FILES *.cpp *.h)
kde_clang_format(${ALL_CLANG_FORMAT_SOURCE_FILES})

feature_summary(WHAT ALL INCLUDE_QUIET_PACKAGES FATAL_ON_MISSING_REQUIRED_PACKAGES)
