/*
 *  SPDX-FileCopyrightText: 2017 by Marco Martin <mart@kde.org>
 *
 *  SPDX-License-Identifier: LGPL-2.0-or-later
 */

#ifndef BASICTHEME_H
#define BASICTHEME_H

#include "platformtheme.h"

namespace Maui
{
class BasicTheme;

class BasicThemeDefinition : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QColor textColor MEMBER textColor NOTIFY changed)
    Q_PROPERTY(QColor disabledTextColor MEMBER disabledTextColor NOTIFY changed)

    Q_PROPERTY(QColor highlightColor MEMBER highlightColor NOTIFY changed)
    Q_PROPERTY(QColor highlightedTextColor MEMBER highlightedTextColor NOTIFY changed)
    Q_PROPERTY(QColor backgroundColor MEMBER backgroundColor NOTIFY changed)
    Q_PROPERTY(QColor alternateBackgroundColor MEMBER alternateBackgroundColor NOTIFY changed)

    Q_PROPERTY(QColor focusColor MEMBER focusColor NOTIFY changed)
    Q_PROPERTY(QColor hoverColor MEMBER hoverColor NOTIFY changed)

    Q_PROPERTY(QColor activeTextColor MEMBER activeTextColor NOTIFY changed)
    Q_PROPERTY(QColor activeBackgroundColor MEMBER activeBackgroundColor NOTIFY changed)
    Q_PROPERTY(QColor linkColor MEMBER linkColor NOTIFY changed)
    Q_PROPERTY(QColor linkBackgroundColor MEMBER linkBackgroundColor NOTIFY changed)
    Q_PROPERTY(QColor visitedLinkColor MEMBER visitedLinkColor NOTIFY changed)
    Q_PROPERTY(QColor visitedLinkBackgroundColor MEMBER visitedLinkBackgroundColor NOTIFY changed)
    Q_PROPERTY(QColor negativeTextColor MEMBER negativeTextColor NOTIFY changed)
    Q_PROPERTY(QColor negativeBackgroundColor MEMBER negativeBackgroundColor NOTIFY changed)
    Q_PROPERTY(QColor neutralTextColor MEMBER neutralTextColor NOTIFY changed)
    Q_PROPERTY(QColor neutralBackgroundColor MEMBER neutralBackgroundColor NOTIFY changed)
    Q_PROPERTY(QColor positiveTextColor MEMBER positiveTextColor NOTIFY changed)
    Q_PROPERTY(QColor positiveBackgroundColor MEMBER positiveBackgroundColor NOTIFY changed)

    Q_PROPERTY(QColor buttonTextColor MEMBER buttonTextColor NOTIFY changed)
    Q_PROPERTY(QColor buttonBackgroundColor MEMBER buttonBackgroundColor NOTIFY changed)
    Q_PROPERTY(QColor buttonAlternateBackgroundColor MEMBER buttonAlternateBackgroundColor NOTIFY changed)
    Q_PROPERTY(QColor buttonHoverColor MEMBER buttonHoverColor NOTIFY changed)
    Q_PROPERTY(QColor buttonFocusColor MEMBER buttonFocusColor NOTIFY changed)

    Q_PROPERTY(QColor viewTextColor MEMBER viewTextColor NOTIFY changed)
    Q_PROPERTY(QColor viewBackgroundColor MEMBER viewBackgroundColor NOTIFY changed)
    Q_PROPERTY(QColor viewAlternateBackgroundColor MEMBER viewAlternateBackgroundColor NOTIFY changed)
    Q_PROPERTY(QColor viewHoverColor MEMBER viewHoverColor NOTIFY changed)
    Q_PROPERTY(QColor viewFocusColor MEMBER viewFocusColor NOTIFY changed)

    Q_PROPERTY(QColor selectionTextColor MEMBER selectionTextColor NOTIFY changed)
    Q_PROPERTY(QColor selectionBackgroundColor MEMBER selectionBackgroundColor NOTIFY changed)
    Q_PROPERTY(QColor selectionAlternateBackgroundColor MEMBER selectionAlternateBackgroundColor NOTIFY changed)
    Q_PROPERTY(QColor selectionHoverColor MEMBER selectionHoverColor NOTIFY changed)
    Q_PROPERTY(QColor selectionFocusColor MEMBER selectionFocusColor NOTIFY changed)

    Q_PROPERTY(QColor tooltipTextColor MEMBER tooltipTextColor NOTIFY changed)
    Q_PROPERTY(QColor tooltipBackgroundColor MEMBER tooltipBackgroundColor NOTIFY changed)
    Q_PROPERTY(QColor tooltipAlternateBackgroundColor MEMBER tooltipAlternateBackgroundColor NOTIFY changed)
    Q_PROPERTY(QColor tooltipHoverColor MEMBER tooltipHoverColor NOTIFY changed)
    Q_PROPERTY(QColor tooltipFocusColor MEMBER tooltipFocusColor NOTIFY changed)

    Q_PROPERTY(QColor complementaryTextColor MEMBER complementaryTextColor NOTIFY changed)
    Q_PROPERTY(QColor complementaryBackgroundColor MEMBER complementaryBackgroundColor NOTIFY changed)
    Q_PROPERTY(QColor complementaryAlternateBackgroundColor MEMBER complementaryAlternateBackgroundColor NOTIFY changed)
    Q_PROPERTY(QColor complementaryHoverColor MEMBER complementaryHoverColor NOTIFY changed)
    Q_PROPERTY(QColor complementaryFocusColor MEMBER complementaryFocusColor NOTIFY changed)

    Q_PROPERTY(QColor headerTextColor MEMBER headerTextColor NOTIFY changed)
    Q_PROPERTY(QColor headerBackgroundColor MEMBER headerBackgroundColor NOTIFY changed)
    Q_PROPERTY(QColor headerAlternateBackgroundColor MEMBER headerAlternateBackgroundColor NOTIFY changed)
    Q_PROPERTY(QColor headerHoverColor MEMBER headerHoverColor NOTIFY changed)
    Q_PROPERTY(QColor headerFocusColor MEMBER headerFocusColor NOTIFY changed)

    Q_PROPERTY(QFont defaultFont MEMBER defaultFont NOTIFY changed)
    Q_PROPERTY(QFont smallFont MEMBER smallFont NOTIFY changed)

