

#pragma once

#include <QObject>
#include <QQmlEngine>
#include <QQmlComponent>
#include <QQuickItem>

/**
 * @brief The Controls class.
 *
 * This object exposes a series of attached properties useful for the MauiKit controls as a sort of common set of metadata.
 *
 * @note This is mean to be used as an attached property. It can be consumed as `Maui.Controls`, for example, `Maui.Controls.showCSD`
 */
class Controls : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_ATTACHED(Controls)
    QML_UNCREATABLE("Cannot be created. Controls object is a set of metadata information to be attached")

    /**
     * A title text that can be attached to any control.
     * @note Some controls depend on this property to be set in order show revelant information. For example, for the SplitViewItem, when requesting to close a view, the view can be referenced by the given title.
     *
     *
     */
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    
    /**
     * A subtitle text that can be attached to any control.
     * This property can be used in the Menu type to set the subtitle in the header information.
     *
     * @image html controls_subtitle_menu.png "Menu with header information: title, subtitle and icon source"
     */
    Q_PROPERTY(QString subtitle READ subtitle WRITE setSubtitle NOTIFY subtitleChanged)

    /**
     * The icon name to be used in or by the widget.
     */
    Q_PROPERTY(QString iconName READ iconName WRITE setIconName NOTIFY iconNameChanged)

    /**
     * The text to be used as a badge for notification purposes.
     * If this is left empty, then not badge will be shown.
     *
     * @image html controls_badge.png "Badge text notification on a few controls"
     *
     * Some of the controls that support this attached property include:
     * - ToolButton
     * - Button
     * - ListBrowser
     * - GridBrowser
     * - SplitViewItem
     * - TextField
     * - TabButton
     */
    Q_PROPERTY(QString badgeText READ badgeText WRITE setBadgeText NOTIFY badgeTextChanged)

    /**
     * The color to be used as an indicator in the supported widgets.
     * Supported widgets include:
     * - TabButton
     * - Button
     * - Page
     * - Badge
     */
    Q_PROPERTY(QString color READ color WRITE setColor NOTIFY colorChanged)

    /**
     * The text to be shown in the tool-tip when hovering over the tab button representing the view.
     */
    Q_PROPERTY(QString toolTipText READ toolTipText WRITE setToolTipText NOTIFY toolTipTextChanged)

    /**
     * Whether a supported MauiKit control should display the window control buttons when using client side decorations.
     * Some of the supported controls include:
     * - Page
     * - PageLayout
     * - TabView
     * - ToolBar
     */
    Q_PROPERTY(bool showCSD READ showCSD WRITE setShowCSD NOTIFY showCSDChanged)

    /**
     * Set a UI element hierarchy level. For example, in a page with two toolbars one could be `Level::Primary`, and the other one `Level::Secondary`, this will allow to better style the toolbars for differentiation.
     * By default `Level::Primary` is assumed.
     * @see Level
     *
     * @image html controls_level_toolbar.png "A primary and secondary toolbar"
     *
     * @code
     * import QtQuick
        import QtQuick.Controls
        import org.mauikit.controls as Maui

   Maui.ApplicationWindow
   {
       Maui.Page
       {
           anchors.fill: parent

         Maui.Controls.showCSD: true
         headBar.leftContent: Label
         {
             text: "Primary"
         }

        headerColumn: Maui.ToolBar
        {
            width: parent.width
            Maui.Controls.level: Maui.Controls.Secondary

               Label
               {
                   text: "Secondary"
               }
           }
       }
   }
    @endcode
**/
    Q_PROPERTY(Level level READ level WRITE setLevel NOTIFY levelChanged)

    /**
     * A property hint for UI elements to be styled as a flat surface, for example, without a background.
     * Although some controls have this property implicitly available, some other controls do not, and thus this is the way to set it.
     * By default this is set to false.
     */
    Q_PROPERTY(bool flat READ flat WRITE setFlat NOTIFY flatChanged)

    /**
     * Mark the supported widget in one of the given status, which will alterate its look.
     * This can serve as a visual clue of an important state or action.
     * @see Status
     *
     * Suported widgets include:
     * - Button
     * - MenuItem
     *
     * @image html controls_status.png "Button with different status"
     *
     * @code
     * import QtQuick
        import QtQuick.Controls
        import org.mauikit.controls as Maui

            Maui.ApplicationWindow
            {

                Maui.Page
                {
                    anchors.fill: parent

                  Column
                  {
                      anchors.centerIn: parent
                      spacing: Maui.Style.space.big

                      Button
                      {
                          text: "Normal"
                          Maui.Controls.status: Maui.Controls.Normal
                      }

                      Button
                      {
                          text: "Positive"
                          Maui.Controls.status: Maui.Controls.Positive
                      }

                      Button
                      {
                          text: "Neutral"
                          Maui.Controls.status: Maui.Controls.Neutral
                      }

                      Button
                      {
                          text: "Negative"
                          Maui.Controls.status: Maui.Controls.Negative
                      }
                  }
              }
          }
     * @endcode
     **/
    Q_PROPERTY(Status status READ status WRITE setStatus NOTIFY statusChanged)

    /**
     * Some controls might depend of a custom Component to be rendered. Some of those controls include:
     * - Menu
     * - ToolBar
     *
     * @note The Menu control depends on this custom property to set a custom menu header, instead of the default one that relies on a title, subtitle, and icon source.
     *
     * @image html controls_item_menu_header.png "A Menu with a custom header via `Maui.Controls.component` attached property"
     */
    Q_PROPERTY(QQmlComponent *component READ component WRITE setComponent NOTIFY componentChanged)
    Q_PROPERTY(QQuickItem *item READ item WRITE setItem NOTIFY itemChanged)
    
    Q_PROPERTY(Qt::Orientation orientation READ orientation WRITE setOrientation NOTIFY orientationChanged)

