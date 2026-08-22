package ute.edu.repository;

import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import ute.edu.entity.Student;

public interface StudentRepository extends JpaRepository<Student, Long> {
    Student findByUserId(Long userId);
    Optional<Student> findByStudentCode(String studentCode);
}
