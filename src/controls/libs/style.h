#ifndef STYLE_H
#define STYLE_H

#include <QObject>

struct GroupSizes
{
    Q_GADGET
    Q_PROPERTY(uint tiny MEMBER m_tiny CONSTANT FINAL)
    Q_PROPERTY(uint small MEMBER m_small CONSTANT FINAL)
    Q_PROPERTY(uint medium MEMBER m_medium CONSTANT FINAL)
    Q_PROPERTY(uint big MEMBER m_big CONSTANT FINAL)
    Q_PROPERTY(uint large MEMBER m_large CONSTANT FINAL)
    Q_PROPERTY(uint huge MEMBER m_huge CONSTANT FINAL)
    Q_PROPERTY(uint enormous MEMBER m_enormous CONSTANT FINAL)


private:
    uint m_tiny;
    uint m_small;
    uint m_medium;
    uint m_big;
    uint m_large;
    uint m_huge;
    uint m_enormous;
};

class Style : public QObject
{
    Q_OBJECT
    Q_PROPERTY(uint toolBarHeight MEMBER m_toolBarHeight NOTIFY toolBarHeightChanged)
    Q_PROPERTY(uint toolBarHeightAlt MEMBER m_toolBarHeightAlt NOTIFY toolBarHeightAltChanged)
    Q_PROPERTY(uint radiusV MEMBER m_radiusV NOTIFY radiusVChanged)
    Q_PROPERTY(uint rowHeight MEMBER m_rowHeight NOTIFY rowHeightChanged)
    Q_PROPERTY(uint rowHeightAlt MEMBER m_rowHeightAlt NOTIFY rowHeightAltChanged)
    Q_PROPERTY(uint contentMargins MEMBER m_contentMargins NOTIFY contentMarginsChanged)
    Q_PROPERTY(uint defaultFontSize MEMBER m_defaultFontSize CONSTANT FINAL)

    Q_PROPERTY(GroupSizes fontSizes MEMBER m_fontSizes CONSTANT FINAL)
    Q_PROPERTY(GroupSizes space MEMBER m_space CONSTANT FINAL)
    Q_PROPERTY(GroupSizes iconSizes MEMBER m_iconSizes CONSTANT FINAL)



public:
    explicit Style(QObject *parent = nullptr);

private:
    GroupSizes m_iconSizes;
    GroupSizes m_fontSizes;
    GroupSizes m_space;
    uint m_toolBarHeight;


    uint m_toolBarHeightAlt;

    uint m_radiusV;

    uint m_rowHeight;

    uint m_rowHeightAlt;

    uint m_contentMargins;

    uint m_defaultFontSize;

signals:

    void toolBarHeightChanged(uint toolBarHeight);
    void toolBarHeightAltChanged(uint toolBarHeightAlt);
    void radiusVChanged(uint radiusV);
    void rowHeightChanged(uint rowHeight);
    void rowHeightAltChanged(uint rowHeightAlt);
    void contentMarginsChanged(uint contentMargins);

};

#endif // STYLE_H
