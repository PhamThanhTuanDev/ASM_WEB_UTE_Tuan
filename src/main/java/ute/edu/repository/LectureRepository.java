package ute.edu.repository;

import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import ute.edu.entity.Lecture;

public interface LectureRepository extends JpaRepository<Lecture, Long> {
    Lecture findByUserId(Long userId);
    Optional<Lecture> findByLecturerCode(String lecturerCode);
    List<Lecture> findByDepartmentId(Long departmentId);
}
