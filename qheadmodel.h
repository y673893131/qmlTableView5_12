#ifndef QHEADMODEL_H
#define QHEADMODEL_H

#include <QAbstractListModel>

class QHeadModel : public QAbstractListModel
{
    Q_OBJECT

    Q_PROPERTY(int count READ count NOTIFY countChanged)
    Q_PROPERTY(QStringList headNames READ headNames WRITE setHeadNames NOTIFY headNamesChanged)
    Q_PROPERTY(QVector<double> defalutWidth READ defalutWidth NOTIFY defalutWidthChanged)

signals:
    void countChanged(int);
    void headNamesChanged(const QStringList&);
    void defalutWidthChanged(const QVector<double>);
    void flushed(int);
public:
    explicit QHeadModel(QObject *parent = nullptr);

    // Header:
    Q_INVOKABLE QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    int count();
    QStringList headNames() const;
    QVector<double> headerWidth() const;
    void setHeadNames(const QStringList& heads);
    void setHeaderWidth(const QVector<double>& widths);
    QVector<double> defalutWidth();
private:
    QStringList m_headers;
    QVector<double> m_headersWidth;
};

#endif // QHEADMODEL_H
