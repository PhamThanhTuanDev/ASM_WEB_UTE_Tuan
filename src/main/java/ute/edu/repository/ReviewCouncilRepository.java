package ute.edu.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import ute.edu.entity.ReviewCouncil;

public interface ReviewCouncilRepository extends JpaRepository<ReviewCouncil, Long> {
    List<ReviewCouncil> findByRegistrationPeriodId(Long periodId);
    List<ReviewCouncil> findByDepartmentId(Long departmentId);
}
