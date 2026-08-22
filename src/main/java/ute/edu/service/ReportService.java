package ute.edu.service;

import java.util.List;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ute.edu.entity.*;
import ute.edu.repository.ReportRepository;
import ute.edu.repository.TopicRegistrationRepository;
import ute.edu.repository.StudentRepository;

@Service
public class ReportService {
    private static final Path REPORT_STORAGE = Paths.get("uploads", "reports");
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

    public List<Report> getAll() {
        return reportRepository.findAll();
    }

    public List<Report> getReportsForRegistration(Long registrationId) {
        return reportRepository.findByTopicRegistrationIdOrderBySubmittedAtDesc(registrationId);
    }

    public Report getById(Long reportId) {
        return reportRepository.findById(reportId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy báo cáo"));
    }

    public String storeFile(MultipartFile file) throws IOException {
        if (file == null || file.isEmpty()) {
            return null;
        }
        String originalName = file.getOriginalFilename() == null ? "report" : file.getOriginalFilename();
        String safeName = Paths.get(originalName).getFileName().toString().replaceAll("[^a-zA-Z0-9._-]", "_");
        Files.createDirectories(REPORT_STORAGE);
        String storedName = UUID.randomUUID() + "_" + safeName;
        file.transferTo(REPORT_STORAGE.resolve(storedName));
        return "/reports/files/" + storedName;
    }

    @Transactional
    public Report submitReport(Long registrationId, Long studentId, String fileName, String filePath, String note) {
        TopicRegistration registration = registrationRepository.findById(registrationId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy thông tin đăng ký đề tài"));
        Student student = studentRepository.findById(studentId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy thông tin sinh viên"));

        Student leader = registration.getGroup().getLeader();
        if (leader == null || !leader.getId().equals(student.getId())) {
            throw new IllegalStateException("QUYỀN HẠN: Chỉ duy nhất Nhóm trưởng mới có quyền nộp báo cáo đề tài!");
        }

        if (fileName == null || fileName.isBlank()) {
            fileName = "BaoCao_DeTai_" + registration.getTopic().getCode() + ".pdf";
        }
        if (filePath == null || filePath.isBlank()) {
            // Keep consistent with download resolver
            filePath = "/uploads/reports/" + Paths.get(fileName).getFileName().toString()
                    .replaceAll("[^a-zA-Z0-9._-]", "_");
        }

        Report report = new Report();
        report.setTopicRegistration(registration);
        report.setSubmittedBy(student);
        report.setFileName(fileName.trim());
        report.setFilePath(filePath.trim());
        report.setNote(note);

        return reportRepository.save(report);
    }
}
