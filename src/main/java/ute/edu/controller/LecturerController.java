package ute.edu.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import jakarta.servlet.http.HttpSession;
import ute.edu.entity.*;
import ute.edu.enums.*;
import ute.edu.repository.*;
import ute.edu.service.*;
import java.util.*;
import java.time.LocalDateTime;

import org.springframework.security.access.prepost.PreAuthorize;

@Controller
@RequestMapping("/lecturer")
@PreAuthorize("hasAnyRole('LECTURER', 'ADMIN', 'DEAN')")
/** Controller giảng viên: đề xuất đề tài, hướng dẫn, báo cáo và chấm điểm. */
public class LecturerController {
    private final TopicService topicService;
    private final RegistrationPeriodService periodService;
    private final DepartmentRepository departmentRepository;
    private final LectureRepository lectureRepository;
    private final TopicRegistrationService registrationService;
    private final CouncilService councilService;
    private final ScoringService scoringService;
    private final ReportService reportService;
    private final NotificationService notificationService;
    private final TopicAssignmentRepository assignmentRepository;
    private final ScoreRepository scoreRepository;
    private final TopicEvaluationRepository evaluationRepository;

    public LecturerController(TopicService topicService,
            RegistrationPeriodService periodService,
            DepartmentRepository departmentRepository,
            LectureRepository lectureRepository,
            TopicRegistrationService registrationService,
            CouncilService councilService,
            ScoringService scoringService,
            ReportService reportService,
            NotificationService notificationService,
            TopicAssignmentRepository assignmentRepository,
            ScoreRepository scoreRepository,
            TopicEvaluationRepository evaluationRepository) {
        this.topicService = topicService;
        this.periodService = periodService;
        this.departmentRepository = departmentRepository;
        this.lectureRepository = lectureRepository;
        this.registrationService = registrationService;
        this.councilService = councilService;
        this.scoringService = scoringService;
        this.reportService = reportService;
        this.notificationService = notificationService;
        this.assignmentRepository = assignmentRepository;
        this.scoreRepository = scoreRepository;
        this.evaluationRepository = evaluationRepository;
    }

    /**
     * Lấy thông tin giảng viên hiện tại từ phiên đăng nhập.
     * 
     * @param session Phiên đăng nhập hiện tại
     * @return Đối tượng Lecture nếu đã đăng nhập hợp lệ, ngược lại trả về null
     */
    private Lecture getCurrentLecturer(HttpSession session) {
        UserAccount user = (UserAccount) session.getAttribute("user");
        return (user != null) ? lectureRepository.findByUserId(user.getId()) : null;
    }

    /**
     * Kiểm tra xem giảng viên có phải là người hướng dẫn của đề tài hay không.
     * 
     * @param topic    Đề tài cần kiểm tra
     * @param lecturer Giảng viên
     * @return true nếu giảng viên là người hướng dẫn hoặc đồng hướng dẫn
     */
    private boolean isSupervisorOf(Topic topic, Lecture lecturer) {
        if (topic == null || lecturer == null)
            return false;
        Long lecturerId = lecturer.getId();
        return (topic.getLecturer() != null && topic.getLecturer().getId().equals(lecturerId))
                || (topic.getCoLecturer() != null && topic.getCoLecturer().getId().equals(lecturerId))
                || scoringService.isLecturerSupervisingTopic(lecturerId, topic.getId());
    }

    /**
     * Phiên bản dùng khi lọc cả danh sách: tập ID đề tài GV hướng dẫn được lấy
     * sẵn 1 lần (scoringService.getSupervisedTopicIds) nên không truy vấn DB
     * cho từng phần tử như hàm ở trên (tránh lỗi N+1 truy vấn).
     */
    private boolean isSupervisorOf(Topic topic, Lecture lecturer, Set<Long> supervisedTopicIds) {
        if (topic == null || lecturer == null)
            return false;
        Long lecturerId = lecturer.getId();
        return (topic.getLecturer() != null && topic.getLecturer().getId().equals(lecturerId))
                || (topic.getCoLecturer() != null && topic.getCoLecturer().getId().equals(lecturerId))
                || supervisedTopicIds.contains(topic.getId());
    }

