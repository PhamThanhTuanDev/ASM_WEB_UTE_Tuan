package ute.edu.repository;

import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import ute.edu.entity.StudentGroup;

public interface StudentGroupRepository extends JpaRepository<StudentGroup, Long> {
    List<StudentGroup> findByRegistrationPeriodId(Long periodId);
    Optional<StudentGroup> findByLeaderIdAndRegistrationPeriodId(Long leaderId, Long periodId);
    List<StudentGroup> findByLeaderId(Long leaderId);
}
