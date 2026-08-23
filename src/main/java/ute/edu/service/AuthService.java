package ute.edu.service;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import ute.edu.entity.UserAccount;
import ute.edu.repository.UserAccountRepository;

@Service
public class AuthService {
    private final UserAccountRepository userAccountRepository;
    private final BCryptPasswordEncoder passwordEncoder;

    public AuthService(UserAccountRepository userAccountRepository, BCryptPasswordEncoder passwordEncoder) {
        this.userAccountRepository = userAccountRepository;
        this.passwordEncoder = passwordEncoder;
    }

    public UserAccount register(UserAccount user) {
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        return userAccountRepository.save(user);
    }

    public UserAccount loginUser(String identifier, String rawPassword) {
        if (identifier == null || rawPassword == null) return null;
        String cleanIdentifier = identifier.trim();
        String cleanPassword = rawPassword.trim();
        if (cleanIdentifier.isEmpty() || cleanPassword.isEmpty()) return null;

        // 1. Check by email or username (case-insensitive email)
        UserAccount user = userAccountRepository.findByEmail(cleanIdentifier);
        if (user == null) {
            user = userAccountRepository.findByUsername(cleanIdentifier);
        }
        if (user == null && cleanIdentifier.contains("@")) {
            user = userAccountRepository.findByEmailIgnoreCase(cleanIdentifier);
        }

        if (user == null || !user.isEnabled()) {
            return null;
        }

        String dbPass = user.getPassword();
        if (dbPass == null) return null;

        // Demo / seed: plain-text password
        if (cleanPassword.equals(dbPass)) {
            return user;
        }
        // Registered accounts: BCrypt hash
        try {
            if (passwordEncoder.matches(cleanPassword, dbPass)) {
                return user;
            }
        } catch (Exception ignored) {
        }
        return null;
    }

    public boolean login(String identifier, String rawPassword) {
        return loginUser(identifier, rawPassword) != null;
    }

    public UserAccount findByUsernameOrEmail(String identifier) {
        if (identifier == null) return null;
        String clean = identifier.trim();
        UserAccount u = userAccountRepository.findByEmail(clean);
        if (u == null) {
            u = userAccountRepository.findByUsername(clean);
        }
        return u;
    }

    public UserAccount findByUsername(String username) {
        return userAccountRepository.findByUsername(username);
    }
}
