import QtQuick
import QtQuick.Controls

import org.mauikit.controls as Maui

/**
 * @inherit QtQuick.Controls.Pane
 * @since org.mauikit.controls
 *  
 * @brief A control for dividing sections with a title label and a message body.
 * <a href="https://doc.qt.io/qt-6/qml-qtquick-controls-pane.html">This controls inherits from QQC2 Pane, to checkout its inherited properties refer to the Qt Docs.</a>
 *  
 * The most common use for this control is to set it as the title of a section. For a more complete implementation of such use case refer to the SectionGroup, which uses this control as the section header.
 *  @see SectionGroup
 */

Pane
{
  id: control
  
  /**
   * @brief An alias to the ListItemTemplate handling the information labels, etc.
   * Exposed for fine tuning more of its properties.
   * @property ListItemtemplate SectionHeader::template
   */
  readonly property alias template : _template
  
  /**
   * @see ListItemTemplate::text1
   */
  property alias text1 : _template.text1
  
  /**
   * @see ListItemTemplate::text2
   */
  property alias text2 : _template.text2
  
  /**
   * @see ListItemTemplate::label1
   */
  readonly property alias label1 : _template.label1
  
  /**
   * @see ListItemTemplate::label2
   */
  readonly property alias label2 : _template.label2
  
  implicitHeight: _template.implicitHeight + topPadding + bottomPadding
  
  padding: Maui.Style.defaultPadding
  spacing: Maui.Style.space.small
  
  contentItem: Maui.ListItemTemplate
  {
    id: _template
    
    label1.font: Maui.Style.h2Font
    label2.wrapMode: Text.WordWrap
    label2.font.pointSize: Maui.Style.fontSizes.small
    isMask: iconSizeHint <= 22
    spacing: control.spacing
  }
  
  background: null
}
