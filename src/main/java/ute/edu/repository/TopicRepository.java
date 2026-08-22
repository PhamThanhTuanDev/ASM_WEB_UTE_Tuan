package ute.edu.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import ute.edu.enums.TopicStatus;
import ute.edu.entity.Topic;

public interface TopicRepository extends JpaRepository<Topic, Long> {
    List<Topic> findByStatus(TopicStatus status);
    List<Topic> findByDepartmentId(Long departmentId);
    List<Topic> findByRegistrationPeriodId(Long periodId);
    List<Topic> findByLecturerId(Long lecturerId);
    List<Topic> findByLecturerIdOrCoLecturerId(Long lecturerId, Long coLecturerId);
    List<Topic> findByDepartmentIdAndStatus(Long departmentId, TopicStatus status);
    List<Topic> findByRegistrationPeriodIdAndStatus(Long periodId, TopicStatus status);
    List<Topic> findByTitleContainingIgnoreCaseOrCodeContainingIgnoreCase(String title, String code);
}
