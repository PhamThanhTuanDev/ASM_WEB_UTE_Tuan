package ute.edu.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import jakarta.servlet.http.HttpSession;
import ute.edu.entity.*;
import ute.edu.enums.*;
import ute.edu.repository.*;
import ute.edu.service.*;
import java.util.*;

@Controller
@RequestMapping("/student")
public class StudentController {
    private final TopicService topicService;
    private final StudentRepository studentRepository;
    private final RegistrationPeriodService periodService;
    private final StudentGroupService groupService;
    private final StudentGroupRepository studentGroupRepository;
    private final TopicRepository topicRepository;
    private final TopicRegistrationService registrationService;
    private final ReportService reportService;
    private final ScoringService scoringService;
    private final NotificationService notificationService;
    private final DepartmentRepository departmentRepository;
    private final TopicAssignmentRepository assignmentRepository;
    private final ScoreRepository scoreRepository;

    public StudentController(TopicService topicService,
                             StudentRepository studentRepository,
                             RegistrationPeriodService periodService,
                             StudentGroupService groupService,
                             StudentGroupRepository studentGroupRepository,
                             TopicRepository topicRepository,
                             TopicRegistrationService registrationService,
                             ReportService reportService,
                             ScoringService scoringService,
                             NotificationService notificationService,
                             DepartmentRepository departmentRepository,
                             TopicAssignmentRepository assignmentRepository,
                             ScoreRepository scoreRepository) {
        this.topicService = topicService;
        this.studentRepository = studentRepository;
        this.periodService = periodService;
        this.groupService = groupService;
        this.studentGroupRepository = studentGroupRepository;
        this.topicRepository = topicRepository;
        this.registrationService = registrationService;
        this.reportService = reportService;
        this.scoringService = scoringService;
        this.notificationService = notificationService;
        this.departmentRepository = departmentRepository;
        this.assignmentRepository = assignmentRepository;
        this.scoreRepository = scoreRepository;
    }

    private Student getCurrentStudent(HttpSession session) {
        UserAccount user = (UserAccount) session.getAttribute("user");
        if (user == null) return null;
        return studentRepository.findByUserId(user.getId());
    }

    // 1. Student Dashboard
    @GetMapping({"", "/", "/dashboard"})
    public String dashboard(HttpSession session, Model model) {
        Student student = getCurrentStudent(session);
        if (student == null) return "redirect:/login";

        RegistrationPeriod activePeriod = periodService.getActivePeriod();
        StudentGroup myGroup = groupService.findGroupByStudent(student.getId());
        TopicRegistration myRegistration = null;
        TopicAssignment myAssignment = null;
        List<Score> myScores = Collections.emptyList();
        Double avgScore = null;

        if (myGroup != null) {
            myRegistration = registrationService.getActiveRegistrationForGroup(myGroup.getId());
            if (myRegistration != null) {
                myAssignment = assignmentRepository.findFirstByTopicRegistrationId(myRegistration.getId()).orElse(null);
                if (myAssignment != null) {
                    myScores = scoreRepository.findByTopicAssignmentId(myAssignment.getId());
                    avgScore = scoringService.calculateAverageScore(myAssignment.getId());
                }
            }
        }

        model.addAttribute("student", student);
        model.addAttribute("activePeriod", activePeriod);
        model.addAttribute("myGroup", myGroup);
        model.addAttribute("myRegistration", myRegistration);
        model.addAttribute("myAssignment", myAssignment);
        model.addAttribute("myScores", myScores);
        model.addAttribute("avgScore", avgScore);
        model.addAttribute("notifications", notificationService.getPublishedForRole("STUDENT"));

        return "student/dashboard";
    }

    // 2. Browse & Register Approved Topics
    @GetMapping("/topics")
    public String topics(@RequestParam(required = false) Long departmentId,
                         @RequestParam(required = false) String keyword,
                         HttpSession session,
                         Model model) {
        Student student = getCurrentStudent(session);
        if (student == null) return "redirect:/login";

        List<Topic> topics;
        if (departmentId != null && departmentId > 0) {
            topics = topicService.getTopicsByDepartment(departmentId).stream()
                    .filter(t -> t.getStatus() == TopicStatus.PUBLISHED || t.getStatus() == TopicStatus.APPROVED)
                    .toList();
        } else {
            topics = topicService.getTopicsByStatus(TopicStatus.PUBLISHED);
        }

        if (keyword != null && !keyword.isBlank()) {
            String q = keyword.trim().toLowerCase();
            topics = topics.stream()
                    .filter(t -> (t.getTitle() != null && t.getTitle().toLowerCase().contains(q))
                            || (t.getCode() != null && t.getCode().toLowerCase().contains(q))
                            || (t.getLecturer() != null && t.getLecturer().getUser().getFullName().toLowerCase().contains(q)))
                    .toList();
        }

        StudentGroup myGroup = groupService.findGroupByStudent(student.getId());
        TopicRegistration myRegistration = (myGroup != null) ? registrationService.getActiveRegistrationForGroup(myGroup.getId()) : null;

        model.addAttribute("student", student);
        model.addAttribute("topics", topics);
        model.addAttribute("departments", departmentRepository.findAll());
        model.addAttribute("selectedDept", departmentId);
        model.addAttribute("keyword", keyword);
        model.addAttribute("myGroup", myGroup);
        model.addAttribute("myRegistration", myRegistration);
        model.addAttribute("activePeriod", periodService.getActivePeriod());

        return "student/topics";
    }

