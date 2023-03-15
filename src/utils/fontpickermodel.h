#pragma once

#include <QObject>
#include <QFont>
#include <QStringList>
#include <QFontDatabase>

class FontPickerModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QFont font READ font WRITE setFont NOTIFY fontChanged)
    Q_PROPERTY(QStringList styles READ styles NOTIFY stylesChanged FINAL)
    Q_PROPERTY(QStringList sizes READ sizes NOTIFY sizesChanged FINAL)
    Q_PROPERTY(QStringList fontsModel READ fontsModel NOTIFY fontsModelChanged FINAL)
    Q_PROPERTY(QFontDatabase::WritingSystem writingSystem READ writingSystem WRITE setWritingSystem NOTIFY writingSystemChanged)
    Q_PROPERTY(bool onlyMonospaced READ onlyMonospaced WRITE setOnlyMonospaced NOTIFY onlyMonospacedChanged FINAL)
    
public:
    explicit FontPickerModel(QObject * parent = nullptr);
    
    QFont font();
    void setFont(const QFont &font);
           
    QStringList styles();
    QStringList sizes();
            
    QStringList fontsModel();
    
    QFontDatabase::WritingSystem writingSystem();
    void setWritingSystem(QFontDatabase::WritingSystem value);
    
    bool onlyMonospaced();
    void setOnlyMonospaced(bool value);
    
public Q_SLOTS:
        void updateModel();
        void setFont(const QString &desc);
        QString fontToString();
        
private: 
    QFontDatabase m_fontDatabase;
    QFont m_font;
    QFontDatabase::WritingSystem m_writingSystem;
    bool m_onlyMonospaced;
    
Q_SIGNALS:
    void fontChanged();
    void stylesChanged();
    void sizesChanged();
    void fontsModelChanged();
    void writingSystemChanged();
    void onlyMonospacedChanged();
};
