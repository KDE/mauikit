cmake_minimum_required(VERSION 3.16)

project(MauiDemo VERSION 3.0.0 LANGUAGES CXX)

#find_package(MauiKit REQUIRED)
#find_package(Qt6 6.2 COMPONENTS Quick REQUIRED)
#find_package(KF6 REQUIRED COMPONENTS I18n CoreAddons)

qt_add_executable(${PROJECT_NAME}
#    src/assets.qrc
    src/main.cpp
    )

qt_add_qml_module(${PROJECT_NAME}
    URI ${PROJECT_NAME}
    VERSION 3.0
    QML_FILES main.qml
)

if (ANDROID)
    find_package(Qt5 REQUIRED COMPONENTS AndroidExtras)

    target_link_libraries(${PROJECT_NAME} Qt6::AndroidExtras)
    kde_source_files_enable_exceptions(index src/index.cpp)
endif()

if (TARGET create-apk-mauidemo)
    set_target_properties(create-apk-mauidemo PROPERTIES ANDROID_APK_DIR "${MAUIKIT_ANDROID_DIR}")
endif()

target_link_libraries(${PROJECT_NAME} PRIVATE MauiKit Qt6::Quick KF6::CoreAddons KF6::I18n)

install(TARGETS ${PROJECT_NAME} ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})
install(FILES src/org.kde.mauidemo.desktop DESTINATION ${KDE_INSTALL_APPDIR})

#TODO: port to ecm_install_icons()
# install(FILES src/assets/mauidemo.svg DESTINATION ${KDE_INSTALL_ICONDIR}/hicolor/scalable/apps)
# install(FILES org.kde.index.appdata.xml DESTINATION ${KDE_INSTALL_METAINFODIR})

feature_summary(WHAT ALL   FATAL_ON_MISSING_REQUIRED_PACKAGES)