    @PostMapping("/topics/register")
    public String registerTopic(@RequestParam Long topicId,
                                @RequestParam Long groupId,
                                @RequestParam(required = false) String note,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        Student student = getCurrentStudent(session);
        if (student == null) return "redirect:/login";

        try {
            StudentGroup group = studentGroupRepository.findById(groupId).orElseThrow();
            // Validate: Only leader can register topic
            if (!group.getLeader().getId().equals(student.getId())) {
                redirectAttributes.addFlashAttribute("errorMessage", "Chỉ Nhóm trưởng mới có quyền đại diện nhóm đăng ký đề tài!");
                return "redirect:/student/topics";
            }

            Topic topic = topicRepository.findById(topicId).orElseThrow();
            registrationService.register(group, topic, note);
            redirectAttributes.addFlashAttribute("successMessage", "Gửi yêu cầu đăng ký đề tài '" + topic.getTitle() + "' thành công! Vui lòng chờ GVHD hoặc Khoa phê duyệt.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi đăng ký đề tài: " + e.getMessage());
        }
        return "redirect:/student/topics";
    }

    // 3. Group Management (Create, Invite via MSSV, Leave)
    @GetMapping("/group")
    public String group(HttpSession session, Model model) {
        Student student = getCurrentStudent(session);
        if (student == null) return "redirect:/login";

        StudentGroup myGroup = groupService.findGroupByStudent(student.getId());
        List<StudentGroupMember> members = (myGroup != null) ? groupService.getMembers(myGroup.getId()) : Collections.emptyList();
        TopicRegistration registration = (myGroup != null) ? registrationService.getActiveRegistrationForGroup(myGroup.getId()) : null;

        model.addAttribute("student", student);
        model.addAttribute("myGroup", myGroup);
        model.addAttribute("members", members);
        model.addAttribute("registration", registration);
        model.addAttribute("activePeriod", periodService.getActivePeriod());

        return "student/group";
    }

    @PostMapping("/group/create")
    public String createGroup(@RequestParam String name,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        Student student = getCurrentStudent(session);
        if (student == null) return "redirect:/login";

        try {
            RegistrationPeriod activePeriod = periodService.getActivePeriod();
            if (activePeriod == null) {
                redirectAttributes.addFlashAttribute("errorMessage", "Hiện tại không có đợt đăng ký nào đang mở.");
                return "redirect:/student/group";
            }
            groupService.create(name, activePeriod, student);
            redirectAttributes.addFlashAttribute("successMessage", "Tạo nhóm '" + name + "' thành công! Bạn là Nhóm trưởng.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi tạo nhóm: " + e.getMessage());
        }
        return "redirect:/student/group";
    }

    @PostMapping("/group/add-member")
    public String addMember(@RequestParam Long groupId,
                            @RequestParam String studentCode,
                            HttpSession session,
                            RedirectAttributes redirectAttributes) {
        Student student = getCurrentStudent(session);
        if (student == null) return "redirect:/login";

        try {
            StudentGroup group = studentGroupRepository.findById(groupId).orElseThrow();
            if (!group.getLeader().getId().equals(student.getId())) {
                redirectAttributes.addFlashAttribute("errorMessage", "Chỉ Nhóm trưởng mới có quyền mời thành viên!");
                return "redirect:/student/group";
            }
            groupService.addMemberByCode(groupId, studentCode);
            redirectAttributes.addFlashAttribute("successMessage", "Đã thêm sinh viên " + studentCode + " vào nhóm thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi thêm thành viên: " + e.getMessage());
        }
        return "redirect:/student/group";
    }

    @PostMapping("/group/remove-member")
    public String removeMember(@RequestParam Long groupId,
                               @RequestParam Long studentId,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        Student student = getCurrentStudent(session);
        if (student == null) return "redirect:/login";

        try {
            StudentGroup group = studentGroupRepository.findById(groupId).orElseThrow();
            if (!group.getLeader().getId().equals(student.getId())) {
                redirectAttributes.addFlashAttribute("errorMessage", "Chỉ Nhóm trưởng mới có quyền xóa thành viên!");
                return "redirect:/student/group";
            }
            groupService.removeMember(groupId, studentId);
            redirectAttributes.addFlashAttribute("successMessage", "Đã xóa thành viên khỏi nhóm.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi: " + e.getMessage());
        }
        return "redirect:/student/group";
    }

