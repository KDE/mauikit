#pragma once

#include <QObject>
#include <QQmlEngine>

#include <QFont>
#include <QStringList>
#include <QFontDatabase>

/**
 * @brief A model of fonts and its properties.
 * @note This class is exposed as the type `FontPickerModel` to the QML engine. * 
 */
class FontPickerModel : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    /**
     * The current picked font for exposing its properties, such as FontPickerModel::styles, FontPickerModel::sizes, etc.
     */
    Q_PROPERTY(QFont font READ font WRITE setFont NOTIFY fontChanged)
    
    /**
     * The available styles for the current picked font.
     */
    Q_PROPERTY(QStringList styles READ styles NOTIFY stylesChanged FINAL)
    
    /**
     * The available optimal font sizes for the picked font.
     */
    Q_PROPERTY(QStringList sizes READ sizes NOTIFY sizesChanged FINAL)
    
    /**
     * All of the fonts available in the system.
     */
    Q_PROPERTY(QStringList fontsModel READ fontsModel NOTIFY fontsModelChanged FINAL)
    
    /**
     * The desired writing system to filter out the fonts model.
     */
    Q_PROPERTY(QFontDatabase::WritingSystem writingSystem READ writingSystem WRITE setWritingSystem NOTIFY writingSystemChanged)
    
    /**
     * Whether to only list fonts in the fonts model that are mono mono-spaced.
     */
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
    
    /**
     * @brief Forces the model to be updated.
     */
    void updateModel();
    
    /**
     * @brief Set the current picked font to extract its properties.
     * @param desc the description of the font, and its properties.
     * @note See the Qt QFont documentation to see how the font string decsription works.
     */
    void setFont(const QString &desc);
    
    /**
     * @brief Converts the current picked font to its string description.
     * @return the converted QFont font and its all properties to a string text.
     */
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
