cmake_minimum_required(VERSION 3.16)

project(MauiDemo VERSION ${MAUIKIT_VERSION} LANGUAGES CXX)
add_compile_definitions(APP_COPYRIGHT_NOTICE="© 2023-2024 Maui Development Team")

#find_package(MauiKit REQUIRED)
find_package(Qt${QT_MAJOR_VERSION} REQUIRED COMPONENTS
    Core
    Qml
    Quick)

find_package(KF${KF_MAJOR_VERSION} REQUIRED COMPONENTS
    I18n
    CoreAddons)

include(KDEInstallDirs)
include(ECMSourceVersionControl)

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
    add_definitions(-DGIT_COMMIT_HASH="${SHELF_VERSION}")
    add_definitions(-DGIT_BRANCH="Stable")
endif()

add_subdirectory(src)

#TODO: port to ecm_install_icons()
install(FILES src/assets/mauidemo.svg DESTINATION ${KDE_INSTALL_ICONDIR}/hicolor/scalable/apps)
install(FILES src/org.kde.mauidemo.desktop DESTINATION ${KDE_INSTALL_APPDIR})

# install(FILES org.kde.index.appdata.xml DESTINATION ${KDE_INSTALL_METAINFODIR})

feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)
