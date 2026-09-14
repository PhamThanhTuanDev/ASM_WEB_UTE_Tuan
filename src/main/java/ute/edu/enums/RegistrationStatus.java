package ute.edu.enums;

/** Trạng thái yêu cầu đăng ký đề tài của nhóm sinh viên. */
public enum RegistrationStatus {
    // Đăng ký đang chờ người có thẩm quyền xét duyệt.
    PENDING,
    // Đăng ký đã được chấp nhận.
    APPROVED,
    // Đăng ký bị từ chối.
    REJECTED,
    // Nhóm hoặc người quản lý đã hủy đăng ký.
    CANCELLED
}
