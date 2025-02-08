import QtQuick 2.15

/**
 * 工具组件——带有默认鼠标效果的按钮
 */
MouseArea {
    property string color: ""
    property string icon_color: ""
    property string source: ""
    property string hovered_color: ""
    property bool is_hovered: false
    width: 30
    height: width
    hoverEnabled: true
    Rectangle {
        anchors.fill: parent
        radius: 100
        color: if (parent.is_hovered) return hovered_color
        else return parent.color
    }
    Qimage_color_mask {
        width: parent.width * .5
        height: width
        anchors.centerIn: parent
        source: parent.source
        sourceSize: Qt.size(32, 32)
        color: parent.icon_color
    }
    onEntered: {
        is_hovered = true
    }
    onExited: {
        is_hovered = false
    }
}