public:
    explicit BasicThemeDefinition(QObject *parent = nullptr);

    virtual void syncToQml(PlatformTheme *object);

    QColor textColor = QColor{"#31363b"};
    QColor disabledTextColor = QColor{"#9931363b"};

    QColor highlightColor = QColor{"#2196F3"};
    QColor highlightedTextColor = QColor{"#eff0fa"};
    QColor backgroundColor = QColor{"#eff0f1"};
    QColor alternateBackgroundColor = QColor{"#bdc3c7"};

    QColor focusColor = QColor{"#2196F3"};
    QColor hoverColor = QColor{"#2196F3"};

    QColor activeTextColor = QColor{"#0176D3"};
    QColor activeBackgroundColor = QColor{"#0176D3"};
    QColor linkColor = QColor{"#2196F3"};
    QColor linkBackgroundColor = QColor{"#2196F3"};
    QColor visitedLinkColor = QColor{"#2196F3"};
    QColor visitedLinkBackgroundColor = QColor{"#2196F3"};
    QColor negativeTextColor = QColor{"#DA4453"};
    QColor negativeBackgroundColor = QColor{"#DA4453"};
    QColor neutralTextColor = QColor{"#F67400"};
    QColor neutralBackgroundColor = QColor{"#F67400"};
    QColor positiveTextColor = QColor{"#27AE60"};
    QColor positiveBackgroundColor = QColor{"#27AE60"};

    QColor buttonTextColor = QColor{"#31363b"};
    QColor buttonBackgroundColor = QColor{"#eff0f1"};
    QColor buttonAlternateBackgroundColor = QColor{"#bdc3c7"};
    QColor buttonHoverColor = QColor{"#2196F3"};
    QColor buttonFocusColor = QColor{"#2196F3"};

    QColor viewTextColor = QColor{"#31363b"};
    QColor viewBackgroundColor = QColor{"#fcfcfc"};
    QColor viewAlternateBackgroundColor = QColor{"#eff0f1"};
    QColor viewHoverColor = QColor{"#2196F3"};
    QColor viewFocusColor = QColor{"#2196F3"};

    QColor selectionTextColor = QColor{"#eff0fa"};
    QColor selectionBackgroundColor = QColor{"#2196F3"};
    QColor selectionAlternateBackgroundColor = QColor{"#1d99f3"};
    QColor selectionHoverColor = QColor{"#2196F3"};
    QColor selectionFocusColor = QColor{"#2196F3"};

    QColor tooltipTextColor = QColor{"#eff0f1"};
    QColor tooltipBackgroundColor = QColor{"#31363b"};
    QColor tooltipAlternateBackgroundColor = QColor{"#4d4d4d"};
    QColor tooltipHoverColor = QColor{"#2196F3"};
    QColor tooltipFocusColor = QColor{"#2196F3"};

    QColor complementaryTextColor = QColor{"#eff0f1"};
    QColor complementaryBackgroundColor = QColor{"#31363b"};
    QColor complementaryAlternateBackgroundColor = QColor{"#3b4045"};
    QColor complementaryHoverColor = QColor{"#2196F3"};
    QColor complementaryFocusColor = QColor{"#2196F3"};

    QColor headerTextColor = QColor{"#232629"};
    QColor headerBackgroundColor = QColor{"#e3e5e7"};
    QColor headerAlternateBackgroundColor = QColor{"#eff0f1"};
    QColor headerHoverColor = QColor{"#2196F3"};
    QColor headerFocusColor = QColor{"#93cee9"};

    QFont defaultFont;
    QFont smallFont;

    Q_SIGNAL void changed();
    Q_SIGNAL void sync(QQuickItem *object);
};

class BasicThemeInstance : public QObject
{
    Q_OBJECT

public:
    explicit BasicThemeInstance(QObject *parent = nullptr);

    BasicThemeDefinition &themeDefinition(QQmlEngine *engine);

    QVector<BasicTheme *> watchers;

private:
    void onDefinitionChanged();

    std::unique_ptr<BasicThemeDefinition> m_themeDefinition;
};

class BasicTheme : public PlatformTheme
{
    Q_OBJECT

public:
    explicit BasicTheme(QObject *parent = nullptr);
    ~BasicTheme() override;

    void sync();

protected:
    bool event(QEvent *event) override;

private:
    QColor tint(const QColor &color);
};

}

#endif // BASICTHEME_H
