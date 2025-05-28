cmake_minimum_required(VERSION 3.16)

project(MauiKitApp VERSION 1.0 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(ECM NO_MODULE)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH})

find_package(Qt6 6.2 COMPONENTS Quick Qml REQUIRED)
find_package(KF6 COMPONENTS I18n CoreAddons)
find_package(MauiKit4)

qt_policy(SET QTP0001 OLD)

qt_add_executable(MauiKitApp
    main.cpp)

qt_add_qml_module(MauiKitApp
    URI mauikitapp
    VERSION 1.0
    QML_FILES main.qml)

target_link_libraries(MauiKitApp
    PRIVATE Qt6::Quick Qt6::Qml KF6::I18n KF6::CoreAddons MauiKit4)

install(TARGETS MauiKitApp
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
