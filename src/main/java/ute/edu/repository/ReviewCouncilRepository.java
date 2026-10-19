package ute.edu.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import ute.edu.entity.ReviewCouncil;

/** Truy vấn bảng councils (hội đồng phản biện). */
public interface ReviewCouncilRepository extends JpaRepository<ReviewCouncil, Long> {
    boolean existsByCodeIgnoreCase(String code);
    /** Khóa dòng hội đồng đến hết giao dịch (SELECT ... FOR UPDATE chạy được trên cả MySQL và MariaDB). */
    @org.springframework.data.jpa.repository.Query(value = "SELECT * FROM councils WHERE id = :id FOR UPDATE", nativeQuery = true)
    java.util.Optional<ReviewCouncil> findForUpdate(@org.springframework.data.repository.query.Param("id") Long id);
    /** Lấy hội đồng theo đợt đăng ký. */
    List<ReviewCouncil> findByRegistrationPeriodIdOrderByCreatedAtDescIdDesc(Long periodId);
    /** Lấy hội đồng theo khoa quản lý. */
    List<ReviewCouncil> findByDepartmentId(Long departmentId);
}
