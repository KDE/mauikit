#ifndef MAUIMACOS_H
#define MAUIMACOS_H

#include "abstractplatform.h"

/**
 * @brief The MAUIMacOS class
 */
class MAUIMacOS : public AbstractPlatform
{
    Q_OBJECT
public:
    explicit MAUIMacOS(QObject *parent = nullptr);
    /**
     * @brief removeTitlebarFromWindow
     * @param winId
     */
    static void removeTitlebarFromWindow(long winId = -1);

    /**
     * @brief runApp
     * @param app
     * @param files
     */
    static void runApp(const QString &app, const QList<QUrl> &files);

    // AbstractPlatform interface
public slots:
    void shareFiles(const QList<QUrl> &urls) override final;
    void shareText(const QString &urls) override final;
    bool hasKeyboard() override final;
    bool hasMouse() override final;
};

#endif // MAUIMACOS_H
