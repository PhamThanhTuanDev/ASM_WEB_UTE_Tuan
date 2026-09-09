package ute.edu.enums;

/** Trạng thái tổ chức của hội đồng phản biện. */
public enum CouncilStatus {
    // Hội đồng đã được tạo nhưng chưa đến ngày thực hiện.
    PLANNED,
    // Hội đồng đang diễn ra hoặc đang chấm điểm.
    ONGOING,
    // Hội đồng đã hoàn tất và có thể công bố kết quả.
    COMPLETED
}
