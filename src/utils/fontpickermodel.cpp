#include "fontpickermodel.h"

#include <QDebug>

FontPickerModel::FontPickerModel(QObject* parent) : QObject(parent)
,m_writingSystem(QFontDatabase::Any)
,m_onlyMonospaced(false)
{
}

QStringList FontPickerModel::fontsModel()
{
    auto fonts = m_fontDatabase.families(m_writingSystem);

    if(m_onlyMonospaced)
    {
        QStringList res;
        foreach (const QString &family, fonts) 
        {
            if (m_fontDatabase.isFixedPitch(family)) 
            {
                res << family;
            }
        }
        
        return res;
    }    
   
    return fonts;
}

QFont FontPickerModel::font()
{
    return m_font;
}

bool FontPickerModel::onlyMonospaced()
{
    return m_onlyMonospaced;
}

void FontPickerModel::setFont(const QFont& font)
{
    if(m_font == font)
        return;
    
    m_font = font;
    Q_EMIT fontChanged();
    Q_EMIT sizesChanged();
    Q_EMIT stylesChanged();
}

void FontPickerModel::setOnlyMonospaced(bool value)
{
    if(m_onlyMonospaced == value)
        return;
    
    m_onlyMonospaced = value;
    Q_EMIT onlyMonospacedChanged();
    Q_EMIT fontsModelChanged();
}

void FontPickerModel::setWritingSystem(QFontDatabase::WritingSystem value)
{
    if(m_writingSystem == value) 
        return;
    
    m_writingSystem = value;
    Q_EMIT writingSystemChanged();
    Q_EMIT fontsModelChanged();
}

QStringList FontPickerModel::sizes()
{
    QStringList res;
    
    for(auto value : m_fontDatabase.smoothSizes(m_font.family(), m_font.styleName()))
    {
        res << QString::number(value);
    }
    
    return res;
}

QStringList FontPickerModel::styles()
{
    return m_fontDatabase.styles(m_font.family());
}

QFontDatabase::WritingSystem FontPickerModel::writingSystem()
{
    return m_writingSystem;
}

void FontPickerModel::updateModel()
{
    Q_EMIT sizesChanged();
    Q_EMIT stylesChanged();
}

QString FontPickerModel::fontToString()
{
    return m_font.toString();
}

void FontPickerModel::setFont(const QString& desc)
{
    QFont font;
    
    if(!font.fromString(desc))
    {
          qWarning() << "Failed to set QFont from desc" << desc;
          return;
    }
    
    setFont(font);
}








