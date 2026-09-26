package ute.edu.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import ute.edu.entity.Topic;
import ute.edu.enums.TopicStatus;
import ute.edu.service.TopicService;
import ute.edu.service.RegistrationPeriodService;
import ute.edu.service.NotificationService;
import ute.edu.repository.DepartmentRepository;
import ute.edu.repository.StudentGroupRepository;
import ute.edu.repository.LectureRepository;
import ute.edu.repository.StudentRepository;
import java.util.List;

@Controller
/** Controller hiển thị trang chủ và danh sách đề tài công khai. */
public class HomeController {
    private final TopicService topicService;
    private final RegistrationPeriodService periodService;
    private final NotificationService notificationService;
    private final DepartmentRepository departmentRepository;
    private final StudentGroupRepository groupRepository;
    private final LectureRepository lectureRepository;
    private final StudentRepository studentRepository;

    public HomeController(TopicService topicService,
                          RegistrationPeriodService periodService,
                          NotificationService notificationService,
                          DepartmentRepository departmentRepository,
                          StudentGroupRepository groupRepository,
                          LectureRepository lectureRepository,
                          StudentRepository studentRepository) {
        this.topicService = topicService;
        this.periodService = periodService;
        this.notificationService = notificationService;
        this.departmentRepository = departmentRepository;
        this.groupRepository = groupRepository;
        this.lectureRepository = lectureRepository;
        this.studentRepository = studentRepository;
    }

    /**
     * Hiển thị trang chủ và danh sách đề tài.
     * Hỗ trợ chức năng lọc danh sách đề tài theo ID Khoa và tìm kiếm theo từ khóa.
     * Chỉ hiển thị các đề tài đã được công bố (PUBLISHED) hoặc đã duyệt (APPROVED).
     * 
     * @param departmentId ID của Khoa (tùy chọn) dùng để lọc
     * @param keyword Từ khóa (tùy chọn) tìm kiếm theo tên, mã đề tài hoặc tên giảng viên
     * @param model Đối tượng Model dùng để truyền dữ liệu xuống View (JSP)
     * @return Tên view hiển thị (index)
     */
    @GetMapping({"/", "/home", "/index"})
    /** Lọc và hiển thị đề tài theo khoa hoặc từ khóa. */
    public String home(@RequestParam(required = false) Long departmentId,
                       @RequestParam(required = false) String keyword,
                       Model model) {
        List<Topic> topics;
        
        // Lọc theo Khoa nếu có
        if (departmentId != null && departmentId > 0) {
            topics = topicService.getTopicsByDepartment(departmentId).stream()
                    .filter(t -> t.getStatus() == TopicStatus.PUBLISHED || t.getStatus() == TopicStatus.APPROVED)
                    .toList();
        } else {
            // Mặc định lấy tất cả đề tài đã công bố
            topics = topicService.getTopicsByStatus(TopicStatus.PUBLISHED);
        }

        // Lọc theo từ khóa tìm kiếm (tên, mã, giảng viên)
        if (keyword != null && !keyword.isBlank()) {
            String q = keyword.trim().toLowerCase();
            topics = topics.stream()
                    .filter(t -> (t.getTitle() != null && t.getTitle().toLowerCase().contains(q))
                              || (t.getCode() != null && t.getCode().toLowerCase().contains(q))
                              || (t.getLecturer() != null && t.getLecturer().getUser().getFullName().toLowerCase().contains(q)))
                    .toList();
        }

        model.addAttribute("topics", topics);
        model.addAttribute("departments", departmentRepository.findAll());
        model.addAttribute("periods", periodService.getAll());
        model.addAttribute("activePeriod", periodService.getActivePeriod());
        model.addAttribute("notifications", notificationService.getPublishedForRole("ALL"));
        model.addAttribute("selectedDept", departmentId);
        model.addAttribute("keyword", keyword);

        // Stats
        model.addAttribute("totalTopics", topicService.getAllTopics().size());
        model.addAttribute("totalLecturers", lectureRepository.count());
        model.addAttribute("totalStudents", studentRepository.count());
        model.addAttribute("totalGroups", groupRepository.count());

        return "index";
    }
}
