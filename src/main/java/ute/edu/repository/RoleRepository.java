package ute.edu.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ute.edu.entity.Role;

/** Truy vấn bảng roles (vai trò phân quyền). */
public interface RoleRepository extends JpaRepository<Role, Long> {
    /** Tìm vai trò theo mã. */
    Role findByCode(String code);
}
