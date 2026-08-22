package ute.edu.repository;

import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import ute.edu.entity.StudentGroupMember;

public interface StudentGroupMemberRepository extends JpaRepository<StudentGroupMember, Long> {
    List<StudentGroupMember> findByGroupId(Long groupId);
    List<StudentGroupMember> findByStudentId(Long studentId);
    Optional<StudentGroupMember> findByGroupIdAndStudentId(Long groupId, Long studentId);
    boolean existsByGroupIdAndStudentId(Long groupId, Long studentId);
    void deleteByGroupIdAndStudentId(Long groupId, Long studentId);
}
