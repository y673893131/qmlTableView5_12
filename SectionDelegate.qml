import QtQuick 2.12
import QtQuick.Controls 2.12

Rectangle
{
    property alias text : label.text
    property alias textColor: label.color
    property alias horizontalAlignment: label.horizontalAlignment
    property alias font: label.font
    property alias textContentWidth: label.contentWidth
    property alias textLeftPadding: label.leftPadding
    property alias textRightPadding: label.rightPadding
    color:"#eec"
    Text {
        id: label
        anchors.fill: parent
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        rightPadding: 5
        leftPadding: 5
        font.bold: true
        font.family: "Microsoft YaHei"
        font.pixelSize: 14
        elide: Text.ElideRight
    }
}