    /**
     * Hiển thị trang tổng quan (dashboard) của giảng viên.
     * 
     * @param session Phiên đăng nhập
     * @param model   Model Spring MVC
     * @return view dashboard hoặc chuyển hướng đến trang đăng nhập
     */
    @GetMapping({ "", "/", "/dashboard" })
    public String dashboard(HttpSession session, Model model) {
        Lecture lecturer = getCurrentLecturer(session);
        if (lecturer == null)
            return "redirect:/login";

        List<Topic> myTopics = topicService.getTopicsByLecturer(lecturer.getId());
        List<ReviewCouncilMember> myCouncils = councilService.getCouncilsForLecturer(lecturer.getId());
        Set<Long> supervisedTopicIds = scoringService.getSupervisedTopicIds(lecturer.getId());
        List<TopicRegistration> myGroupRegs = registrationService.getAll().stream()
                .filter(r -> isSupervisorOf(r.getTopic(), lecturer, supervisedTopicIds))
                .toList();

        model.addAttribute("lecturer", lecturer);
        model.addAttribute("myTopics", myTopics);
        model.addAttribute("myCouncils", myCouncils);
        model.addAttribute("myGroupRegs", myGroupRegs);
        model.addAttribute("notifications", notificationService.getPublishedForRole("LECTURER"));
        model.addAttribute("activePeriod", periodService.getActivePeriod());

        return "lecturer/dashboard";
    }

    /**
     * Hiển thị danh sách các đề tài của giảng viên và form đề xuất đề tài.
     * 
     * @param session Phiên đăng nhập
     * @param model   Model Spring MVC
     * @return view topics
     */
    @GetMapping("/topics")
    public String topics(HttpSession session, Model model) {
        Lecture lecturer = getCurrentLecturer(session);
        if (lecturer == null)
            return "redirect:/login";

        model.addAttribute("lecturer", lecturer);
        model.addAttribute("topics", topicService.getTopicsByLecturer(lecturer.getId()));
        model.addAttribute("topic", new Topic());
        model.addAttribute("departments", departmentRepository.findAll());
        model.addAttribute("periods", periodService.getAll());
        model.addAttribute("lecturers", lectureRepository.findAll());
        model.addAttribute("activePeriod", periodService.getActivePeriod());
        return "lecturer/topics";
    }

    /**
     * Xử lý lưu đề xuất đề tài mới của giảng viên.
     * 
     * @param topic              Đối tượng đề tài
     * @param departmentId       ID khoa
     * @param periodId           ID đợt đăng ký
     * @param coLecturerId       ID giảng viên đồng hướng dẫn (tùy chọn)
     * @param session            Phiên đăng nhập
     * @param redirectAttributes Dùng để truyền thông báo flash
     * @return Chuyển hướng về trang danh sách đề tài
     */
    @PostMapping("/topics/save")
    public String saveTopic(@ModelAttribute Topic topic,
            @RequestParam Long departmentId,
            @RequestParam Long periodId,
            @RequestParam(required = false) Long coLecturerId,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        Lecture lecturer = getCurrentLecturer(session);
        if (lecturer == null)
            return "redirect:/login";

        try {
            topic.setLecturer(lecturer);
            topic.setDepartment(departmentRepository.findById(departmentId).orElseThrow());
            topic.setRegistrationPeriod(periodService.findById(periodId));

            if (coLecturerId != null && coLecturerId > 0 && !coLecturerId.equals(lecturer.getId())) {
                topic.setCoLecturer(lectureRepository.findById(coLecturerId).orElse(null));
            } else {
                topic.setCoLecturer(null);
            }

            if (topic.getId() == null) {
                topic.setStatus(TopicStatus.PENDING); // Gửi chờ Trưởng khoa duyệt
            }
            topicService.save(topic);
            redirectAttributes.addFlashAttribute("successMessage", "Đề xuất đề tài thành công! Chờ Trưởng khoa duyệt.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi: " + e.getMessage());
        }
        return "redirect:/lecturer/topics";
    }

