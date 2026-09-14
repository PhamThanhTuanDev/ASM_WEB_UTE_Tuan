package ute.edu.repository;

import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import ute.edu.entity.StudentGroupMember;

/** Truy vấn bảng group_members (thành viên nhóm). */
public interface StudentGroupMemberRepository extends JpaRepository<StudentGroupMember, Long> {
    /** Lấy thành viên của một nhóm. */
    List<StudentGroupMember> findByGroupId(Long groupId);
    /** Lấy các nhóm mà sinh viên tham gia. */
    List<StudentGroupMember> findByStudentId(Long studentId);
    /** Tìm sinh viên trong một nhóm. */
    Optional<StudentGroupMember> findByGroupIdAndStudentId(Long groupId, Long studentId);
    /** Kiểm tra sinh viên đã thuộc nhóm chưa. */
    boolean existsByGroupIdAndStudentId(Long groupId, Long studentId);
    /** Xóa sinh viên khỏi nhóm. */
    void deleteByGroupIdAndStudentId(Long groupId, Long studentId);
}
