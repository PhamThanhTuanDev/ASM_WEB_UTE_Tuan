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

@Controller
@RequestMapping("/lecturer")
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
                              ScoreRepository scoreRepository) {
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
    }

    private Lecture getCurrentLecturer(HttpSession session) {
        UserAccount user = (UserAccount) session.getAttribute("user");
        if (user == null) return null;
        return lectureRepository.findByUserId(user.getId());
    }

    // 1. Lecturer Dashboard
    @GetMapping({"", "/", "/dashboard"})
    public String dashboard(HttpSession session, Model model) {
        Lecture lecturer = getCurrentLecturer(session);
        if (lecturer == null) {
            return "redirect:/login";
        }

        List<Topic> myTopics = topicService.getTopicsByLecturer(lecturer.getId());
        List<ReviewCouncilMember> myCouncils = councilService.getCouncilsForLecturer(lecturer.getId());
        List<TopicRegistration> allRegs = registrationService.getAll();
        List<TopicRegistration> myGroupRegs = allRegs.stream()
                .filter(r -> (r.getTopic().getLecturer() != null && r.getTopic().getLecturer().getId().equals(lecturer.getId()))
                        || (r.getTopic().getCoLecturer() != null && r.getTopic().getCoLecturer().getId().equals(lecturer.getId())))
                .toList();

        model.addAttribute("lecturer", lecturer);
        model.addAttribute("myTopics", myTopics);
        model.addAttribute("myCouncils", myCouncils);
        model.addAttribute("myGroupRegs", myGroupRegs);
        model.addAttribute("notifications", notificationService.getPublishedForRole("LECTURER"));
        model.addAttribute("activePeriod", periodService.getActivePeriod());

        return "lecturer/dashboard";
    }

    // 2. Topic Proposals & Management
    @GetMapping("/topics")
    public String topics(HttpSession session, Model model) {
        Lecture lecturer = getCurrentLecturer(session);
        if (lecturer == null) return "redirect:/login";

        model.addAttribute("lecturer", lecturer);
        model.addAttribute("topics", topicService.getTopicsByLecturer(lecturer.getId()));
        model.addAttribute("topic", new Topic());
        model.addAttribute("departments", departmentRepository.findAll());
        model.addAttribute("periods", periodService.getAll());
        model.addAttribute("lecturers", lectureRepository.findAll());
        model.addAttribute("activePeriod", periodService.getActivePeriod());
        return "lecturer/topics";
    }

    @PostMapping("/topics/save")
    public String saveTopic(@ModelAttribute Topic topic,
                            @RequestParam Long departmentId,
                            @RequestParam Long periodId,
                            @RequestParam(required = false) Long coLecturerId,
                            HttpSession session,
                            RedirectAttributes redirectAttributes) {
        Lecture lecturer = getCurrentLecturer(session);
        if (lecturer == null) return "redirect:/login";

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
                topic.setStatus(TopicStatus.PENDING); // Sent for dean approval
            }
            topicService.save(topic);
            redirectAttributes.addFlashAttribute("successMessage", "Đề xuất đề tài thành công! Chờ Trưởng khoa duyệt.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi: " + e.getMessage());
        }
        return "redirect:/lecturer/topics";
    }

    @PostMapping("/topics/{id}/delete")
    public String deleteTopic(@PathVariable Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        Lecture lecturer = getCurrentLecturer(session);
        if (lecturer == null) return "redirect:/login";

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

    // 3. Supervised Groups & Registrations Approval
    @GetMapping("/groups")
    public String groups(HttpSession session, Model model) {
        Lecture lecturer = getCurrentLecturer(session);
        if (lecturer == null) return "redirect:/login";

        List<TopicRegistration> allRegs = registrationService.getAll();
        List<TopicRegistration> myGroupRegs = allRegs.stream()
                .filter(r -> (r.getTopic().getLecturer() != null && r.getTopic().getLecturer().getId().equals(lecturer.getId()))
                        || (r.getTopic().getCoLecturer() != null && r.getTopic().getCoLecturer().getId().equals(lecturer.getId())))
                .toList();

        model.addAttribute("registrations", myGroupRegs);
        return "lecturer/groups";
    }

    @PostMapping("/groups/{id}/status")
    public String updateRegistrationStatus(@PathVariable Long id,
                                           @RequestParam RegistrationStatus status,
                                           @RequestParam(required = false) String rejectionReason,
                                           HttpSession session,
                                           RedirectAttributes redirectAttributes) {
        UserAccount user = (UserAccount) session.getAttribute("user");
        try {
            registrationService.updateStatus(id, status, user, rejectionReason);
            redirectAttributes.addFlashAttribute("successMessage", "Đã cập nhật trạng thái duyệt đăng ký nhóm!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi duyệt đăng ký: " + e.getMessage());
        }
        return "redirect:/lecturer/groups";
    }

    // 4. Councils & Topic Grading
    @GetMapping("/councils")
    public String councils(HttpSession session, Model model) {
        Lecture lecturer = getCurrentLecturer(session);
        if (lecturer == null) return "redirect:/login";

        List<ReviewCouncilMember> myCouncilMembers = councilService.getCouncilsForLecturer(lecturer.getId());
        model.addAttribute("myCouncilMembers", myCouncilMembers);
        model.addAttribute("lecturer", lecturer);
        model.addAttribute("councilService", councilService);
        model.addAttribute("scoringService", scoringService);
        model.addAttribute("scoreRepository", scoreRepository);
        return "lecturer/councils";
    }

    @GetMapping("/grading/{assignmentId}")
    public String gradingPage(@PathVariable Long assignmentId,
                              HttpSession session,
                              Model model,
                              RedirectAttributes redirectAttributes) {
        Lecture lecturer = getCurrentLecturer(session);
        if (lecturer == null) return "redirect:/login";

        TopicAssignment assignment = assignmentRepository.findById(assignmentId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy phân công đề tài"));

        // Anti-supervision check
        Topic topic = assignment.getTopicRegistration().getTopic();
        boolean isSupervisor = false;
        if (topic.getLecturer() != null && topic.getLecturer().getId().equals(lecturer.getId())) isSupervisor = true;
        if (topic.getCoLecturer() != null && topic.getCoLecturer().getId().equals(lecturer.getId())) isSupervisor = true;
        if (scoringService.isLecturerSupervisingTopic(lecturer.getId(), topic.getId())) isSupervisor = true;

        // Find existing score if any
        ReviewCouncil council = assignment.getCouncil();
        List<ReviewCouncilMember> members = councilService.getMembers(council.getId());
        ReviewCouncilMember myMemberRecord = members.stream()
                .filter(m -> m.getLecturer().getId().equals(lecturer.getId())).findFirst().orElse(null);

        Score myScore = null;
        if (myMemberRecord != null) {
            myScore = scoreRepository.findByTopicAssignmentIdAndCouncilMemberId(assignmentId, myMemberRecord.getId()).orElse(null);
        }

        List<Report> reports = reportService.getReportsForRegistration(assignment.getTopicRegistration().getId());

        model.addAttribute("assignment", assignment);
        model.addAttribute("lecturer", lecturer);
        model.addAttribute("isSupervisor", isSupervisor);
        model.addAttribute("myScore", myScore);
        model.addAttribute("reports", reports);
        model.addAttribute("allScores", scoreRepository.findByTopicAssignmentId(assignmentId));
        return "lecturer/grading";
    }

    @PostMapping("/grading/{assignmentId}/save")
    public String saveGrade(@PathVariable Long assignmentId,
                            @RequestParam Double score,
                            @RequestParam String comment,
                            HttpSession session,
                            RedirectAttributes redirectAttributes) {
        Lecture lecturer = getCurrentLecturer(session);
        if (lecturer == null) return "redirect:/login";

        try {
            scoringService.gradeTopic(assignmentId, lecturer.getId(), score, comment);
            redirectAttributes.addFlashAttribute("successMessage", "Lưu điểm và nhận xét thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi chấm điểm: " + e.getMessage());
        }
        return "redirect:/lecturer/councils";
    }

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
            resp.put("updatedAt", savedScore.getUpdatedAt() != null ? savedScore.getUpdatedAt().toString() : "Vừa xong");
        } catch (Exception e) {
            resp.put("success", false);
            resp.put("message", e.getMessage());
        }
        return resp;
    }

    // 5. Reports Review
    @GetMapping("/reports")
    public String reports(HttpSession session, Model model) {
        Lecture lecturer = getCurrentLecturer(session);
        if (lecturer == null) return "redirect:/login";

        List<Report> all = reportService.getAll();
        List<Report> myReports = all.stream()
                .filter(r -> {
                    Topic t = r.getTopicRegistration().getTopic();
                    return (t.getLecturer() != null && t.getLecturer().getId().equals(lecturer.getId()))
                            || (t.getCoLecturer() != null && t.getCoLecturer().getId().equals(lecturer.getId()));
                }).toList();

        model.addAttribute("reports", myReports);
        return "lecturer/reports";
    }

    // 6. Notifications
    @GetMapping("/notifications")
    public String notifications(HttpSession session, Model model) {
        UserAccount user = (UserAccount) session.getAttribute("user");
        List<Notification> notifications = notificationService.getPublishedForRole("LECTURER");
        notificationService.markAllAsRead(notifications, user);
        model.addAttribute("notifications", notifications);
        model.addAttribute("notificationService", notificationService);
        model.addAttribute("currentUser", user);
        return "lecturer/notifications";
    }

    @PostMapping("/notifications/{id}/read")
    public String markNotificationRead(@PathVariable Long id, HttpSession session) {
        notificationService.markAsRead(id, (UserAccount) session.getAttribute("user"));
        return "redirect:/lecturer/notifications";
    }
}