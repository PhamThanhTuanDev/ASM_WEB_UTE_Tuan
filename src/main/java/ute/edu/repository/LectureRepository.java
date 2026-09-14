package ute.edu.repository;

import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import ute.edu.entity.Lecture;

/** Truy vấn bảng lecturers (hồ sơ giảng viên). */
public interface LectureRepository extends JpaRepository<Lecture, Long> {
    /** Tìm giảng viên theo tài khoản. */
    Lecture findByUserId(Long userId);
    /** Tìm giảng viên theo mã số. */
    Optional<Lecture> findByLecturerCode(String lecturerCode);
    /** Lấy giảng viên thuộc một khoa. */
    List<Lecture> findByDepartmentId(Long departmentId);
}
