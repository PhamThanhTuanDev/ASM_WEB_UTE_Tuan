package ute.edu.service;

import java.util.List;
import java.time.LocalTime;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ute.edu.entity.*;
import ute.edu.enums.CommitteeRole;
import ute.edu.enums.CouncilStatus;
import ute.edu.enums.AssignmentStatus;
import ute.edu.repository.*;

/**
 * Service quản lý hội đồng, thành viên hội đồng và phân công đề tài.
 */
@Service
public class CouncilService {
    private final ReviewCouncilRepository councilRepository;
    private final ReviewCouncilMemberRepository memberRepository;
    private final TopicAssignmentRepository assignmentRepository;
    private final TopicRegistrationRepository registrationRepository;
    private final LectureRepository lectureRepository;
    private final TopicSupervisorRepository supervisorRepository;
    private final TopicEvaluationRepository evaluationRepository;

    public CouncilService(ReviewCouncilRepository councilRepository,
            ReviewCouncilMemberRepository memberRepository,
            TopicAssignmentRepository assignmentRepository,
            TopicRegistrationRepository registrationRepository,
            LectureRepository lectureRepository,
            TopicSupervisorRepository supervisorRepository,
            TopicEvaluationRepository evaluationRepository) {
        this.councilRepository = councilRepository;
        this.memberRepository = memberRepository;
        this.assignmentRepository = assignmentRepository;
        this.registrationRepository = registrationRepository;
        this.lectureRepository = lectureRepository;
        this.supervisorRepository = supervisorRepository;
        this.evaluationRepository = evaluationRepository;
    }

    public List<ReviewCouncil> getAll() {
        return councilRepository.findAll(org.springframework.data.domain.Sort.by(
                org.springframework.data.domain.Sort.Direction.DESC, "createdAt", "id"));
    }

    public List<ReviewCouncil> getByPeriod(Long periodId) {
        return councilRepository.findByRegistrationPeriodIdOrderByCreatedAtDescIdDesc(periodId);
    }

    public ReviewCouncil findById(Long id) {
        return councilRepository.findById(id).orElse(null);
    }

    @Transactional
    /**
     * Tạo hội đồng, kiểm tra khoa và bảo đảm có từ 3 đến 5 thành viên.
     */
    public ReviewCouncil createCouncil(ReviewCouncil council, Long chairmanId, Long secretaryId, List<Long> memberIds) {
        if (council.getId() != null)
            throw new IllegalArgumentException("Không thể ghi đè hội đồng hiện có qua thao tác tạo mới!");
        String code = council.getCode() == null ? "" : council.getCode().trim();
        if (code.isEmpty()) {
            throw new IllegalArgumentException("Vui lòng nhập mã hội đồng!");
        }
        if (councilRepository.existsByCodeIgnoreCase(code)) {
            throw new IllegalArgumentException("Mã hội đồng \"" + code + "\" đã tồn tại. Vui lòng nhập mã khác!");
        }
        council.setCode(code);
        RegistrationPeriod period = council.getRegistrationPeriod();
        if (period == null || period.getCouncilReportDate() == null) {
            throw new IllegalArgumentException("Đợt đăng ký chưa thiết lập ngày báo cáo hội đồng!");
        }
        if (!RegistrationPeriodService.canCreateCouncil(period)) {
            throw new IllegalArgumentException("Đợt đăng ký đã đóng hoặc đã qua ngày báo cáo hội đồng!");
        }
        council.setCouncilDate(period.getCouncilReportDate());
        if (chairmanId == null || secretaryId == null) {
            throw new IllegalArgumentException("Chủ tịch và Thư ký hội đồng là bắt buộc");
        }
        if (chairmanId.equals(secretaryId)) {
            throw new IllegalArgumentException("Chủ tịch và Thư ký không được trùng nhau");
        }

        if (council.getDepartment() == null) {
            throw new IllegalArgumentException("Khoa quản lý hội đồng là bắt buộc");
        }
        Long departmentId = council.getDepartment().getId();
        var selectedIds = new java.util.TreeSet<Long>();
        selectedIds.add(chairmanId);
        selectedIds.add(secretaryId);
        if (memberIds != null) memberIds.stream().filter(java.util.Objects::nonNull).forEach(selectedIds::add);
        if (selectedIds.size() < 3 || selectedIds.size() > 5) {
            throw new IllegalArgumentException("Hội đồng phải có từ 3 đến 5 giảng viên!");
        }
        var selectedLecturers = new java.util.LinkedHashMap<Long, Lecture>();
        // Lấy khóa theo cùng thứ tự để tránh deadlock khi hai yêu cầu có giảng viên chung.
        for (Long lecturerId : selectedIds) {
            Lecture lecturer = lectureRepository.findForUpdate(lecturerId)
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy giảng viên " + lecturerId));
            if (lecturer.getDepartment() == null || !departmentId.equals(lecturer.getDepartment().getId())) {
                throw new IllegalArgumentException("Tất cả thành viên phải thuộc khoa quản lý của hội đồng!");
            }
            selectedLecturers.put(lecturerId, lecturer);
        }
        for (Long lecturerId : selectedIds) {
            if (!memberRepository.findMembershipIdsForUpdate(lecturerId, period.getId()).isEmpty()) {
                throw new IllegalStateException("Giảng viên " + selectedLecturers.get(lecturerId).getUser().getFullName()
                        + " đã tham gia một hội đồng trong đợt đăng ký này. Vui lòng chọn giảng viên khác!");
            }
        }
        council.setChairman(selectedLecturers.get(chairmanId));
        council.setSecretary(selectedLecturers.get(secretaryId));
        council.setStatus(CouncilStatus.PLANNED);
        ReviewCouncil saved = councilRepository.save(council);
        for (var entry : selectedLecturers.entrySet()) {
            ReviewCouncilMember member = new ReviewCouncilMember();
            member.setCouncil(saved);
            member.setLecturer(entry.getValue());
            member.setRole(entry.getKey().equals(chairmanId) ? CommitteeRole.CHAIRMAN
                    : entry.getKey().equals(secretaryId) ? CommitteeRole.SECRETARY : CommitteeRole.MEMBER);
            memberRepository.save(member);
            saved.getMembers().add(member);
        }

        return saved;
    }

