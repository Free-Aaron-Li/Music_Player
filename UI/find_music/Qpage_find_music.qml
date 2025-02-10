import QtQuick 2.15

/**
  * 页面——发现
  */
Flickable {
    id: find_music_page_flickable
    property var theme: themes.default_theme[themes.current]

    property var header_data: [
        {
            header_text: "歌单",
            qml: "Qpage_find_music_play_list_content.qml"
        },
        {
            header_text: "最新音乐",
            qml: "Qpage_find_music_latest_music_content.qml"
        },
        {
            header_text: "个性推荐",
            qml: ""
        },
        {
            header_text: "专属定制",
            qml: ""
        },
    ]

    property double font_size: theme.page_find_music_font_size
    anchors.fill: parent

    /// 1. 头部
    Rectangle {
        id: find_music_header
        property int current: 0
        property double top_bottom_padding: 25 /// 内间距
        property double left_right_padding: 35
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 25
        radius: width / 2
        color: "#0F" + theme.page_find_music_header_sub_background_color

        Row {
            Repeater {
                model: ListModel {}
                delegate: find_music_header_delegate
                Component.onCompleted: {
                    model.append(find_music_page_flickable.header_data);
                }
                onCountChanged: {
                    /// 头部组件大小
                    var w = 0;
                    var h = 0;
                    for (var i = 0; i < count; ++i) {
                        w += itemAt(i).width;
                        if (h < itemAt(i).height) {
                            h = itemAt(i).height;
                        }
                        find_music_header.width = w;
                        find_music_header.height = h;
                    }
                }
            }
        }
        Component {
            id: find_music_header_delegate
            Rectangle {
                property bool is_hovered: false
                width: children[0].contentWidth + find_music_header.left_right_padding
                height: children[0].contentHeight + find_music_header.top_bottom_padding
                radius: width / 2
                color: if (find_music_header.current === index)
                    return "#2F" + theme.page_find_music_header_sub_background_color
                else if (is_hovered)
                    return "#1F" + theme.page_find_music_header_sub_background_color
                else
                    return theme.page_find_music_header_cursor_leave_button_color
                Text {
                    anchors.centerIn: parent
                    font.pointSize: theme.page_find_music_header_font_size
                    font.bold: find_music_header.current === index
                    text: header_text
                    color: theme.page_find_music_header_font_color
                }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        find_music_header.current = index;
                    }
                    onEntered: {
                        parent.is_hovered = true;
                    }
                    onExited: {
                        parent.is_hovered = false;
                    }
                }
            }
        }
    }

    /// 2. 主体
    Item {
        id: find_music_content
        /// 组件加载方式实现
        width: parent.width * .85
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: find_music_header.bottom
        anchors.topMargin: 25

        Loader {
            source: find_music_page_flickable.header_data[find_music_header.current].qml
            onStatusChanged: {
                if(status === Loader.Ready) {
                    item.parent = find_music_content
                    console.log("加载内容："+source)
                }
            }
        }
    }
}
