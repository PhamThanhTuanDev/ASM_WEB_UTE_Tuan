package ute.edu.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "students")
/** Bảng students: lưu hồ sơ và thông tin học tập của sinh viên. */
public class Student {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    // Khóa chính hồ sơ sinh viên.
    private Long id;

    @OneToOne
    @JoinColumn(name = "user_id", nullable = false, unique = true)
    // Tài khoản đăng nhập tương ứng.
    private UserAccount user;

    @ManyToOne
    @JoinColumn(name = "department_id")
    // Khoa sinh viên đang theo học.
    private Department department;

    @Column(nullable = false)
    // Mã số sinh viên.
    private String studentCode;

    @Column(nullable = false)
    // Khóa học của sinh viên.
    private String courseYear = "K21";

    @Column(nullable = false)
    // Tên lớp hành chính.
    private String className;

    @Column(nullable = false)
    // Ngành đào tạo.
    private String major;

    public Student() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public UserAccount getUser() { return user; }
    public void setUser(UserAccount user) { this.user = user; }
    public Department getDepartment() { return department; }
    public void setDepartment(Department department) { this.department = department; }
    public String getStudentCode() { return studentCode; }
    public void setStudentCode(String studentCode) { this.studentCode = studentCode; }
    public String getCourseYear() { return courseYear; }
    public void setCourseYear(String courseYear) { this.courseYear = courseYear; }
    public String getClassName() { return className; }
    public void setClassName(String className) { this.className = className; }
    public String getMajor() { return major; }
    public void setMajor(String major) { this.major = major; }
}
