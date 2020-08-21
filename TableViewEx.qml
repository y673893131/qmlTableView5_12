import QtQuick 2.12
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

GridLayout
{
    id: root

    anchors.fill: parent
    property alias model: view.model
    property int rowHeight: 35
    property alias widths: header.widths

    columns: 1
    rows: 2

    function rowCount(){ return root.model.count }

    //header
    HeaderViewEx
    {
        id: header
        Layout.fillWidth: true
        spacing: 1
        model: root.model.headModel
        contentX: view.contentX
        contentWidth: widthsLen()
        interactive: false
        color: "#E2EEFB"
        property real p: 0
        onMoveSection: {
            model.layoutChanged()
            view.model.layoutChanged()
            forceLayout();
            view.forceLayout();
            contentX = view.contentX
        }
        onColumnWidthChanged: {  view.forceLayout(); view.contentWidth = widthsLen(); }
        onJump: {
            if(!inOrDe) {horScrollBar.decrease()
//            inOrDe ? horScrollBar.increase() : horScrollBar.decrease();//qt bug, increase make view cannot align column with header
            model.layoutChanged()
            view.forceLayout();}
        }
    }

    //view
    TableView
    {
        id: view

        property var hoverIndex: -1
        property var currentIndex: -1
        Layout.fillWidth: true
        Layout.fillHeight: true
        columnSpacing: 1
        rowSpacing: 1
        clip: true
        reuseItems: false
        contentWidth: header.widthsLen()
        columnWidthProvider: header.columnWidthProvider
        rowHeightProvider: function (column) { return root.rowHeight }
        flickableDirection: Flickable.VerticalFlick
        synchronousDrag: true
        ScrollBar.horizontal: ScrollBar { id: horScrollBar; active: true; onActiveChanged: active = true;}
        ScrollBar.vertical: ScrollBar{ id: scrollBar; minimumSize: 0.1; active: true; onActiveChanged: active = true}
        Keys.onUpPressed: upRow()
        Keys.onDownPressed: downRow()
        Component.onCompleted: { view.forceActiveFocus(); selected.connect(onSelected)}
        onContentXChanged: header.contentX = contentX

        delegate: Rectangle
        {
            id: cashierContent
            color:
            {
                view.currentIndex === row ? "#3298FE" :
                (view.hoverIndex === row ? "#97CBFF" : (row % 2 ? "#E0EFFD" : "#E7F6FD"))
            }

            Text {
                id: textId
                text: view.data(row, header.logicIndexMap[column], Qt.DisplayRole)
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font: Global_Object.font
                color: view.currentIndex === row ? "white" : "black"
                elide: Text.ElideRight
                onContentWidthChanged:
                {
                    var i = header.logicIndexMap[column]
                    if(typeof header.maxContentWith[i] === "undefined" || header.maxContentWith[i] < contentWidth)
                        header.maxContentWith[i] = contentWidth
                }
            }

            MouseArea
            {
                id: cashierMouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked:
                {
                    view.forceActiveFocus()
                    view.currentIndex = row
                }
                onDoubleClicked:
                {
                    view.selected(row, header.logicIndexMap[column])
                }
                onEntered: view.hoverIndex = row
                onExited: view.hoverIndex = -1
            }
        }

        signal selected(var row,var column)
        function onSelected(row, column)
        {
            console.log("double click:", data(row, column, Qt.DisplayRole) + "(" + row + "," + column + ")")
        }

        function upRow()
        {
            currentIndex = currentIndex > 0 ? currentIndex - 1 : currentIndex
            if(!isCurrentIndexInView(currentIndex - 1))
            {
                contentY -= (root.rowHeight + rowSpacing)
                if(contentY < 0) contentY = 0
            }

            console.log("up:" + currentIndex)
        }

        function downRow()
        {
            currentIndex = currentIndex < root.rowCount() - 1 ? currentIndex + 1 : currentIndex
            if(!isCurrentIndexInView(currentIndex + 1))
                contentY += (root.rowHeight + rowSpacing)
            console.log("down:" + currentIndex)
        }

        function isCurrentIndexInView(index)
        {
            return (index * (root.rowHeight + rowSpacing) >= contentY && index * (root.rowHeight + rowSpacing)<= contentY + height)
        }


        function data(row, column, role){ return model.data(row, column, role)}


    }
}

