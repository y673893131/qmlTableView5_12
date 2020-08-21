import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

ListView {
    id:root
    property var widths : []
    property var maxContentWith: []
    property var labels: model.headNames
    property var count : labels.length
    property var defaultWidth : model.defalutWidth
    property real minimalWidth : 50
    property color color: "black"
    property color textColor: "black"
    property int sectionIndexUnder: -1
    property var logicIndexMap: logicIndexInit()
    property var sortIndicateGroup
    property font font: Qt.font({bold: true, family: "Microsoft YaHei", pixelSize: 14})
    property alias moved: moveId.moved
    property bool pressed: false
    height: /*columnHeight()*/35
    orientation: ListView.Horizontal
    clip: true

    delegate: SectionDelegate {
        id: header
        property int logicIndex: root.logicIndexMap[index]
        font: root.font
        width:  root.widths[logicIndex] ? root.widths[logicIndex] : defaultWidth[logicIndex]
        height:  root.height
        color: sectionIndexUnder == index ? Qt.darker(root.color, 1.1) : root.color
        text: root.model.headNames[logicIndex]
        textColor: root.textColor
        Component.onCompleted: logicIndex=root.logicIndexMap[index]

        Popup
        {
            id: resizeSection
            height: parent.height
            width: 20
            x: parent.width - width/2
            closePolicy: Popup.NoAutoClose
            Component.onCompleted: open()
            background: Rectangle
            {
                color: "transparent"
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                MouseArea {
                    id: mouseRightHandle
                    acceptedButtons: Qt.LeftButton
                    anchors.fill: parent
                    drag{ target: parent; axis: Drag.XAxis }
//                    hoverEnabled: true
                    cursorShape: Qt.SplitHCursor
                    onDoubleClicked:
                    {
                        header.width = /*header.textContentWidth*/root.maxContentWith[logicIndex] + header.textLeftPadding + header.textRightPadding
                        root.widths[logicIndex] = header.width
                        root.columnWidthChanged()
                    }
                    onPressed: root.pressed = true
                    onReleased: root.pressed = false
                    onMouseXChanged: {
                        if (drag.active) {
                            var p = root.mapFromItem(mouseRightHandle, mouseX, mouseRightHandle.y)
                            if(p.x <= 2) return
//                            console.log(p, header.text)
                            var newWidth = header.width + mouseX
                            if (newWidth >= minimalWidth) {
                                header.width = newWidth
                                root.widths[logicIndex] = newWidth
                                root.columnWidthChanged()
                            }
                        }
                    }
                }
            }
        }
    }

    MoveSection
    {
        id: moveId
        font: root.font
        fontColor: Qt.rgba(root.textColor.r, root.textColor.g, root.textColor.b, 0.8)
        sectionColor: Qt.rgba(root.color.r, root.color.g, root.color.b, 0.8)
        onMoveSection: {root.moveSection(oldSection, newSection);root.sectionIndexUnder=-1}
        onJump: root.jump(inOrDe)
    }

    signal columnWidthChanged
    signal moveSection(var oldSection, var newSection)
    signal jump(var inOrDe)
    signal sectionChanged

    onMoveSection:
    {
        var oldLogicIndex = logicIndexMap[oldSection]
        var newLogicIndex = logicIndexMap[newSection]

        if(oldSection > newSection) //jump left
        {
            for(var i = oldSection; i > newSection; --i)
            {
                logicIndexMap[i] = logicIndexMap[i - 1]
            }

            logicIndexMap[newSection] = oldLogicIndex
        }
        else
        {
            for(var j = oldSection; j < newSection; ++j)
            {
                logicIndexMap[j] = logicIndexMap[j + 1]
            }

            logicIndexMap[newSection] = oldLogicIndex
        }

        sectionIndexUnder = -1
        console.log("move section:", labels[oldLogicIndex] + "(" + oldLogicIndex + ")", "->", labels[newLogicIndex] + "(" + newLogicIndex + ")", logicIndexMap)
    }
    function widthsLen()
    {
        var pos = 0
        for (var i=0; i<count; i++) pos += widths[i]
        pos += (count - 1) * spacing
        return pos
    }
    function columnCount() { return model.headNames.length }
    function columnHeight() { return root.model.headerData(0, Qt.Vertical, Qt.SizeHintRole) }
    function virtualPosX(mouseX)
    {
        var pos = mouseX + contentX
        if(pos < 0) return 0
        var w = 0.0
        for (var i=0; i<count; i++)
        {
            w += widths[logicIndexMap[i]] + spacing
            if(w >= pos) return i
        }

        return count - 1
    }
    function virtualIndex(sectionText)
    {
        for (var i=0; i<count; i++)
        {
            if(labels[logicIndexMap[i]] === sectionText) return i
        }

        return -1
    }
    function logicIndexInit()
    {
        var index=[]
        for (var i=0; i<count; i++)
            index[i] = i
        return index
    }
    function columnPos(index) {
        var pos = 0
        for (var i=0; i<index; i++) pos += widths[logicIndexMap[i]] + root.spacing
        return pos
    }
    function columnWidthProvider(column) { return widths[logicIndexMap[column]] }
    function columnTextProvider(column) { return labels[logicIndexMap[column]] }
    function checkUnderIndex(index, xPos)
    {
        if(xPos < 0) xPos = 0
        var pos = 0
        var posEnd = xPos + widths[logicIndexMap[index]]
        if(posEnd > width) posEnd = width
        for (var i=0; i<count; i++)
        {
            var lIndex = logicIndexMap[i]
            if(i !== index && ((xPos <= pos + widths[lIndex] / 2 && posEnd >= pos + widths[lIndex] / 2)
                               || (xPos >= pos && posEnd <= pos + widths[lIndex] )))
            {
                sectionIndexUnder = i
                if(xPos <= 0) jump(false)
                else if(posEnd >= width) jump(true)
                return
            }

            pos += widths[lIndex] + spacing
        }

        if(xPos <= 0) jump(false)
        else if(posEnd >= width) jump(true)
        else sectionIndexUnder = -1

    }
}
