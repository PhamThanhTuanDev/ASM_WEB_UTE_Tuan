package ute.edu.enums;

/** Trạng thái xét duyệt báo cáo của sinh viên. */
public enum ReportReviewStatus {
    // Báo cáo đang chờ giảng viên xem xét.
    PENDING,
    // Báo cáo đã được chấp nhận.
    APPROVED,
    // Báo cáo bị từ chối và cần xử lý lại.
    REJECTED
}
