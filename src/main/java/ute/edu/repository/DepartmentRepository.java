package ute.edu.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ute.edu.entity.Department;

public interface DepartmentRepository extends JpaRepository<Department, Long> {
}
