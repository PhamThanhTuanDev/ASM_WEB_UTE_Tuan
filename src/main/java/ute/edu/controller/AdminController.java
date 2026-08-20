package ute.edu.controller;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import ute.edu.enums.RegistrationType;
import ute.edu.enums.TopicStatus;
import ute.edu.model.RegistrationPeriod;
import ute.edu.model.Topic;
import ute.edu.repository.DepartmentRepository;
import ute.edu.service.RegistrationPeriodService;
import ute.edu.service.TopicService;

@Controller
@RequestMapping("/admin")
public class AdminController {
    private final TopicService topicService;
    private final RegistrationPeriodService periodService;
    private final DepartmentRepository departmentRepository;

    public AdminController(TopicService topicService, RegistrationPeriodService periodService,
                           DepartmentRepository departmentRepository) {
        this.topicService = topicService;
        this.periodService = periodService;
        this.departmentRepository = departmentRepository;
    }

    @GetMapping({"", "/", "/dashboard"})
    public String dashboard(Model model) {
        model.addAttribute("topics", topicService.getAllTopics());
        model.addAttribute("periods", periodService.getAll());
        return "admin/dashboard";
    }

    @GetMapping("/periods")
    public String registrationPeriods(Model model) {
        model.addAttribute("periods", periodService.getAll());
        model.addAttribute("period", new RegistrationPeriod());
        model.addAttribute("registrationTypes", RegistrationType.values());
        return "admin/periods";
    }

    @PostMapping("/periods/save")
    public String savePeriod(@ModelAttribute RegistrationPeriod period) {
        periodService.save(period);
        return "redirect:/admin/periods";
    }

    @GetMapping("/topics")
    public String topics(Model model) {
        model.addAttribute("topics", topicService.getAllTopics());
        model.addAttribute("topic", new Topic());
        model.addAttribute("departments", departmentRepository.findAll());
        model.addAttribute("statuses", TopicStatus.values());
        return "admin/topics";
    }

    @PostMapping("/topics/save")
    public String saveTopic(@ModelAttribute Topic topic) {
        topicService.save(topic);
        return "redirect:/admin/topics";
    }

    @PostMapping("/topics/{id}/status")
    public String updateTopicStatus(@PathVariable Long id, TopicStatus status) {
        Topic topic = topicService.findById(id);
        if (topic != null) {
            topic.setStatus(status);
            topicService.save(topic);
        }
        return "redirect:/admin/topics";
    }

    @PostMapping("/topics/{id}/delete")
    public String deleteTopic(@PathVariable Long id) {
        topicService.delete(id);
        return "redirect:/admin/topics";
    }

    @GetMapping("/reports")
    public String reports(Model model) {
        model.addAttribute("topics", topicService.getAllTopics());
        return "admin/reports";
    }
}
