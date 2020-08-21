import QtQuick 2.12
import QtQuick.Window 2.12
import QDataModel 0.1
Window {
    visible:true
    id: root
    width: 800
    height: 600
    title: "tableView qml 2.12"
    Rectangle
    {
        focus: true
        color: "transparent"

        width: 400
        height: parent.height - 20
        anchors.centerIn: parent
        border.color: "gray"
        border.width: 1

        TableViewEx
        {
            id: table

            anchors.margins: 2
            widths: [50, 100, 100, 100, 40, 140, 110]
            model: model
        }

        QDataModel
        {
            id: model
        }
    }
}
