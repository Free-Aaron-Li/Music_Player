import QtQuick 2.15

/**
  * 资源——歌曲信息
  */
Item {

    function getLatestMusic(obj) {
        var type = obj.type || "0";
        var call_back = obj.call_back || (() => {}); /// 回调函数（由于数据获取是异步）
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function () {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    var res = JSON.parse(xhr.responseText).data;
                    res = res.map(obj => {
                        return {
                            id: obj.id,
                            name: obj.name,
                            artists: obj.artists.map(artist => artist.name).join('/'),
                            album: obj.album.name,
                            coverImg: obj.album.picUrl,
                            allTime: "00:00"
                        };
                    });
                    call_back(res);
                } else {
                    console.log("获取数据失败：最新音乐：" + xhr.status);
                }
            }
        };
        xhr.open("GET", "http://localhost:3000/top/song?type=" + type, true); /// 请求
        xhr.send();
    }
}
