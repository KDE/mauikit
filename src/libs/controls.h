#pragma once

#include <QObject>
#include <QQmlEngine>

/**
 * @brief The Controls class
 */
class Controls : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool showCSD READ showCSD WRITE setShowCSD NOTIFY showCSDChanged)

public:
    explicit Controls(QObject *parent = nullptr);

    static Controls *qmlAttachedProperties(QObject *object);

    bool showCSD() const;
    void setShowCSD(bool newShowCSD);

Q_SIGNALS:

    void showCSDChanged();
private:
    bool m_showCSD;
};

QML_DECLARE_TYPEINFO(Controls, QML_HAS_ATTACHED_PROPERTIES)
