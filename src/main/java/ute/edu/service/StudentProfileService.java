package ute.edu.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ute.edu.entity.Student;
import ute.edu.repository.StudentRepository;
import ute.edu.repository.UserAccountRepository;

@Service
/** Cập nhật hồ sơ cá nhân; MSSV và khoa chỉ được thay đổi bởi quản trị viên. */
public class StudentProfileService {
    private final StudentRepository students;
    private final UserAccountRepository users;
    public StudentProfileService(StudentRepository students, UserAccountRepository users) {
        this.students = students; this.users = users;
    }

    /** Kiểm tra các trường bắt buộc rồi lưu đồng thời hồ sơ và số điện thoại tài khoản. */
    @Transactional
    public Student update(Long userId, String code, String course, String className, String major, Long departmentId, String phone) {
        Student student = students.findByUserId(userId);
        if (student == null) throw new IllegalArgumentException("Không tìm thấy hồ sơ sinh viên!");
        if (!student.getStudentCode().equals(code) || student.getDepartment() == null
                || !student.getDepartment().getId().equals(departmentId)) {
            throw new IllegalArgumentException("MSSV và khoa do quản trị viên quản lý, sinh viên không được tự thay đổi!");
        }
        if (course == null || course.isBlank() || className == null || className.isBlank() || major == null || major.isBlank()
                || phone == null || !phone.matches("[0-9+() .-]{8,20}")) {
            throw new IllegalArgumentException("Vui lòng nhập đầy đủ khóa học, lớp, ngành và số điện thoại hợp lệ!");
        }
        student.setCourseYear(course.trim()); student.setClassName(className.trim()); student.setMajor(major.trim());
        student.getUser().setPhone(phone.trim());
        users.save(student.getUser());
        return students.save(student);
    }
}
