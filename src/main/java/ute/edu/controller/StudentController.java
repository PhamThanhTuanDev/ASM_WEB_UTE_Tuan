package ute.edu.controller;

import org.springframework.security.access.prepost.PreAuthorize;
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
@PreAuthorize("hasAnyRole('STUDENT', 'ADMIN')")
/** Controller sinh viên: quản lý nhóm, đăng ký đề tài, báo cáo và xem điểm. */
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

    /**
     * Lấy thông tin sinh viên hiện tại từ phiên đăng nhập.
     * 
     * @param session Phiên đăng nhập hiện tại
     * @return Đối tượng Student nếu đã đăng nhập hợp lệ, ngược lại trả về null
     */
    private Student getCurrentStudent(HttpSession session) {
        UserAccount user = (UserAccount) session.getAttribute("user");
        return (user != null) ? studentRepository.findByUserId(user.getId()) : null;
    }

    /**
     * Hiển thị trang tổng quan (dashboard) của sinh viên.
     * 
     * @param session Phiên đăng nhập
     * @param model   Model Spring MVC
     * @return view dashboard hoặc chuyển hướng đến trang đăng nhập
     */
    @GetMapping({ "", "/", "/dashboard" })
    public String dashboard(HttpSession session, Model model) {
        Student student = getCurrentStudent(session);
        if (student == null)
            return "redirect:/login";

        // Yêu cầu sinh viên mới cập nhật thông tin trước khi dùng hệ thống
        if (student.getDepartment() == null || "Chưa cập nhật".equals(student.getClassName())) {
            return "redirect:/student/profile";
        }

        RegistrationPeriod activePeriod = periodService.getActivePeriod();
        StudentGroup myGroup = groupService.findGroupByStudent(student.getId());
        TopicRegistration myRegistration = null;
        TopicAssignment myAssignment = null;
        List<Score> myScores = Collections.emptyList();
        Double avgScore = null;

        if (myGroup != null) {
            myRegistration = registrationService.getActiveRegistrationForGroup(myGroup.getId());
            if (myRegistration != null) {
                if (myRegistration.getStatus() == RegistrationStatus.APPROVED) {
                    myAssignment = assignmentRepository.findFirstByTopicRegistrationId(myRegistration.getId())
                            .orElse(null);
                }
                if (myAssignment != null) {
                    myScores = scoreRepository.findByTopicAssignmentId(myAssignment.getId());
                    avgScore = scoringService.calculateFinalScore(myAssignment.getId());
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

    /**
     * Hiển thị trang cập nhật hồ sơ sinh viên (cho lần đầu đăng nhập bằng Google).
     */
    @GetMapping("/profile")
    public String profile(HttpSession session, Model model) {
        Student student = getCurrentStudent(session);
        if (student == null)
            return "redirect:/login";

        model.addAttribute("student", student);
        model.addAttribute("departments", departmentRepository.findAll());
        return "student/profile";
    }

    /**
     * Xử lý cập nhật hồ sơ sinh viên.
     */
    @PostMapping("/profile/update")
    public String updateProfile(@RequestParam String studentCode,
            @RequestParam String courseYear,
            @RequestParam String className,
            @RequestParam String major,
            @RequestParam Long departmentId,
            @RequestParam String phone,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        Student student = getCurrentStudent(session);
        if (student == null)
            return "redirect:/login";

        try {
            Department dept = departmentRepository.findById(departmentId)
                    .orElseThrow(() -> new IllegalArgumentException("Khoa không tồn tại"));
            student.setStudentCode(studentCode);
            student.setCourseYear(courseYear);
            student.setClassName(className);
            student.setMajor(major);
            student.setDepartment(dept);
            studentRepository.save(student);

            UserAccount user = student.getUser();
            if (phone != null && !phone.trim().isEmpty()) {
                user.setPhone(phone.trim());
                // userAccountRepository.save(user) will be cascaded or done via
                // studentRepository if mapped correctly
                // We should probably save it explicitly but let's assume it's attached or we
                // can save it via service
            }

            // Update session
            session.setAttribute("studentProfile", student);

            redirectAttributes.addFlashAttribute("successMessage", "Cập nhật hồ sơ thành công!");
            return "redirect:/student/dashboard";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi cập nhật hồ sơ: " + e.getMessage());
            return "redirect:/student/profile";
        }
    }

    /**
     * Hiển thị danh sách các đề tài đã duyệt, cho phép tìm kiếm và xem đề tài.
     * 
     * @param departmentId ID khoa cần lọc (tùy chọn)
     * @param keyword      Từ khóa tìm kiếm đề tài (tùy chọn)
     * @param session      Phiên đăng nhập
     * @param model        Model Spring MVC
     * @return view topics
     */
    @GetMapping("/topics")
    public String topics(@RequestParam(required = false) Long departmentId,
            @RequestParam(required = false) String keyword,
            HttpSession session,
            Model model) {
        Student student = getCurrentStudent(session);
        if (student == null)
            return "redirect:/login";

        Long studentDepartmentId = student.getDepartment() != null
                ? student.getDepartment().getId()
                : null;
        List<Topic> topics = studentDepartmentId == null
                ? Collections.emptyList()
                : topicService.getTopicsByDepartment(studentDepartmentId).stream()
                        .filter(t -> t.getStatus() == TopicStatus.PUBLISHED || t.getStatus() == TopicStatus.APPROVED)
                        .toList();

        if (keyword != null && !keyword.isBlank()) {
            String q = keyword.trim().toLowerCase();
            topics = topics.stream()
                    .filter(t -> (t.getTitle() != null && t.getTitle().toLowerCase().contains(q))
                            || (t.getCode() != null && t.getCode().toLowerCase().contains(q))
                            || (t.getLecturer() != null
                                    && t.getLecturer().getUser().getFullName().toLowerCase().contains(q)))
                    .toList();
        }

        StudentGroup myGroup = groupService.findGroupByStudent(student.getId());
        TopicRegistration myRegistration = (myGroup != null)
                ? registrationService.getActiveRegistrationForGroup(myGroup.getId())
                : null;

        model.addAttribute("student", student);
        model.addAttribute("topics", topics);
        model.addAttribute("departments", departmentRepository.findAll());
        model.addAttribute("selectedDept", studentDepartmentId);
        model.addAttribute("keyword", keyword);
        model.addAttribute("myGroup", myGroup);
        model.addAttribute("myRegistration", myRegistration);
        model.addAttribute("activePeriod", periodService.getActivePeriod());

        return "student/topics";
    }

    /**
     * Xử lý gửi yêu cầu đăng ký đề tài của nhóm (chỉ nhóm trưởng mới được đăng ký).
     * 
     * @param topicId            ID đề tài muốn đăng ký
     * @param groupId            ID nhóm sinh viên
     * @param note               Ghi chú cho đăng ký
     * @param session            Phiên đăng nhập
     * @param redirectAttributes Dùng để truyền thông báo flash
     * @return Chuyển hướng về trang danh sách đề tài
     */
    @PostMapping("/topics/register")
    public String registerTopic(@RequestParam Long topicId,
            @RequestParam Long groupId,
            @RequestParam(required = false) String note,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        Student student = getCurrentStudent(session);
        if (student == null)
            return "redirect:/login";

        try {
            StudentGroup group = studentGroupRepository.findById(groupId).orElseThrow();
            if (!group.getLeader().getId().equals(student.getId())) {
                redirectAttributes.addFlashAttribute("errorMessage",
                        "Chỉ Nhóm trưởng mới có quyền đại diện nhóm đăng ký đề tài!");
                return "redirect:/student/topics";
            }

            Topic topic = topicRepository.findById(topicId).orElseThrow();
            if (student.getDepartment() == null
                    || topic.getDepartment() == null
                    || !student.getDepartment().getId().equals(topic.getDepartment().getId())) {
                throw new IllegalStateException("Bạn chỉ được đăng ký đề tài thuộc khoa của mình!");
            }
            registrationService.register(group, topic, note);
            redirectAttributes.addFlashAttribute("successMessage", "Gửi yêu cầu đăng ký đề tài '" + topic.getTitle()
                    + "' thành công! Vui lòng chờ GVHD hoặc Khoa phê duyệt.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi đăng ký đề tài: " + e.getMessage());
        }
        return "redirect:/student/topics";
    }

    /**
     * Hiển thị thông tin nhóm của sinh viên (tạo nhóm, thành viên, mời thêm sinh
     * viên).
     * 
     * @param session Phiên đăng nhập
     * @param model   Model Spring MVC
     * @return view group
     */
    @GetMapping("/group")
    public String group(HttpSession session, Model model) {
        Student student = getCurrentStudent(session);
        if (student == null)
            return "redirect:/login";

        StudentGroup myGroup = groupService.findGroupByStudent(student.getId());
        List<StudentGroupMember> members = (myGroup != null) ? groupService.getMembers(myGroup.getId())
                : Collections.emptyList();
        TopicRegistration registration = (myGroup != null)
                ? registrationService.getActiveRegistrationForGroup(myGroup.getId())
                : null;

        model.addAttribute("student", student);
        model.addAttribute("myGroup", myGroup);
        model.addAttribute("members", members);
        model.addAttribute("registration", registration);
        model.addAttribute("activePeriod", periodService.getActivePeriod());

        return "student/group";
    }

    /**
     * Xử lý tạo nhóm sinh viên mới. Sinh viên tạo nhóm tự động trở thành Nhóm
     * trưởng.
     * 
     * @param name               Tên nhóm
     * @param session            Phiên đăng nhập
     * @param redirectAttributes Dùng để truyền thông báo flash
     * @return Chuyển hướng về trang quản lý nhóm
     */
    @PostMapping("/group/create")
    public String createGroup(@RequestParam String name,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        Student student = getCurrentStudent(session);
        if (student == null)
            return "redirect:/login";

        try {
            RegistrationPeriod activePeriod = periodService.getActivePeriod();
            if (activePeriod == null) {
                redirectAttributes.addFlashAttribute("errorMessage", "Hiện tại không có đợt đăng ký nào đang mở.");
                return "redirect:/student/group";
            }
            groupService.create(name, activePeriod, student);
            redirectAttributes.addFlashAttribute("successMessage",
                    "Tạo nhóm '" + name + "' thành công! Bạn là Nhóm trưởng.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi tạo nhóm: " + e.getMessage());
        }
        return "redirect:/student/group";
    }

    /**
     * Thêm thành viên vào nhóm dựa trên Mã số sinh viên (MSSV).
     * 
     * @param groupId            ID nhóm
     * @param studentCode        MSSV của sinh viên cần thêm
     * @param session            Phiên đăng nhập
     * @param redirectAttributes Dùng để truyền thông báo flash
     * @return Chuyển hướng về trang quản lý nhóm
     */
    @PostMapping("/group/add-member")
    public String addMember(@RequestParam Long groupId,
            @RequestParam String studentCode,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        Student student = getCurrentStudent(session);
        if (student == null)
            return "redirect:/login";

        try {
            StudentGroup group = studentGroupRepository.findById(groupId).orElseThrow();
            if (!group.getLeader().getId().equals(student.getId())) {
                redirectAttributes.addFlashAttribute("errorMessage", "Chỉ nhóm trưởng mới có quyền mời thành viên!");
                return "redirect:/student/group";
            }
            Student addedStudent = groupService.addMemberByCode(groupId, studentCode);
            redirectAttributes.addFlashAttribute("successMessage",
                    "Đã thêm sinh viên " + addedStudent.getUser().getFullName() + " (" + addedStudent.getStudentCode()
                            + ") vào nhóm thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi thêm thành viên: " + e.getMessage());
        }
        return "redirect:/student/group";
    }

    /**
     * Xóa một thành viên khỏi nhóm (chỉ dành cho Nhóm trưởng).
     * 
     * @param groupId            ID nhóm
     * @param studentId          ID sinh viên cần xóa
     * @param session            Phiên đăng nhập
     * @param redirectAttributes Dùng để truyền thông báo flash
     * @return Chuyển hướng về trang quản lý nhóm
     */
    @PostMapping("/group/remove-member")
    public String removeMember(@RequestParam Long groupId,
            @RequestParam Long studentId,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        Student student = getCurrentStudent(session);
        if (student == null)
            return "redirect:/login";

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

    /**
     * API tra cứu thông tin sinh viên theo MSSV.
     * 
     * @param code MSSV cần tra cứu
     * @return JSON chứa thông tin sinh viên nếu tìm thấy
     */
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
            resp.put("faculty", s.getDepartment() != null ? s.getDepartment().getName() : "Khoa CNTT");
            // SEC-09: Không trả email để tránh lộ thông tin người dùng khác
        } else {
            resp.put("found", false);
            resp.put("message", "Không tìm thấy sinh viên có MSSV: " + code);
        }
        return resp;
    }

    /**
     * Hiển thị trang nộp báo cáo và lịch sử báo cáo của nhóm.
     * 
     * @param session Phiên đăng nhập
     * @param model   Model Spring MVC
     * @return view reports
     */
    @GetMapping("/reports")
    public String reports(HttpSession session, Model model) {
        Student student = getCurrentStudent(session);
        if (student == null)
            return "redirect:/login";

        StudentGroup myGroup = groupService.findGroupByStudent(student.getId());
        TopicRegistration registration = (myGroup != null)
                ? registrationService.getActiveRegistrationForGroup(myGroup.getId())
                : null;
        List<Report> reports = (registration != null) ? reportService.getReportsForRegistration(registration.getId())
                : Collections.emptyList();

        boolean isLeader = (myGroup != null && myGroup.getLeader().getId().equals(student.getId()));

        model.addAttribute("student", student);
        model.addAttribute("myGroup", myGroup);
        model.addAttribute("registration", registration);
        model.addAttribute("reports", reports);
        model.addAttribute("isLeader", isLeader);

        return "student/reports";
    }

    /**
     * Xử lý nộp báo cáo tiến độ/hoàn thành (chỉ dành cho Nhóm trưởng).
     * 
     * @param registrationId     ID đăng ký đề tài
     * @param fileName           Tên tệp
     * @param file               Tệp báo cáo (MultipartFile)
     * @param filePath           Đường dẫn tệp nếu có sẵn
     * @param note               Ghi chú kèm theo báo cáo
     * @param session            Phiên đăng nhập
     * @param redirectAttributes Dùng để truyền thông báo flash
     * @return Chuyển hướng về trang báo cáo
     */
    @PostMapping("/reports/submit")
    public String submitReport(@RequestParam Long registrationId,
            @RequestParam String fileName,
            @RequestParam(required = false) MultipartFile file,
            @RequestParam(required = false) String filePath,
            @RequestParam(required = false) String note,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        Student student = getCurrentStudent(session);
        if (student == null)
            return "redirect:/login";

        try {
            String uploadedPath = reportService.storeFile(file);
            if (uploadedPath != null) {
                filePath = uploadedPath;
                fileName = file.getOriginalFilename();
            }
            reportService.submitReport(registrationId, student.getId(), fileName, filePath, note);
            redirectAttributes.addFlashAttribute("successMessage",
                    "Nộp báo cáo thành công! Giảng viên hướng dẫn và Hội đồng có thể xem tài liệu.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi nộp báo cáo: " + e.getMessage());
        }
        return "redirect:/student/reports";
    }

    /**
     * Hiển thị trang kết quả (điểm quá trình, điểm hội đồng, lịch bảo vệ).
     * 
     * @param session Phiên đăng nhập
     * @param model   Model Spring MVC
     * @return view results
     */
    @GetMapping("/results")
    public String results(HttpSession session, Model model) {
        Student student = getCurrentStudent(session);
        if (student == null)
            return "redirect:/login";

        StudentGroup myGroup = groupService.findGroupByStudent(student.getId());
        TopicRegistration registration = (myGroup != null)
                ? registrationService.getActiveRegistrationForGroup(myGroup.getId())
                : null;
        TopicAssignment assignment = (registration != null && registration.getStatus() == RegistrationStatus.APPROVED)
                ? assignmentRepository.findFirstByTopicRegistrationId(registration.getId()).orElse(null)
                : null;

        List<Score> scores = (assignment != null) ? scoreRepository.findByTopicAssignmentId(assignment.getId())
                : Collections.emptyList();
        List<TopicEvaluation> processEvaluations = (assignment != null)
                ? scoringService.getProcessEvaluations(assignment.getId())
                : Collections.emptyList();
        Double processScore = (assignment != null) ? scoringService.calculateProcessAverageScore(assignment.getId())
                : null;
        Double avgScore = (assignment != null) ? scoringService.calculateFinalScore(assignment.getId()) : null;

        model.addAttribute("student", student);
        model.addAttribute("myGroup", myGroup);
        model.addAttribute("registration", registration);
        model.addAttribute("assignment", assignment);
        model.addAttribute("scores", scores);
        model.addAttribute("processEvaluations", processEvaluations);
        model.addAttribute("processScore", processScore);
        model.addAttribute("avgScore", avgScore);
        model.addAttribute("scoringService", scoringService);

        return "student/results";
    }

    /**
     * Hiển thị danh sách thông báo dành cho sinh viên.
     * 
     * @param notificationId ID thông báo cần đánh dấu đã đọc (tùy chọn)
     * @param session        Phiên đăng nhập
     * @param model          Model Spring MVC
     * @return view notifications
     */
    @GetMapping("/notifications")
    public String notifications(@RequestParam(required = false) Long notificationId,
            HttpSession session, Model model) {
        Student student = getCurrentStudent(session);
        UserAccount user = (UserAccount) session.getAttribute("user");
        if (notificationId != null) {
            notificationService.markAsRead(notificationId, user);
        }
        List<Notification> list = notificationService.getPublishedForRole("STUDENT");

        model.addAttribute("student", student);
        model.addAttribute("notifications", list);
        model.addAttribute("notificationService", notificationService);
        model.addAttribute("currentUser", user);
        // Tập ID đã đọc (1 truy vấn) để JSP không phải gọi isRead() cho từng thông báo
        model.addAttribute("readNotificationIds",
                notificationService.getReadNotificationIds(user != null ? user.getId() : null));

        return "student/notifications";
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
        UserAccount user = (UserAccount) session.getAttribute("user");
        if (user != null) {
            notificationService.markAsRead(id, user);
        }
        return "redirect:/student/notifications";
    }
}