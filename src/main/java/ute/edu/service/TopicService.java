package ute.edu.service;

import java.util.List;
import java.time.LocalDateTime;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ute.edu.enums.TopicStatus;
import ute.edu.enums.SupervisorRole;
import ute.edu.entity.Topic;
import ute.edu.entity.Lecture;
import ute.edu.entity.TopicSupervisor;
import ute.edu.repository.TopicRepository;
import ute.edu.repository.TopicSupervisorRepository;

@Service
/** Service quản lý tạo, tìm kiếm và duyệt đề tài. */
public class TopicService {
    private final TopicRepository topicRepository;
    private final TopicSupervisorRepository supervisorRepository;

    public TopicService(TopicRepository topicRepository,
                        TopicSupervisorRepository supervisorRepository) {
        this.topicRepository = topicRepository;
        this.supervisorRepository = supervisorRepository;
    }

    /** Lấy toàn bộ đề tài. */
    public List<Topic> getAllTopics() {
        return topicRepository.findAll();
    }

    /** Lấy đề tài theo trạng thái. */
    public List<Topic> getTopicsByStatus(TopicStatus status) {
        return topicRepository.findByStatus(status);
    }

    /** Lấy đề tài theo khoa. */
    public List<Topic> getTopicsByDepartment(Long departmentId) {
        return topicRepository.findByDepartmentId(departmentId);
    }

    /** Lấy đề tài theo đợt đăng ký. */
    public List<Topic> getTopicsByPeriod(Long periodId) {
        return topicRepository.findByRegistrationPeriodId(periodId);
    }

    /** Lấy đề tài do giảng viên phụ trách. */
    public List<Topic> getTopicsByLecturer(Long lecturerId) {
        return topicRepository.findByLecturerIdOrCoLecturerId(lecturerId, lecturerId);
    }

    /** Tìm một đề tài theo mã định danh. */
    public Topic findById(Long id) {
        return topicRepository.findById(id).orElse(null);
    }

    @Transactional
    /** Lưu đề tài mới hoặc cập nhật đề tài hiện có. */
    public Topic save(Topic topic) {
        if (topic.getCreatedAt() == null) {
            topic.setCreatedAt(LocalDateTime.now());
        }
        topic.setUpdatedAt(LocalDateTime.now());
        Topic saved = topicRepository.save(topic);

        // Update TopicSupervisors table
        if (saved.getLecturer() != null) {
            supervisorRepository.deleteByTopicId(saved.getId());

            TopicSupervisor primary = new TopicSupervisor();
            primary.setTopic(saved);
            primary.setLecturer(saved.getLecturer());
            primary.setRole(SupervisorRole.PRIMARY);
            supervisorRepository.save(primary);

            if (saved.getCoLecturer() != null && !saved.getCoLecturer().getId().equals(saved.getLecturer().getId())) {
                TopicSupervisor co = new TopicSupervisor();
                co.setTopic(saved);
                co.setLecturer(saved.getCoLecturer());
                co.setRole(SupervisorRole.CO_SUPERVISOR);
                supervisorRepository.save(co);
            }
        }

        return saved;
    }

    @Transactional
    /** Cập nhật trạng thái duyệt của đề tài. */
    public Topic updateStatus(Long topicId, TopicStatus status) {
        Topic topic = topicRepository.findById(topicId).orElseThrow(() -> new IllegalArgumentException("Không tìm thấy đề tài"));
        topic.setStatus(status);
        topic.setUpdatedAt(LocalDateTime.now());
        return topicRepository.save(topic);
    }

    @Transactional
    /** Xóa đề tài theo mã định danh. */
    public void delete(Long id) {
        supervisorRepository.deleteByTopicId(id);
        topicRepository.deleteById(id);
    }
}
