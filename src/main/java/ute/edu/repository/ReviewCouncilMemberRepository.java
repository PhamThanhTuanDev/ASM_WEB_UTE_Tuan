package ute.edu.repository;

import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import ute.edu.entity.ReviewCouncilMember;

/** Truy vấn bảng council_members (thành viên hội đồng). */
public interface ReviewCouncilMemberRepository extends JpaRepository<ReviewCouncilMember, Long> {
    /** Đọc lịch mới nhất sau khi lấy khóa giảng viên, kể cả với MySQL REPEATABLE READ. */
    @org.springframework.data.jpa.repository.Query(value = "SELECT m.id FROM council_members m "
            + "JOIN councils c ON c.id=m.council_id WHERE m.lecturer_id=:lecturerId "
            + "AND c.reg_period_id=:periodId FOR UPDATE", nativeQuery = true)
    List<Long> findMembershipIdsForUpdate(
            @org.springframework.data.repository.query.Param("lecturerId") Long lecturerId,
            @org.springframework.data.repository.query.Param("periodId") Long periodId);
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
