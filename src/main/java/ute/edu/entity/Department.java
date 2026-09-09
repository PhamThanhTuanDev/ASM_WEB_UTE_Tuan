package ute.edu.entity;

import jakarta.persistence.*;
import java.util.List;
import java.time.LocalDateTime;

@Entity
@Table(name = "departments")
/** Bảng departments: lưu danh mục các khoa trong trường. */
public class Department {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    // Khóa chính của khoa.
    private Long id;

    @Column(nullable = false, unique = true)
    // Tên đầy đủ của khoa.
    private String name;

    @Column(nullable = false, unique = true, length = 30)
    // Mã viết tắt của khoa.
    private String code = "CNTT";

    @Column(length = 500)
    // Mô tả chức năng hoặc chuyên ngành của khoa.
    private String description;

    @Column(nullable = false)
    // Khoa còn hoạt động trong hệ thống hay không.
    private boolean active = true;

    @Column
    private LocalDateTime createdAt = LocalDateTime.now();

    @OneToMany(mappedBy = "department")
    private List<Lecture> lecturers;

    public Department() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public List<Lecture> getLecturers() { return lecturers; }
    public void setLecturers(List<Lecture> lecturers) { this.lecturers = lecturers; }
}
