package ute.edu.service;

import java.util.List;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;
import java.time.LocalDateTime;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ute.edu.entity.*;
import ute.edu.repository.ReportRepository;
import ute.edu.repository.TopicRegistrationRepository;
import ute.edu.repository.StudentRepository;
import ute.edu.enums.ReportReviewStatus;

@Service
/** Service nộp, lưu trữ và xét duyệt báo cáo của nhóm sinh viên. */
public class ReportService {
    private static final Path REPORT_STORAGE = Paths.get("uploads", "reports").toAbsolutePath().normalize();
    private final ReportRepository reportRepository;
    private final TopicRegistrationRepository registrationRepository;
    private final StudentRepository studentRepository;

    public ReportService(ReportRepository reportRepository,
                         TopicRegistrationRepository registrationRepository,
                         StudentRepository studentRepository) {
        this.reportRepository = reportRepository;
        this.registrationRepository = registrationRepository;
        this.studentRepository = studentRepository;
    }

    /** Lấy toàn bộ báo cáo. */
    public List<Report> getAll() {
        return reportRepository.findAll(org.springframework.data.domain.Sort.by(
                org.springframework.data.domain.Sort.Direction.DESC, "submittedAt", "id"));
    }

    public boolean hasApprovedReportForTopic(Long topicId) {
        return reportRepository.existsByTopicRegistrationTopicIdAndApprovedTrue(topicId);
    }

    /** Lấy báo cáo của một đăng ký theo thứ tự mới nhất. */
    public List<Report> getReportsForRegistration(Long registrationId) {
        return reportRepository.findByTopicRegistrationIdOrderBySubmittedAtDescIdDesc(registrationId);
    }

    /** Tìm báo cáo theo mã, báo lỗi nếu không tồn tại. */
    public Report getById(Long reportId) {
        return reportRepository.findById(reportId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy báo cáo"));
    }

    @Transactional
    /** Duyệt một báo cáo. */
    public Report approve(Long reportId) {
        Report report = getById(reportId);
        report.setApproved(true);
        report.setApprovedAt(LocalDateTime.now());
        report.setReviewStatus(ReportReviewStatus.APPROVED);
        return reportRepository.save(report);
    }

    @Transactional
    /** Từ chối một báo cáo. */
    public Report reject(Long reportId) {
        Report report = getById(reportId);
        report.setApproved(false);
        report.setApprovedAt(null);
        report.setReviewStatus(ReportReviewStatus.REJECTED);
        return reportRepository.save(report);
    }

    /** Lưu file báo cáo an toàn và trả về đường dẫn tải file. */
    public String storeFile(MultipartFile file) throws IOException {
        if (file == null || file.isEmpty()) {
            return null;
        }
        String originalName = file.getOriginalFilename() == null ? "report" : file.getOriginalFilename();
        if (file.getSize() > 10L * 1024 * 1024) {
            throw new IllegalArgumentException("Tệp báo cáo không được vượt quá 10 MB!");
        }
        if (!originalName.toLowerCase(java.util.Locale.ROOT).matches(".*\\.(pdf|doc|docx|zip|rar)$")) {
            throw new IllegalArgumentException("Chỉ hỗ trợ tệp PDF, DOC, DOCX, ZIP hoặc RAR!");
        }
        String safeName = Paths.get(originalName).getFileName().toString().replaceAll("[^a-zA-Z0-9._-]", "_");
        Files.createDirectories(REPORT_STORAGE);
        String storedName = UUID.randomUUID() + "_" + safeName;
        file.transferTo(REPORT_STORAGE.resolve(storedName));
        return "/reports/files/" + storedName;
    }

    @Transactional
    /** Kiểm tra quyền nhóm trưởng và lưu báo cáo mới. */
    public Report submitReport(Long registrationId, Long studentId, String fileName, String filePath, String note) {
        if (filePath == null || filePath.isBlank()) {
            throw new IllegalArgumentException("Vui lòng chọn tệp báo cáo hoặc nhập liên kết tài liệu!");
        }
        TopicRegistration registration = registrationRepository.findById(registrationId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy thông tin đăng ký đề tài"));
        if (registration.getStatus() != ute.edu.enums.RegistrationStatus.APPROVED) {
            throw new IllegalStateException("Đơn đăng ký chưa được duyệt, chưa thể nộp báo cáo!");
        }
        Student student = studentRepository.findById(studentId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy thông tin sinh viên"));

        Student leader = registration.getGroup().getLeader();
        if (leader == null || !leader.getId().equals(student.getId())) {
            throw new IllegalStateException("QUYỀN HẠN: Chỉ duy nhất Nhóm trưởng mới có quyền nộp báo cáo đề tài!");
        }

        if (fileName == null || fileName.isBlank()) {
            fileName = "BaoCao_DeTai_" + registration.getTopic().getCode() + ".pdf";
        }
        if (registration.getTopic().getStatus() == ute.edu.enums.TopicStatus.COMPLETED) {
            throw new IllegalStateException("Đề tài đã hoàn tất, không thể nộp thêm báo cáo!");
        }
        if (filePath != null && !filePath.isBlank()
                && !filePath.startsWith("/reports/files/") && !filePath.startsWith("/uploads/reports/")) {
            java.net.URI uri = java.net.URI.create(filePath.trim());
            if (!("https".equalsIgnoreCase(uri.getScheme()) || "http".equalsIgnoreCase(uri.getScheme())) || uri.getHost() == null) {
                throw new IllegalArgumentException("Đường dẫn tài liệu phải là liên kết HTTP/HTTPS hợp lệ!");
            }
        }

        Report report = new Report();
        report.setTopicRegistration(registration);
        report.setSubmittedBy(student);
        report.setFileName(fileName.trim());
        report.setFilePath(filePath == null || filePath.isBlank() ? null : filePath.trim());
        report.setNote(note);

        return reportRepository.save(report);
    }
}
