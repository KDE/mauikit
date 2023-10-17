cmake_minimum_required(VERSION 3.16)

project(untitled1-6 VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(ECM NO_MODULE)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH})

find_package(Qt6 6.2 COMPONENTS Quick Qml REQUIRED)
find_package(KF6 COMPONENTS I18n CoreAddons)
find_package(MauiKit4)

qt_add_executable(appuntitled1-6
    main.cpp
    plantslist.cpp
)

qt_add_qml_module(appuntitled1-6
    URI untitled1-6
    VERSION 1.0
    QML_FILES main.qml 
)

set_target_properties(appuntitled1-6 PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appuntitled1-6
    PRIVATE Qt6::Quick Qt6::Qml KF6::I18n KF6::CoreAddons MauiKit4)

install(TARGETS appuntitled1-6
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
