package ute.edu.controller;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import ute.edu.enums.*;
import ute.edu.entity.*;
import ute.edu.repository.*;
import ute.edu.service.*;

import java.util.*;

@Controller
@RequestMapping("/admin")
public class AdminController {
    private final TopicService topicService;
    private final RegistrationPeriodService periodService;
    private final DepartmentRepository departmentRepository;
    private final TopicRegistrationService registrationService;
    private final StudentGroupService groupService;
    private final StudentGroupRepository groupRepository;
    private final CouncilService councilService;
    private final ScoringService scoringService;
    private final ReportService reportService;
    private final NotificationService notificationService;
    private final LectureRepository lectureRepository;
    private final StudentRepository studentRepository;
    private final UserAccountRepository userRepository;

    public AdminController(TopicService topicService,
                           RegistrationPeriodService periodService,
                           DepartmentRepository departmentRepository,
                           TopicRegistrationService registrationService,
                           StudentGroupService groupService,
                           StudentGroupRepository groupRepository,
                           CouncilService councilService,
                           ScoringService scoringService,
                           ReportService reportService,
                           NotificationService notificationService,
                           LectureRepository lectureRepository,
                           StudentRepository studentRepository,
                           UserAccountRepository userRepository) {
        this.topicService = topicService;
        this.periodService = periodService;
        this.departmentRepository = departmentRepository;
        this.registrationService = registrationService;
        this.groupService = groupService;
        this.groupRepository = groupRepository;
        this.councilService = councilService;
        this.scoringService = scoringService;
        this.reportService = reportService;
        this.notificationService = notificationService;
        this.lectureRepository = lectureRepository;
        this.studentRepository = studentRepository;
        this.userRepository = userRepository;
    }

    // 1. Dashboard
    @GetMapping({"", "/", "/dashboard"})
    public String dashboard(Model model) {
        List<Topic> topics = topicService.getAllTopics();
        model.addAttribute("topics", topics);
        model.addAttribute("periods", periodService.getAll());
        model.addAttribute("groupCount", groupRepository.count());
        model.addAttribute("councilCount", councilService.getAll().size());
        model.addAttribute("totalLecturers", lectureRepository.count());
        model.addAttribute("totalStudents", studentRepository.count());
        model.addAttribute("totalRegistrations", registrationService.getAll().size());

        // Count topics by status
        long publishedCount = topics.stream().filter(t -> t.getStatus() == TopicStatus.PUBLISHED || t.getStatus() == TopicStatus.APPROVED).count();
        long pendingCount = topics.stream().filter(t -> t.getStatus() == TopicStatus.PENDING || t.getStatus() == TopicStatus.DRAFT).count();
        long rejectedCount = topics.stream().filter(t -> t.getStatus() == TopicStatus.REJECTED).count();
        model.addAttribute("publishedTopicCount", publishedCount);
        model.addAttribute("pendingTopicCount", pendingCount);
        model.addAttribute("rejectedTopicCount", rejectedCount);

        model.addAttribute("recentRegistrations", registrationService.getAll());
        model.addAttribute("recentCouncils", councilService.getAll());
        model.addAttribute("notifications", notificationService.getAll());

        return "admin/dashboard";
    }

    // 2. Registration Periods Management
    @GetMapping("/periods")
    public String registrationPeriods(Model model) {
        model.addAttribute("periods", periodService.getAll());
        model.addAttribute("period", new RegistrationPeriod());
        model.addAttribute("registrationTypes", RegistrationType.values());
        model.addAttribute("periodStatuses", PeriodStatus.values());
        return "admin/periods";
    }

    @PostMapping("/periods/save")
    public String savePeriod(@ModelAttribute RegistrationPeriod period,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        try {
            UserAccount adminUser = (UserAccount) session.getAttribute("user");
            if (period.getCreatedBy() == null && adminUser != null) {
                period.setCreatedBy(adminUser);
            }
            periodService.save(period);
            redirectAttributes.addFlashAttribute("successMessage", "Lưu đợt đăng ký '" + period.getName() + "' thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi lưu đợt đăng ký: " + e.getMessage());
        }
        return "redirect:/admin/periods";
    }

