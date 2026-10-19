package ute.edu.service;

import org.junit.jupiter.api.Test;
import ute.edu.entity.*;
import ute.edu.enums.RegistrationStatus;
import ute.edu.repository.*;
import java.util.List;
import java.util.Optional;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class GroupMembershipRulesTest {
    private final StudentGroupRepository groups = mock(StudentGroupRepository.class);
    private final StudentGroupMemberRepository members = mock(StudentGroupMemberRepository.class);
    private final StudentRepository students = mock(StudentRepository.class);
    private final TopicRegistrationRepository registrations = mock(TopicRegistrationRepository.class);
    private final StudentGroupService service = new StudentGroupService(groups, members, students, registrations);

    @Test
    void addingStudentAlreadyInSamePeriodFailsBeforeSaving() {
        var period = new RegistrationPeriod();
        period.setId(10L);
        period.setStatus(ute.edu.enums.PeriodStatus.OPEN);
        period.setStudentStartDate(RegistrationPeriodService.today());
        period.setStudentEndDate(RegistrationPeriodService.today());
        var department = new Department();
        department.setId(1L);
        var leader = new Student();
        leader.setDepartment(department);
        var student = new Student();
        student.setId(2L);
        student.setDepartment(department);
        student.setUser(new UserAccount());
        var group = new StudentGroup();
        group.setId(1L);
        group.setLeader(leader);
        group.setRegistrationPeriod(period);
        when(groups.findForUpdate(1L)).thenReturn(Optional.of(group));
        when(students.findByStudentCode("123")).thenReturn(Optional.of(student));
        when(students.findForUpdate(2L)).thenReturn(Optional.of(student));
        when(members.existsByStudentIdAndGroupRegistrationPeriodId(2L, 10L)).thenReturn(true);
        assertThrows(IllegalStateException.class, () -> service.addMemberByCode(1L, "123"));
        verify(members, never()).save(any());
    }

    @Test
    void groupWithoutPeriodCannotAddMembers() {
        var group = new StudentGroup();
        group.setId(1L);
        when(groups.findForUpdate(1L)).thenReturn(Optional.of(group));
        assertThrows(IllegalStateException.class, () -> service.addMemberByCode(1L, "123"));
        verifyNoInteractions(students);
        verify(members, never()).save(any());
    }

    @Test
    void fullGroupCannotAddOrRemoveMembers() {
        var group = new StudentGroup();
        group.setId(1L);
        when(groups.findForUpdate(1L)).thenReturn(Optional.of(group));
        when(members.findByGroupId(1L)).thenReturn(List.of(
                new StudentGroupMember(), new StudentGroupMember(), new StudentGroupMember()));
        assertFalse(service.canChangeMembers(group));
        assertThrows(IllegalStateException.class, () -> service.addMemberByCode(1L, "123"));
        assertThrows(IllegalStateException.class, () -> service.removeMember(1L, 2L));
        verify(members, never()).save(any());
        verify(members, never()).deleteByGroupIdAndStudentId(anyLong(), anyLong());
    }

    @Test
    void pendingRegistrationLocksMembersBeforeTopicApproval() {
        var group = new StudentGroup();
        group.setId(1L);
        when(groups.findForUpdate(1L)).thenReturn(Optional.of(group));
        when(members.findByGroupId(1L)).thenReturn(List.of(new StudentGroupMember()));
        assertTrue(service.canChangeMembers(group));
        when(registrations.existsByGroupIdAndStatusIn(1L,
                List.of(RegistrationStatus.PENDING, RegistrationStatus.APPROVED))).thenReturn(true);
        assertFalse(service.canChangeMembers(group));
        assertThrows(IllegalStateException.class, () -> service.addMemberByCode(1L, "123"));
        assertThrows(IllegalStateException.class, () -> service.removeMember(1L, 2L));
    }
}
