package ute.edu.enums;

/** Trạng thái vòng đời của một đề tài. */
public enum TopicStatus {
    // Đề tài mới tạo, chưa gửi duyệt.
    DRAFT,
    // Đề tài đang chờ người có thẩm quyền duyệt.
    PENDING,
    // Đề tài đã được duyệt.
    APPROVED,
    // Đề tài bị từ chối.
    REJECTED,
    // Đề tài đã công khai cho sinh viên đăng ký.
    PUBLISHED,
    // Đề tài đã được gán cho nhóm sinh viên.
    ASSIGNED,
    // Đề tài đã hoàn tất.
    COMPLETED,
    // Đề tài đã bị hủy.
    CANCELLED
}
