import QtQuick 2.15
import Qt5Compat.GraphicalEffects

/**
 * 图片组件——圆角图片
 * 用于：设置底部栏音乐封面
 */
Item {
    id: image_round_corner
    property alias fillMode: img.fillMode
    property string source: ""
    property double radius: 10

    Image {
        id: img
        anchors.fill: parent
        source: parent.source
        fillMode: Image.PreserveAspectCrop
    }
    OpacityMask { /// 蒙版
        anchors.fill: parent
        source: img
        maskSource: mask
    }

    Rectangle {
        id: mask
        anchors.fill: parent
        visible: false
        radius: parent.radius
    }

}
