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

    @GetMapping({"/", "/home", "/index"})
    public String home(@RequestParam(required = false) Long departmentId,
                       @RequestParam(required = false) String keyword,
                       Model model) {
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