    /**
     * Xóa đề tài do giảng viên đề xuất.
     * 
     * @param id                 ID đề tài cần xóa
     * @param session            Phiên đăng nhập
     * @param redirectAttributes Dùng để truyền thông báo flash
     * @return Chuyển hướng về trang danh sách đề tài
     */
    @PostMapping("/topics/{id}/delete")
    public String deleteTopic(@PathVariable Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        Lecture lecturer = getCurrentLecturer(session);
        if (lecturer == null)
            return "redirect:/login";

        try {
            Topic topic = topicService.findById(id);
            if (topic != null && topic.getLecturer() != null && topic.getLecturer().getId().equals(lecturer.getId())) {
                topicService.delete(id);
                redirectAttributes.addFlashAttribute("successMessage", "Đã xóa đề tài thành công.");
            } else {
                redirectAttributes.addFlashAttribute("errorMessage", "Bạn không có quyền xóa đề tài này.");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi xóa đề tài: " + e.getMessage());
        }
        return "redirect:/lecturer/topics";
    }

    /**
     * Hiển thị danh sách các nhóm sinh viên đăng ký đề tài của giảng viên.
     * 
     * @param session Phiên đăng nhập
     * @param model   Model Spring MVC
     * @return view groups
     */
    @GetMapping("/groups")
    public String groups(HttpSession session, Model model) {
        Lecture lecturer = getCurrentLecturer(session);
        if (lecturer == null)
            return "redirect:/login";

        Set<Long> supervisedTopicIds = scoringService.getSupervisedTopicIds(lecturer.getId());
        List<TopicRegistration> myGroupRegs = registrationService.getAll().stream()
                .filter(r -> isSupervisorOf(r.getTopic(), lecturer, supervisedTopicIds))
                .toList();

        model.addAttribute("registrations", myGroupRegs);
        return "lecturer/groups";
    }

    /**
     * Cập nhật trạng thái duyệt đăng ký đề tài của nhóm sinh viên.
     * 
     * @param id                 ID đăng ký đề tài
     * @param status             Trạng thái mới
     * @param rejectionReason    Lý do từ chối (nếu có)
     * @param session            Phiên đăng nhập
     * @param redirectAttributes Dùng để truyền thông báo flash
     * @return Chuyển hướng về trang danh sách nhóm
     */
    @PostMapping("/groups/{id}/status")
    public String updateRegistrationStatus(@PathVariable Long id,
            @RequestParam RegistrationStatus status,
            @RequestParam(required = false) String rejectionReason,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        Lecture lecturer = getCurrentLecturer(session);
        if (lecturer == null)
            return "redirect:/login";
        UserAccount user = (UserAccount) session.getAttribute("user");
        try {
            TopicRegistration reg = registrationService.findById(id);
            if (reg == null)
                throw new IllegalArgumentException("Không tìm thấy đăng ký");
            if (!isSupervisorOf(reg.getTopic(), lecturer)) {
                throw new IllegalStateException("Bạn không phải GVHD của đề tài này");
            }
            registrationService.updateStatus(id, status, user, rejectionReason);
            redirectAttributes.addFlashAttribute("successMessage", "Đã cập nhật trạng thái duyệt đăng ký nhóm!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi duyệt đăng ký: " + e.getMessage());
        }
        return "redirect:/lecturer/groups";
    }

    /**
     * Hiển thị danh sách hội đồng mà giảng viên là thành viên.
     * 
     * @param session Phiên đăng nhập
     * @param model   Model Spring MVC
     * @return view councils
     */
    @GetMapping("/councils")
    public String councils(HttpSession session, Model model) {
        Lecture lecturer = getCurrentLecturer(session);
        if (lecturer == null)
            return "redirect:/login";

        List<ReviewCouncilMember> myCouncilMembers = councilService.getCouncilsForLecturer(lecturer.getId());
        model.addAttribute("myCouncilMembers", myCouncilMembers);
        model.addAttribute("lecturer", lecturer);
        model.addAttribute("councilService", councilService);
        model.addAttribute("scoringService", scoringService);
        model.addAttribute("scoreRepository", scoreRepository);
        return "lecturer/councils";
    }

    /**
     * Hiển thị giao diện chấm điểm cho một phân công đề tài.
     * 
     * @param assignmentId       ID phân công đề tài
     * @param session            Phiên đăng nhập
     * @param model              Model Spring MVC
     * @param redirectAttributes Dùng để truyền thông báo flash
     * @return view grading
     */
    @GetMapping("/grading/{assignmentId}")
    public String gradingPage(@PathVariable Long assignmentId,
            HttpSession session,
            Model model,
            RedirectAttributes redirectAttributes) {
        Lecture lecturer = getCurrentLecturer(session);
        if (lecturer == null)
            return "redirect:/login";

        TopicAssignment assignment = assignmentRepository.findById(assignmentId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy phân công đề tài"));

        Topic topic = assignment.getTopicRegistration().getTopic();
        boolean isSupervisor = isSupervisorOf(topic, lecturer);

        ReviewCouncil council = assignment.getCouncil();
        List<ReviewCouncilMember> members = councilService.getMembers(council.getId());
        ReviewCouncilMember myMemberRecord = members.stream()
                .filter(m -> m.getLecturer().getId().equals(lecturer.getId())).findFirst().orElse(null);

        Score myScore = (myMemberRecord != null)
                ? scoreRepository.findByTopicAssignmentIdAndCouncilMemberId(assignmentId, myMemberRecord.getId())
                        .orElse(null)
                : null;

        List<Report> reports = reportService.getReportsForRegistration(assignment.getTopicRegistration().getId());

        model.addAttribute("assignment", assignment);
        model.addAttribute("lecturer", lecturer);
        model.addAttribute("isSupervisor", isSupervisor);
        model.addAttribute("myScore", myScore);
        model.addAttribute("reports", reports);
        model.addAttribute("allScores", scoreRepository.findByTopicAssignmentId(assignmentId));
        return "lecturer/grading";
    }

    /**
     * Lưu điểm và nhận xét của giảng viên cho một phân công đề tài.
     * 
     * @param assignmentId       ID phân công đề tài
     * @param score              Điểm số
     * @param comment            Nhận xét
     * @param session            Phiên đăng nhập
     * @param redirectAttributes Dùng để truyền thông báo flash
     * @return Chuyển hướng về trang danh sách hội đồng
     */
    @PostMapping("/grading/{assignmentId}/save")
    public String saveGrade(@PathVariable Long assignmentId,
            @RequestParam Double score,
            @RequestParam String comment,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        Lecture lecturer = getCurrentLecturer(session);
        if (lecturer == null)
            return "redirect:/login";

        try {
            scoringService.gradeTopic(assignmentId, lecturer.getId(), score, comment);
            redirectAttributes.addFlashAttribute("successMessage", "Lưu điểm và nhận xét thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi chấm điểm: " + e.getMessage());
        }
        return "redirect:/lecturer/councils";
    }

    /**
     * Lưu điểm và nhận xét của giảng viên qua AJAX.
     * 
     * @param assignmentId ID phân công đề tài
     * @param score        Điểm số
     * @param comment      Nhận xét
     * @param session      Phiên đăng nhập
     * @return JSON kết quả xử lý
     */
    @PostMapping(value = "/grading/{assignmentId}/save-ajax", produces = "application/json")
    @ResponseBody
    public Map<String, Object> saveGradeAjax(@PathVariable Long assignmentId,
            @RequestParam Double score,
            @RequestParam String comment,
            HttpSession session) {
        Map<String, Object> resp = new HashMap<>();
        Lecture lecturer = getCurrentLecturer(session);
        if (lecturer == null) {
            resp.put("success", false);
            resp.put("message", "Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.");
            return resp;
        }

        try {
            Score savedScore = scoringService.gradeTopic(assignmentId, lecturer.getId(), score, comment);
            resp.put("success", true);
            resp.put("message", "Đã lưu điểm " + savedScore.getScore() + "/10 và nhận xét thành công!");
            resp.put("score", savedScore.getScore());
            resp.put("comment", savedScore.getComment());
            resp.put("updatedAt",
                    savedScore.getUpdatedAt() != null ? savedScore.getUpdatedAt().toString() : "Vừa xong");
        } catch (Exception e) {
            resp.put("success", false);
            resp.put("message", e.getMessage());
        }
        return resp;
    }

    /**
     * Xem chi tiết báo cáo của nhóm sinh viên.
     * 
     * @param id                 ID báo cáo
     * @param session            Phiên đăng nhập
     * @param model              Model Spring MVC
     * @param redirectAttributes Dùng để truyền thông báo flash
     * @return view report detail
     */
    @GetMapping("/reports/{id}")
    public String reportDetail(@PathVariable Long id,
            HttpSession session,
            Model model,
            RedirectAttributes redirectAttributes) {
        Lecture lecturer = getCurrentLecturer(session);
        if (lecturer == null)
            return "redirect:/login";
        try {
            Report report = reportService.getById(id);
            if (!isSupervisorOf(report.getTopicRegistration().getTopic(), lecturer)) {
                throw new IllegalStateException("Bạn không có quyền xem báo cáo này");
            }
            TopicEvaluation evaluation = evaluationRepository
                    .findByTopicIdAndReviewerId(report.getTopicRegistration().getTopic().getId(), lecturer.getId())
                    .orElse(null);
            model.addAttribute("report", report);
            model.addAttribute("evaluation", evaluation);
            model.addAttribute("lecturer", lecturer);
            return "lecturer/report-detail";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/lecturer/reports";
        }
    }

    /**
     * Hiển thị danh sách các báo cáo của các nhóm do giảng viên hướng dẫn.
     * 
     * @param session Phiên đăng nhập
     * @param model   Model Spring MVC
     * @return view reports
     */
    @GetMapping("/reports")
    public String reports(HttpSession session, Model model) {
        Lecture lecturer = getCurrentLecturer(session);
        if (lecturer == null)
            return "redirect:/login";

        Set<Long> supervisedTopicIds = scoringService.getSupervisedTopicIds(lecturer.getId());
        List<Report> myReports = reportService.getAll().stream()
                .filter(r -> isSupervisorOf(r.getTopicRegistration().getTopic(), lecturer, supervisedTopicIds))
                .toList();

        model.addAttribute("reports", myReports);
        model.addAttribute("lecturer", lecturer);
        return "lecturer/reports";
    }

    /**
     * Duyệt báo cáo của nhóm sinh viên.
     * 
     * @param id                 ID báo cáo
     * @param session            Phiên đăng nhập
     * @param redirectAttributes Dùng để truyền thông báo flash
     * @return Chuyển hướng về trang chi tiết báo cáo
     */
    @PostMapping("/reports/{id}/approve")
    public String approveReport(@PathVariable Long id,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        Lecture lecturer = getCurrentLecturer(session);
        if (lecturer == null)
            return "redirect:/login";
        try {
            Report report = reportService.getById(id);
            if (!isSupervisorOf(report.getTopicRegistration().getTopic(), lecturer)) {
                throw new IllegalStateException("Bạn không phải giảng viên hướng dẫn của đề tài này");
            }
            if (report.isApproved()) {
                throw new IllegalStateException("Báo cáo đã được duyệt và đang bị khóa");
            }
            if (evaluationRepository
                    .findByTopicIdAndReviewerId(report.getTopicRegistration().getTopic().getId(), lecturer.getId())
                    .isEmpty()) {
                throw new IllegalStateException("Vui lòng chấm điểm quá trình trước khi duyệt báo cáo");
            }
            reportService.approve(id);
            redirectAttributes.addFlashAttribute("successMessage", "Đã duyệt báo cáo cho nhóm.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi duyệt báo cáo: " + e.getMessage());
        }
        return "redirect:/lecturer/reports/" + id;
    }

    /**
     * Từ chối báo cáo của nhóm sinh viên.
     * 
     * @param id                 ID báo cáo
     * @param session            Phiên đăng nhập
     * @param redirectAttributes Dùng để truyền thông báo flash
     * @return Chuyển hướng về trang chi tiết báo cáo
     */
    @PostMapping("/reports/{id}/reject")
    public String rejectReport(@PathVariable Long id,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        Lecture lecturer = getCurrentLecturer(session);
        if (lecturer == null)
            return "redirect:/login";
        try {
            Report report = reportService.getById(id);
            if (!isSupervisorOf(report.getTopicRegistration().getTopic(), lecturer)) {
                throw new IllegalStateException("Bạn không phải giảng viên hướng dẫn của đề tài này");
            }
            if (report.isApproved()) {
                throw new IllegalStateException("Báo cáo đã được duyệt và đang bị khóa");
            }
            reportService.reject(id);
            redirectAttributes.addFlashAttribute("successMessage",
                    "Đã từ chối báo cáo. Nhóm cần nộp lại báo cáo phù hợp.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi từ chối báo cáo: " + e.getMessage());
        }
        return "redirect:/lecturer/reports/" + id;
    }

    /**
     * Lưu điểm đánh giá quá trình cho đề tài.
     * 
     * @param topicId            ID đề tài
     * @param reportId           ID báo cáo (nếu có)
     * @param score              Điểm số (0 - 10)
     * @param comment            Nhận xét
     * @param session            Phiên đăng nhập
     * @param redirectAttributes Dùng để truyền thông báo flash
     * @return Chuyển hướng về trang chi tiết báo cáo hoặc danh sách
     */
    @PostMapping("/reports/evaluation")
    public String saveProcessEvaluation(@RequestParam Long topicId,
            @RequestParam(required = false) Long reportId,
            @RequestParam Double score,
            @RequestParam(required = false) String comment,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        Lecture lecturer = getCurrentLecturer(session);
        if (lecturer == null)
            return "redirect:/login";
        try {
            Topic topic = topicService.findById(topicId);
            if (!isSupervisorOf(topic, lecturer)) {
                throw new IllegalStateException("Bạn không phải giảng viên hướng dẫn của đề tài này");
            }
            if (reportId != null && reportService.getById(reportId).isApproved()) {
                throw new IllegalStateException("Báo cáo đã được duyệt, không thể chỉnh sửa điểm quá trình");
            }
            if (score < 0 || score > 10) {
                throw new IllegalArgumentException("Điểm quá trình phải nằm trong khoảng 0 đến 10");
            }
            TopicEvaluation evaluation = evaluationRepository.findByTopicIdAndReviewerId(topicId, lecturer.getId())
                    .orElseGet(TopicEvaluation::new);
            evaluation.setTopic(topic);
            evaluation.setReviewer(lecturer);
            evaluation.setScore(score);
            evaluation.setComment(comment);
            evaluation.setEvaluatedAt(LocalDateTime.now());
            evaluationRepository.save(evaluation);
            redirectAttributes.addFlashAttribute("successMessage", "Đã lưu điểm quá trình.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi lưu điểm quá trình: " + e.getMessage());
        }
        return reportId != null ? "redirect:/lecturer/reports/" + reportId : "redirect:/lecturer/reports";
    }

    /**
     * Hiển thị danh sách thông báo dành cho giảng viên.
     * 
     * @param notificationId ID thông báo cần đánh dấu đã đọc (tùy chọn)
     * @param session        Phiên đăng nhập
     * @param model          Model Spring MVC
     * @return view notifications
     */
    @GetMapping("/notifications")
    public String notifications(@RequestParam(required = false) Long notificationId,
            HttpSession session, Model model) {
        UserAccount user = (UserAccount) session.getAttribute("user");
        if (notificationId != null) {
            notificationService.markAsRead(notificationId, user);
        }
        List<Notification> notifications = notificationService.getPublishedForRole("LECTURER");
        model.addAttribute("notifications", notifications);
        model.addAttribute("notificationService", notificationService);
        model.addAttribute("currentUser", user);
        // Tập ID đã đọc (1 truy vấn) để JSP không phải gọi isRead() cho từng thông báo
        model.addAttribute("readNotificationIds",
                notificationService.getReadNotificationIds(user != null ? user.getId() : null));
        return "lecturer/notifications";
    }

    /**
     * Đánh dấu một thông báo là đã đọc.
     * 
     * @param id      ID thông báo
     * @param session Phiên đăng nhập
     * @return Chuyển hướng về trang danh sách thông báo
     */
    @PostMapping("/notifications/{id}/read")
    public String markNotificationRead(@PathVariable Long id, HttpSession session) {
        notificationService.markAsRead(id, (UserAccount) session.getAttribute("user"));
        return "redirect:/lecturer/notifications";
    }
}