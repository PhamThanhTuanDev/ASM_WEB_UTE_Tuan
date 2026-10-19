package ute.edu.controller;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.oauth2.core.user.DefaultOAuth2User;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import ute.edu.config.OAuth2LoginSuccessHandler;
import ute.edu.entity.*;
import ute.edu.enums.*;
import ute.edu.repository.*;
import ute.edu.service.*;
import java.util.*;

@Controller
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
    private final StudentProfileService profileService;
    private final AuthService authService;
    private final OAuth2LoginSuccessHandler googleLoginHandler;

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
            ScoreRepository scoreRepository, StudentProfileService profileService,
            AuthService authService, OAuth2LoginSuccessHandler googleLoginHandler) {
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
        this.profileService = profileService;
        this.authService = authService;
        this.googleLoginHandler = googleLoginHandler;
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
    @GetMapping({ "/student", "/student/", "/student/dashboard" })
    public String dashboard(HttpSession session, Model model) {
        Student student = getCurrentStudent(session);
        if (student == null)
            return "redirect:/login";

        // Yêu cầu sinh viên mới cập nhật thông tin trước khi dùng hệ thống
        if (student.getDepartment() == null || "Chưa cập nhật".equals(student.getClassName())) {
            return "redirect:/student/profile";
        }

        StudentGroup myGroup = groupService.findGroupByStudent(student.getId());
        RegistrationPeriod activePeriod = myGroup != null
                ? myGroup.getRegistrationPeriod()
                : periodService.getActivePeriod();
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
                if (myAssignment != null && myAssignment.getCouncil().getStatus() == CouncilStatus.COMPLETED) {
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
        List<Report> submittedReports = myRegistration != null
                ? reportService.getReportsForRegistration(myRegistration.getId())
                : Collections.emptyList();
        int currentStep = progressStep(myRegistration, myAssignment, submittedReports);
        if (currentStep == 2 && myGroup == null && activePeriod != null && activePeriod.getLecturerEndDate() != null
                && !RegistrationPeriodService.today().isAfter(activePeriod.getLecturerEndDate()))
            currentStep = 1;
        model.addAttribute("currentStep", currentStep);
        model.addAttribute("workflowCompleted", currentStep == 5);
        model.addAttribute("notifications", notificationService.getPublishedForRole("STUDENT"));

        return "student/dashboard";
    }

    /**
     * Hiển thị trang cập nhật hồ sơ sinh viên (cho lần đầu đăng nhập bằng Google).
     */
    @PreAuthorize("permitAll()")
    @GetMapping({ "/student/profile", "/google/complete-profile" })
    public String profile(HttpSession session, Model model) {
        if (session.getAttribute("googleRegistrationEmail") != null) {
            String email = (String) session.getAttribute("googleRegistrationEmail");
            Student student = new Student();
            UserAccount user = new UserAccount();
            user.setEmail(email);
            user.setFullName((String) session.getAttribute("googleRegistrationName"));
            student.setUser(user);
            student.setStudentCode(email.substring(0, email.indexOf('@')));
            student.setCourseYear("");
            model.addAttribute("student", student);
            model.addAttribute("googleRegistration", true);
            model.addAttribute("departments",
                    departmentRepository.findAll().stream().filter(d -> d.isActive()).toList());
            return "student/profile";
        }
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
    @PreAuthorize("permitAll()")
    @PostMapping({ "/student/profile/update", "/google/complete-profile" })
    public String updateProfile(@RequestParam(required = false) String studentCode,
            @RequestParam(required = false) String registrationToken,
            @RequestParam(required = false) String fullName,
            @RequestParam String courseYear,
            @RequestParam String className,
            @RequestParam String major,
            @RequestParam Long departmentId,
            @RequestParam String phone,
            HttpSession session,
            RedirectAttributes redirectAttributes, HttpServletRequest request,
            HttpServletResponse response, Model model) throws Exception {
        if (session.getAttribute("googleRegistrationEmail") != null) {
            return registerGoogleProfile(registrationToken, fullName, phone, courseYear, className,
                    major, departmentId, request, response, session, model);
        }
        Student student = getCurrentStudent(session);
        if (student == null)
            return "redirect:/login";
        if (student.getUser().getRole() != UserRole.STUDENT && student.getUser().getRole() != UserRole.ADMIN) {
            response.sendError(403);
            return null;
        }
        try {
            student = profileService.update(student.getUser().getId(), studentCode, courseYear, className, major,
                    departmentId, phone);

            // Update session
            session.setAttribute("studentProfile", student);

            redirectAttributes.addFlashAttribute("successMessage", "Cập nhật hồ sơ thành công!");
            return "redirect:/student/dashboard";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi cập nhật hồ sơ: " + ute.edu.helper.UserMessages.forException(e));
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
    @GetMapping("/student/topics")
    public String topics(@RequestParam(required = false) Long departmentId,
            @RequestParam(required = false) Long periodId,
            @RequestParam(required = false) String keyword,
            HttpSession session,
            Model model) {
        Student student = getCurrentStudent(session);
        if (student == null)
            return "redirect:/login";

        Long studentDepartmentId = student.getDepartment() != null
                ? student.getDepartment().getId()
                : null;
        StudentGroup myGroup = groupService.findGroupByStudent(student.getId());
        List<RegistrationPeriod> openPeriods = periodService.getOpenStudentPeriods();
        RegistrationPeriod groupPeriod = myGroup != null ? myGroup.getRegistrationPeriod() : null;
        Long requestedPeriodId = groupPeriod != null ? groupPeriod.getId() : periodId;
        RegistrationPeriod selectedPeriod = groupPeriod != null ? groupPeriod : openPeriods.stream()
                .filter(p -> Objects.equals(p.getId(), requestedPeriodId)).findFirst()
                .orElse(periodId == null && !openPeriods.isEmpty() ? openPeriods.get(0) : null);
        Long selectedPeriodId = selectedPeriod != null ? selectedPeriod.getId() : null;
        List<Topic> topics = studentDepartmentId == null || !RegistrationPeriodService.isStudentWindow(selectedPeriod)
                ? Collections.emptyList()
                : topicService.getAvailableTopics().stream()
                        .filter(t -> t.getDepartment() != null && studentDepartmentId.equals(t.getDepartment().getId()))
                        .filter(t -> t.getRegistrationPeriod() != null
                                && selectedPeriodId.equals(t.getRegistrationPeriod().getId()))
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
        model.addAttribute("activePeriod", selectedPeriod);
        model.addAttribute("openPeriods", openPeriods);
        model.addAttribute("selectedPeriodId", selectedPeriodId);
        model.addAttribute("groupPeriod", groupPeriod);
        TopicAssignment topicAssignment = myRegistration != null
                && myRegistration.getStatus() == RegistrationStatus.APPROVED
                        ? assignmentRepository.findFirstByTopicRegistrationId(myRegistration.getId()).orElse(null)
                        : null;
        model.addAttribute("workflowCompleted",
                progressStep(myRegistration, topicAssignment, Collections.emptyList()) == 5);

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
    @PostMapping("/student/topics/register")
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
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi đăng ký đề tài: " + ute.edu.helper.UserMessages.forException(e));
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
    @GetMapping("/student/group")
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
        model.addAttribute("canChangeMembers", groupService.canChangeMembers(myGroup));
        model.addAttribute("registration", registration);
        model.addAttribute("activePeriod", periodService.getActivePeriod());
        model.addAttribute("openPeriods", periodService.getOpenStudentPeriods());

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
    @PostMapping("/student/group/create")
    public String createGroup(@RequestParam String name,
            @RequestParam(required = false) Long periodId,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        Student student = getCurrentStudent(session);
        if (student == null)
            return "redirect:/login";

        try {
            groupService.create(name, periodId == null ? null : periodService.findById(periodId), student);
            redirectAttributes.addFlashAttribute("successMessage",
                    "Tạo nhóm '" + name + "' thành công! Bạn là Nhóm trưởng.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi tạo nhóm: " + ute.edu.helper.UserMessages.forException(e));
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
    @PostMapping("/student/group/select-period")
    public String selectGroupPeriod(@RequestParam Long groupId, @RequestParam Long periodId,
            HttpSession session, RedirectAttributes redirectAttributes) {
        Student student = getCurrentStudent(session);
        if (student == null) return "redirect:/login";
        try {
            groupService.selectPeriod(groupId, periodService.findById(periodId), student.getId());
            redirectAttributes.addFlashAttribute("successMessage", "Đã chọn đợt đăng ký cho nhóm.");
        } catch (IllegalArgumentException | IllegalStateException ex) {
            redirectAttributes.addFlashAttribute("errorMessage", ute.edu.helper.UserMessages.forException(ex));
        }
        return "redirect:/student/group";
    }

    @PostMapping("/student/group/add-member")
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
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi thêm thành viên: " + ute.edu.helper.UserMessages.forException(e));
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
    @PostMapping("/student/group/remove-member")
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
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi: " + ute.edu.helper.UserMessages.forException(e));
        }
        return "redirect:/student/group";
    }

    /**
     * API tra cứu thông tin sinh viên theo MSSV.
     * 
     * @param code MSSV cần tra cứu
     * @return JSON chứa thông tin sinh viên nếu tìm thấy
     */
    @GetMapping(value = "/student/api/students/lookup", produces = "application/json")
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
    @GetMapping("/student/reports")
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
    @PostMapping("/student/reports/submit")
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
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi nộp báo cáo: " + ute.edu.helper.UserMessages.forException(e));
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
    @GetMapping("/student/results")
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

        boolean published = assignment != null && assignment.getCouncil() != null && assignment.getCouncil().getStatus() == CouncilStatus.COMPLETED;
        List<Score> scores = (published && assignment != null) ? scoreRepository.findByTopicAssignmentId(assignment.getId())
                : Collections.emptyList();
        List<TopicEvaluation> processEvaluations = (assignment != null)
                ? scoringService.getProcessEvaluations(assignment.getId())
                : Collections.emptyList();
        Double processScore = (assignment != null) ? scoringService.calculateProcessAverageScore(assignment.getId())
                : null;
        Double avgScore = (published && assignment != null) ? scoringService.calculateFinalScore(assignment.getId()) : null;

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
    @GetMapping("/student/notifications")
    public String notifications(@RequestParam(required = false) Long notificationId,
            HttpSession session, Model model) {
        Student student = getCurrentStudent(session);
        UserAccount user = (UserAccount) session.getAttribute("user");
        if (notificationId != null) {
            notificationService.markAsRead(notificationId, user);
            GlobalModelAdvice.refreshNotificationModel(notificationService, user, model);
        }
        List<Notification> list = notificationService.getPublishedForRole("STUDENT");

        model.addAttribute("student", student);
        model.addAttribute("notifications", list);
        model.addAttribute("notificationService", notificationService);
        model.addAttribute("currentUser", user);

        return "student/notifications";
    }

    /**
     * Đánh dấu một thông báo là đã đọc.
     * 
     * @param id      ID thông báo
     * @param session Phiên đăng nhập
     * @return Chuyển hướng về trang danh sách thông báo
     */
    @PostMapping("/student/notifications/{id}/read")
    public String markNotificationRead(@PathVariable Long id, HttpSession session) {
        UserAccount user = (UserAccount) session.getAttribute("user");
        if (user != null) {
            notificationService.markAsRead(id, user);
        }
        return "redirect:/student/notifications";
    }

    private String registerGoogleProfile(@RequestParam String registrationToken, @RequestParam String fullName,
            @RequestParam String phone, @RequestParam String courseYear, @RequestParam String className,
            @RequestParam String major, @RequestParam Long departmentId,
            HttpServletRequest request, HttpServletResponse response, HttpSession session, Model model)
            throws Exception {
        String email = (String) session.getAttribute("googleRegistrationEmail");
        if (email == null)
            return "redirect:/login";
        if (registrationToken == null || !registrationToken.equals(session.getAttribute("googleRegistrationToken"))) {
            response.sendError(403);
            return null;
        }
        try {
            authService.registerGoogleStudent(email, fullName, phone, courseYear, className, major, departmentId);
        } catch (IllegalArgumentException | DataIntegrityViolationException ex) {
            model.addAttribute("errorMessage", ex instanceof IllegalArgumentException ? ute.edu.helper.UserMessages.forException(ex)
                    : "Email hoặc MSSV đã tồn tại. Vui lòng đăng nhập lại.");
            String view = profile(session, model);
            Student draft = (Student) model.getAttribute("student");
            draft.getUser().setFullName(fullName);
            draft.getUser().setPhone(phone);
            draft.setCourseYear(courseYear);
            draft.setClassName(className);
            draft.setMajor(major);
            return view;
        }
        session.removeAttribute("googleRegistrationEmail");
        session.removeAttribute("googleRegistrationName");
        session.removeAttribute("googleRegistrationToken");
        var authority = new SimpleGrantedAuthority("ROLE_STUDENT");
        var principal = new DefaultOAuth2User(List.of(authority), Map.of("email", email, "email_verified", true),
                "email");
        googleLoginHandler.onAuthenticationSuccess(request, response,
                new UsernamePasswordAuthenticationToken(principal, null, List.of(authority)));
        return null;
    }

    static int progressStep(TopicRegistration registration, TopicAssignment assignment, List<Report> reports) {
        if (registration == null || registration.getStatus() != RegistrationStatus.APPROVED)
            return 2;
        if ((registration.getTopic() != null && registration.getTopic().getStatus() == TopicStatus.COMPLETED)
                || (assignment != null && assignment.getCouncil() != null
                        && assignment.getCouncil().getStatus() == CouncilStatus.COMPLETED))
            return 5;
        if (reports != null && !reports.isEmpty() && reports.get(0).getReviewStatus() != ReportReviewStatus.REJECTED)
            return 4;
        return 3;
    }

}
