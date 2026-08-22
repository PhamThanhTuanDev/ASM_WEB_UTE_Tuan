package ute.edu.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ute.edu.entity.Announcement;

public interface AnnouncementRepository extends JpaRepository<Announcement, Long> {
}
