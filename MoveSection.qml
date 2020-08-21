import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

Rectangle
{
    id: root
    color: "transparent"
    height: parent.height
    width: parent.width

    property alias font: label.font
    property color fontColor: "black"
    property color sectionColor: "lightgray"
    property alias moved: sectionArea.moved

    Rectangle
    {
        id: sectionId
        height: parent.height
        color: Qt.darker(sectionColor, 1.05)
        Text {
            id: label
            anchors.fill: parent
            verticalAlignment: Qt.AlignVCenter
            horizontalAlignment: Qt.AlignHCenter
            elide: Text.ElideRight
            color: fontColor
        }

        opacity: sectionArea.moved ? 1 : 0
    }

    MouseArea
    {
        id: sectionArea
        anchors.fill: parent
//        hoverEnabled: true //don't set true
        acceptedButtons: Qt.LeftButton
        drag{ target: sectionId; axis: Drag.XAxis; }
        property int from: -1
        property int to: -1
        property bool moved: false
        property real pressX: 0
        onPressed:
        {
            pressX = mouseX
            from = root.parent.virtualPosX(mouseX)
            label.text = root.parent.columnTextProvider(from)
            to = -1
            sectionId.width = root.parent.columnWidthProvider(from)
            sectionId.x = root.parent.columnPos(from) - root.parent.contentX
            mouse.accepted = true
            moved = false
        }

        onMouseXChanged: {
            if(!moved && pressX != mouseX) moved = true
            if(mouseX > root.width)
                root.jump(true)
            else if(mouseX < 0)
                root.jump(false)
            to = root.parent.virtualPosX(mouseX)
            root.parent.sectionIndexUnder = to
        }

        onReleased: {
            if(!moved) root.clicked(from)
            moved = false

            if(from !== to && from >= 0 && to >= 0)
                root.moveSection(from, to)
            root.parent.sectionIndexUnder = -1
        }
    }

    signal moveSection(var oldSection, var newSection)
    signal jump(var inOrDe)
    signal clicked(var section)

    onClicked: console.log("click column is:" + root.parent.logicIndexMap[section], "text:" + root.parent.labels[root.parent.logicIndexMap[section]])
}
