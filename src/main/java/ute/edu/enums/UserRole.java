package ute.edu.enums;

/** Vai trò dùng để phân quyền người dùng trong hệ thống. */
public enum UserRole {
    // Quản trị viên toàn hệ thống.
    ADMIN,
    // Trưởng khoa duyệt đề tài và quản lý hội đồng.
    DEAN,
    // Giảng viên hướng dẫn hoặc giảng viên phản biện.
    LECTURER,
    // Sinh viên thực hiện đề tài.
    STUDENT,
    // Người phụ trách quản lý một khoa.
    DEPARTMENT_HEAD
}
