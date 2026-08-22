package ute.edu.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ute.edu.entity.Role;

public interface RoleRepository extends JpaRepository<Role, Long> {
    Role findByCode(String code);
}
