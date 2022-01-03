#ifndef PLATFORM_H
#define PLATFORM_H

#include <QObject>
#include <QQmlEngine>

#include "mauikit_export.h"

#include "abstractplatform.h"

class MAUIKIT_EXPORT Platform : public AbstractPlatform
{
    Q_OBJECT
public:
    static Platform *qmlAttachedProperties(QObject *object);
    static Platform *instance()
    {
        if (m_instance)
            return m_instance;

        m_instance = new Platform;
        return m_instance;
    }

    Platform(const Platform &) = delete;
    Platform &operator=(const Platform &) = delete;
    Platform(Platform &&) = delete;
    Platform &operator=(Platform &&) = delete;

    // AbstractPlatform interface
public slots:
    void shareFiles(const QList<QUrl> &urls) override final;
    void shareText(const QString &text) override final;
    bool hasKeyboard() override final;
    bool hasMouse() override final;    
    bool darkModeEnabled() override final;

private:
    static Platform *m_instance;

    explicit Platform(QObject *parent = nullptr);
    AbstractPlatform *m_platform;

};

QML_DECLARE_TYPEINFO(Platform, QML_HAS_ATTACHED_PROPERTIES)
#endif // PLATFORM_H
