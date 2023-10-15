#pragma once

#include <QObject>
#include <QQmlEngine>

/**
 * @brief The Controls class.
 * 
 * This object exposes a series of attached properties useful for the MauiKit controls.
 * 
 * @note This is mean to be used as an attached property. It can be consumed as `Maui.Controls`, for example, `Maui.Controls.showCSD`
 */
class Controls : public QObject
{
    Q_OBJECT

    /**
     * A title text that can be attached to any control.
     */
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    
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

Q_SIGNALS:
    void titleChanged();
    void showCSDChanged();

private:
    bool m_showCSD;
    QString m_title;
};

QML_DECLARE_TYPEINFO(Controls, QML_HAS_ATTACHED_PROPERTIES)
