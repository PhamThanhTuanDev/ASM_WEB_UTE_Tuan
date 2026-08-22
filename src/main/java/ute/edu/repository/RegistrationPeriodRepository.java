package ute.edu.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ute.edu.entity.RegistrationPeriod;

public interface RegistrationPeriodRepository extends JpaRepository<RegistrationPeriod, Long> {
}
