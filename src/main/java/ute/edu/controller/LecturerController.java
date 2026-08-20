package ute.edu.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.ui.Model;
import ute.edu.service.TopicService;

@Controller
@RequestMapping("/lecturer")
public class LecturerController {
    private final TopicService topicService;

    public LecturerController(TopicService topicService) {
        this.topicService = topicService;
    }

    @GetMapping({"", "/", "/dashboard"})
    public String dashboard(Model model) {
        model.addAttribute("topics", topicService.getAllTopics());
        return "lecturer/dashboard";
    }

    @GetMapping("/topics")
    public String topics(Model model) {
        model.addAttribute("topics", topicService.getAllTopics());
        return "lecturer/topics";
    }

    @GetMapping("/reviews")
    public String reviews() {
        return "lecturer/reviews";
    }
}