#ifndef TRANSLATIONHANDLER_H
#define TRANSLATIONHANDLER_H

#include <QObject>
#include <QTranslator>
#include <QQmlEngine>

class TranslationHandler : public QObject
{
    Q_OBJECT
public:
    explicit TranslationHandler(QObject *parent = nullptr);
    ~TranslationHandler();

    // Load new translation.
    Q_INVOKABLE void loadTranslation(QString language);

signals:
    void translateUI();

public slots:

private:
    QTranslator m_translator;
    QString m_langPath;
    QString m_langFilePrefix;
    QString m_defaultLangPrefix;
};

#endif // TRANSLATIONHANDLER_H
