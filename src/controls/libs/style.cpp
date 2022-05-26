#include "style.h"
#include <QCoreApplication>

#include <MauiMan/thememanager.h>
#include <MauiMan/backgroundmanager.h>

Style *Style::m_instance = nullptr;

Style::Style(QObject *parent) : QObject(parent)
,m_defaultFont (QFont())
,m_iconSizes (new GroupSizes(8,16, 22, 32, 48, 64, 128, this))
,m_space( new GroupSizes(4, 6, 8, 16, 24, 32, 40, this))
,m_fontSizes (new GroupSizes{uint(qRound (m_defaultFont.pointSize ()*0.7)),uint(qRound (m_defaultFont.pointSize ()*0.8)),uint(m_defaultFont.pointSize ()),uint(qRound (m_defaultFont.pointSize ()*1.1)),uint(qRound (m_defaultFont.pointSize ()*1.2)),uint(qRound (m_defaultFont.pointSize ()*1.3)),uint(qRound (m_defaultFont.pointSize ()*1.4)), this})
,m_defaultFontSize(m_defaultFont.pointSize ())
, m_accentColor(QColor("#26c6da"))
{
 connect(qApp, &QCoreApplication::aboutToQuit, []()
    {
        delete m_instance;
        m_instance = nullptr;
    });    
  
 auto themeSettings = new MauiMan::ThemeManager(this);
 auto backgroundSettings = new MauiMan::BackgroundManager(this);
 
 connect(themeSettings, &MauiMan::ThemeManager::styleTypeChanged, [this](int type)
 {
     m_darkMode = type == 1;
     m_adaptiveColorScheme = type == 2;
     emit this->darkModeChanged(m_darkMode);
     emit this->adaptiveColorSchemeChanged();
 });
 
  connect(themeSettings, &MauiMan::ThemeManager::accentColorChanged, [this](QString color)
 {
     m_accentColor = color;
     emit this->accentColorChanged();
 });
  
   connect(backgroundSettings, &MauiMan::BackgroundManager::wallpaperSourceChanged, [this](QString source)
 {
     m_adaptiveColorSchemeSource = QUrl::fromUserInput(source).toLocalFile();
     emit this->adaptiveColorSchemeSourceChanged();
 }); 
 
   m_accentColor = themeSettings->accentColor();
    m_darkMode = themeSettings->styleType() == 1;
    
    m_adaptiveColorScheme = themeSettings->styleType() == 2;
    m_adaptiveColorSchemeSource = QUrl::fromUserInput(backgroundSettings->wallpaperSource()).toLocalFile();
}

Style *Style::qmlAttachedProperties(QObject *object)
{
    Q_UNUSED(object)
    return Style::instance();
}

int getClosest(int, int, int);

// Returns element closest to target in arr[]
int findClosest(int arr[], int n, int target)
{
    // Corner cases
    if (target <= arr[0])
        return arr[0];
    if (target >= arr[n - 1])
        return arr[n - 1];

    // Doing binary search
    int i = 0, j = n, mid = 0;
    while (i < j) {
        mid = (i + j) / 2;

        if (arr[mid] == target)
            return arr[mid];

        /* If target is less than array element,
            then search in left */
        if (target < arr[mid]) {

            // If target is greater than previous
            // to mid, return closest of two
            if (mid > 0 && target > arr[mid - 1])
                return getClosest(arr[mid - 1],
                                  arr[mid], target);

            /* Repeat for left half */
            j = mid;
        }

        // If target is greater than mid
        else {
            if (mid < n - 1 && target < arr[mid + 1])
                return getClosest(arr[mid],
                                  arr[mid + 1], target);
            // update i
            i = mid + 1;
        }
    }

    // Only single element left after search
    return arr[mid];
}

// Method to compare which one is the more close.
// We find the closest by taking the difference
// between the target and both values. It assumes
// that val2 is greater than val1 and target lies
// between these two.
int getClosest(int val1, int val2,
               int target)
{
    if (target - val1 >= val2 - target)
        return val2;
    else
        return val1;
}


int Style::mapToIconSizes(const int &size)
{
  int values[] = {8, 16, 22, 32, 48, 64, 128};
  int n = sizeof(values) / sizeof(values[0]);
  return findClosest (values, n, size);
}

GroupSizes::GroupSizes(const uint tiny, const uint small, const uint medium, const uint big, const uint large, const uint huge, const uint enormous, QObject *parent) : QObject(parent)
,m_tiny(tiny)
,m_small(small)
,m_medium(medium)
,m_big(big)
,m_large(large)
,m_huge(huge)
,m_enormous(enormous)

{

}

QVariant Style::adaptiveColorSchemeSource() const
{
    return m_adaptiveColorSchemeSource;
}

void Style::setAdaptiveColorSchemeSource(const QVariant& source)
{
    if(source == m_adaptiveColorSchemeSource)
    {
        return;
    }
    
    m_adaptiveColorSchemeSource = source;
    Q_EMIT adaptiveColorSchemeSourceChanged();
}

bool Style::adaptiveColorScheme() const
{
    return m_adaptiveColorScheme;
}

void Style::setAdaptiveColorScheme(const bool& value)
{
    if(value == m_adaptiveColorScheme)
    {
        return;
    }
    
    m_adaptiveColorScheme = value;
    Q_EMIT adaptiveColorSchemeChanged();
}

QColor Style::accentColor() const
{
    return m_accentColor;
}

void Style::setAccentColor(const QColor& color)
{
    if(m_accentColor == color)
    {
        return;
    }
    
    m_accentColor = color;
    emit accentColorChanged();
}

bool Style::darkMode() const
{
    return m_darkMode;
}

bool Style::bundledStyle() const
{
#if defined BUNDLE_MAUI_STYLE
    return true;
#else
    return false;
#endif
}

void Style::setDarkMode(bool darkMode)
{
    if (m_darkMode == darkMode)
        return;

    m_darkMode = darkMode;
    emit darkModeChanged(m_darkMode);
}
