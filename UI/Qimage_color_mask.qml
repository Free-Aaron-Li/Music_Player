import QtQuick 2.15
import Qt5Compat.GraphicalEffects

/**
 * 图片组件——为图片添加颜色蒙版
 */
Image {
    id: img
    property string color: ""
    source: ""

    ColorOverlay { /// 为图片添加颜色蒙版
        anchors.fill: parent
        source: img
        color: parent.color
    }
}
