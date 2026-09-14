package ute.edu.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import ute.edu.entity.TopicSupervisor;

/** Truy vấn bảng topic_supervisors (quan hệ GVHD - đề tài). */
public interface TopicSupervisorRepository extends JpaRepository<TopicSupervisor, Long> {
    /** Lấy giảng viên hướng dẫn của một đề tài. */
    List<TopicSupervisor> findByTopicId(Long topicId);
    /** Lấy các đề tài do giảng viên hướng dẫn. */
    List<TopicSupervisor> findByLecturerId(Long lecturerId);
    /** Kiểm tra giảng viên có hướng dẫn đề tài không. */
    boolean existsByTopicIdAndLecturerId(Long topicId, Long lecturerId);
    /** Xóa các quan hệ hướng dẫn của đề tài. */
    void deleteByTopicId(Long topicId);
}
