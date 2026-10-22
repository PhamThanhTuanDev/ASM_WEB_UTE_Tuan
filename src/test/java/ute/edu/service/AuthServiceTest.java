package ute.edu.service;

import org.junit.jupiter.api.Test;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import ute.edu.entity.UserAccount;
import ute.edu.repository.*;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class AuthServiceTest {
    @Test
    void passwordWhitespaceIsSignificantButIdentifierWhitespaceIsIgnored() {
        var users = mock(UserAccountRepository.class);
        var encoder = new BCryptPasswordEncoder(4);
        var service = new AuthService(users, encoder, mock(StudentRepository.class), mock(DepartmentRepository.class));
        var user = new UserAccount();
        user.setEnabled(true);
        user.setPassword(encoder.encode(" 123456 "));
        when(users.findByUsername("student")).thenReturn(user);
        assertSame(user, service.loginUser(" student ", " 123456 "));
        assertNull(service.loginUser("student", "123456"));
        user.setEnabled(false);
        assertNull(service.loginUser("student", " 123456 "));
    }
}
