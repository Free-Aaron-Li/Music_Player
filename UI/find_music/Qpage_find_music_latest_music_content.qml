import QtQuick 2.15
import "../"

/**
  * 页面——发现：最新音乐
  * API:
  * npx NeteaseCloudMusicApi@latest
  * Document：
  * https://neteasecloudmusicapi.js.org/
 */
Item {
    id: latest_music
    property var theme: themes.default_theme[themes.current]
    property var header_data: [
        /// 新歌速递
        {
            name: "全部",
            type: "0"
        },
        {
            name: "华语",
            type: "7"
        },
        {
            name: "欧美",
            type: "96"
        },
        {
            name: "日本",
            type: "8"
        },
        {
            name: "韩国",
            type: "16"
        },
    ]
    property double font_size: theme.page_find_music_latest_music_font_size
    property int header_current: 0
    property int current: -1
    width: parent.width
    height: header.height + content.height + 80

    onHeader_currentChanged: {
        setContentModel();
    }

    /// 歌曲信息导入
    function setContentModel(argument) {
        /// 每次切换标题（华语、欧美等）前置工作
        content.height = 0;
        content_model.clear();

        var call_back = res => {
            //console.log(JSON.stringify(res[0]));
            content.height = res.length * 80 + 20;
            content_model.append(res);
        };
        resource_music.getLatestMusic({
            type: header_data[header_current].type,
            call_back: call_back
        });
    }
    Component.onCompleted: {
        setContentModel();
    }

    /// 1. 头部
    Row {
        id: header
        spacing: 10
        width: parent.width * .9
        height: 20
        anchors.horizontalCenter: parent.horizontalCenter
        Repeater {
            model: ListModel {}
            delegate: latest_music_header_delegate
            Component.onCompleted: {
                model.append(latest_music.header_data);
            }
        }
        Component {
            id: latest_music_header_delegate

            Text {
                property bool is_hovered: false
                font.bold: is_hovered || latest_music.header_current === index
                font.pointSize: latest_music.font_size
                text: name
                color: theme.page_find_music_latest_music_title_color
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        latest_music.header_current = index;
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
    Rectangle {
        id: content
        width: parent.width * .9
        height: 0
        anchors.top: header.bottom
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        radius: 10
        Column {
            topPadding: 10
            anchors.horizontalCenter: parent.horizontalCenter
            Repeater {
                model: ListModel {
                    id: content_model
                }
                delegate: content_delegate
            }
        }
        Component {
            id: content_delegate
            Rectangle {
                /// 委托项单元：图片、音乐人、专辑等
                property bool is_hovered: false
                width: content.width - 20 /// 减去内间距
                height: 80
                radius: 10
                color: if (latest_music.current === index)
                    return "#2F" + theme.page_find_music_header_sub_background_color
                else if (is_hovered)
                    return "#2F" + theme.page_find_music_header_sub_background_color
                else
                    return theme.page_find_music_header_cursor_leave_button_color
                Row {
                    width: parent.width - 20
                    height: parent.height - 20
                    anchors.centerIn: parent
                    spacing: 10
                    /// 1. 序号
                    Text {
                        width: parent.width * .1 - 40
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignVCenter
                        font.weight: 2
                        font.pointSize: latest_music.font_size
                        /// 文本超出最大宽度省略
                        elide: Text.ElideRight
                        text: index + 1
                        color: theme.page_find_music_latest_music_content_font_color
                    }
                    /// 2. 封面
                    Qimage_round_corner {
                        width: parent.height
                        height: width
                        source: coverImg + "?param=" + width + "y" + height /// 限制图片大小，节约内存
                    }
                    /// 3. 歌名
                    Text {
                        width: parent.width * .3
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignLeft
                        font.weight: 2
                        font.pointSize: latest_music.font_size
                        elide: Text.ElideRight
                        text: name
                        color: theme.page_find_music_latest_music_content_font_color
                    }
                    /// 4. 歌手
                    Text {
                        width: parent.width * .2
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignLeft
                        font.weight: 2
                        font.pointSize: latest_music.font_size
                        elide: Text.ElideRight
                        text: artists
                        color: theme.page_find_music_latest_music_content_font_color
                    }
                    /// 5. 专辑
                    Text {
                        width: parent.width * .2
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignLeft
                        font.weight: 2
                        font.pointSize: latest_music.font_size
                        elide: Text.ElideRight
                        text: album
                        color: theme.page_find_music_latest_music_content_font_color
                    }
                    /// 6. 时长
                    Text {
                        width: parent.width * .2 - parent.height
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignLeft
                        font.weight: 2
                        font.pointSize: latest_music.font_size
                        elide: Text.ElideRight
                        text: allTime
                        color: theme.page_find_music_latest_music_content_font_color
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        latest_music.header_current = index;
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
}
