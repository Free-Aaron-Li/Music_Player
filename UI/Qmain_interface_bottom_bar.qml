import QtQuick 2.15
import QtQuick.Controls
import "find_music/"

/**
 * 主页——底部栏
 */
Rectangle {
    id: bottom_bar
    property var theme: themes.default_theme[themes.current]
    property double font_size: theme.bottom_bar_font_size
    color: theme.bottom_bar_background_color

    Slider { /// 进度条
        id: bottom_bar_slider
        width: parent.width
        height: 5
        anchors.bottom: parent.top
        background: Rectangle {
            /// 进度条背景
            color: "#1F" + bottom_bar.theme.bottom_bar_sub_background_color
            Rectangle {
                width: bottom_bar_slider.visualPosition * parent.width
                height: parent.height
                color: "#FF" + bottom_bar.theme.bottom_bar_sub_background_color
            }
        }
        handle: Rectangle {
            /// 进度条头部
            implicitWidth: 20 
            implicitHeight: 20
            x: (bottom_bar_slider.availableWidth - width) * bottom_bar_slider.visualPosition
            y: -((height - bottom_bar_slider.height) / 2)
            radius: 100
            border.width: 1.5
            border.color: "#FF" + bottom_bar.theme.bottom_bar_sub_background_color
            color: bottom_bar_slider.pressed ? "#FF" + bottom_bar.theme.bottom_bar_sub_background_color : "WHITE"
        }
    }

    Item {
        /// 底部栏分区
        width: parent.width - 15
        height: parent.height - 20
        anchors.centerIn: parent
        /// 1. 左侧区域
        Row {
            /// 歌曲封面
            width: parent.width * 3
            height: parent.height
            anchors.left: parent.left
            spacing: 10
            Qimage_round_corner {
                id: music_cover_image
                width: parent.height
                height: width
                source: bottom_bar.theme.bottom_bar_music_cover_image_dir
            }
            Column {
                /// 歌曲信息
                width: parent.width - music_cover_image.width - parent.spacing
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    font.pointSize: bottom_bar.font_size
                    text: "歌名"
                    color: bottom_bar.theme.bottom_bar_font_color
                }
                Text {
                    font.pointSize: bottom_bar.font_size
                    text: "歌手"
                    color: bottom_bar.theme.bottom_bar_font_color
                }
            }
        }
        /// 2. 中间区域
        Row {
            width: parent.width * .3
            anchors.centerIn: parent
            spacing: 5
            /// 2.1 按钮设置
            Qtool_tip_button {
                /// 2.1.1 单曲循环
                width: 35
                height: width
                source: bottom_bar.theme.bottom_bar_repeat_single_play_icon_dir
                hovered_color: "#1F" + bottom_bar.theme.bottom_bar_sub_background_color
                color: bottom_bar.theme.bottom_bar_cursor_leave_button_color
                icon_color: "#FF" + bottom_bar.theme.bottom_bar_sub_background_color
            }
            Qtool_tip_button {
                /// 2.1.2 上一曲
                width: 35
                height: width
                source: bottom_bar.theme.bottom_bar_pre_play_icon_dir
                hovered_color: "#1F" + bottom_bar.theme.bottom_bar_sub_background_color
                color: bottom_bar.theme.bottom_bar_cursor_leave_button_color
                icon_color: "#FF" + bottom_bar.theme.bottom_bar_sub_background_color
            }
            Qtool_tip_button {
                /// 2.1.3 播放
                width: 35
                height: width
                source: bottom_bar.theme.bottom_bar_player_icon_dir
                hovered_color: "#FF" + bottom_bar.theme.bottom_bar_sub_background_color
                color: "#FF" + bottom_bar.theme.bottom_bar_sub_background_color
                icon_color: "WHITE"
                onEntered: {
                    scale = 1.1;
                }
                onExited: {
                    scale = 1;
                }
                Behavior on scale {
                    ScaleAnimator {
                        duration: 200
                        easing.type: Easing.InOutQuart
                    }
                }
            }
            Qtool_tip_button {
                /// 2.1.4 下一曲
                width: 35
                height: width
                /// 上一曲与下一曲图标一致，仅需更改方向
                source: bottom_bar.theme.bottom_bar_pre_play_icon_dir
                transformOrigin: Item.Center
                rotation: -180
                hovered_color: "#1F" + bottom_bar.theme.bottom_bar_sub_background_color
                color: bottom_bar.theme.bottom_bar_cursor_leave_button_color
                icon_color: "#FF" + bottom_bar.theme.bottom_bar_sub_background_color
            }

            Component.onCompleted: {
                /// 定义中间组件（播放等）宽度
                var w = 0;
                for (var i = 0; i < children.length; ++i) {
                    w += children[i].width;
                }
                w = w + children.length * spacing - spacing;
                width = w;
            }
        }
        /// 3. 右侧区域
        Row {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: 5
            /// 3.1 时间轴
            Text {
                /// 3.1.1 时间轴：当前时间
                font.pointSize: bottom_bar.font_size
                anchors.verticalCenter: parent.verticalCenter
                font.weight: 1
                text: "00:00"
                color: bottom_bar.theme.bottom_bar_font_color
            }
            Text {
                /// 3.1.2 时间轴：总时间
                font.pointSize: bottom_bar.font_size
                anchors.verticalCenter: parent.verticalCenter
                font.weight: 1
                text: "/00:00"
                color: bottom_bar.theme.bottom_bar_font_color
            }
            /// 3.2 按钮设置
            Qtool_tip_button {
                /// 3.2.1 音量
                width: 35
                height: width
                source: bottom_bar.theme.bottom_bar_player_volume_dir
                hovered_color: "#1F" + bottom_bar.theme.bottom_bar_sub_background_color
                color: bottom_bar.theme.bottom_bar_cursor_leave_button_color
                icon_color: "#FF" + bottom_bar.theme.bottom_bar_sub_background_color
            }
            Qtool_tip_button {
                /// 3.2.2 播放列表
                width: 35
                height: width
                source: bottom_bar.theme.bottom_bar_play_list_dir
                hovered_color: "#1F" + bottom_bar.theme.bottom_bar_sub_background_color
                color: bottom_bar.theme.bottom_bar_cursor_leave_button_color
                icon_color: "#FF" + bottom_bar.theme.bottom_bar_sub_background_color
            }

            Component.onCompleted: {
                /// 定义中间组件宽度
                var w = 0;
                for (var i = 0; i < children.length; ++i) {
                    if (children[i] instanceof Text) {
                        w += children[i].contentWidth;
                    } else {
                        w += children[i].width;
                    }
                }
                w = w + children.length * spacing - spacing;
                width = w;
            }
        }
    }
}
