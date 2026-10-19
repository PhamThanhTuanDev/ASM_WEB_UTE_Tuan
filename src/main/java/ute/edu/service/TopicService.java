package ute.edu.service;

import java.util.List;
import java.time.LocalDateTime;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ute.edu.enums.TopicStatus;
import ute.edu.enums.SupervisorRole;
import ute.edu.entity.Topic;
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

    /**
     * Lấy toàn bộ danh sách đề tài hiện có.
     * 
     * @return Danh sách các đối tượng Topic
     */
    public List<Topic> getAllTopics() {
        return topicRepository.findAll(org.springframework.data.domain.Sort.by(
                org.springframework.data.domain.Sort.Direction.DESC, "createdAt", "id"));
    }

    public List<Topic> getAvailableTopics() {
        return topicRepository.findAvailableTopics();
    }

    /**
     * Lấy danh sách đề tài dựa theo trạng thái duyệt.
     * 
     * @param status Trạng thái của đề tài (Ví dụ: APPROVED, PENDING)
     * @return Danh sách các đề tài có trạng thái tương ứng
     */
    public List<Topic> getTopicsByStatus(TopicStatus status) {
        return topicRepository.findByStatusOrderByCreatedAtDescIdDesc(status);
    }

    /**
     * Lấy danh sách đề tài trực thuộc một khoa (Department).
     * 
     * @param departmentId Mã định danh của khoa
     * @return Danh sách đề tài thuộc khoa
     */
    public List<Topic> getTopicsByDepartment(Long departmentId) {
        return topicRepository.findByDepartmentIdOrderByCreatedAtDescIdDesc(departmentId);
    }

    /**
     * Lấy danh sách đề tài trong một đợt đăng ký cụ thể.
     * 
     * @param periodId Mã định danh của đợt đăng ký
     * @return Danh sách đề tài thuộc đợt đăng ký đó
     */
    public List<Topic> getTopicsByPeriod(Long periodId) {
        return topicRepository.findByRegistrationPeriodIdOrderByCreatedAtDescIdDesc(periodId);
    }

    /**
     * Lấy danh sách đề tài do một giảng viên phụ trách (có thể là GVHD chính hoặc
     * Đồng GVHD).
     * 
     * @param lecturerId Mã định danh của giảng viên
     * @return Danh sách đề tài của giảng viên đó
     */
    public List<Topic> getTopicsByLecturer(Long lecturerId) {
        return topicRepository.findByLecturerIdOrCoLecturerIdOrderByCreatedAtDescIdDesc(lecturerId, lecturerId);
    }

    /**
     * Tìm một đề tài cụ thể theo mã định danh (ID).
     * 
     * @param id Mã định danh của đề tài
     * @return Đối tượng Topic nếu tìm thấy, ngược lại trả về null
     */
    public Topic findById(Long id) {
        return topicRepository.findById(id).orElse(null);
    }

    /**
     * Lưu mới hoặc cập nhật một đề tài.
     * Tự động thiết lập thời gian tạo/cập nhật và đồng bộ bảng TopicSupervisor.
     * 
     * @param topic Đối tượng đề tài cần lưu
     * @return Đề tài sau khi đã lưu thành công vào CSDL
     */
    @Transactional
    public Topic save(Topic topic) {
        if (topic.getCode() == null || topic.getCode().isBlank() || topic.getCode().trim().length() > 30
                || topic.getTitle() == null || topic.getTitle().isBlank() || topic.getTitle().trim().length() > 255
                || topic.getDescription() == null || topic.getDescription().isBlank()) {
            throw new IllegalArgumentException("Vui lòng nhập mã (tối đa 30 ký tự), tên (tối đa 255 ký tự) và mô tả đề tài!");
        }
        topic.setCode(topic.getCode().trim());
        topic.setTitle(topic.getTitle().trim());
        topic.setDescription(topic.getDescription().trim());
        if (topic.getId() != null) {
            Topic existing = topicRepository.findForUpdate(topic.getId()).orElseThrow();
            if (existing.getStatus() == TopicStatus.ASSIGNED || existing.getStatus() == TopicStatus.COMPLETED) {
                throw new IllegalStateException("Đề tài đã có nhóm thực hiện hoặc đã hoàn tất, không thể ghi đè thông tin!");
            }
            topic.setCreatedAt(existing.getCreatedAt());
        }
        if (topic.getDepartment() == null || topic.getRegistrationPeriod() == null || topic.getLecturer() == null
                || topic.getMaxStudents() < 1 || topic.getMaxStudents() > 3) {
            throw new IllegalArgumentException("Khoa, đợt, GVHD là bắt buộc; số sinh viên từ 1 đến 3!");
        }
        if (!topic.getDepartment().getId().equals(topic.getLecturer().getDepartment().getId())
                || (topic.getCoLecturer() != null && (!topic.getDepartment().getId().equals(topic.getCoLecturer().getDepartment().getId())
                || topic.getCoLecturer().getId().equals(topic.getLecturer().getId())))) {
            throw new IllegalArgumentException("GVHD và đồng hướng dẫn phải cùng khoa, không được trùng nhau!");
        }
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

    /**
     * Cập nhật trạng thái duyệt của đề tài.
     * 
     * @param topicId Mã định danh của đề tài cần cập nhật
     * @param status  Trạng thái mới của đề tài
     * @return Đề tài sau khi đã cập nhật trạng thái
     * @throws IllegalArgumentException Nếu không tìm thấy đề tài
     */
    @Transactional
    public Topic updateStatus(Long topicId, TopicStatus status) {
        Topic topic = topicRepository.findById(topicId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy đề tài với ID: " + topicId));
        if (status == null || status == TopicStatus.ASSIGNED || status == TopicStatus.COMPLETED
                || topic.getStatus() == TopicStatus.ASSIGNED || topic.getStatus() == TopicStatus.COMPLETED) {
            throw new IllegalStateException("Trạng thái thực hiện/hoàn tất phải được cập nhật qua duyệt đăng ký và chốt điểm!");
        }
        topic.setStatus(status);
        topic.setUpdatedAt(LocalDateTime.now());
        return topicRepository.save(topic);
    }

    /**
     * Xóa một đề tài ra khỏi hệ thống.
     * Thực hiện xóa các liên kết giám sát (TopicSupervisor) trước khi xóa đề tài.
     * 
     * @param id Mã định danh của đề tài cần xóa
     */
    @Transactional
    public void delete(Long id) {
        supervisorRepository.deleteByTopicId(id);
        topicRepository.deleteById(id);
    }
}
