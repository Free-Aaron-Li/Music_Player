#include "../include/FrameLessWindow.h"

FrameLessWindow::FrameLessWindow(QWindow *parent) : QQuickWindow(parent) {
    /// 设置窗口
    /// 1. 基本功能窗口
    /// 2. 无边框窗口
    /// 3. 为窗口添加最小化，最大化按钮
    this->setFlags(Qt::Window | Qt::FramelessWindowHint | Qt::WindowMinMaxButtonsHint);
}
void FrameLessWindow::mouseMoveEvent(QMouseEvent *mouse_event) {
    /// 判断是否按下，按下更新窗口大小，反之更新鼠标样式
    const QPointF position = mouse_event->position();
    if (mouse_event->button() & Qt::LeftButton) {
        /// 改变窗口大小
        this->SetWindowGeometry(mouse_event->globalPosition());
    } else {
        /// 改变鼠标样式
        this->mouse_position_ = this->get_mouse_position_(position);
        this->SetCursorIcon();
    }
    QQuickWindow::mouseMoveEvent(mouse_event);
}
void FrameLessWindow::mouseReleaseEvent(QMouseEvent *mouse_event) {
    this->old_position_ = this->position();
    QQuickWindow::mouseReleaseEvent(mouse_event);
}
void FrameLessWindow::mousePressEvent(QMouseEvent *mouse_event) {
    this->start_position_ = mouse_event->globalPosition();
    this->old_position_ = this->position();
    this->old_size_ = this->size();
    mouse_event->ignore(); /// 阻止事件默认行为

    QQuickWindow::mousePressEvent(mouse_event);
}

FrameLessWindow::kMousePosition FrameLessWindow::get_mouse_position_(const QPointF &pos) const {
    const int x = static_cast<int>(pos.x());
    const int y = static_cast<int>(pos.y());
    const int width = this->width();
    const int high = this->height();
    /// 直接return会弹出警告，所以选择存储
    kMousePosition mouse_position = NORMAL;

    /// 设置边界判断范围
    if (x >= 0 && x <= this->step && y >= 0 && y <= this->step) {
        mouse_position = TOPLEFT;
    } else if (x > this->step && x < (width - this->step) && y >= 0 && y <= this->step) {
        mouse_position = TOP;
    } else if (x >= (width - this->step) && x <= width && y >= 0 && y <= this->step) {
        mouse_position = TOPRIGHT;
    } else if (x >= 0 && x <= this->step && y > this->step && y < (high - this->step)) {
        mouse_position = LEFT;
    } else if (x >= (width - this->step) && x <= width && y > this->step && y < (high - this->step)) {
        mouse_position = RIGHT;
    } else if (x >= 0 && x <= this->step && y >= (high - this->step) && y < high) {
        mouse_position = BOTTOMLEFT;
    } else if (x > this->step && x < (width - this->step) && y >= (high - this->step) && y <= high) {
        mouse_position = BOTTOM;
    } else if (x >= (width - this->step) && x <= width && y >= (high - this->step) && y <= high) {
        mouse_position = BOTTOMRIGHT;
    }
    return mouse_position;
}

void FrameLessWindow::SetCursorIcon() {
    static bool is_set = false;
    switch (this->mouse_position_) {
        case TOPLEFT:
        case BOTTOMRIGHT:
            this->setCursor(Qt::SizeFDiagCursor); /// 自左上到坐下拉伸箭头
            is_set = true;
            break;
        case TOP:
        case BOTTOM:
            this->setCursor(Qt::SizeVerCursor); /// ⬍ 自上到下的拉伸箭头
            is_set = true;
            break;
        case TOPRIGHT:
        case BOTTOMLEFT:
            this->setCursor(Qt::SizeBDiagCursor); /// 自右上到左下的拉伸箭头
            is_set = true;
            break;
        case LEFT:
        case RIGHT:
            this->setCursor(Qt::SizeHorCursor); /// ⬌ 自左到右的拉伸箭头
            is_set = true;
            break;
        default:
            if (is_set) {
                is_set = false;
                this->unsetCursor(); /// 恢复默认箭头
            }
            break;
    }
}
void FrameLessWindow::SetWindowGeometry(const QPointF &pos) {
    /// 偏移量
    const auto offset = this->start_position_ - pos;
    if (offset.x() == 0 && offset.y() == 0)
        return;
    /// 依据偏移量创建新窗口
    /// @param size 窗口新大小
    /// @param position 窗口新位置
    static auto SetGeometryFunction = [this](const QSize &size, const QPointF &position) {
        auto temp_pos = this->old_position_;
        auto temp_size = minimumSize();
        if (size.width() > minimumWidth()) {
            temp_pos.setX(position.x());
            temp_size.setWidth(size.width());
        } else if (this->mouse_position_ == LEFT) { /// 不允许向左扩展窗口
            temp_pos.setX(this->old_position_.x() + this->old_size_.width() - minimumWidth());
        }
        if (size.height() > minimumHeight()) {
            temp_pos.setY(position.y());
            temp_size.setHeight(size.height());
        } else if (this->mouse_position_ == LEFT) {
            temp_pos.setY(this->old_position_.y() + this->old_size_.height() - minimumHeight());
        }
        /// 创建指定大小窗口
        this->setGeometry(temp_pos.x(), temp_pos.y(), temp_size.width(), temp_size.height());
        this->update();
    };
    switch (this->mouse_position_) {
        case TOPLEFT:
            /// 拖动后大小==原大小+偏移量，
            /// 坐标==y原坐标-偏移量
            SetGeometryFunction(this->old_size_ + QSize(offset.x(), offset.y()), this->old_position_ - offset);
            break;
        case TOP:
            SetGeometryFunction(this->old_size_ + QSize(0, offset.y()), this->old_position_ - QPointF(0, offset.y()));
            break;
        case TOPRIGHT:
            SetGeometryFunction(this->old_size_ - QSize(offset.x(), -offset.y()),
                                this->old_position_ - QPointF(0, offset.y()));
            break;
        case LEFT:
            SetGeometryFunction(this->old_size_ + QSize(offset.x(), 0), this->old_position_ - QPointF(offset.x(), 0));
            break;
        case RIGHT:
            SetGeometryFunction(this->old_size_ - QSize(offset.x(), 0), this->position());
            break;
        case BOTTOMLEFT:
            SetGeometryFunction(this->old_size_ + QSize(offset.x(), -offset.y()),
                                this->old_position_ - QPointF(offset.x(), 0));
            break;
        case BOTTOM:
            SetGeometryFunction(this->old_size_ + QSize(0, -offset.y()), this->position());
            break;
        case BOTTOMRIGHT:
            SetGeometryFunction(this->old_size_ - QSize(offset.x(), offset.y()), this->position());
            break;
        default:
            break;
    }
}

FrameLessWindow::kMousePosition FrameLessWindow::mouse_position() const { return mouse_position_; }

void FrameLessWindow::setMouse_position(const kMousePosition newMouse_position) {
    if (mouse_position_ == newMouse_position)
        return;
    mouse_position_ = newMouse_position;
    emit mouse_positionChanged();
}
