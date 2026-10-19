package ute.edu.service;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.transaction.support.TransactionSynchronization;
import org.springframework.transaction.support.TransactionSynchronizationManager;
import ute.edu.entity.*;
import ute.edu.enums.*;
import ute.edu.repository.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.AdditionalMatchers.aryEq;
import static org.mockito.Mockito.*;

class RegistrationApprovalMailTest {
    private final TopicRegistrationRepository registrations = mock(TopicRegistrationRepository.class);
    private final StudentGroupRepository groups = mock(StudentGroupRepository.class);
    private final TopicRepository topics = mock(TopicRepository.class);
    private final MailerService mailer = mock(MailerService.class);
    private final TopicRegistrationService service = new TopicRegistrationService(registrations, groups, topics, mailer);
    private TopicRegistration registration;
    private StudentGroup group;

    @BeforeEach
    void preparePendingRegistration() {
        TransactionSynchronizationManager.initSynchronization();
        var period = new RegistrationPeriod();
        period.setStatus(PeriodStatus.OPEN);
        period.setName("Đợt kiểm thử");
        var topic = new Topic();
        topic.setId(2L);
        topic.setCode("DT002");
        topic.setTitle("Đề tài <script>alert(1)</script>");
        topic.setStatus(TopicStatus.PUBLISHED);
        topic.setRegistrationPeriod(period);
        group = new StudentGroup();
        group.setId(3L);
        group.setName("Nhóm thử nghiệm");
        group.setMembers(new ArrayList<>(List.of(member("one@example.com"), member("two@example.com"))));
        registration = new TopicRegistration();
        registration.setId(1L);
        registration.setTopic(topic);
        registration.setGroup(group);
        registration.setStatus(RegistrationStatus.PENDING);
        when(registrations.findForUpdate(1L)).thenReturn(Optional.of(registration));
        when(topics.findForUpdate(2L)).thenReturn(Optional.of(topic));
        when(groups.findForUpdate(3L)).thenReturn(Optional.of(group));
        when(registrations.save(registration)).thenReturn(registration);
    }

    @AfterEach
    void clearTransactionCallbacks() {
        TransactionSynchronizationManager.clearSynchronization();
    }

    private StudentGroupMember member(String email) {
        var user = new UserAccount();
        user.setEmail(email);
        var student = new Student();
        student.setUser(user);
        var member = new StudentGroupMember();
        member.setStudent(student);
        return member;
    }

    @Test
    void queuesAllMembersOnlyAfterCommitAndEscapesHtml() {
        service.updateStatus(1L, RegistrationStatus.APPROVED, null, null);
        assertEquals(RegistrationStatus.APPROVED, registration.getStatus());
        verifyNoInteractions(mailer);
        var callbacks = TransactionSynchronizationManager.getSynchronizations();
        assertEquals(1, callbacks.size());
        callbacks.forEach(TransactionSynchronization::afterCommit);
        verify(mailer).queue(aryEq(new String[]{"one@example.com", "two@example.com"}),
                eq("Đăng ký đề tài đã được duyệt: DT002"), argThat(body ->
                        body.contains("Nhóm thử nghiệm") && body.contains("Đợt kiểm thử")
                        && body.contains("&lt;script&gt;") && !body.contains("<script>")));
        assertThrows(IllegalStateException.class,
                () -> service.updateStatus(1L, RegistrationStatus.APPROVED, null, null));
        verifyNoMoreInteractions(mailer);
    }

    @Test
    void rollbackDoesNotQueueMail() {
        service.updateStatus(1L, RegistrationStatus.APPROVED, null, null);
        TransactionSynchronizationManager.getSynchronizations()
                .forEach(callback -> callback.afterCompletion(TransactionSynchronization.STATUS_ROLLED_BACK));
        verifyNoInteractions(mailer);
    }

    @Test
    void rejectionNotifiesAllMembersAfterCommitWithEscapedReason() {
        service.updateStatus(1L, RegistrationStatus.REJECTED, null, "Cần điều chỉnh <b>nội dung</b>");
        verifyNoInteractions(mailer);
        TransactionSynchronizationManager.getSynchronizations().forEach(TransactionSynchronization::afterCommit);
        verify(mailer).queue(aryEq(new String[]{"one@example.com", "two@example.com"}),
                eq("Đăng ký đề tài bị từ chối: DT002"), argThat(body ->
                        body.contains("Cần điều chỉnh &lt;b&gt;nội dung&lt;/b&gt;")
                        && !body.contains("đã được giảng viên chấp nhận")));
    }

    @Test
    void rejectionRollbackDoesNotSendMail() {
        service.updateStatus(1L, RegistrationStatus.REJECTED, null, "Chưa phù hợp hướng nghiên cứu");
        TransactionSynchronizationManager.getSynchronizations()
                .forEach(callback -> callback.afterCompletion(TransactionSynchronization.STATUS_ROLLED_BACK));
        verifyNoInteractions(mailer);
    }

    @Test
    void rejectionWithoutReasonIsRefusedAndSendsNoMail() {
        assertThrows(IllegalArgumentException.class,
                () -> service.updateStatus(1L, RegistrationStatus.REJECTED, null, " "));
        assertThrows(IllegalArgumentException.class,
                () -> service.updateStatus(1L, RegistrationStatus.REJECTED, null, null));
        verifyNoInteractions(mailer);
    }

    @Test
    void failedSaveDoesNotScheduleMail() {
        when(registrations.save(registration)).thenThrow(new IllegalStateException("Database unavailable"));
        assertThrows(IllegalStateException.class,
                () -> service.updateStatus(1L, RegistrationStatus.APPROVED, null, null));
        assertTrue(TransactionSynchronizationManager.getSynchronizations().isEmpty());
        verifyNoInteractions(mailer);
    }

    @Test
    void duplicateAndBlankEmailsAreNotQueuedTwice() {
        group.setMembers(List.of(member(" one@example.com "), member("one@example.com"), member(" ")));
        service.updateStatus(1L, RegistrationStatus.APPROVED, null, null);
        TransactionSynchronizationManager.getSynchronizations().forEach(TransactionSynchronization::afterCommit);
        verify(mailer).queue(aryEq(new String[]{"one@example.com"}), anyString(), anyString());
    }
}
