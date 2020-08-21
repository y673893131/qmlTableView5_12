#ifndef QDATAMODEL_H
#define QDATAMODEL_H

#include <QAbstractTableModel>
#include "qheadmodel.h"
class QDataModel : public QAbstractTableModel
{
    Q_OBJECT

    Q_PROPERTY(int count READ count NOTIFY countChanged)
    Q_PROPERTY(QHeadModel* headModel READ headModel NOTIFY headModelChanged)

signals:
    void countChanged(int);
    void flushed();
    void headModelChanged(QHeadModel*);
    void dataChanged();
public:
    explicit QDataModel(QObject *parent = nullptr);

    // Header:
    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    Q_INVOKABLE QVariant data(int row, int column, int role = Qt::DisplayRole) const;

    int count() const;
    QHeadModel* headModel();
private:
    QHeadModel* m_head;
    QVector<QStringList> m_datas;
};

#endif // QDATAMODEL_H
