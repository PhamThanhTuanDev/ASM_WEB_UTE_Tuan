package ute.edu.service;

import java.util.List;
import java.time.LocalDateTime;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ute.edu.enums.RegistrationStatus;
import ute.edu.enums.GroupStatus;
import ute.edu.entity.StudentGroup;
import ute.edu.entity.Topic;
import ute.edu.entity.TopicRegistration;
import ute.edu.entity.UserAccount;
import ute.edu.repository.TopicRegistrationRepository;
import ute.edu.repository.StudentGroupRepository;

@Service
public class TopicRegistrationService {
    private final TopicRegistrationRepository registrationRepository;
    private final StudentGroupRepository groupRepository;

    public TopicRegistrationService(TopicRegistrationRepository registrationRepository,
                                    StudentGroupRepository groupRepository) {
        this.registrationRepository = registrationRepository;
        this.groupRepository = groupRepository;
    }

    public List<TopicRegistration> getAll() {
        return registrationRepository.findAll();
    }

    public TopicRegistration findById(Long id) {
        return registrationRepository.findById(id).orElse(null);
    }

    public List<TopicRegistration> getByStatus(RegistrationStatus status) {
        return registrationRepository.findByStatus(status);
    }

    public List<TopicRegistration> getByGroupId(Long groupId) {
        return registrationRepository.findByGroupId(groupId);
    }

    public List<TopicRegistration> getApprovedRegistrations() {
        return registrationRepository.findByStatus(RegistrationStatus.APPROVED);
    }

    public TopicRegistration getActiveRegistrationForGroup(Long groupId) {
        List<TopicRegistration> list = registrationRepository.findByGroupId(groupId);
        return list.stream()
                .filter(r -> r.getStatus() == RegistrationStatus.APPROVED || r.getStatus() == RegistrationStatus.PENDING)
                .findFirst()
                .orElse(null);
    }

    @Transactional
    public TopicRegistration register(StudentGroup group, Topic topic, String note) {
        if (group == null || topic == null) {
            throw new IllegalArgumentException("Nhóm và đề tài không được để trống");
        }
        if (group.getTopic() != null) {
            throw new IllegalStateException("QUY ĐỊNH: Nhóm đã được gán một đề tài chính thức!");
        }
        if (registrationRepository.existsByGroupIdAndTopicId(group.getId(), topic.getId())) {
            throw new IllegalStateException("Nhóm đã gửi yêu cầu đăng ký cho đề tài này!");
        }
        TopicRegistration registration = new TopicRegistration();
        registration.setGroup(group);
        registration.setTopic(topic);
        registration.setNote(note);
        registration.setStatus(RegistrationStatus.PENDING);
        registration.setCreatedAt(LocalDateTime.now());
        return registrationRepository.save(registration);
    }

    @Transactional
    public TopicRegistration updateStatus(Long id, RegistrationStatus status,
                                          UserAccount approver, String rejectionReason) {
        TopicRegistration registration = registrationRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy đăng ký đề tài"));
        registration.setStatus(status);
        registration.setApprovedBy(approver);
        registration.setRejectionReason(rejectionReason);
        registration.setApprovedAt(status == RegistrationStatus.APPROVED ? LocalDateTime.now() : null);

        if (status == RegistrationStatus.APPROVED) {
            StudentGroup group = registration.getGroup();
            group.setTopic(registration.getTopic());
            group.setStatus(GroupStatus.ASSIGNED);
            groupRepository.save(group);
        }
        return registrationRepository.save(registration);
    }
}
