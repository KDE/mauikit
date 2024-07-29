project(MauiStyle)

ecm_add_qml_module(MauiStyle
    URI "org.mauikit.style"
    # CLASS_NAME MauiStylePlugin
    GENERATE_PLUGIN_SOURCE
    DESIGNER_SUPPORTED
    DEPENDENCIES
    "QtQuick.Controls"
    "org.mauikit.controls")

# target_sources(MauiStyle
#     PRIVATE
#     mauistyleplugin.cpp)

ecm_target_qml_sources(MauiStyle SOURCES
    qtquickcontrols/ApplicationWindow.qml
    qtquickcontrols/BusyIndicator.qml
    qtquickcontrols/Button.qml
    qtquickcontrols/CheckBox.qml
    qtquickcontrols/CheckIndicator.qml
    qtquickcontrols/ComboBox.qml
    qtquickcontrols/Container.qml
    qtquickcontrols/Control.qml
    qtquickcontrols/Dial.qml
    qtquickcontrols/Dialog.qml
    qtquickcontrols/DialogButtonBox.qml
    qtquickcontrols/Drawer.qml
    qtquickcontrols/Frame.qml
    qtquickcontrols/GroupBox.qml
    qtquickcontrols/ItemDelegate.qml
    qtquickcontrols/Label.qml
    qtquickcontrols/Menu.qml
    qtquickcontrols/MenuItem.qml
    qtquickcontrols/MenuSeparator.qml
    qtquickcontrols/Page.qml
    qtquickcontrols/Pane.qml
    qtquickcontrols/Popup.qml
    qtquickcontrols/ProgressBar.qml
    qtquickcontrols/RadioButton.qml
    qtquickcontrols/RadioDelegate.qml
    qtquickcontrols/RadioIndicator.qml
    qtquickcontrols/RangeSlider.qml
    qtquickcontrols/ScrollBar.qml
    qtquickcontrols/ScrollView.qml
    qtquickcontrols/Slider.qml
    qtquickcontrols/SpinBox.qml
    qtquickcontrols/SplitView.qml
    qtquickcontrols/StackView.qml
    qtquickcontrols/SwipeView.qml
    qtquickcontrols/Switch.qml
    qtquickcontrols/SwitchDelegate.qml
    qtquickcontrols/SwitchIndicator.qml
    qtquickcontrols/TabBar.qml
    qtquickcontrols/TabButton.qml
    qtquickcontrols/TextArea.qml
    qtquickcontrols/TextField.qml
    qtquickcontrols/ToolBar.qml
    qtquickcontrols/ToolButton.qml
    qtquickcontrols/ToolSeparator.qml
    qtquickcontrols/ToolTip.qml
    qtquickcontrols/Tumbler.qml)

ecm_target_qml_sources(MauiStyle PATH private SOURCES
    qtquickcontrols/private/DefaultListItemBackground.qml
    qtquickcontrols/private/MobileCursor.qml
)

target_link_libraries(MauiStyle
    PRIVATE
    Qt::Core
    Qt::Gui
    Qt::Qml
    Qt::Quick)

# add_subdirectory(impl)
# add_subdirectory(qtquickcontrols)

ecm_finalize_qml_module(MauiStyle DESTINATION ${KDE_INSTALL_QMLDIR})
