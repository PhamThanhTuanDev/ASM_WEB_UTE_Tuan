package ute.edu.service;

import java.util.List;
import java.util.Optional;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ute.edu.entity.StudentGroup;
import ute.edu.entity.Student;
import ute.edu.entity.StudentGroupMember;
import ute.edu.entity.RegistrationPeriod;
import ute.edu.enums.GroupStatus;
import ute.edu.repository.StudentGroupMemberRepository;
import ute.edu.repository.StudentGroupRepository;
import ute.edu.repository.StudentRepository;

@Service
public class StudentGroupService {
    private final StudentGroupRepository studentGroupRepository;
    private final StudentGroupMemberRepository memberRepository;
    private final StudentRepository studentRepository;

    public StudentGroupService(StudentGroupRepository studentGroupRepository,
                               StudentGroupMemberRepository memberRepository,
                               StudentRepository studentRepository) {
        this.studentGroupRepository = studentGroupRepository;
        this.memberRepository = memberRepository;
        this.studentRepository = studentRepository;
    }

    public List<StudentGroup> getAll() {
        return studentGroupRepository.findAll();
    }

    public StudentGroup findById(Long id) {
        return studentGroupRepository.findById(id).orElse(null);
    }

    public List<StudentGroupMember> getMembers(Long groupId) {
        return memberRepository.findByGroupId(groupId);
    }

    public StudentGroup findGroupByStudent(Long studentId) {
        List<StudentGroupMember> members = memberRepository.findByStudentId(studentId);
        if (!members.isEmpty()) {
            return members.get(0).getGroup();
        }
        return null;
    }

    public StudentGroup save(StudentGroup group) {
        return studentGroupRepository.save(group);
    }

    @Transactional
    public StudentGroup create(String name, RegistrationPeriod period, Student leader) {
        if (name == null || name.isBlank() || period == null || leader == null) {
            throw new IllegalArgumentException("Tên nhóm, đợt đăng ký và nhóm trưởng là bắt buộc");
        }
        boolean alreadyJoined = memberRepository.findAll().stream()
                .anyMatch(member -> member.getStudent().getId().equals(leader.getId())
                        && member.getGroup().getRegistrationPeriod() != null
                        && member.getGroup().getRegistrationPeriod().getId().equals(period.getId()));
        if (alreadyJoined) {
            throw new IllegalStateException("Sinh viên đã thuộc một nhóm trong đợt đăng ký này!");
        }
        StudentGroup group = new StudentGroup();
        group.setName(name.trim());
        group.setLeader(leader);
        group.setRegistrationPeriod(period);
        group.setStatus(GroupStatus.READY);
        group = studentGroupRepository.save(group);

        StudentGroupMember member = new StudentGroupMember();
        member.setGroup(group);
        member.setStudent(leader);
        member.setLeader(true);
        memberRepository.save(member);
        return group;
    }

    @Transactional
    public void addMemberByCode(Long groupId, String studentCode) {
        StudentGroup group = studentGroupRepository.findById(groupId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy nhóm"));
        Student student = studentRepository.findByStudentCode(studentCode.trim())
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy sinh viên có MSSV: " + studentCode));

        long memberCount = memberRepository.findByGroupId(groupId).size();
        if (memberCount >= 3) {
            throw new IllegalStateException("QUY ĐỊNH: Mỗi nhóm chỉ được tối đa 03 sinh viên!");
        }

        boolean alreadyJoined = memberRepository.findAll().stream()
                .anyMatch(member -> member.getStudent().getId().equals(student.getId())
                        && member.getGroup().getRegistrationPeriod() != null
                        && group.getRegistrationPeriod() != null
                        && member.getGroup().getRegistrationPeriod().getId()
                                .equals(group.getRegistrationPeriod().getId()));
        if (alreadyJoined) {
            throw new IllegalStateException("Sinh viên " + studentCode + " (" + student.getUser().getFullName() + ") đã tham gia một nhóm khác trong đợt này!");
        }

        StudentGroupMember member = new StudentGroupMember();
        member.setGroup(group);
        member.setStudent(student);
        member.setLeader(false);
        memberRepository.save(member);
    }

    @Transactional
    public void removeMember(Long groupId, Long studentId) {
        StudentGroup group = studentGroupRepository.findById(groupId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy nhóm"));
        if (group.getLeader().getId().equals(studentId)) {
            throw new IllegalStateException("Không thể xóa nhóm trưởng khỏi nhóm!");
        }
        memberRepository.deleteByGroupIdAndStudentId(groupId, studentId);
    }
}
