cmake_minimum_required(VERSION 3.16)

project(MauiDemo VERSION 3.0.0 LANGUAGES CXX)

#find_package(MauiKit REQUIRED)
#find_package(Qt6 6.2 COMPONENTS Quick REQUIRED)
#find_package(KF6 REQUIRED COMPONENTS I18n CoreAddons)
include(KDEInstallDirs)

add_subdirectory(src)

#TODO: port to ecm_install_icons()
install(FILES src/assets/mauidemo.svg DESTINATION ${KDE_INSTALL_ICONDIR}/hicolor/scalable/apps)
install(FILES src/org.kde.mauidemo.desktop DESTINATION ${KDE_INSTALL_APPDIR})

# install(FILES org.kde.index.appdata.xml DESTINATION ${KDE_INSTALL_METAINFODIR})

feature_summary(WHAT ALL   FATAL_ON_MISSING_REQUIRED_PACKAGES)
