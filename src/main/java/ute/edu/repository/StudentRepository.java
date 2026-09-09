package ute.edu.repository;

import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import ute.edu.entity.Student;

/** Truy vấn bảng students (hồ sơ sinh viên). */
public interface StudentRepository extends JpaRepository<Student, Long> {
    /** Tìm hồ sơ sinh viên theo tài khoản. */
    Student findByUserId(Long userId);
    /** Tìm sinh viên theo mã số sinh viên. */
    Optional<Student> findByStudentCode(String studentCode);
}
