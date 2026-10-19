package ute.edu.service;

import org.junit.jupiter.api.Test;
import ute.edu.entity.*;
import ute.edu.enums.PeriodStatus;
import ute.edu.repository.*;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class CouncilScheduleTest {
    @Test
    void councilCreationRequiresOpenActivePeriodAndUnexpiredReportDate() {
        var period = new RegistrationPeriod();
        period.setStatus(PeriodStatus.OPEN);
        assertFalse(RegistrationPeriodService.canCreateCouncil(period));
        period.setCouncilReportDate(RegistrationPeriodService.today());
        assertTrue(RegistrationPeriodService.canCreateCouncil(period));
        period.setCouncilReportDate(RegistrationPeriodService.today().minusDays(1));
        assertFalse(RegistrationPeriodService.canCreateCouncil(period));
        period.setCouncilReportDate(RegistrationPeriodService.today().plusDays(1));
        period.setStatus(PeriodStatus.CLOSED);
        assertFalse(RegistrationPeriodService.canCreateCouncil(period));
        period.setStatus(PeriodStatus.OPEN);
        period.setActive(false);
        assertFalse(RegistrationPeriodService.canCreateCouncil(period));
        assertFalse(RegistrationPeriodService.canCreateCouncil(null));
    }

    @Test
    void lecturerWindowRejectsExpiredFutureAndClosedPeriods() {
        var period = new RegistrationPeriod();
        var today = RegistrationPeriodService.today();
        period.setStatus(PeriodStatus.OPEN);
        period.setLecturerStartDate(today);
        period.setLecturerEndDate(today);
        assertTrue(RegistrationPeriodService.isLecturerWindow(period));
        period.setLecturerEndDate(today.minusDays(1));
        assertFalse(RegistrationPeriodService.isLecturerWindow(period));
        period.setLecturerStartDate(today.plusDays(1));
        period.setLecturerEndDate(today.plusDays(2));
        assertFalse(RegistrationPeriodService.isLecturerWindow(period));
        period.setLecturerStartDate(today);
        period.setStatus(PeriodStatus.CLOSED);
        assertFalse(RegistrationPeriodService.isLecturerWindow(period));
        period.setStatus(PeriodStatus.OPEN);
        period.setActive(false);
        assertFalse(RegistrationPeriodService.isLecturerWindow(period));
        assertFalse(RegistrationPeriodService.isLecturerWindow(null));
    }

    @Test
    void councilUsesPeriodDateEvenWhenSubmittedDateDiffers() {
        var councils = mock(ReviewCouncilRepository.class);
        var members = mock(ReviewCouncilMemberRepository.class);
        var lecturers = mock(LectureRepository.class);
        var service = new CouncilService(councils, members, mock(TopicAssignmentRepository.class),
                mock(TopicRegistrationRepository.class), lecturers, mock(TopicSupervisorRepository.class),
                mock(TopicEvaluationRepository.class));
        var period = new RegistrationPeriod();
        period.setCouncilReportDate(RegistrationPeriodService.today().plusDays(1));
        period.setStatus(PeriodStatus.OPEN);
        var department = new Department();
        department.setId(1L);
        var council = new ReviewCouncil();
        council.setCode("HD-NEW");
        council.setRegistrationPeriod(period);
        council.setDepartment(department);
        council.setCouncilDate(LocalDate.of(2026, 10, 17));
        for (long id = 1; id <= 3; id++) {
            var lecturer = new Lecture();
            lecturer.setDepartment(department);
            when(lecturers.findById(id)).thenReturn(Optional.of(lecturer));
        }
        when(councils.save(council)).thenAnswer(call -> {
            council.setId(10L);
            return council;
        });
        when(members.findByCouncilId(10L)).thenReturn(List.of(
                new ReviewCouncilMember(), new ReviewCouncilMember(), new ReviewCouncilMember()));
        assertEquals(period.getCouncilReportDate(),
                service.createCouncil(council, 1L, 2L, List.of(3L)).getCouncilDate());
    }

    @Test
    void councilRequiresPeriodWithReportDateBeforeWriting() {
        var councils = mock(ReviewCouncilRepository.class);
        var service = new CouncilService(councils, mock(ReviewCouncilMemberRepository.class),
                mock(TopicAssignmentRepository.class), mock(TopicRegistrationRepository.class),
                mock(LectureRepository.class), mock(TopicSupervisorRepository.class),
                mock(TopicEvaluationRepository.class));
        var council = new ReviewCouncil();
        council.setCode("HD-NEW");
        assertThrows(IllegalArgumentException.class, () -> service.createCouncil(council, 1L, 2L, List.of(3L)));
        council.setRegistrationPeriod(new RegistrationPeriod());
        assertThrows(IllegalArgumentException.class, () -> service.createCouncil(council, 1L, 2L, List.of(3L)));
        verify(councils, never()).save(any());
    }

    @Test
    void duplicateCodeIsTrimmedAndRejectedBeforeAnyWrites() {
        var councils = mock(ReviewCouncilRepository.class);
        var members = mock(ReviewCouncilMemberRepository.class);
        var service = new CouncilService(councils, members,
                mock(TopicAssignmentRepository.class), mock(TopicRegistrationRepository.class),
                mock(LectureRepository.class), mock(TopicSupervisorRepository.class),
                mock(TopicEvaluationRepository.class));
        var council = new ReviewCouncil();
        council.setCode("  demo  ");
        when(councils.existsByCodeIgnoreCase("demo")).thenReturn(true);
        var error = assertThrows(IllegalArgumentException.class,
                () -> service.createCouncil(council, 1L, 2L, List.of(3L)));
        assertTrue(error.getMessage().contains("demo"));
        verify(councils, never()).save(any());
        verifyNoInteractions(members);
    }

    @Test
    void studentWindowIncludesBothBoundaryDatesAndRequiresOpenActivePeriod() {
        var period = new RegistrationPeriod();
        period.setStatus(PeriodStatus.OPEN);
        period.setStudentStartDate(RegistrationPeriodService.today());
        period.setStudentEndDate(RegistrationPeriodService.today());
        assertTrue(RegistrationPeriodService.isStudentWindow(period));
        period.setActive(false);
        assertFalse(RegistrationPeriodService.isStudentWindow(period));
        period.setActive(true);
        period.setStatus(PeriodStatus.CLOSED);
        assertFalse(RegistrationPeriodService.isStudentWindow(period));
        period.setStatus(PeriodStatus.OPEN);
        period.setStudentEndDate(RegistrationPeriodService.today().minusDays(1));
        assertThrows(IllegalStateException.class, () -> RegistrationPeriodService.requireStudentWindow(period));
        assertFalse(RegistrationPeriodService.isStudentWindow(null));
    }
}
