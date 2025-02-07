import QtQuick 2.15
import QtQuick.Window 2.15
import qc.window
import Qt5Compat.GraphicalEffects
import QtQuick.Layouts

FrameLessWindow {
    id: frame_less_window
    width: 640
    height: 480
    /**
     * 设置最小大小
     */
    minimumWidth: 1010
    minimumHeight: 710
    visible: true
    title: qsTr("Hello World")

    Column {
        anchors.fill: parent

        /// 1. 标题部分
        Qmain_interface_title_bar {
            id: title_bar
            width: parent.width
            height: 80
        }

        /// 2. 主体部分
        Rectangle {
            id: content
            width: parent.width
            height: frame_less_window.height - title_bar.height - bottom_bar.height
            Row {
                width: parent.width
                height: parent.height
                /// 2.1 左侧主体部分
                Qmain_interface_content_left {
                    id: left_content
                    width: 180
                    height: parent.height
                }

                /// 2.2 右侧主体部分
                Qmain_interface_content_right {
                    id: right_content
                    width: parent.width - left_content.width
                    height: parent.height
                }

            }
        }

        /// 3. 底部部分
        Qmain_interface_bottom_bar {
            id: bottom_bar
            width: parent.width
            height: 80
        }
    }
}
