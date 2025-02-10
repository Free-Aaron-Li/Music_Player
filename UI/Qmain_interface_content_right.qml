import QtQuick 2.15

/**
 * 主页——右侧主体部分
 */
Rectangle {
    id: right_content

    property string this_qml: "Qpage_find_music.qml"
    property var theme: themes.default_theme[themes.current]
    color: theme.page_find_music_sub_color
    /// 加载qml文件
    Loader {
        source: right_content.this_qml
        onStatusChanged: {
            if (status === Loader.Ready) {
                item.parent = parent; /// 加载父组件
            }
        }
    }
}
