package ute.edu.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.ui.Model;
import ute.edu.enums.TopicStatus;
import ute.edu.service.TopicService;

@Controller
@RequestMapping("/student")
public class StudentController {
    private final TopicService topicService;

    public StudentController(TopicService topicService) {
        this.topicService = topicService;
    }

    @GetMapping({"", "/", "/dashboard"})
    public String dashboard(Model model) {
        model.addAttribute("topics", topicService.getTopicsByStatus(TopicStatus.PUBLISHED));
        return "student/dashboard";
    }

    @GetMapping("/topics")
    public String topics(Model model) {
        model.addAttribute("topics", topicService.getTopicsByStatus(TopicStatus.PUBLISHED));
        return "student/topics";
    }

    @GetMapping("/group")
    public String group() {
        return "student/group";
    }
}