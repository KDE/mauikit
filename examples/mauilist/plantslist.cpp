#include "plantslist.h"

PlantsList::PlantsList(QObject *parent) : MauiList(parent)
{

}

void PlantsList::componentComplete()
{
    Q_EMIT preListChanged();
    m_list = getData();
    Q_EMIT postListChanged();
    Q_EMIT countChanged();
}

const FMH::MODEL_LIST &PlantsList::items() const
{
    return m_list;
}

FMH::MODEL_LIST PlantsList::getData() const
{
    FMH::MODEL_LIST data;

    data << FMH::MODEL {{FMH::MODEL_KEY::TITLE, QStringLiteral("Acanthaceae")}, {FMH::MODEL_KEY::CATEGORY, QStringLiteral("Acanthus")}};

    data << FMH::MODEL {{FMH::MODEL_KEY::TITLE, QStringLiteral("Agavaceae")}, {FMH::MODEL_KEY::CATEGORY, QStringLiteral("Agave")}};

    data << FMH::MODEL {{FMH::MODEL_KEY::TITLE, QStringLiteral("Bixaceae")}, {FMH::MODEL_KEY::CATEGORY, QStringLiteral("Annatto")}};

    data << FMH::MODEL {{FMH::MODEL_KEY::TITLE, QStringLiteral("Asteraceae")}, {FMH::MODEL_KEY::CATEGORY, QStringLiteral("Aster")}};

    data << FMH::MODEL {{FMH::MODEL_KEY::TITLE, QStringLiteral("Leguminaceae")}, {FMH::MODEL_KEY::CATEGORY, QStringLiteral("Bean")}};

    return data;
}
