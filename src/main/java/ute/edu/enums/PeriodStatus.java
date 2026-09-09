package ute.edu.enums;

/** Trạng thái của một đợt đăng ký đề tài. */
public enum PeriodStatus {
    // Đợt đang được chuẩn bị, chưa cho đăng ký.
    DRAFT,
    // Đợt đang mở cho các nghiệp vụ theo thời gian quy định.
    OPEN,
    // Đợt đã kết thúc và không nhận thêm dữ liệu.
    CLOSED
}
