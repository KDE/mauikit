qt_policy(SET QTP0001 NEW)

qt_add_executable(${PROJECT_NAME}
    demo_assets.qrc
    main.cpp
)

set(QML_SRCS
    main.qml
    controls/ButtonsPage.qml
    controls/DemoPage.qml
    controls/DemoSection.qml
)

qt_add_qml_module(${PROJECT_NAME}
    URI ${PROJECT_NAME}
    VERSION 3.0
    QML_FILES ${QML_SRCS}
)

if (ANDROID)
    find_package(Qt5 REQUIRED COMPONENTS AndroidExtras)
    target_link_libraries(${PROJECT_NAME} Qt6::AndroidExtras)
endif()

if (TARGET create-apk-mauidemo)
    set_target_properties(create-apk-mauidemo PROPERTIES ANDROID_APK_DIR "${MAUIKIT_ANDROID_DIR}")
endif()

target_link_libraries(${PROJECT_NAME} PRIVATE MauiKit Qt6::Quick KF6::CoreAddons KF6::I18n)

install(TARGETS ${PROJECT_NAME} ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})
install(FILES org.kde.mauidemo.desktop DESTINATION ${KDE_INSTALL_APPDIR})

