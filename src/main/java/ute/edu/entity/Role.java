package ute.edu.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "roles")
/** Bảng roles: lưu danh mục các vai trò và quyền trong hệ thống. */
public class Role {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    // Khóa chính của vai trò.
    private Long id;

    @Column(nullable = false, unique = true, length = 30)
    // Mã vai trò dùng trong phân quyền.
    private String code;

    @Column(nullable = false, length = 100)
    // Tên hiển thị của vai trò.
    private String name;

    public Long getId() { return id; }
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
}
