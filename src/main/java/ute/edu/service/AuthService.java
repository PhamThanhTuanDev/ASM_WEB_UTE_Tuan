package ute.edu.service;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import ute.edu.entity.*;
import ute.edu.repository.StudentRepository;
import ute.edu.repository.DepartmentRepository;
import ute.edu.enums.UserRole;
import java.util.UUID;
import org.springframework.transaction.annotation.Transactional;
import ute.edu.repository.UserAccountRepository;

@Service
/** Service đăng ký tài khoản và xác thực người dùng. */
public class AuthService {
    private final UserAccountRepository userAccountRepository;
    private final BCryptPasswordEncoder passwordEncoder;

    private final StudentRepository students;
    private final DepartmentRepository departments;

    public AuthService(UserAccountRepository userAccountRepository, BCryptPasswordEncoder passwordEncoder,
            StudentRepository students, DepartmentRepository departments) {
        this.students = students;
        this.departments = departments;
        this.userAccountRepository = userAccountRepository;
        this.passwordEncoder = passwordEncoder;
    }

    /** Kiểm tra tên đăng nhập/email và mật khẩu, trả về người dùng hợp lệ. */
    public UserAccount loginUser(String identifier, String rawPassword) {
        if (identifier == null || rawPassword == null) return null;
        String cleanIdentifier = identifier.trim();
        String cleanPassword = rawPassword;
        if (cleanIdentifier.isEmpty() || cleanPassword.isEmpty()) return null;

        UserAccount user = findByUsernameOrEmail(cleanIdentifier);

        if (user == null || !user.isEnabled()) {
            return null;
        }

        String dbPass = user.getPassword();
        if (dbPass == null) return null;

        try {
            if (passwordEncoder.matches(cleanPassword, dbPass)) {
                return user;
            }
        } catch (IllegalArgumentException ignored) {
        }
        return null;
    }

    /** Tìm tài khoản bằng email hoặc tên đăng nhập. */
    public UserAccount findByUsernameOrEmail(String identifier) {
        if (identifier == null) return null;
        String clean = identifier.trim();
        UserAccount u = userAccountRepository.findByEmailIgnoreCase(clean);
        if (u == null) {
            u = userAccountRepository.findByUsername(clean);
        }
        return u;
    }

    /** Tạo tài khoản và hồ sơ sinh viên trong cùng giao dịch sau khi Google xác minh email. */
    @Transactional
    public UserAccount registerGoogleStudent(String email, String name, String phone, String course, String className,
            String major, Long departmentId) {
        if (email == null || !email.matches("[0-9]+@(student\\.)?hcmute\\.edu\\.vn"))
            throw new IllegalArgumentException("Email sinh viên không hợp lệ.");
        String code = email.substring(0, email.indexOf('@'));
        if (name == null || name.isBlank() || name.length() > 255 || phone == null
                || !phone.matches("[0-9+() .-]{8,20}") || invalid(course) || invalid(className) || invalid(major))
            throw new IllegalArgumentException("Vui lòng nhập đầy đủ thông tin và số điện thoại hợp lệ.");
        if (userAccountRepository.findByEmailIgnoreCase(email) != null || userAccountRepository.findByUsername(code) != null
                || students.findByStudentCode(code).isPresent())
            throw new IllegalArgumentException("Email hoặc MSSV đã tồn tại. Vui lòng đăng nhập lại hoặc liên hệ quản trị viên.");
        Department department = departmentId == null ? null : departments.findById(departmentId).orElse(null);
        if (department == null || !department.isActive())
            throw new IllegalArgumentException("Vui lòng chọn khoa đang hoạt động.");
        UserAccount user = new UserAccount();
        user.setUsername(code); user.setEmail(email); user.setFullName(name.trim()); user.setPhone(phone.trim());
        user.setRole(UserRole.STUDENT); user.setPassword(passwordEncoder.encode(UUID.randomUUID().toString()));
        user = userAccountRepository.save(user);
        Student student = new Student();
        student.setUser(user); student.setStudentCode(code); student.setDepartment(department);
        student.setCourseYear(course.trim()); student.setClassName(className.trim()); student.setMajor(major.trim());
        students.save(student);
        return user;
    }

    private boolean invalid(String value) { return value == null || value.isBlank() || value.length() > 255; }
}
