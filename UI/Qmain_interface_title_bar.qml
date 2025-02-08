import QtQuick 2.15
import QtQuick.Window 2.15
import qc.window
import Qt5Compat.GraphicalEffects
import QtQuick.Layouts

/**
 * 主页——标题栏
 */
Rectangle {
    id: title_bar
    property var theme: themes.default_theme[themes.current]
    color: theme.title_background_color
    /// 获取鼠标事件
    MouseArea {
        property var click_pos: Qt.point(0, 0)
        anchors.fill: parent /// 撑满父组件
        /// 应用面积拉伸
        onPositionChanged: function (mouse) {
            if (!pressed) return
            if (!frame_less_window.startSystemMove()) {
                var off_set = Qt.point(mouseX - click_pos.x, mouseY - click_pos.y)
                frame_less_window.x += off_set.x
                frame_less_window.y += off_set.y
            }
        }
        /// 双击全屏
        onDoubleClicked: {
            if (frame_less_window.visibility === Window.Maximized) {
                frame_less_window.showNormal();
            } else {
                frame_less_window.showMaximized();
            }
        }
        /// 获取鼠标点击位置
        onPressedChanged: function (mouse) {
            click_pos = Qt.point(mouseX, mouseY)
        }

        /// 顶部标题栏
        /// 鼠标事件判断
        RowLayout {
            /// 高宽留出间距
            width: parent.width - 20
            height: parent.height - 10
            anchors.centerIn: parent
            /// 左侧标题区域
            Row {
                width: 80
                height: parent.height
                spacing: 15
                Image {
                    id: music163
                    width: 40
                    height: width
                    anchors.verticalCenter: parent.verticalCenter /// 居中显示
                    source: theme.title_logo_dir
                    /// 更改Logo颜色
                    ColorOverlay {
                        anchors.fill: parent
                        source: parent
                        color: theme.title_logo_color
                    }
                }
                Text {
                    id: title_name
                    font.pointSize: 12
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("Music Player")
                    /// 更改文本颜色
                    color: theme.title_font_color
                }
                /// 处理组件宽度
                Component.onCompleted: {
                    /// logo+文本宽+间隔
                    width = children[0].width + children[1].contentWidth + spacing
                }
            }
            /// 占位组件，将按钮挤压到右方
            Item {
                Layout.preferredWidth: 10
                Layout.fillWidth: true
            }

            /// 右侧窗口控制按钮区
            Row {
                width: 30 * 3 + 5 * 3
                spacing: 5
                /// 1. 缩小图标
                Rectangle {
                    id: min_window_button
                    /// 标志位，判断鼠标是否移入组件
                    property bool is_hovered: false
                    width: 30
                    height: width

                    /// 圆形阴影
                    radius: 100
                    color: if (is_hovered) return theme.title_cursor_hovered_button_shadow_color
                    else return theme.title_cursor_leave_button_color

                    /// 绘制图标
                    Rectangle {
                        width: parent.width - 10
                        height: 2
                        anchors.centerIn: parent
                        border.color: theme.title_button_minimize_color
                        color: theme.title_cursor_leave_button_color
                    }

                    /// 鼠标事件判断
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            frame_less_window.showMinimized()
                        }
                        onEntered: {
                            parent.is_hovered = true
                        }
                        onExited: {
                            parent.is_hovered = false
                        }
                    }
                }
                /// 2. 放大图标
                Rectangle {
                    id: max_window_button
                    property bool is_hovered: false
                    width: 30
                    height: width
                    radius: 100
                    color: if (is_hovered) return theme.title_cursor_hovered_button_shadow_color
                    else return theme.title_cursor_leave_button_color

                    /// 绘制图标
                    Rectangle {
                        width: parent.width - 10
                        height: width
                        anchors.centerIn: parent
                        radius: 100
                        border.width: 2
                        border.color: theme.title_button_maximize_restore_color
                        color: theme.title_cursor_leave_button_color
                    }

                    /// 鼠标事件判断
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            if (frame_less_window === Window.Maximized) {
                                frame_less_window.showNormal()
                            } else {
                                frame_less_window.showMaximized()
                            }
                        }
                        onEntered: {
                            parent.is_hovered = true
                        }
                        onExited: {
                            parent.is_hovered = false
                        }
                    }
                }
                /// 3. 关闭图标
                Rectangle {
                    id: close_window_button
                    property bool is_hovered: false
                    width: 30
                    height: width
                    radius: 100
                    color: if (is_hovered) return theme.title_cursor_hovered_button_shadow_color
                    else return theme.title_cursor_leave_button_color

                    /// 绘制图标
                    Rectangle {
                        width: parent.width - 10
                        height: 2
                        anchors.centerIn: parent
                        rotation: 45
                        border.color: theme.title_button_close_color
                        color: theme.title_cursor_leave_button_color
                    }
                    Rectangle {
                        width: parent.width - 10
                        height: 2
                        anchors.centerIn: parent
                        rotation: -45
                        border.color: theme.title_button_close_color
                        color: theme.title_cursor_leave_button_color
                    }

                    /// 鼠标事件判断
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            Qt.quit()
                        }
                        onEntered: {
                            parent.is_hovered = true
                        }
                        onExited: {
                            parent.is_hovered = false
                        }
                    }
                }
            }
        }
    }
}
