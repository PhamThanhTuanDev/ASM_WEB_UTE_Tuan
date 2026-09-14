package ute.edu.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "lecturers")
/** Bảng lecturers: lưu hồ sơ giảng viên và khoa công tác. */
public class Lecture {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    // Khóa chính hồ sơ giảng viên.
    private Long id;

    @OneToOne
    @JoinColumn(name = "user_id", nullable = false, unique = true)
    // Tài khoản đăng nhập của giảng viên.
    private UserAccount user;

    @ManyToOne
    @JoinColumn(name = "department_id")
    // Khoa giảng viên công tác.
    private Department department;

    @Column(unique = true, length = 30)
    // Mã số giảng viên.
    private String lecturerCode;

    @Column(length = 255)
    // Văn bằng chuyên môn.
    private String degree;

    // Chức danh nghề nghiệp.
    private String academicTitle;
    // Học hàm hoặc học vị.
    private String academicDegree;

    @Column(length = 255)
    // Lĩnh vực nghiên cứu và chuyên môn.
    private String researchField;

    public Lecture() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public UserAccount getUser() { return user; }
    public void setUser(UserAccount user) { this.user = user; }
    public Department getDepartment() { return department; }
    public void setDepartment(Department department) { this.department = department; }
    public String getLecturerCode() { return lecturerCode; }
    public void setLecturerCode(String lecturerCode) { this.lecturerCode = lecturerCode; }
    public String getDegree() { return degree; }
    public void setDegree(String degree) { this.degree = degree; }
    public String getAcademicTitle() { return academicTitle; }
    public void setAcademicTitle(String academicTitle) { this.academicTitle = academicTitle; }
    public String getAcademicDegree() { return academicDegree; }
    public void setAcademicDegree(String academicDegree) { this.academicDegree = academicDegree; }
    public String getResearchField() { return researchField; }
    public void setResearchField(String researchField) { this.researchField = researchField; }
}