    @PostMapping("/periods/{id}/delete")
    public String deletePeriod(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            periodService.delete(id);
            redirectAttributes.addFlashAttribute("successMessage", "Đã xóa đợt đăng ký thành công.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không thể xóa đợt này do đang có đề tài hoặc dữ liệu liên kết.");
        }
        return "redirect:/admin/periods";
    }

    // 3. Duyệt đề xuất đề tài (GVHD nộp → Trưởng khoa chấp nhận/từ chối → công bố)
    @GetMapping("/topics")
    public String topics(@RequestParam(required = false) Long departmentId,
                         @RequestParam(required = false) Long periodId,
                         Model model) {
        List<Topic> list = topicService.getAllTopics();
        if (departmentId != null && departmentId > 0) {
            list = list.stream().filter(t -> t.getDepartment() != null && t.getDepartment().getId().equals(departmentId)).toList();
        }
        if (periodId != null && periodId > 0) {
            list = list.stream().filter(t -> t.getRegistrationPeriod() != null && t.getRegistrationPeriod().getId().equals(periodId)).toList();
        }

        model.addAttribute("topics", list);
        model.addAttribute("topic", new Topic());
        model.addAttribute("departments", departmentRepository.findAll());
        model.addAttribute("periods", periodService.getAll());
        model.addAttribute("lecturers", lectureRepository.findAll());
        model.addAttribute("statuses", TopicStatus.values());
        model.addAttribute("selectedDept", departmentId);
        model.addAttribute("selectedPeriod", periodId);
        return "admin/topics";
    }

    @PostMapping("/topics/save")
    public String saveTopic(@ModelAttribute Topic topic,
                            @RequestParam(name = "departmentId") Long departmentId,
                            @RequestParam(name = "periodId") Long periodId,
                            @RequestParam(name = "primaryLecturerId") Long primaryLecturerId,
                            @RequestParam(name = "coLecturerId", required = false) Long coLecturerId,
                            RedirectAttributes redirectAttributes) {
        try {
            topic.setDepartment(departmentRepository.findById(departmentId).orElseThrow());
            topic.setRegistrationPeriod(periodService.findById(periodId));
            topic.setLecturer(lectureRepository.findById(primaryLecturerId).orElse(null));
            if (coLecturerId != null && coLecturerId > 0) {
                topic.setCoLecturer(lectureRepository.findById(coLecturerId).orElse(null));
            } else {
                topic.setCoLecturer(null);
            }
            topicService.save(topic);
            redirectAttributes.addFlashAttribute("successMessage", "Lưu thông tin đề tài thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi lưu đề tài: " + e.getMessage());
        }
        return "redirect:/admin/topics";
    }

    @PostMapping("/topics/{id}/status")
    public String updateTopicStatus(@PathVariable Long id,
                                    @RequestParam TopicStatus status,
                                    RedirectAttributes redirectAttributes) {
        try {
            topicService.updateStatus(id, status);
            redirectAttributes.addFlashAttribute("successMessage", "Cập nhật trạng thái đề tài thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi: " + e.getMessage());
        }
        return "redirect:/admin/topics";
    }

    @PostMapping(value = "/topics/{id}/status-ajax", produces = "application/json")
    @ResponseBody
    public Map<String, Object> updateTopicStatusAjax(@PathVariable Long id,
                                                     @RequestParam TopicStatus status,
                                                     @RequestParam(required = false) String rejectionReason) {
        Map<String, Object> resp = new HashMap<>();
        try {
            Topic updated = topicService.updateStatus(id, status);
            resp.put("success", true);
            resp.put("status", updated.getStatus().name());
            resp.put("message", status == TopicStatus.REJECTED
                    ? "Đã từ chối đề tài" + (rejectionReason != null && !rejectionReason.isBlank() ? ": " + rejectionReason.trim() : ".")
                    : "Cập nhật trạng thái đề tài thành công!");
        } catch (Exception e) {
            resp.put("success", false);
            resp.put("message", e.getMessage());
        }
        return resp;
    }

    @PostMapping("/topics/{id}/delete")
    public String deleteTopic(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            topicService.delete(id);
            redirectAttributes.addFlashAttribute("successMessage", "Đã xóa đề tài thành công.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không thể xóa đề tài đang có nhóm đăng ký hoặc liên kết.");
        }
        return "redirect:/admin/topics";
    }

    // 4. Student Groups Management
    @GetMapping("/groups")
    public String groups(Model model) {
        List<StudentGroup> groups = groupService.getAll();
        model.addAttribute("groups", groups);
        return "admin/groups";
    }

    // 5. Duyệt đăng ký nhóm SV thuộc quyền GVHD (/lecturer/groups)
    @GetMapping("/registrations")
    public String registrations() {
        return "redirect:/admin/topics";
    }

    @PostMapping("/registrations/{id}/status")
    public String updateRegistrationStatus(@PathVariable Long id,
                                           @RequestParam RegistrationStatus status,
                                           @RequestParam(required = false) String rejectionReason,
                                           HttpSession session,
                                           RedirectAttributes redirectAttributes) {
        try {
            UserAccount user = (UserAccount) session.getAttribute("user");
            registrationService.updateStatus(id, status, user, rejectionReason);
            redirectAttributes.addFlashAttribute("successMessage", "Cập nhật duyệt đăng ký thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi duyệt: " + e.getMessage());
        }
        return "redirect:/admin/topics";
    }

    @PostMapping(value = "/registrations/{id}/status-ajax", produces = "application/json")
    @ResponseBody
    public Map<String, Object> updateRegistrationStatusAjax(@PathVariable Long id,
                                                            @RequestParam RegistrationStatus status,
                                                            @RequestParam(required = false) String rejectionReason,
                                                            HttpSession session) {
        Map<String, Object> resp = new HashMap<>();
        try {
            UserAccount user = (UserAccount) session.getAttribute("user");
            TopicRegistration updated = registrationService.updateStatus(id, status, user, rejectionReason);
            resp.put("success", true);
            resp.put("status", updated.getStatus().name());
            resp.put("message", status == RegistrationStatus.REJECTED
                    ? "Đã từ chối đăng ký kèm lý do."
                    : "Cập nhật duyệt đăng ký thành công!");
        } catch (Exception e) {
            resp.put("success", false);
            resp.put("message", e.getMessage());
        }
        return resp;
    }

    // 6. Review Councils & Assignment
    @GetMapping("/councils")
    public String councils(Model model) {
        model.addAttribute("councils", councilService.getAll());
        model.addAttribute("periods", periodService.getAll());
        model.addAttribute("departments", departmentRepository.findAll());
        model.addAttribute("lecturers", lectureRepository.findAll());
        model.addAttribute("approvedRegistrations", registrationService.getApprovedRegistrations());
        return "admin/councils";
    }

    @PostMapping("/councils/save")
    public String saveCouncil(@ModelAttribute ReviewCouncil council,
                              @RequestParam Long periodId,
                              @RequestParam Long departmentId,
                              @RequestParam Long chairmanId,
                              @RequestParam Long secretaryId,
                              @RequestParam(required = false) List<Long> memberIds,
                              RedirectAttributes redirectAttributes) {
        try {
            council.setRegistrationPeriod(periodService.findById(periodId));
            council.setDepartment(departmentRepository.findById(departmentId).orElse(null));
            councilService.createCouncil(council, chairmanId, secretaryId, memberIds);
            redirectAttributes.addFlashAttribute("successMessage", "Thành lập Hội đồng phản biện thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi tạo hội đồng: " + e.getMessage());
        }
        return "redirect:/admin/councils";
    }

    @PostMapping("/councils/{id}/assign-topic")
    public String assignTopicToCouncil(@PathVariable Long id,
                                       @RequestParam Long registrationId,
                                       RedirectAttributes redirectAttributes) {
        try {
            councilService.assignTopic(id, registrationId);
            redirectAttributes.addFlashAttribute("successMessage", "Đã phân công đề tài vào Hội đồng!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi phân công: " + e.getMessage());
        }
        return "redirect:/admin/councils";
    }

    @PostMapping("/councils/{id}/delete")
    public String deleteCouncil(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            councilService.deleteCouncil(id);
            redirectAttributes.addFlashAttribute("successMessage", "Đã xóa hội đồng thành công.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi: " + e.getMessage());
        }
        return "redirect:/admin/councils";
    }

    // 7. Scoring, Results & Publication
    @GetMapping("/results")
    public String results(Model model) {
        List<ReviewCouncil> councils = councilService.getAll();
        model.addAttribute("councils", councils);
        model.addAttribute("scoringService", scoringService);
        model.addAttribute("councilService", councilService);
        return "admin/results";
    }

    @PostMapping("/results/{councilId}/finalize")
    public String finalizeCouncil(@PathVariable Long id,
                                  @PathVariable Long councilId,
                                  RedirectAttributes redirectAttributes) {
        try {
            scoringService.finalizeCouncil(councilId);
            redirectAttributes.addFlashAttribute("successMessage", "Đã chốt và công bố kết quả đánh giá cho Hội đồng!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi: " + e.getMessage());
        }
        return "redirect:/admin/results";
    }

    // 8. Reports Management
    @GetMapping("/reports")
    public String reports(Model model) {
        model.addAttribute("reports", reportService.getAll());
        return "admin/reports";
    }

    // 9. Notifications Management
    @GetMapping("/notifications")
    public String notifications(Model model) {
        model.addAttribute("notifications", notificationService.getAll());
        model.addAttribute("types", NotificationType.values());
        return "admin/notifications";
    }

    @PostMapping("/notifications/save")
    public String saveNotification(@RequestParam String title,
                                   @RequestParam String content,
                                   @RequestParam NotificationType type,
                                   @RequestParam(defaultValue = "true") boolean published,
                                   HttpSession session,
                                   RedirectAttributes redirectAttributes) {
        try {
            UserAccount creator = (UserAccount) session.getAttribute("user");
            notificationService.create(title, content, type, published, creator);
            redirectAttributes.addFlashAttribute("successMessage", "Đăng thông báo thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi đăng thông báo: " + e.getMessage());
        }
        return "redirect:/admin/notifications";
    }

    @PostMapping("/notifications/{id}/toggle")
    public String toggleNotification(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        notificationService.togglePublish(id);
        redirectAttributes.addFlashAttribute("successMessage", "Đã cập nhật trạng thái thông báo.");
        return "redirect:/admin/notifications";
    }

    @PostMapping("/notifications/{id}/delete")
    public String deleteNotification(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        notificationService.delete(id);
        redirectAttributes.addFlashAttribute("successMessage", "Đã xóa thông báo.");
        return "redirect:/admin/notifications";
    }

    // 10. User Management
    @GetMapping("/users")
    public String users(Model model) {
        model.addAttribute("users", userRepository.findAll());
        model.addAttribute("lecturers", lectureRepository.findAll());
        model.addAttribute("students", studentRepository.findAll());
        return "admin/users";
    }
}
