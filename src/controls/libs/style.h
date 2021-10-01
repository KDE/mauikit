#ifndef STYLE_H
#define STYLE_H

#include <QObject>
#include <QFont>

class GroupSizes : public QObject
{
  Q_OBJECT
  Q_PROPERTY(uint tiny MEMBER m_tiny CONSTANT FINAL)
  Q_PROPERTY(uint small MEMBER m_small CONSTANT FINAL)
  Q_PROPERTY(uint medium MEMBER m_medium CONSTANT FINAL)
  Q_PROPERTY(uint big MEMBER m_big CONSTANT FINAL)
  Q_PROPERTY(uint large MEMBER m_large CONSTANT FINAL)
  Q_PROPERTY(uint huge MEMBER m_huge CONSTANT FINAL)
  Q_PROPERTY(uint enormous MEMBER m_enormous CONSTANT FINAL)

public:
  explicit GroupSizes(const uint tiny,const uint small, const uint medium, const uint big, const uint large, const uint huge, const uint enormous, QObject *parent = nullptr);

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
  Q_PROPERTY(uint toolBarHeight MEMBER m_toolBarHeight CONSTANT FINAL)
  Q_PROPERTY(uint toolBarHeightAlt MEMBER m_toolBarHeightAlt CONSTANT FINAL)
  Q_PROPERTY(uint radiusV MEMBER m_radiusV CONSTANT FINAL)
  Q_PROPERTY(uint rowHeight MEMBER m_rowHeight CONSTANT FINAL)
  Q_PROPERTY(uint rowHeightAlt MEMBER m_rowHeightAlt CONSTANT FINAL)
  Q_PROPERTY(uint contentMargins MEMBER m_contentMargins CONSTANT FINAL)
  Q_PROPERTY(uint defaultFontSize MEMBER m_defaultFontSize CONSTANT FINAL)

  Q_PROPERTY(QFont defaultFont MEMBER m_defaultFont NOTIFY defaultFontChanged)

  Q_PROPERTY(GroupSizes *fontSizes MEMBER m_fontSizes CONSTANT FINAL)
  Q_PROPERTY(GroupSizes *space MEMBER m_space CONSTANT FINAL)
  Q_PROPERTY(GroupSizes *iconSizes MEMBER m_iconSizes CONSTANT FINAL)

public:
  static Style *instance()
  {
    if (m_instance)
      return m_instance;

    m_instance = new Style;
    return m_instance;
  }

  Style(const Style &) = delete;
  Style &operator=(const Style &) = delete;
  Style(Style &&) = delete;
  Style &operator=(Style &&) = delete;

public slots:
  int mapToIconSizes(const int &size);

private:
  explicit Style(QObject *parent = nullptr);
  static Style *m_instance;
  QFont m_defaultFont = QFont {};

  GroupSizes *m_iconSizes;
  GroupSizes *m_space;
  GroupSizes *m_fontSizes;

  uint m_defaultFontSize;

  uint m_toolBarHeight = 48;
  uint m_toolBarHeightAlt = 40;
  uint m_radiusV = 4;
  uint m_rowHeight = 32;
  uint m_rowHeightAlt = 28;
  uint m_contentMargins = 8;

signals:
  void defaultFontChanged();
};

#endif // STYLE_H
