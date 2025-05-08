/*
 *  SPDX-FileCopyrightText: 2017 by Marco Martin <mart@kde.org>
 *
 *  SPDX-License-Identifier: LGPL-2.0-or-later
 */

#ifndef BASICTHEME_H
#define BASICTHEME_H

#include "platformtheme.h"

class ImageColors;

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


public:
    explicit BasicThemeDefinition(PlatformTheme::StyleType type, QObject *parent = nullptr);

    virtual void syncToQml(PlatformTheme *object);

    QColor textColor ;
    QColor disabledTextColor ;

    QColor highlightColor ;
    QColor highlightedTextColor ;
    QColor backgroundColor ;
    QColor alternateBackgroundColor ;

    QColor focusColor ;
    QColor hoverColor;

    QColor activeTextColor;
    QColor activeBackgroundColor ;
    QColor linkColor;
    QColor linkBackgroundColor;
    QColor visitedLinkColor;
    QColor visitedLinkBackgroundColor;
    QColor negativeTextColor ;
    QColor negativeBackgroundColor;
    QColor neutralTextColor;
    QColor neutralBackgroundColor;
    QColor positiveTextColor;
    QColor positiveBackgroundColor;

    QColor buttonTextColor;
    QColor buttonBackgroundColor;
    QColor buttonAlternateBackgroundColor;
    QColor buttonHoverColor;
    QColor buttonFocusColor ;

    QColor viewTextColor;
    QColor viewBackgroundColor ;
    QColor viewAlternateBackgroundColor;
    QColor viewHoverColor;
    QColor viewFocusColor;

    QColor selectionTextColor;
    QColor selectionBackgroundColor;
    QColor selectionAlternateBackgroundColor;
    QColor selectionHoverColor;
    QColor selectionFocusColor;

    QColor tooltipTextColor;
    QColor tooltipBackgroundColor;
    QColor tooltipAlternateBackgroundColor;
    QColor tooltipHoverColor;
    QColor tooltipFocusColor;

    QColor complementaryTextColor;
    QColor complementaryBackgroundColor;
    QColor complementaryAlternateBackgroundColor;
    QColor complementaryHoverColor;
    QColor complementaryFocusColor;

    QColor headerTextColor;
    QColor headerBackgroundColor;
    QColor headerAlternateBackgroundColor;
    QColor headerHoverColor;
    QColor headerFocusColor;

    Q_SIGNAL void changed();
    Q_SIGNAL void sync(QQuickItem *object);

    void setDarkColors();
    void setTrueBlackColors(bool inverted = false);
    void setLightColors();
    void setAdaptiveColors();
    void setSystemPaletteColors();

private:
    ImageColors *m_imgColors;
    PlatformTheme::StyleType m_initialType = PlatformTheme::Undefined;


    struct LightColor
    {
        const static inline QColor textColor = QColor{"#31363b"};
        const static inline QColor disabledTextColor = QColor{"#83909d"};
        const static inline QColor backgroundColor = QColor{"#e8e8e8"};
        const static inline QColor alternateBackgroundColor = QColor{"#f0f0f0"};
        const static inline QColor hoverColor = QColor{"#dbdbdb"};

        const static inline QColor buttonBackgroundColor = QColor{"#ffffff"};
        const static inline QColor buttonAlternateBackgroundColor = QColor{"#f8f7f7"};
        const static inline QColor buttonHoverColor = QColor{"#f2f2f2"};

        const static inline QColor viewBackgroundColor = QColor{"#fafafa"};
        const static inline QColor viewAlternateBackgroundColor = QColor{"#f0f0f0"};
        const static inline  QColor viewHoverColor = QColor{"#e5e5e5"};

        const static inline QColor headerBackgroundColor = QColor{"#dedede"};
        const static inline QColor headerAlternateBackgroundColor = QColor{"#f0f0f0"};
        const static inline QColor headerHoverColor = QColor{"#dbdbdb"};
    };

    struct DarkColor
    {
        const static inline QColor textColor = QColor{"#f4f5f6"};
        const static inline QColor disabledTextColor = QColor{"#505050"};
        const static inline QColor backgroundColor = QColor{"#27292a"};
        const static inline QColor alternateBackgroundColor = QColor{"#1a1e1e"};
        const static inline QColor hoverColor = QColor{"#202727"};

        const static inline  QColor buttonBackgroundColor = QColor{"#4c5052"};
        const static inline QColor buttonAlternateBackgroundColor = QColor{"#353637"};
        const static inline  QColor buttonHoverColor = QColor{"#7d8487"};

        const static inline QColor viewBackgroundColor = QColor{"#0a0b0b"};
        const static inline QColor viewAlternateBackgroundColor = QColor{"#1a1e1e"};
        const static inline  QColor viewHoverColor = QColor{"#1f1f1f"};

        const static inline QColor headerBackgroundColor = QColor{"#2b2c31"};
        const static inline QColor headerAlternateBackgroundColor = QColor{"#1a1e1e"};
        const static inline QColor headerHoverColor = QColor{"#202727"};
    };
};

class BasicThemeInstance : public QObject
{
    Q_OBJECT

public:
    explicit BasicThemeInstance(QObject *parent = nullptr);

    BasicThemeDefinition &themeDefinition(PlatformTheme::StyleType type);
    QVector<BasicTheme *> watchers;

private:
    void onDefinitionChanged();
    std::unique_ptr<BasicThemeDefinition> m_themeDefinition;
    std::unique_ptr<BasicThemeDefinition> m_themeDefinitionLight;
    std::unique_ptr<BasicThemeDefinition> m_themeDefinitionDark;
};

class BasicTheme : public PlatformTheme
{
    Q_OBJECT

public:
    explicit BasicTheme(QObject *parent = nullptr);
    ~BasicTheme() override;

    void sync();
    static QColor getColor(PlatformTheme::StyleType style, PlatformTheme::ColorRole role, PlatformTheme::ColorSet set, ColorGroup group);
protected:
    bool event(QEvent *event) override;

private:
    static QColor tint(const QColor &color, PlatformTheme::ColorGroup);
};

}

#endif // BASICTHEME_H
