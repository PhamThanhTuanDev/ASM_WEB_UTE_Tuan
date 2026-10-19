package ute.edu.service;

import jakarta.mail.Session;
import jakarta.mail.internet.MimeMessage;
import org.junit.jupiter.api.Test;
import org.springframework.mail.javamail.JavaMailSender;
import java.util.Properties;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class MailerServiceImpTest {
    @Test
    void usesConfiguredSenderAndDeliversQueuedMessageWithoutRealSmtp() throws Exception {
        var sender = mock(JavaMailSender.class);
        var message = new MimeMessage(Session.getInstance(new Properties()));
        when(sender.createMimeMessage()).thenReturn(message);
        var service = new MailerServiceImp(sender, "configured@example.com");
        service.queue(new String[]{"student@example.com"}, "Đăng ký đã duyệt", "<p>Thành công</p>");
        verifyNoInteractions(sender);
        service.run();
        assertEquals("configured@example.com", message.getFrom()[0].toString());
        assertEquals("configured@example.com", message.getReplyTo()[0].toString());
        assertEquals("student@example.com", message.getAllRecipients()[0].toString());
        assertEquals("Đăng ký đã duyệt", message.getSubject());
        verify(sender).send(message);
        service.run();
        verify(sender, times(1)).send(message);
    }

    @Test
    void retriesFailedMailAtMostThreeTimesThenDropsIt() throws Exception {
        var sender = mock(JavaMailSender.class);
        when(sender.createMimeMessage()).thenAnswer(call -> new MimeMessage(Session.getInstance(new Properties())));
        doThrow(new org.springframework.mail.MailSendException("SMTP không phản hồi"))
                .when(sender).send(any(MimeMessage.class));
        var service = new MailerServiceImp(sender, "configured@example.com");
        service.queue(new String[]{"student@example.com"}, "Kết quả hội đồng", "<p>Điểm</p>");
        for (int i = 0; i < 5; i++) {
            service.run();
        }
        verify(sender, times(MailerServiceImp.MAX_ATTEMPTS)).send(any(MimeMessage.class));
        assertTrue(service.listEmails.isEmpty());
    }
}
