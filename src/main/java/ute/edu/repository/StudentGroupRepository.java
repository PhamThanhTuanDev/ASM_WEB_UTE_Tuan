package ute.edu.repository;

import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import ute.edu.entity.StudentGroup;

/** Truy vấn bảng student_groups (nhóm sinh viên). */
public interface StudentGroupRepository extends JpaRepository<StudentGroup, Long> {
    /** Lấy nhóm trong một đợt đăng ký. */
    List<StudentGroup> findByRegistrationPeriodId(Long periodId);
    /** Tìm nhóm do sinh viên làm trưởng trong một đợt. */
    Optional<StudentGroup> findByLeaderIdAndRegistrationPeriodId(Long leaderId, Long periodId);
    /** Lấy các nhóm do một sinh viên làm trưởng. */
    List<StudentGroup> findByLeaderId(Long leaderId);
}
