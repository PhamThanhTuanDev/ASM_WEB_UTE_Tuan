package ute.edu.repository;

import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import ute.edu.entity.ReviewCouncilMember;

public interface ReviewCouncilMemberRepository extends JpaRepository<ReviewCouncilMember, Long> {
    List<ReviewCouncilMember> findByCouncilId(Long councilId);
    List<ReviewCouncilMember> findByLecturerId(Long lecturerId);
    Optional<ReviewCouncilMember> findByCouncilIdAndLecturerId(Long councilId, Long lecturerId);
    boolean existsByCouncilIdAndLecturerId(Long councilId, Long lecturerId);
    void deleteByCouncilId(Long councilId);
}
