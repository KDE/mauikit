cmake_minimum_required(VERSION 3.16)

project(MauiDemo VERSION ${MAUIKIT_VERSION} LANGUAGES CXX)

#find_package(MauiKit REQUIRED)
find_package(Qt${QT_MAJOR_VERSION} REQUIRED COMPONENTS
    Core
    Qml
    Quick)

find_package(KF${KF_MAJOR_VERSION} REQUIRED COMPONENTS
    I18n
    CoreAddons)

include(KDEInstallDirs)

add_subdirectory(src)

#TODO: port to ecm_install_icons()
install(FILES src/assets/mauidemo.svg DESTINATION ${KDE_INSTALL_ICONDIR}/hicolor/scalable/apps)
install(FILES src/org.kde.mauidemo.desktop DESTINATION ${KDE_INSTALL_APPDIR})

# install(FILES org.kde.index.appdata.xml DESTINATION ${KDE_INSTALL_METAINFODIR})

feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)
