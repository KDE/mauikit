qt_policy(SET QTP0001 NEW)

qt_add_executable(${PROJECT_NAME}${MAUI_MAJOR_VERSION}
    demo_assets.qrc
    main.cpp
)

set(QML_SRCS
    main.qml
    controls/ButtonsPage.qml
    controls/InputsPage.qml
    controls/MauiPage.qml
    controls/DemoPage.qml
    controls/DemoSection.qml
    controls/SplitViewPage.qml
    controls/SideBarViewPage.qml
    controls/AppViewsPage.qml
    controls/IndicatorsPage.qml
    controls/ListBrowserPage.qml
    controls/GridBrowserPage.qml
    controls/TemplatesPage.qml
    controls/BarsPage.qml
    controls/TabViewPage.qml
    controls/DelegatesPage.qml
    controls/ImagePage.qml
    controls/AltBrowserPage.qml
    controls/PopupsPage.qml
    controls/OthersPage.qml
)

if(${QT_MAJOR_VERSION} STREQUAL 6)
	qt6_add_qml_module(${PROJECT_NAME}${MAUI_MAJOR_VERSION}
		URI ${PROJECT_NAME}${MAUI_MAJOR_VERSION}
		VERSION 3.0
		QML_FILES ${QML_SRCS}
	)
else()
	qt_add_qml_module(${PROJECT_NAME}${MAUI_MAJOR_VERSION}
		URI ${PROJECT_NAME}${MAUI_MAJOR_VERSION}
		VERSION 3.0
		QML_FILES ${QML_SRCS}
	)
endif()

if (ANDROID)
    find_package(Qt${QT_MAJOR_VERSION} REQUIRED COMPONENTS AndroidExtras)
    target_link_libraries(${PROJECT_NAME}${MAUI_MAJOR_VERSION} Qt${QT_MAJOR_VERSION}::AndroidExtras)
endif()

if (TARGET create-apk-mauidemo)
    set_target_properties(create-apk-mauidemo PROPERTIES ANDROID_APK_DIR "${MAUIKIT_ANDROID_DIR}")
endif()

target_link_libraries(${PROJECT_NAME}${MAUI_MAJOR_VERSION}
    PRIVATE
    MauiKit${MAUI_MAJOR_VERSION}
    Qt${QT_MAJOR_VERSION}::Quick
    Qt${QT_MAJOR_VERSION}::Qml
    KF${KF_MAJOR_VERSION}::CoreAddons
    KF${KF_MAJOR_VERSION}::I18n)

install(TARGETS ${PROJECT_NAME}${MAUI_MAJOR_VERSION} ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})

