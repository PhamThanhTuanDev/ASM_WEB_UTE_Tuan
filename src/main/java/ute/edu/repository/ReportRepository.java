package ute.edu.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import ute.edu.entity.Report;

public interface ReportRepository extends JpaRepository<Report, Long> {
    List<Report> findByTopicRegistrationIdOrderBySubmittedAtDesc(Long registrationId);
}
