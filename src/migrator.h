#ifndef MIGRATOR_H
#define MIGRATOR_H

#include <QString>

class Migrator
{
public:
    Migrator();

    bool migrate();
    QString lastError();

private:
    QString _lastError;
};

#endif // MIGRATOR_H
