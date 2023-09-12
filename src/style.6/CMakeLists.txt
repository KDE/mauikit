project(MauiStyle)

ecm_add_qml_module(
	MauiStyle
	URI "org.mauikit.style"
	CLASS_NAME MauiStylePlugin
	DEPENDENCIES
		"QtQuick.Controls 2.15"
		"org.kde.kirigami 2.14"
)

target_sources(MauiStyle PRIVATE
    mauistyleplugin.cpp
)

target_link_libraries(MauiStyle
    Qt::Core
    Qt::Gui
    Qt::Qml
    Qt::Quick
    Qt::QuickControls2
    Qt::QuickTemplates2
)

add_subdirectory(impl)
add_subdirectory(qtquickcontrols)

ecm_finalize_qml_module(MauiStyle DESTINATION ${KDE_INSTALL_QMLDIR})
