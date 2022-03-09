#include "style.h"
#include <QCoreApplication>

Style *Style::m_instance = nullptr;

Style::Style(QObject *parent) : QObject(parent)
,m_defaultFont (QFont())
,m_iconSizes (new GroupSizes(8,16, 22, 32, 48, 64, 128, this))
,m_space( new GroupSizes(4, 6, 8, 16, 24, 32, 40, this))
,m_fontSizes (new GroupSizes{uint(qRound (m_defaultFont.pointSize ()*0.7)),uint(qRound (m_defaultFont.pointSize ()*0.8)),uint(m_defaultFont.pointSize ()),uint(qRound (m_defaultFont.pointSize ()*1.1)),uint(qRound (m_defaultFont.pointSize ()*1.2)),uint(qRound (m_defaultFont.pointSize ()*1.3)),uint(qRound (m_defaultFont.pointSize ()*1.4)), this})
,m_defaultFontSize(m_defaultFont.pointSize ())
{
 connect(qApp, &QCoreApplication::aboutToQuit, []()
    {
        delete m_instance;
        m_instance = nullptr;
    });    
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


