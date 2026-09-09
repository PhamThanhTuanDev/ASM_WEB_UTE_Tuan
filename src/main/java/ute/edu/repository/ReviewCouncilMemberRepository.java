package ute.edu.repository;

import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import ute.edu.entity.ReviewCouncilMember;

/** Truy vấn bảng council_members (thành viên hội đồng). */
public interface ReviewCouncilMemberRepository extends JpaRepository<ReviewCouncilMember, Long> {
    /** Lấy thành viên của một hội đồng. */
    List<ReviewCouncilMember> findByCouncilId(Long councilId);
    /** Lấy các hội đồng mà một giảng viên tham gia. */
    List<ReviewCouncilMember> findByLecturerId(Long lecturerId);
    /** Tìm một giảng viên trong một hội đồng. */
    Optional<ReviewCouncilMember> findByCouncilIdAndLecturerId(Long councilId, Long lecturerId);
    /** Kiểm tra giảng viên đã thuộc hội đồng chưa. */
    boolean existsByCouncilIdAndLecturerId(Long councilId, Long lecturerId);
    /** Xóa toàn bộ thành viên của hội đồng. */
    void deleteByCouncilId(Long councilId);
}
