package ute.edu.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import ute.edu.entity.ReviewCouncil;

/** Truy vấn bảng councils (hội đồng phản biện). */
public interface ReviewCouncilRepository extends JpaRepository<ReviewCouncil, Long> {
    /** Lấy hội đồng theo đợt đăng ký. */
    List<ReviewCouncil> findByRegistrationPeriodId(Long periodId);
    /** Lấy hội đồng theo khoa quản lý. */
    List<ReviewCouncil> findByDepartmentId(Long departmentId);
}
