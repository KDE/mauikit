project(MauiStyle)

ecm_add_qml_module(MauiStyle
    URI "org.mauikit.style"
    CLASS_NAME MauiStylePlugin
    DEPENDENCIES
    "QtQuick.Controls")

target_sources(MauiStyle
    PRIVATE
    mauistyleplugin.cpp)

target_link_libraries(MauiStyle
    PRIVATE
    Qt::Core
    Qt::Gui
    Qt::Qml
    Qt::Quick)

add_subdirectory(impl)
add_subdirectory(qtquickcontrols)

ecm_finalize_qml_module(MauiStyle DESTINATION ${KDE_INSTALL_QMLDIR})