    @GetMapping(value = "/api/students/lookup", produces = "application/json")
    @ResponseBody
    public Map<String, Object> lookupStudent(@RequestParam String code) {
        Map<String, Object> resp = new HashMap<>();
        if (code == null || code.trim().isEmpty()) {
            resp.put("found", false);
            resp.put("message", "Vui lòng nhập MSSV");
            return resp;
        }
        Optional<Student> opt = studentRepository.findByStudentCode(code.trim());
        if (opt.isPresent()) {
            Student s = opt.get();
            resp.put("found", true);
            resp.put("id", s.getId());
            resp.put("studentCode", s.getStudentCode());
            resp.put("fullName", s.getUser() != null ? s.getUser().getFullName() : "Sinh viên");
            resp.put("className", s.getClassName() != null ? s.getClassName() : "N/A");
            resp.put("email", s.getUser() != null ? s.getUser().getEmail() : "");
            resp.put("faculty", s.getDepartment() != null ? s.getDepartment().getName() : "Khoa CNTT");
        } else {
            resp.put("found", false);
            resp.put("message", "Không tìm thấy sinh viên có MSSV: " + code);
        }
        return resp;
    }

    // 4. Report Submission (Leader Only)
    @GetMapping("/reports")
    public String reports(HttpSession session, Model model) {
        Student student = getCurrentStudent(session);
        if (student == null) return "redirect:/login";

        StudentGroup myGroup = groupService.findGroupByStudent(student.getId());
        TopicRegistration registration = (myGroup != null) ? registrationService.getActiveRegistrationForGroup(myGroup.getId()) : null;
        List<Report> reports = (registration != null) ? reportService.getReportsForRegistration(registration.getId()) : Collections.emptyList();

        boolean isLeader = (myGroup != null && myGroup.getLeader().getId().equals(student.getId()));

        model.addAttribute("student", student);
        model.addAttribute("myGroup", myGroup);
        model.addAttribute("registration", registration);
        model.addAttribute("reports", reports);
        model.addAttribute("isLeader", isLeader);

        return "student/reports";
    }

    @PostMapping("/reports/submit")
    public String submitReport(@RequestParam Long registrationId,
                               @RequestParam String fileName,
                               @RequestParam(required = false) MultipartFile file,
                               @RequestParam(required = false) String filePath,
                               @RequestParam(required = false) String note,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        Student student = getCurrentStudent(session);
        if (student == null) return "redirect:/login";

        try {
            String uploadedPath = reportService.storeFile(file);
            if (uploadedPath != null) {
                filePath = uploadedPath;
                fileName = file.getOriginalFilename();
            }
            reportService.submitReport(registrationId, student.getId(), fileName, filePath, note);
            redirectAttributes.addFlashAttribute("successMessage", "Nộp báo cáo thành công! Giảng viên hướng dẫn và Hội đồng có thể xem tài liệu.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi nộp báo cáo: " + e.getMessage());
        }
        return "redirect:/student/reports";
    }

    // 5. Results & Defense Schedule
    @GetMapping("/results")
    public String results(HttpSession session, Model model) {
        Student student = getCurrentStudent(session);
        if (student == null) return "redirect:/login";

        StudentGroup myGroup = groupService.findGroupByStudent(student.getId());
        TopicRegistration registration = (myGroup != null) ? registrationService.getActiveRegistrationForGroup(myGroup.getId()) : null;
        TopicAssignment assignment = (registration != null) ? assignmentRepository.findFirstByTopicRegistrationId(registration.getId()).orElse(null) : null;
        List<Score> scores = (assignment != null) ? scoreRepository.findByTopicAssignmentId(assignment.getId()) : Collections.emptyList();
        Double avgScore = (assignment != null) ? scoringService.calculateAverageScore(assignment.getId()) : null;

        model.addAttribute("student", student);
        model.addAttribute("myGroup", myGroup);
        model.addAttribute("registration", registration);
        model.addAttribute("assignment", assignment);
        model.addAttribute("scores", scores);
        model.addAttribute("avgScore", avgScore);

        return "student/results";
    }

    // 6. Notifications
    @GetMapping("/notifications")
    public String notifications(HttpSession session, Model model) {
        Student student = getCurrentStudent(session);
        UserAccount user = (UserAccount) session.getAttribute("user");
        List<Notification> list = notificationService.getPublishedForRole("STUDENT");
        notificationService.markAllAsRead(list, user);

        model.addAttribute("student", student);
        model.addAttribute("notifications", list);
        model.addAttribute("notificationService", notificationService);
        model.addAttribute("currentUser", user);

        return "student/notifications";
    }

    @PostMapping("/notifications/{id}/read")
    public String markNotificationRead(@PathVariable Long id, HttpSession session) {
        UserAccount user = (UserAccount) session.getAttribute("user");
        if (user != null) {
            notificationService.markAsRead(id, user);
        }
        return "redirect:/student/notifications";
    }
}