package ute.edu.helper;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataIntegrityViolationException;

/** Chuyển lỗi nghiệp vụ thành thông báo tiếng Việt; giữ chi tiết kỹ thuật trong nhật ký máy chủ. */
public final class UserMessages {
    private static final Logger LOG = LoggerFactory.getLogger(UserMessages.class);

    private UserMessages() {}

    /** Không đưa câu lệnh SQL, tên bảng hoặc stack trace vào hộp thông báo trên giao diện. */
    public static String forException(Exception error) {
        if (error instanceof DataIntegrityViolationException) {
            LOG.warn("Thao tác vi phạm ràng buộc dữ liệu", error);
            return "Không thể lưu vì dữ liệu đã tồn tại hoặc đang có liên kết. Vui lòng kiểm tra thông tin.";
        }
        if ((error instanceof IllegalArgumentException || error instanceof IllegalStateException)
                && error.getMessage() != null && !error.getMessage().isBlank()) {
            return error.getMessage();
        }
        LOG.error("Không thể xử lý thao tác", error);
        return "Không thể thực hiện thao tác. Vui lòng thử lại hoặc liên hệ quản trị viên.";
    }
}
