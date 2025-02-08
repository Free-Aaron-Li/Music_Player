import QtQuick 2.15

/**
 * 主页——左侧主体部分
 */
Rectangle {
    id: left_content
    property var theme: themes.default_theme[themes.current]
    /// 按钮元素数组
    /// 侧边栏由多个区块组成，如：发现、关注、我喜欢、最近播放
    property var left_content_parts: [
        {
            header_text: "在线音乐",
            button_data: [
                {
                    button_text: "发现",
                    button_icon: theme.left_content_discover_music_icon_dir,
                    qml: "", /// 跳转文件
                    is_active: true, /// 是否显示
                },
                {
                    button_text: "关注",
                    button_icon: theme.left_content_my_attention_icon_dir,
                    qml: "",
                    is_active: true,
                },
                {
                    button_text: "FM",
                    button_icon: theme.left_content_fm_icon_dir,
                    qml: "",
                    is_active: true,
                }
            ],
            is_active: true
        },
        {
            header_text: "我的音乐",
            button_data: [
                {
                    button_text: "喜欢",
                    button_icon: theme.left_content_my_favorite_icon_dir,
                    qml: "", /// 跳转文件
                    is_active: true, /// 是否显示
                },
                {
                    button_text: "收藏",
                    button_icon: theme.left_content_my_collection_icon_dir,
                    qml: "",
                    is_active: true,
                },
                {
                    button_text: "本地",
                    button_icon: theme.left_content_local_icon_dir,
                    qml: "",
                    is_active: true,
                }
            ],
            is_active: true
        },
    ]

    /// 筛选需要显示的数据
    function filter_left_content_parts(left_content_parts) {
        let filtered_data = left_content_parts.map(item => {
            if (item.is_active) {
                let filtered_button_data = item.button_data.filter(button => button.is_active);
                return {
                    header_text: item.header_text, button_data: filtered_button_data
                };
            }
            return null;
        }).filter(item => item !== null);
        return filtered_data
    }

    color: theme.left_content_background_color
    ///property var this_data: left_content_parts
    property var this_data: filter_left_content_parts(left_content_parts)
    property string this_qml: ""
    property string this_button_text: "发现"
    property int count: this_data.length
    property int button_height: 40


    Flickable {
        id: left_content_flickable
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: left_content_repeater.all_height
        Column {
            topPadding: 10
            spacing: 15
            Repeater {
                id: left_content_repeater
                property int all_height: 0
                model: left_content.count
                delegate: left_content_repeater_delegate
                onCountChanged: { /// 内容总高度
                    var h = 0;
                    for (var i = 0; i < count; ++i) {
                        h += itemAt(i).height
                    }
                    h = all_height + parent.spacing * count
                }
            }

        }
        Component {
            id: left_content_repeater_delegate
            ListView {
                id: list_view
                width: left_content_flickable.width
                height: left_content.button_height * count
                spacing: 4
                interactive: false /// 禁止拖曳
                model: ListModel {
                }
                header: Text { /// 侧边栏分区标题
                    width: parent.width
                    height: text === "" ? 0 : contentHeight + 5
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    font.pointSize: theme.left_content_font_size - 2
                    text: left_content.this_data[index].header_text
                    color: theme.left_content_font_color
                }
                delegate: left_content_list_view_delegate
                Component.onCompleted: { /// 组件创建完成后，添加数据
                    model.append(left_content.this_data[index].button_data)
                }
            }
        }
        Component { /// ListView委托项，区块内设置
            id: left_content_list_view_delegate
            Rectangle {
                property bool is_hovered: false
                property bool is_this_button: left_content.this_button_text === button_text /// 当前按钮是否被选中
                width: left_content_flickable.width - 15
                height: left_content.button_height - 6 /// 彼此区块间间隔
                radius: 50
                color: if (is_hovered) {
                    return "#1F" + theme.left_content_sub_background_color
                } else {
                    return theme.left_content_cursor_leave_button_color
                }
                Rectangle { /// 按钮被选中背景效果
                    width: parent.is_this_button ? parent.width : 0
                    height: parent.height
                    radius: parent.radius
                    color: "#2F" + theme.left_content_sub_background_color
                    Behavior on width {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.InOutQuad
                        }
                    }
                }

                Row {
                    spacing: 10
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: parent.radius / 4
                    Image {
                        width: 20
                        height: width
                        source: button_icon
                        sourceSize: Qt.size(32, 32)
                    }
                    Text {
                        font.bold: is_this_button ? true : false
                        font.pointSize: theme.left_content_font_size
                        scale: is_this_button ? 1.1 : 1
                        text: button_text
                        color: theme.left_content_font_color
                        Behavior on scale {
                            NumberAnimation {
                                duration: 200
                                easing.type: Easing.InOutQuad
                            }
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        left_content.this_button_text = button_text
                        left_content.this_qml = qml
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
