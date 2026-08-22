package ute.edu.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ute.edu.entity.UserAccount;

public interface UserAccountRepository extends JpaRepository<UserAccount, Long> {
    UserAccount findByUsername(String username);
    UserAccount findByEmail(String email);
    UserAccount findByEmailIgnoreCase(String email);
}
