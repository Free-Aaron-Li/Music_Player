#ifndef FRAME_LESS_WINDOW_H
#define FRAME_LESS_WINDOW_H

#include <QQuickWindow>

class FrameLessWindow : public QQuickWindow {
    Q_OBJECT
    Q_PROPERTY(kMousePosition mouse_position READ mouse_position WRITE setMouse_position NOTIFY mouse_positionChanged
                       FINAL)

public:
    // 鼠标大概位置
    enum kMousePosition { TOPLEFT = 1, TOP, TOPRIGHT, LEFT, RIGHT, BOTTOM, BOTTOMLEFT, BOTTOMRIGHT, NORMAL };
    Q_ENUM(kMousePosition);
    explicit FrameLessWindow(QWindow *parent = nullptr);

    [[nodiscard]] kMousePosition mouse_position() const;
    void setMouse_position(kMousePosition newMouse_position);

signals:
    void mouse_positionChanged();

protected:
    void mouseMoveEvent(QMouseEvent *) override; // 鼠标移动事件
    void mouseReleaseEvent(QMouseEvent *) override; // 鼠标弹回事件
    void mousePressEvent(QMouseEvent *) override; // 鼠标点击事件
private:
    /// 获取鼠标位置
    [[nodiscard]] kMousePosition get_mouse_position_(const QPointF &pos) const;
    /// 更改鼠标样式
    void SetCursorIcon();
    /// 计算偏移量
    /// 通过偏移量设置窗口大小和位置
    void SetWindowGeometry(const QPointF &pos);
    /// 缩放边距
    int step = 8;
    /// 鼠标大概位置
    kMousePosition mouse_position_ = NORMAL;
    /// 起始位置
    QPointF start_position_;
    /// 旧大小，窗口基于桌面位置，用于校准位置
    QPointF old_position_;
    /// 原大小，存储窗口原大小
    QSize old_size_;
};

#endif // FRAME_LESS_WINDOW_H