public:

    enum Level
    {
        Undefined,
        Primary,
        Secondary
    }; Q_ENUM(Level)

    enum Status
    {
        Normal,
        Positive,
        Negative,
        Neutral
    }; Q_ENUM(Status)

    explicit Controls(QObject *parent = nullptr);

    static Controls *qmlAttachedProperties(QObject *object);

    bool showCSD() const;
    void setShowCSD(bool newShowCSD);

    QString title() const;
    void setTitle(const QString &title);

    QString subtitle() const;
    void setSubtitle(const QString &subtitle);

    QString iconName() const;
    void setIconName(const QString &newIconName);

    QString badgeText() const;
    void setBadgeText(const QString &newBadgeText);

    QString toolTipText() const;
    void setToolTipText(const QString &newToolTipText);

    QString color() const;
    void setColor(const QString &newColor);

    Controls::Level level() const;
    void setLevel(Level level);

    bool flat() const;
    void setFlat(bool value);

    Controls::Status status() const;
    void setStatus(Controls::Status status);

    QQmlComponent *component() const;
    void setComponent(QQmlComponent *component);

    QQuickItem *item() const;
    void setItem(QQuickItem *item);
    
    void setOrientation(Qt::Orientation orientation);
    Qt::Orientation orientation() const;

Q_SIGNALS:
    void titleChanged();
    void subtitleChanged();
    void showCSDChanged();
    void iconNameChanged();
    void badgeTextChanged();
    void toolTipTextChanged();
    void colorChanged();
    void levelChanged();
    void flatChanged();
    void statusChanged();
    void itemChanged();
    void componentChanged();
    void orientationChanged();

private:
    bool m_showCSD;
    QString m_title;
    QString m_subtitle;
    QString m_iconName;
    QString m_badgeText;
    QString m_toolTipText;
    QString m_color;
    Controls::Level m_level = Controls::Level::Undefined;
    bool m_flat;
    Controls::Status m_status = Controls::Status::Normal;
    QQuickItem *m_item = nullptr;
    QQmlComponent *m_component = nullptr;
    Qt::Orientation m_orientation = Qt::Orientation::Vertical;
};

QML_DECLARE_TYPEINFO(Controls, QML_HAS_ATTACHED_PROPERTIES)
