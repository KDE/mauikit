#pragma once
#include <QObject>

#include <QQmlExtensionPlugin>

class MauiStylePlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_DISABLE_COPY(MauiStylePlugin)
    Q_PLUGIN_METADATA(IID QQmlExtensionInterface_iid)

public:
    MauiStylePlugin(QObject *parent = nullptr);
    ~MauiStylePlugin();

    QString name() const;

    void registerTypes(const char *uri) override;

private:
};
