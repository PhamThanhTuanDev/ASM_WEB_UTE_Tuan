package ute.edu.controller;

import java.io.IOException;
import java.net.URI;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import jakarta.servlet.http.HttpSession;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;
import ute.edu.entity.*;
import ute.edu.enums.UserRole;
import ute.edu.repository.*;
import ute.edu.service.ReportService;

@RestController
public class ReportDownloadController {
    private final ReportService reports;
    private final StudentRepository students;
    private final LectureRepository lecturers;
    private final StudentGroupMemberRepository members;
    private final TopicAssignmentRepository assignments;
    private final ReviewCouncilMemberRepository councilMembers;

    public ReportDownloadController(ReportService reports, StudentRepository students, LectureRepository lecturers,
            StudentGroupMemberRepository members, TopicAssignmentRepository assignments,
            ReviewCouncilMemberRepository councilMembers) {
        this.reports = reports;
        this.students = students;
        this.lecturers = lecturers;
        this.members = members;
        this.assignments = assignments;
        this.councilMembers = councilMembers;
    }

    @GetMapping("/reports/download/{id}")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<?> download(@PathVariable Long id, HttpSession session) throws IOException {
        UserAccount user = (UserAccount) session.getAttribute("user");
        if (user == null) throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
        Report report;
        try { report = reports.getById(id); }
        catch (IllegalArgumentException missing) { throw new ResponseStatusException(HttpStatus.NOT_FOUND); }
        if (!canRead(user, report)) throw new ResponseStatusException(HttpStatus.FORBIDDEN);
        String location = report.getFilePath();
        if (location == null || location.isBlank()) throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Báo cáo chưa có tệp đính kèm");
        if (location.startsWith("/demo-reports/")) {
            String name = location.substring("/demo-reports/".length());
            if (!name.matches("BaoCao_DT\\d{3}_demo\\.pdf")) throw new ResponseStatusException(HttpStatus.BAD_REQUEST);
            var resource = new ClassPathResource("demo-reports/" + name);
            if (!resource.exists()) throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Không tìm thấy PDF mẫu");
            return ResponseEntity.ok().contentType(MediaType.APPLICATION_PDF)
                    .header(HttpHeaders.CONTENT_DISPOSITION, ContentDisposition.attachment()
                            .filename(name, StandardCharsets.UTF_8).build().toString())
                    .contentLength(resource.contentLength()).body(resource);
        }
        if (location.startsWith("https://") || location.startsWith("http://")) {
            URI uri = URI.create(location);
            if (uri.getHost() == null) throw new ResponseStatusException(HttpStatus.BAD_REQUEST);
            return ResponseEntity.status(HttpStatus.FOUND).location(uri).build();
        }
        String prefix = location.startsWith("/reports/files/") ? "/reports/files/" : "/uploads/reports/";
        if (!location.startsWith(prefix)) throw new ResponseStatusException(HttpStatus.BAD_REQUEST);
        Path storage = Path.of("uploads", "reports").toAbsolutePath().normalize();
        Path file = storage.resolve(location.substring(prefix.length())).normalize();
        if (!file.startsWith(storage) || !Files.isRegularFile(file)
                || !file.toRealPath().startsWith(storage.toRealPath())) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND);
        }
        return ResponseEntity.ok().contentType(MediaType.APPLICATION_OCTET_STREAM)
                .header(HttpHeaders.CONTENT_DISPOSITION, ContentDisposition.attachment()
                        .filename(report.getFileName(), StandardCharsets.UTF_8).build().toString())
                .body(new FileSystemResource(file));
    }

    private boolean canRead(UserAccount user, Report report) {
        TopicRegistration registration = report.getTopicRegistration();
        Topic topic = registration.getTopic();
        // Nhóm vai trò quản trị (Quản trị viên, Trưởng khoa, Phụ trách khoa) được xem mọi báo cáo
        // đang liệt kê ở trang /admin/reports, khớp với phạm vi phân quyền của khu vực quản trị.
        if (user.getRole() == UserRole.ADMIN || user.getRole() == UserRole.DEAN
                || user.getRole() == UserRole.DEPARTMENT_HEAD) return true;
        if (user.getRole() == UserRole.STUDENT) {
            Student student = students.findByUserId(user.getId());
            return student != null && members.existsByGroupIdAndStudentId(registration.getGroup().getId(), student.getId());
        }
        Lecture lecturer = lecturers.findByUserId(user.getId());
        if (lecturer == null) return false;
        if ((topic.getLecturer() != null && lecturer.getId().equals(topic.getLecturer().getId()))
                || (topic.getCoLecturer() != null && lecturer.getId().equals(topic.getCoLecturer().getId()))) return true;
        return assignments.findByTopicRegistrationId(registration.getId()).stream()
                .anyMatch(a -> councilMembers.findByCouncilIdAndLecturerId(a.getCouncil().getId(), lecturer.getId()).isPresent());
    }
}
