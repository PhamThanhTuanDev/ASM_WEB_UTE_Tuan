package ute.edu.service;

import java.util.List;
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
/** Service tạo nhóm, quản lý thành viên và nhóm trưởng. */
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

    /**
     * Lấy toàn bộ danh sách các nhóm sinh viên.
     * 
     * @return Danh sách các nhóm sinh viên (StudentGroup)
     */
    public List<StudentGroup> getAll() {
        return studentGroupRepository.findAll();
    }

    /**
     * Tìm một nhóm sinh viên theo mã định danh.
     * 
     * @param id Mã định danh của nhóm
     * @return Đối tượng StudentGroup nếu tồn tại, ngược lại trả về null
     */
    public StudentGroup findById(Long id) {
        return studentGroupRepository.findById(id).orElse(null);
    }

    /**
     * Lấy danh sách thành viên của một nhóm.
     * 
     * @param groupId Mã định danh của nhóm cần truy vấn
     * @return Danh sách các bản ghi thành viên (StudentGroupMember)
     */
    public List<StudentGroupMember> getMembers(Long groupId) {
        return memberRepository.findByGroupId(groupId);
    }

    /**
     * Tìm nhóm mà một sinh viên đang tham gia (nếu có).
     * Mặc định lấy nhóm đầu tiên mà sinh viên này đang là thành viên.
     * 
     * @param studentId Mã định danh của sinh viên
     * @return Đối tượng StudentGroup nếu sinh viên đang ở trong nhóm, ngược lại
     *         null
     */
    public StudentGroup findGroupByStudent(Long studentId) {
        return memberRepository.findByStudentId(studentId).stream()
                .map(StudentGroupMember::getGroup)
                .findFirst()
                .orElse(null);
    }

    /**
     * Lưu thông tin nhóm sinh viên mới hoặc cập nhật nhóm đã có.
     * 
     * @param group Đối tượng nhóm sinh viên
     * @return Nhóm sau khi đã được lưu vào CSDL
     */
    public StudentGroup save(StudentGroup group) {
        return studentGroupRepository.save(group);
    }

    /**
     * Khởi tạo nhóm mới và tự động thêm nhóm trưởng vào nhóm.
     * Đảm bảo sinh viên chưa thuộc nhóm nào khác trong cùng một đợt đăng ký.
     * 
     * @param name   Tên của nhóm mới
     * @param period Đợt đăng ký hiện hành
     * @param leader Đối tượng sinh viên làm nhóm trưởng
     * @return Nhóm đã được tạo
     * @throws IllegalArgumentException nếu các tham số đầu vào không hợp lệ
     * @throws IllegalStateException    nếu sinh viên đã thuộc nhóm khác
     */
    @Transactional
    public StudentGroup create(String name, RegistrationPeriod period, Student leader) {
        if (name == null || name.isBlank() || period == null || leader == null) {
            throw new IllegalArgumentException("Tên nhóm, đợt đăng ký và nhóm trưởng là bắt buộc");
        }
        // Kiểm tra sinh viên đã tham gia nhóm khác trong cùng đợt đăng ký chưa.
        // Dùng query trực tiếp thay vì findAll() để tránh tải toàn bộ bảng vào RAM.
        if (memberRepository.existsByStudentIdAndGroupRegistrationPeriodId(leader.getId(), period.getId())) {
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

    /**
     * Thêm một sinh viên vào nhóm thông qua Mã số sinh viên (MSSV).
     * Kiểm tra các ràng buộc: nhóm tồn tại, sinh viên tồn tại, tối đa 3 thành viên,
     * sinh viên chưa nằm trong nhóm này, và chưa tham gia nhóm khác trong cùng đợt.
     * 
     * @param groupId     Mã định danh của nhóm
     * @param studentCode Mã số sinh viên cần thêm
     * @return Sinh viên vừa được thêm
     * @throws IllegalArgumentException nếu không tìm thấy nhóm hoặc sinh viên
     * @throws IllegalStateException    nếu vi phạm quy định (nhóm đầy, sinh viên đã
     *                                  tham gia)
     */
    @Transactional
    public Student addMemberByCode(Long groupId, String studentCode) {
        StudentGroup group = studentGroupRepository.findById(groupId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy nhóm"));
        Student student = studentRepository.findByStudentCode(studentCode.trim())
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy sinh viên có MSSV: " + studentCode));

        long memberCount = memberRepository.findByGroupId(groupId).size();
        if (memberCount >= 5) {
            throw new IllegalStateException("QUY ĐỊNH: Mỗi nhóm chỉ được tối đa 05 sinh viên!");
        }

        boolean alreadyInThisGroup = memberRepository.findByGroupId(groupId).stream()
                .anyMatch(member -> member.getStudent().getId().equals(student.getId()));
        if (alreadyInThisGroup) {
            throw new IllegalStateException("Sinh viên " + studentCode + " đã là thành viên của nhóm này!");
        }

        // Kiểm tra sinh viên đã tham gia nhóm khác trong cùng đợt. Dùng query DB thay vì findAll().
        if (group.getRegistrationPeriod() != null
                && memberRepository.existsByStudentIdAndGroupRegistrationPeriodId(
                        student.getId(), group.getRegistrationPeriod().getId())) {
            throw new IllegalStateException("Sinh viên " + studentCode + " (" + student.getUser().getFullName()
                    + ") đã tham gia một nhóm khác trong đợt này!");
        }

        StudentGroupMember member = new StudentGroupMember();
        member.setGroup(group);
        member.setStudent(student);
        member.setLeader(false);
        memberRepository.save(member);
        return student;
    }

    /**
     * Xóa một thành viên khỏi nhóm. Không cho phép xóa trưởng nhóm.
     * 
     * @param groupId   Mã định danh của nhóm
     * @param studentId Mã định danh của sinh viên cần xóa
     * @throws IllegalArgumentException nếu không tìm thấy nhóm
     * @throws IllegalStateException    nếu sinh viên bị xóa là nhóm trưởng
     */
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