    @Transactional
    /** Phân công đăng ký đề tài vào hội đồng sau khi kiểm tra toàn bộ điều kiện. */
    public TopicAssignment assignTopic(Long councilId, Long registrationId, LocalTime startTime) {
        // Dùng cùng khóa hội đồng với luồng chốt điểm; khóa đăng ký ngăn hai hội đồng nhận cùng đề tài.
        ReviewCouncil council = councilRepository.findForUpdate(councilId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy Hội đồng"));
        LocalTime endTime = validateAvailableTime(councilId, startTime);
        TopicRegistration registration = registrationRepository.findForUpdate(registrationId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy Đăng ký đề tài"));
        if (council.getStatus() == CouncilStatus.COMPLETED || council.getRegistrationPeriod() == null
                || registration.getTopic().getRegistrationPeriod() == null
                || !council.getRegistrationPeriod().getId()
                        .equals(registration.getTopic().getRegistrationPeriod().getId())) {
            throw new IllegalStateException("Hội đồng phải cùng đợt với đề tài và chưa chốt điểm!");
        }

        if (council.getDepartment() == null || registration.getTopic() == null
                || registration.getTopic().getDepartment() == null
                || !council.getDepartment().getId().equals(registration.getTopic().getDepartment().getId())) {
            throw new IllegalArgumentException("Đề tài phải thuộc cùng khoa với hội đồng");
        }

        if (assignmentRepository.findFirstByTopicRegistrationId(registrationId).isPresent()) {
            throw new IllegalStateException("Đề tài đã được phân công cho một hội đồng khác!");
        }

        if (!isEligibleForCouncil(registration)) {
            throw new IllegalStateException(
                    "Nhóm chưa đủ điều kiện vào Hội đồng: đăng ký phải được duyệt và điểm quá trình của GVHD phải lớn hơn 5");
        }

        Topic topic = registration.getTopic();
        List<ReviewCouncilMember> councilMembers = memberRepository.findByCouncilId(councilId);
        if (councilMembers.size() < 3 || councilMembers.size() > 5) {
            throw new IllegalStateException("Hội đồng phải có từ 3 đến 5 thành viên!");
        }
        for (ReviewCouncilMember councilMember : councilMembers) {
            Long lecturerId = councilMember.getLecturer().getId();
            boolean isSupervisor = topic.getLecturer() != null
                    && topic.getLecturer().getId().equals(lecturerId);
            boolean isCoSupervisor = topic.getCoLecturer() != null
                    && topic.getCoLecturer().getId().equals(lecturerId);
            boolean isAssignedSupervisor = supervisorRepository.existsByTopicIdAndLecturerId(topic.getId(), lecturerId);

            if (isSupervisor || isCoSupervisor || isAssignedSupervisor) {
                String lecturerName = councilMember.getLecturer().getUser().getFullName();
                throw new IllegalStateException("Không thể phân công: " + lecturerName
                        + " là giảng viên hướng dẫn của đề tài " + topic.getCode()
                        + " và không được tham gia chấm đề tài này");
            }
        }

        TopicAssignment assignment = new TopicAssignment();
        assignment.setCouncil(council);
        assignment.setTopicRegistration(registration);
        assignment.setStatus(AssignmentStatus.ASSIGNED);
        assignment.setStartTime(startTime);
        assignment.setEndTime(endTime);
        return assignmentRepository.save(assignment);
    }

    private LocalTime validateAvailableTime(Long councilId, LocalTime startTime) {
        if (startTime == null || startTime.isBefore(LocalTime.of(7, 0))
                || startTime.isAfter(LocalTime.of(17, 0)) || startTime.getMinute() != 0
                || startTime.getSecond() != 0 || startTime.getNano() != 0) {
            throw new IllegalArgumentException("Vui lòng chọn khung giờ 1 tiếng từ 07:00 đến 18:00!");
        }
        LocalTime endTime = startTime.plusHours(1);
        // Khóa dòng hội đồng được giữ đến khi commit, ngăn hai yêu cầu cùng chiếm một khung giờ.
        if (assignmentRepository.existsByCouncilIdAndStartTimeLessThanAndEndTimeGreaterThan(
                councilId, endTime, startTime)) {
            throw new IllegalStateException("Khung giờ này đã được phân công cho đề tài khác trong hội đồng. Vui lòng chọn giờ khác!");
        }
        return endTime;
    }

    public static final class ReportTimeSlot {
        private final LocalTime startTime;
        private final LocalTime endTime;
        private final boolean available;

        public ReportTimeSlot(LocalTime startTime, LocalTime endTime, boolean available) {
            this.startTime = startTime;
            this.endTime = endTime;
            this.available = available;
        }

        public LocalTime getStartTime() { return startTime; }
        public String getLabel() { return startTime + " - " + endTime; }
        public boolean isAvailable() { return available; }
    }

    /** Dùng cùng danh sách phân công cho cả bảng lịch và các lựa chọn bị khóa trên giao diện. */
    public List<ReportTimeSlot> getReportTimeSlots(List<TopicAssignment> assignments) {
        var slots = new java.util.ArrayList<ReportTimeSlot>();
        for (LocalTime start = LocalTime.of(7, 0); start.isBefore(LocalTime.of(18, 0)); start = start.plusHours(1)) {
            LocalTime from = start;
            LocalTime to = start.plusHours(1);
            boolean occupied = assignments.stream().anyMatch(a -> a.getStartTime() != null && a.getEndTime() != null
                    && a.getStartTime().isBefore(to) && a.getEndTime().isAfter(from));
            slots.add(new ReportTimeSlot(from, to, !occupied));
        }
        return slots;
    }

    /**
     * Bản lọc hàng loạt của isEligibleForCouncil (cùng điều kiện): lấy điểm quá trình của cả danh sách
     * bằng 1 câu truy vấn thay vì mỗi đăng ký một câu.
     */
    public List<TopicRegistration> filterEligibleForCouncil(List<TopicRegistration> registrations) {
        List<TopicRegistration> candidates = registrations.stream()
                .filter(r -> r != null && r.getTopic() != null && r.getTopic().getLecturer() != null
                        && r.getStatus() == ute.edu.enums.RegistrationStatus.APPROVED)
                .toList();
        if (candidates.isEmpty())
            return List.of();
        java.util.Map<String, Double> scores = new java.util.HashMap<>();
        for (TopicEvaluation evaluation : evaluationRepository.findByTopicIdIn(
                candidates.stream().map(r -> r.getTopic().getId()).collect(java.util.stream.Collectors.toSet()))) {
            scores.put(evaluation.getTopic().getId() + ":" + evaluation.getReviewer().getId(), evaluation.getScore());
        }
        return candidates.stream().filter(r -> {
            Double score = scores.get(r.getTopic().getId() + ":" + r.getTopic().getLecturer().getId());
            return score != null && Double.isFinite(score) && score <= 10 && score > 5.0;
        }).toList();
    }

    /** Kiểm tra đăng ký đã duyệt và điểm quá trình GVHD chính lớn hơn 5. */
    public boolean isEligibleForCouncil(TopicRegistration registration) {
        if (registration == null || registration.getTopic() == null)
            return false;
        if (registration.getStatus() != ute.edu.enums.RegistrationStatus.APPROVED)
            return false;
        Topic topic = registration.getTopic();
        if (topic.getLecturer() == null)
            return false;

        TopicEvaluation supervisorEvaluation = evaluationRepository
                .findByTopicIdAndReviewerId(topic.getId(), topic.getLecturer().getId())
                .orElse(null);
        return supervisorEvaluation != null
                && supervisorEvaluation.getScore() != null
                && Double.isFinite(supervisorEvaluation.getScore()) && supervisorEvaluation.getScore() <= 10
                && supervisorEvaluation.getScore() > 5.0;
    }

    /**
     * Kiểm tra điều kiện: cùng khoa, đăng ký đã duyệt, và GVHD không là thành viên
     * hội đồng.
     */
    public boolean canAssignToCouncil(ReviewCouncil council, TopicRegistration registration) {
        if (council == null || !isEligibleForCouncil(registration))
            return false;

        Topic topic = registration.getTopic();
        if (council.getStatus() == CouncilStatus.COMPLETED || council.getRegistrationPeriod() == null
                || topic.getRegistrationPeriod() == null
                || !council.getRegistrationPeriod().getId().equals(topic.getRegistrationPeriod().getId())
                || assignmentRepository.existsByTopicRegistrationId(registration.getId()))
            return false;
        if (council.getDepartment() == null || topic.getDepartment() == null
                || !council.getDepartment().getId().equals(topic.getDepartment().getId())) {
            return false;
        }

        // Lấy 1 lần danh sách GVHD của đề tài thay vì hỏi CSDL cho từng thành viên hội đồng
        java.util.Set<Long> supervisorIds = supervisorRepository.findByTopicId(topic.getId()).stream()
                .map(ts -> ts.getLecturer().getId()).collect(java.util.stream.Collectors.toSet());
        for (ReviewCouncilMember member : memberRepository.findByCouncilId(council.getId())) {
            Long lecturerId = member.getLecturer().getId();
            boolean isSupervisor = topic.getLecturer() != null
                    && topic.getLecturer().getId().equals(lecturerId);
            boolean isCoSupervisor = topic.getCoLecturer() != null
                    && topic.getCoLecturer().getId().equals(lecturerId);
            boolean isAssignedSupervisor = supervisorIds.contains(lecturerId);
            if (isSupervisor || isCoSupervisor || isAssignedSupervisor)
                return false;
        }
        return true;
    }

    /** Lấy danh sách thành viên của một hội đồng. */
    public List<ReviewCouncilMember> getMembers(Long councilId) {
        return memberRepository.findByCouncilId(councilId);
    }

    /** Lấy các đề tài đã được phân công cho hội đồng. */
    public List<TopicAssignment> getAssignments(Long councilId) {
        return assignmentRepository.findByCouncilIdOrderByAssignedAtDescIdDesc(councilId);
    }

    /** Lấy các hội đồng mà một giảng viên đang tham gia. */
    public List<ReviewCouncilMember> getCouncilsForLecturer(Long lecturerId) {
        return memberRepository.findByLecturerId(lecturerId).stream()
                .sorted(java.util.Comparator.comparing((ReviewCouncilMember member) -> member.getCouncil().getCreatedAt(),
                        java.util.Comparator.nullsLast(java.util.Comparator.reverseOrder()))
                        .thenComparing(member -> member.getCouncil().getId(), java.util.Comparator.reverseOrder()))
                .toList();
    }

    @Transactional
    /** Xóa hội đồng cùng các thành viên và phân công liên quan. */
    public void deleteCouncil(Long councilId) {
        ReviewCouncil council = findById(councilId);
        if (council != null && council.getStatus() == CouncilStatus.COMPLETED) {
            throw new IllegalStateException("Không được xóa hội đồng đã công bố kết quả!");
        }
        assignmentRepository.deleteByCouncilId(councilId);
        memberRepository.deleteByCouncilId(councilId);
        councilRepository.deleteById(councilId);
    }
}
