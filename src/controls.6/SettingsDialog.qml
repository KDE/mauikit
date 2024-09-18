import QtQuick.Controls
import QtQuick.Layouts
import QtQuick

import org.mauikit.controls as Maui

/**
 * @inherit QtQuick.Loader
 *
 * @brief A popup page with a scrollable vertical layout, and support for a stack of multiple pages.
 * The default container fo this control is a MauiKit SettingsPage, and the popup will snap to the window full size on constrained spaces.
 * @see SettingsPage
 *
 * You can add multiple sub pages to this control by making use of the SettingsPage control and the `addPage` function.
 * By using the SettingsPage you can expect to have a way to navigate between the control sub pages.
 * The code snippet below shows a quick demo on how to do it.
 * @see addPage
 *
 * @image html Misc/settingsdialog.png
 *
 * @note This control is mostly use for presenting a group of configuration settings to the user. Usually it is populated with sections SectionGroup containing FlexSectionItem.
 *
 * @code
 * Maui.SettingsDialog
 * {
 *    id: _settingsDialog
 *
 *    Maui.FlexSectionItem
 *    {
 *        label1.text: "SSetting Subpage"
 *        label2.text: "Click me to add a new page"
 *
 *        ToolButton
 *        {
 *            icon.name: "go-next"
 *            checkable: true
 *            onToggled: _settingsDialog.addPage(_settingsPage2)
 *        }
 *    }
 *
 *    Maui.SectionGroup
 *    {
 *        title: "First Section"
 *
 *        Maui.FlexSectionItem
 *        {
 *            label1.text: "Configuration title"
 *            label2.text: "Description text"
 *
 *            Button
 *            {
 *                text: "Test"
 *            }
 *        }
 *
 *        Maui.FlexSectionItem
 *        {
 *            label1.text: "Configuration title"
 *            label2.text: "Description text"
 *
 *            Switch {}
 *        }
 *
 *        Maui.FlexSectionItem
 *        {
 *            label1.text: "Configuration title"
 *            label2.text: "Description text"
 *
 *            Switch {}
 *        }
 *    }
 *
 *    Maui.SectionGroup
 *    {
 *        title: "A Second Section"
 *
 *        Maui.FlexSectionItem
 *        {
 *            label1.text: "Configuration title"
 *            label2.text: "Description text"
 *
 *            Switch {}
 *        }
 *
 *        Maui.FlexSectionItem
 *        {
 *            label1.text: "Configuration title"
 *            label2.text: "Description text"
 *            wide: false
 *            TextField
 *            {
 *                Layout.fillWidth: true
 *            }
 *        }
 *
 *        Maui.FlexSectionItem
 *        {
 *            label1.text: "Configuration title"
 *            label2.text: "Description text"
 *
 *            Switch {}
 *        }
 *    }
 *
 *    Component
 *    {
 *        id: _settingsPage2
 *
 *        Maui.SettingsPage
 *        {
 *            title: "Page2"
 *
 *            Maui.FlexSectionItem
 *            {
 *                label1.text: "Configuration title"
 *                label2.text: "Description text"
 *
 *                Switch {}
 *            }
 *        }
 *    }
 * }
 * @endcode
 *
 * <a href="https://invent.kde.org/maui/mauikit/-/blob/qt6-2/examples/SettingsDialog.qml">You can find a more complete example at this link.</a>
 */
Maui.PopupPage
{
    id: control
    Maui.Controls.title: i18n("Settings")
    default property alias content: _content.content
    maxHeight: implicitHeight
    maxWidth: 500

    hint: 1

    page.title: _stackView.currentItem.title ?  _stackView.currentItem.title  : ""

    headBar.visible: true

    headBar.leftContent: ToolButton
    {
        icon.name: "go-previous"
        visible: _stackView.depth > 1

        onClicked: _stackView.pop()
    }

    stack: StackView
    {
        id: _stackView
        Layout.fillHeight: true
        Layout.fillWidth: true
        implicitHeight: Math.max(_content.implicitHeight, currentItem.implicitHeight)+topPadding +bottomPadding

        initialItem: Maui.SettingsPage
        {
            id: _content
            title: control.Maui.Controls.title
        }
    }

    /**
     * @brief Adds a new sub page to the control. Use a MauiKit SettingsPage for the component.
     * @param component the QQC2 Component wrapping a MauiKit SettingsPage
     * @param properties optional properties map for the newly added sub page component
     *
     * @note The optional properties argument specifies a map of initial property values for the pushed item. For dynamically created items, these values are applied before the creation is finalized. This is more efficient than setting property values after creation, particularly where large sets of property values are defined, and also allows property bindings to be set up (using Qt.binding()) before the item is created.
     * Checkout QT documentation on the StackView methods.
     */
    function addPage(component, properties)
    {
        _stackView.push(component, properties)
    }
}

