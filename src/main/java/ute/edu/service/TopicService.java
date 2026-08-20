package ute.edu.service;

import java.util.List;
import org.springframework.stereotype.Service;
import ute.edu.enums.TopicStatus;
import ute.edu.model.Topic;
import ute.edu.repository.TopicRepository;

@Service
public class TopicService {
    private final TopicRepository topicRepository;

    public TopicService(TopicRepository topicRepository) {
        this.topicRepository = topicRepository;
    }

    public List<Topic> getAllTopics() {
        return topicRepository.findAll();
    }

    public List<Topic> getTopicsByStatus(TopicStatus status) {
        return topicRepository.findByStatus(status);
    }

    public Topic save(Topic topic) {
        return topicRepository.save(topic);
    }

    public Topic findById(Long id) {
        return topicRepository.findById(id).orElse(null);
    }

    public void delete(Long id) {
        topicRepository.deleteById(id);
    }
}
