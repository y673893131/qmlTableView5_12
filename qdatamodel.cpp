#include "qdatamodel.h"
#include <QTimer>
QDataModel::QDataModel(QObject *parent)
    : QAbstractTableModel(parent)
{
    m_head = new QHeadModel(this);
    QStringList heads;
    QVector<double> widths;

    heads << tr("ID") << tr("name") << tr("ip address") << tr("tel") << tr("sex") << tr("mac") << tr("floor");
    widths << 50 << 100 << 100 << 100<< 40 << 140 << 110;
    QStringList ss;
    ss << "123" << "test name" << "127.0.0.1" << "12345678901" << "M" << "00-11-22-33-44-55" << "10";
    for(int n = 0; n < 10000; ++n)
    {
        ss[0] = QString::number(n);
        m_datas.push_back(ss);
    }

    m_head->setHeadNames(heads);
    m_head->setHeaderWidth(widths);
}

QVariant QDataModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    return QVariant();
}

int QDataModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    // FIXME: Implement me!
    return m_datas.size();
}

int QDataModel::columnCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    // FIXME: Implement me!
    return m_head->count();
}

QVariant QDataModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    switch (role) {
    case Qt::DisplayRole:
        if(index.row() < m_datas.size() && index.column() < m_datas[index.row()].size())
            return m_datas[index.row()][index.column()];
        break;
    }

    // FIXME: Implement me!
    return QVariant();
}

QVariant QDataModel::data(int row, int column, int role) const
{
    return data(index(row, column), role);
}

int QDataModel::count() const
{
    return m_datas.size();
}

QHeadModel* QDataModel::headModel()
{
    return m_head;
}
