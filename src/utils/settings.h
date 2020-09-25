#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>
#include <QVariant>
#include <QSettings>
#include <QString>
#include <QUrl>

#include <QCoreApplication>

#ifndef STATIC_MAUIKIT
#include "mauikit_export.h"
#endif

class SettingSection : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString key READ key WRITE setKey NOTIFY keyChanged)
    Q_PROPERTY(QString group READ group WRITE setGroup NOTIFY groupChanged)
    Q_PROPERTY(QVariant defaultValue READ defaultValue WRITE setDefaultValue NOTIFY defaultValueChanged)

private:
    QString m_key;
    QString m_group;
    QVariant m_defaultValue;

public:
    explicit SettingSection(QObject * parent = nullptr);
    QString key() const;
    QString group() const;
    QVariant defaultValue() const;

public slots:
    void setKey(QString key);
    void setGroup(QString group);
    QVariant value() const;
    void setValue(QVariant value);
    void setDefaultValue(QVariant defaultValue);

signals:
    void keyChanged(QString key);
    void groupChanged(QString group);
    void defaultValueChanged(QVariant defaultValue);
};

/**
 * @brief The Settings class
 */
#ifdef STATIC_MAUIKIT
class Settings : public QObject
#else
class MAUIKIT_EXPORT Settings : public QObject
#endif
{
    Q_OBJECT
public:
    /**
     * @brief local
     * @return
     */
    static Settings &local()
    {
        static Settings settings;
        return settings;
    }

    /**
     * @brief global
     * @return
     */
    static Settings &global()
    {
        static Settings settings("mauiproject");
        return settings;
    }

    Settings(const Settings &) = delete;
    Settings &operator=(const Settings &) = delete;
    Settings(Settings &&) = delete;
    Settings &operator=(Settings &&) = delete;

    /**
     * @brief url
     * @return
     */
    QUrl url() const;

    /**
     * @brief load
     * @param key
     * @param group
     * @param defaultValue
     * @return
     */
    QVariant load(const QString &key, const QString &group, const QVariant &defaultValue) const;

    /**
     * @brief save
     * @param key
     * @param value
     * @param group
     */
    void save(const QString &key, const QVariant &value, const QString &group);

private:
    explicit Settings(QString app = qApp->applicationName(), QString org = qApp->organizationName().isEmpty() ? QString("org.kde.maui") : qApp->organizationName());

    QString m_app;
    QString m_org;
    QSettings *m_settings;

signals:
    /**
     * @brief settingChanged
     * @param url
     * @param key
     * @param value
     * @param group
     */
    void settingChanged(QUrl url, QString key, QVariant value, QString group);
};

#endif // SETTINGS_H
