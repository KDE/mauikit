import QtQuick

import QtQuick.Layouts
import QtQuick.Controls

import org.mauikit.controls 1.3 as Maui

/**
 * @inherit QtQuick.Controls.Pane
 *  @since org.mauikit.controls
 *  @brief A control to group children elements into a column layout with a header section with a title and message body.
 * 
 * <a href="https://doc.qt.io/qt-6/qml-qtquick-controls-pane.html">This controls inherits from QQC2 Pane, to checkout its inherited properties refer to the Qt Docs.</a>
 * 
 * @image html Misc/sectiongroup.png "Example of different usages of the control"
 * 
 * @code
 * Maui.SectionGroup
 * {
 *     title: "Section with Children"
 *     description: "The description label can be a bit longer explaining something importand. Maybe?"
 * 
 *     Rectangle
 *     {
 *        Layout.fillWidth: true
 *        implicitHeight: 60
 *        radius: 20
 * 
 *        color: "orange"
 *     }
 * }
 * @endcode
 * 
 * @note Consider using the SectionItem or FlexSectionItem as the children elements of this control, in order to have a more cohesive look with another MauiKit applications.
 * 
 * <a href="https://invent.kde.org/maui/mauikit/-/blob/qt6-2/examples/SectionGroup.qml">You can find a more complete example at this link.</a>
 */
Pane
{
     id: control
     
     /**
      * @brief By default the content children will be placed on a ColumnLayout, so use the Layout attached properties for positioning them.
      * @note The children elements should have an implicit height.
      * @property list<QtObject>
      */
     default property alias content : _layout.data
          
          /**
           * @brief The title of the section header.
           * @property string SectionGroup::title
           */
          property alias title : _template.text1
          
          /**
           * @brief The message body of the section header.
           * @property string SectionGroup::description
           */
          property alias description : _template.text2
          
          /**
           * @brief An alias to the section header title control, which is handled by SectionHeader
           * More properties can be accessed via this alias, such as setting a custom icon or image, etc, for that use the `template` of the `template`.
           * @code
           * Maui.SectionGroup
           * {
           *   title: "Hello"
           *   description: "Description text"
           *   template.template.iconSource: "folder" //Here we access the template of this control, which is a SectionHeader, and then the template fo the section header, which is a ListItemTemplate.
           * }
           * @endcode
           * @see SectionHeader
           * @see ListItemTemplate
           * @property SectionHeader SectionGroup::template
           */
          readonly property alias template: _template
          
          spacing: Maui.Style.defaultSpacing
          
          Layout.fillWidth: true
          padding: Maui.Style.contentMargins
          
          implicitHeight: implicitContentHeight + topPadding + bottomPadding
          
          background: null
          
          contentItem: ColumnLayout
          {
               id: _layout               
               spacing: control.spacing
               
               Maui.SectionHeader
               {
                    id: _template
                    Layout.fillWidth: true
                    label1.font: Maui.Style.defaultFont
                    label1.text: control.title
                    label2.text: control.description
                    label1.opacity: 0.7
                    label2.opacity: 0.7
                    template.iconSizeHint: Maui.Style.iconSizes.medium
               }
          }
}
