project(MauiStyle)

install(FILES qmldir DESTINATION ${KDE_INSTALL_QMLDIR}/QtQuick/Controls/Maui)
file(GLOB qtquickcontrolsfiles
    RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}"
    CONFIGURE_DEPENDS
    "*.qml"
)
install(FILES ${qtquickcontrolsfiles} DESTINATION ${KDE_INSTALL_QMLDIR}/QtQuick/Controls/Maui)
install(DIRECTORY private DESTINATION ${KDE_INSTALL_QMLDIR}/QtQuick/Controls/Maui)
