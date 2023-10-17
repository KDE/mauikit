#pragma once

#include <QObject>
#include <MauiKit4/Core/mauilist.h>

class PlantsList : public MauiList
{
    Q_OBJECT
public:
    PlantsList(QObject *parent = nullptr);

    // QQmlParserStatus interface
    void componentComplete();

    // MauiList interface
    const FMH::MODEL_LIST &items() const;

private:
    FMH::MODEL_LIST m_list;

    //Here we have our own custom raw data and turn it into a FMH::MODEL_LIST
    FMH::MODEL_LIST getData() const;
};
