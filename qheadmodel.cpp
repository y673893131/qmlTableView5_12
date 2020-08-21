#include "qheadmodel.h"

QHeadModel::QHeadModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

QVariant QHeadModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    switch (role) {
    case Qt::DisplayRole:
        if(section < m_headers.size())
            return m_headers[section];
        break;
    case Qt::SizeHintRole:
        if(orientation == Qt::Horizontal)
            return m_headersWidth[section];
        else
            return 35;
    }

    return QVariant();
}

int QHeadModel::rowCount(const QModelIndex &parent) const
{
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    if (parent.isValid())
        return 0;

    // FIXME: Implement me!
    return m_headers.size();
}

QVariant QHeadModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    // FIXME: Implement me!
    switch (role) {
    case Qt::DisplayRole:
        return m_headers[index.row()];
    }
    return QVariant();
}

int QHeadModel::count()
{
    return m_headers.size();
}

QStringList QHeadModel::headNames() const
{
    return m_headers;
}

QVector<double> QHeadModel::headerWidth() const
{
    return m_headersWidth;
}

void QHeadModel::setHeadNames(const QStringList &heads)
{
    bool bNotify = m_headers == heads;
    m_headers = heads;
    if(bNotify) emit headNamesChanged(m_headers);
}

void QHeadModel::setHeaderWidth(const QVector<double> &widths)
{
    m_headersWidth = widths;
}

QVector<double> QHeadModel::defalutWidth()
{
    return m_headersWidth;
}
