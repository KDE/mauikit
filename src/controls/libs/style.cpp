#include "style.h"
#include <QCoreApplication>
#include <QGuiApplication>

#include <MauiMan/thememanager.h>
#include <MauiMan/backgroundmanager.h>

Style *Style::m_instance = nullptr;

Style::Style(QObject *parent) : QObject(parent)
,m_defaultFont (QFont())
,m_iconSizes (new GroupSizes(8,16, 22, 32, 48, 64, 128, this))
,m_space( new GroupSizes(4, 6, 8, 16, 24, 32, 40, this))
,m_fontSizes (new GroupSizes{uint(qRound (m_defaultFont.pointSize ()*0.7)),uint(qRound (m_defaultFont.pointSize ()*0.8)),uint(m_defaultFont.pointSize ()),uint(qRound (m_defaultFont.pointSize ()*1.1)),uint(qRound (m_defaultFont.pointSize ()*1.2)),uint(qRound (m_defaultFont.pointSize ()*1.3)),uint(qRound (m_defaultFont.pointSize ()*1.4)), this})
,m_units(new Units(this))
,m_defaultFontSize(m_defaultFont.pointSize ())
,m_accentColor(QColor("#26c6da"))
,m_themeSettings( new MauiMan::ThemeManager(this))
,m_backgroundSettings( new MauiMan::BackgroundManager(this))
{
    connect(qApp, &QCoreApplication::aboutToQuit, []()
    {
        delete m_instance;
        m_instance = nullptr;
    });    
    
    connect(m_themeSettings, &MauiMan::ThemeManager::styleTypeChanged, [this](int type)
    {
        if(m_styleType_blocked)
            return;
        
        m_styleType = static_cast<Style::StyleType>(type);
        Q_EMIT styleTypeChanged(m_styleType);
    });
    
    connect(m_themeSettings, &MauiMan::ThemeManager::accentColorChanged, [this](QString color)
    {
        m_accentColor = color;
        Q_EMIT this->accentColorChanged(m_accentColor);
    });
    
    connect(m_themeSettings, &MauiMan::ThemeManager::borderRadiusChanged, [this](uint radius)
    {
        m_radiusV = radius;
        Q_EMIT this->radiusVChanged(m_radiusV);
    });
    
    connect(m_themeSettings, &MauiMan::ThemeManager::iconSizeChanged, [this](uint size)
    {
        m_iconSize = size;
        Q_EMIT this->iconSizeChanged(m_iconSize);
    });
    
    connect(m_themeSettings, &MauiMan::ThemeManager::enableEffectsChanged, [this](bool value)
    {
        m_enableEffects = value;
        Q_EMIT this->enableEffectsChanged(m_enableEffects);
    });
    
    connect(m_backgroundSettings, &MauiMan::BackgroundManager::wallpaperSourceChanged, [this](QString source)
    {
        m_adaptiveColorSchemeSource = QUrl::fromUserInput(source).toLocalFile();
        Q_EMIT this->adaptiveColorSchemeSourceChanged(m_adaptiveColorSchemeSource);
    });     
    
    m_radiusV = m_themeSettings->borderRadius();
    m_iconSize = m_themeSettings->iconSize();
    m_accentColor = m_themeSettings->accentColor();
    m_styleType = static_cast<Style::StyleType>(m_themeSettings->styleType());    
    m_adaptiveColorSchemeSource = QUrl::fromUserInput(m_backgroundSettings->wallpaperSource()).toLocalFile();
    m_enableEffects = m_themeSettings->enableEffects();
}

void Style::setRadiusV(const uint& radius)
{
    if(m_radiusV == radius)
    {
        return;
    }
    
    m_radiusV = radius;
    Q_EMIT radiusVChanged(m_radiusV);
}

bool Style::enableEffects() const
{
    return m_enableEffects;
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
         *        then search in left */
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
    m_adaptiveColorSchemeSource_blocked = true;
    if(source == m_adaptiveColorSchemeSource)
    {
        return;
    }
    
    m_adaptiveColorSchemeSource = source;
    Q_EMIT adaptiveColorSchemeSourceChanged(m_adaptiveColorSchemeSource);
}

void Style::unsetAdaptiveColorSchemeSource()
{
    m_adaptiveColorSchemeSource_blocked = false;
    m_adaptiveColorSchemeSource = QUrl::fromUserInput(m_backgroundSettings->wallpaperSource()).toLocalFile();
    Q_EMIT adaptiveColorSchemeSourceChanged(m_adaptiveColorSchemeSource);    
}

QColor Style::accentColor() const
{
    return m_accentColor;
}

void Style::setAccentColor(const QColor& color)
{
    m_accentColor_blocked = true;
    
    if(m_accentColor == color)
    {
        return;
    }
    
    m_accentColor = color;
    Q_EMIT accentColorChanged(m_accentColor);
}

void Style::unsetAccentColor()
{
    m_accentColor_blocked = false;
    m_accentColor = m_themeSettings->accentColor();
    Q_EMIT accentColorChanged(m_accentColor);
}

Style::StyleType Style::styleType() const
{
    return m_styleType;
}

void Style::setStyleType(const Style::StyleType &type)
{
    m_styleType_blocked = true;
    
    if (m_styleType == type)
        return;
    
    m_styleType = type;
    Q_EMIT styleTypeChanged(m_styleType);
}

void Style::unsetStyeType()
{
    m_styleType_blocked = false;
    m_styleType = static_cast<Style::StyleType>(m_themeSettings->styleType());    
    Q_EMIT styleTypeChanged(m_styleType);
}

Units::Units(QObject *parent) : QObject(parent)
, m_fontMetrics(QFontMetricsF(QGuiApplication::font()))
, m_gridUnit(m_fontMetrics.height())    
, m_veryLongDuration(400)
, m_longDuration(200)
, m_shortDuration(100)
, m_veryShortDuration(50)
, m_humanMoment(2000)
, m_toolTipDelay(700)
{
    
}
