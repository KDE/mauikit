#ifndef MAUIWINDOWSH_H
#define MAUIWINDOWSH_H

#include "abstractplatform.h"
#include <QObject>

class MAUIWindows : public AbstractPlatform
{
    Q_OBJECT
public:
    explicit MAUIWindows(QObject *parent = nullptr);

public slots:
    void shareFiles(const QList<QUrl> &urls) override final;
    void shareText(const QString &urls) override final;
    bool hasKeyboard() override final;
    bool hasMouse() override final;
    void notify(const QString &title, const QString &message, const QString &icon, const QString &imageUrl) override final;
};

#endif // MAUIWINDOWSH_H
