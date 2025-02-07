import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import qc.window

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

    /// 主题
    QtObject {
        id: themes
        property int current: 0 /// 当前主题索引
        /// var类型只有它的类型改变才会触发信号
        /// 如：var t = {t:""}
        /// t.t = "aaa" /// 不会触发信号
        /// t = "" /// 触发信号
        /// var类型只有复制的对象类型改变才会触发信号
        /// 解决思路：手动触发信号
        /// 默认主题
        property var default_theme: [
            {
                name:"pink",
                /// title
                title_background_color: "#FAF2F1",
                title_logo_color:"#572920",
                title_font_color:"#572920",
                title_button_minimize_color: "#572920",
                title_button_maximize_restore_color: "#572920",
                title_button_close_color: "#572920",
                title_cursor_hovered_button_shadow_color:"#1F572920",
                title_cursor_leave_button_color: "#00000000",
                type:"default",
            },
        ]

    }

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
                    height: parent.heigh
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
