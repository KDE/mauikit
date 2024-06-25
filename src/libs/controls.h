#pragma once

#include <QObject>
#include <QQmlEngine>

/**
 * @brief The Controls class.
 *
 * This object exposes a series of attached properties useful for the MauiKit controls as a sort of common set metadata.
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
     */
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)

    /**
     * The icon name to be used in the AppViews button port
     */
    Q_PROPERTY(QString iconName READ iconName WRITE setIconName NOTIFY iconNameChanged)


    /**
     * The text to be used as a badge for notification purposes.
     * If this is left empty, then not badge will be shown.
     */
    Q_PROPERTY(QString badgeText READ badgeText WRITE setBadgeText NOTIFY badgeTextChanged)

    /**
     * The color to be used as an indicator in the tab button representing the view.
     */
    Q_PROPERTY(QString color READ color WRITE setColor NOTIFY colorChanged)

    /**
     * The text to be shown in the tool-tip when hovering over the tab button representing the view.
     */
    Q_PROPERTY(QString toolTipText READ toolTipText WRITE setToolTipText NOTIFY toolTipTextChanged)

    /**
     * Whether a supported MauiKit controls should display the window control buttons when using CSD.
     */
    Q_PROPERTY(bool showCSD READ showCSD WRITE setShowCSD NOTIFY showCSDChanged)

public:
    explicit Controls(QObject *parent = nullptr);

    static Controls *qmlAttachedProperties(QObject *object);

    bool showCSD() const;
    void setShowCSD(bool newShowCSD);

    QString title() const;
    void setTitle(const QString &title);

    QString iconName() const;
    void setIconName(const QString &newIconName);

    QString badgeText() const;
    void setBadgeText(const QString &newBadgeText);

    QString toolTipText() const;
    void setToolTipText(const QString &newToolTipText);
    
    QString color() const;
    void setColor(const QString &newColor);
    
Q_SIGNALS:
    void titleChanged();
    void showCSDChanged();
    void iconNameChanged();
    void badgeTextChanged();
    void toolTipTextChanged();    
    void colorChanged();
    
private:
    bool m_showCSD;
    QString m_title;
    QString m_iconName;
    QString m_badgeText;
    QString m_toolTipText;
    QString m_color;
};

QML_DECLARE_TYPEINFO(Controls, QML_HAS_ATTACHED_PROPERTIES)
