package ute.edu.helper;

import java.util.Map;
import org.springframework.stereotype.Component;

@Component("enumLabel")
public class EnumLabelFormatter {
    private static final Map<String, String> LABELS = Map.ofEntries(
            Map.entry("ASSIGNED", "Đã phân công"),
            Map.entry("EVALUATED", "Đã chấm"),
            Map.entry("CHAIRMAN", "Chủ tịch"),
            Map.entry("SECRETARY", "Thư ký"),
            Map.entry("MEMBER", "Ủy viên"),
            Map.entry("PLANNED", "Đã lên lịch"),
            Map.entry("ONGOING", "Đang diễn ra"),
            Map.entry("COMPLETED", "Đã hoàn tất"),
            Map.entry("INCOMPLETE", "Chưa hoàn thiện"),
            Map.entry("READY", "Sẵn sàng"),
            Map.entry("ALL", "Toàn trường"),
            Map.entry("STUDENT", "Sinh viên"),
            Map.entry("LECTURER", "Giảng viên"),
            Map.entry("DRAFT", "Bản nháp"),
            Map.entry("OPEN", "Đang mở"),
            Map.entry("CLOSED", "Đã đóng"),
            Map.entry("PENDING", "Chờ duyệt"),
            Map.entry("APPROVED", "Đã duyệt"),
            Map.entry("REJECTED", "Từ chối"),
            Map.entry("CANCELLED", "Đã hủy"),
            Map.entry("KLTN", "KHÓA LUẬN TỐT NGHIỆP"),
            Map.entry("TLCN", "TIỂU LUẬN CHUYÊN NGÀNH"),
            Map.entry("NCKH", "NGHIÊN CỨU KHOA HỌC"),
            Map.entry("PRIMARY", "GVHD chính"),
            Map.entry("CO_SUPERVISOR", "Đồng hướng dẫn"),
            Map.entry("PUBLISHED", "Đã công bố"),
            Map.entry("ADMIN", "Quản trị viên"),
            Map.entry("DEAN", "Trưởng khoa"),
            Map.entry("DEPARTMENT_HEAD", "Phụ trách khoa"));

    public String label(Object value) {
        if (value == null) return "Chưa xác định";
        String key = value instanceof Enum<?> enumValue ? enumValue.name() : value.toString();
        return LABELS.getOrDefault(key, key);
    }
}
