# SPDX-FileCopyrightText: 2020 Camilo Higuita <milo.h@aol.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later

cmake_minimum_required(VERSION 3.16)

set(QT_MAJOR_VERSION 6)
set(REQUIRED_QT_VERSION 6.4)

set(KF_MAJOR_VERSION 6)
set(REQUIRED_KF_VERSION 5.240.0)

set(MAUI_MAJOR_VERSION 4)
set(MAUIKIT_VERSION 4.0.0)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

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
include(ECMSourceVersionControl)

include(KDEClangFormat)
include(KDEInstallDirs)
include(KDECMakeSettings)

option(BUILD_DEMO "Build the MauiKit Demo application." OFF)
option(BUNDLE_LUV_ICONS "Ship Luv icon bundled." OFF)

if(ANDROID OR WIN32 OR APPLE)
    set(BUNDLE_LUV_ICONS ON)
endif()

find_package(Qt${QT_MAJOR_VERSION} ${REQUIRED_QT_VERSION} REQUIRED COMPONENTS
    Core
    Concurrent
    Multimedia
    Qml
    Quick
    QuickControls2
    Svg
    Widgets)

find_package(KF${KF_MAJOR_VERSION} ${REQUIRED_KF_VERSION} REQUIRED COMPONENTS
    I18n
    CoreAddons
    Notifications)

find_package(MauiMan${MAUI_MAJOR_VERSION} ${MAUIKIT_VERSION} REQUIRED)
set_package_properties(MauiMan${MAUI_MAJOR_VERSION} PROPERTIES
    TYPE REQUIRED
    DESCRIPTION "MauiMan is a server and API for syncing global system setting preferences."
    URL "https://invent.kde.org/maui/mauiman"
    PURPOSE "Synced system setting preferences.")

#    find_package(OpenMP)
#set_package_properties(OpenMP
#    PROPERTIES DESCRIPTION "Multi-platform shared-memory parallel programming in C/C++ and Fortran"
#    TYPE OPTIONAL
#    PURPOSE "Accelerates palette generation in Kirigami.ImageColors"
#)
#if(OpenMP_CXX_FOUND)
#    set(HAVE_OpenMP TRUE)
#    set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
#endif()

#include_directories("${CMAKE_CURRENT_BINARY_DIR}")
#configure_file(config-OpenMP.h.cmake ${CMAKE_CURRENT_BINARY_DIR}/config-OpenMP.h)

ecm_find_qmlmodule(QtQuick.Shapes 1.0)

#if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
#    # link time optimization has been observed to break colors. Force-disable it.
#    # Before undoing this make double sure the lockscreen
#    # and logout screen are correctly colored in light/dark mode!
#    add_compile_options("-fno-lto")
#endif()

if(ANDROID)
    find_package(Gradle REQUIRED)
elseif(UNIX AND NOT ANDROID)
    if(NOT APPLE)
        find_package(KF${KF_MAJOR_VERSION} REQUIRED COMPONENTS WindowSystem)

        find_package(XCB 1.10 REQUIRED COMPONENTS
            ICCCM
            SHAPE
            XCB)
        set_package_properties(XCB PROPERTIES TYPE REQUIRED)
    endif()
endif()

if(${ECM_SOURCE_UNDER_VERSION_CONTROL})
    execute_process(
        COMMAND git rev-parse --abbrev-ref HEAD
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        OUTPUT_VARIABLE GIT_BRANCH
        OUTPUT_STRIP_TRAILING_WHITESPACE)

    # Get the latest abbreviated commit hash of the working branch
    execute_process(
        COMMAND git log -1 --format=%h
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        OUTPUT_VARIABLE GIT_COMMIT_HASH
        OUTPUT_STRIP_TRAILING_WHITESPACE)

    add_definitions(-DGIT_COMMIT_HASH="${GIT_COMMIT_HASH}")
    add_definitions(-DGIT_BRANCH="${GIT_BRANCH}")
else()
    add_definitions(-DGIT_COMMIT_HASH="${PROJECT_VERSION}")
    add_definitions(-DGIT_BRANCH="Stable")
endif()

##CMAKE PARTS
set(CMAKECONFIG_INSTALL_DIR "${KDE_INSTALL_CMAKEPACKAGEDIR}/MauiKit${MAUI_MAJOR_VERSION}")

ecm_setup_version(${MAUIKIT_VERSION}
    VARIABLE_PREFIX MAUIKIT
    VERSION_HEADER "${CMAKE_CURRENT_BINARY_DIR}/mauikit_version.h"
    PACKAGE_VERSION_FILE "${CMAKE_CURRENT_BINARY_DIR}/MauiKit${MAUI_MAJOR_VERSION}ConfigVersion.cmake"
    SOVERSION ${PROJECT_VERSION_MAJOR})

configure_package_config_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/MauiKitConfig.cmake.in.${QT_MAJOR_VERSION}"
    "${CMAKE_CURRENT_BINARY_DIR}/MauiKit${MAUI_MAJOR_VERSION}Config.cmake"
    INSTALL_DESTINATION ${CMAKECONFIG_INSTALL_DIR}
    PATH_VARS CMAKE_INSTALL_PREFIX)

install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/MauiKit${MAUI_MAJOR_VERSION}Config.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/MauiKit${MAUI_MAJOR_VERSION}ConfigVersion.cmake"
    DESTINATION "${CMAKECONFIG_INSTALL_DIR}"
    COMPONENT Devel)

install(EXPORT MauiKit${MAUI_MAJOR_VERSION}Targets
    DESTINATION "${CMAKECONFIG_INSTALL_DIR}"
    FILE MauiKit${MAUI_MAJOR_VERSION}Targets.cmake)

##Translations stuff with KI18n
add_definitions(-DTRANSLATION_DOMAIN="mauikit")
ki18n_install(po)

add_compile_definitions(QT_DISABLE_DEPRECATED_UP_TO=0x050F00)

add_subdirectory(src)

if(BUILD_DEMO AND NOT ANDROID)
    add_subdirectory(demo.6)
endif()

##Clang formatting
file(GLOB_RECURSE ALL_CLANG_FORMAT_SOURCE_FILES *.cpp *.h)
kde_clang_format(${ALL_CLANG_FORMAT_SOURCE_FILES})

feature_summary(WHAT ALL INCLUDE_QUIET_PACKAGES FATAL_ON_MISSING_REQUIRED_PACKAGES)
