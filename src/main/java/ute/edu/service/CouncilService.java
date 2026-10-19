package ute.edu.service;

import java.util.List;
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

        Lecture chairman = lectureRepository.findById(chairmanId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy Chủ tịch"));
        Lecture secretary = lectureRepository.findById(secretaryId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy Thư ký"));

        if (council.getDepartment() == null) {
            throw new IllegalArgumentException("Khoa quản lý hội đồng là bắt buộc");
        }
        Long departmentId = council.getDepartment().getId();
        if (!departmentId.equals(chairman.getDepartment().getId())
                || !departmentId.equals(secretary.getDepartment().getId())) {
            throw new IllegalArgumentException("Chủ tịch và Thư ký phải thuộc khoa quản lý của hội đồng");
        }

        council.setChairman(chairman);
        council.setSecretary(secretary);
        council.setStatus(CouncilStatus.PLANNED);
        ReviewCouncil saved = councilRepository.save(council);

        // Add chairman as member
        ReviewCouncilMember mChairman = new ReviewCouncilMember();
        mChairman.setCouncil(saved);
        mChairman.setLecturer(chairman);
        mChairman.setRole(CommitteeRole.CHAIRMAN);
        memberRepository.save(mChairman);

        // Add secretary as member
        ReviewCouncilMember mSecretary = new ReviewCouncilMember();
        mSecretary.setCouncil(saved);
        mSecretary.setLecturer(secretary);
        mSecretary.setRole(CommitteeRole.SECRETARY);
        memberRepository.save(mSecretary);

        // Add other members (3 to 5 total)
        if (memberIds != null) {
            for (Long mId : new java.util.LinkedHashSet<>(memberIds)) {
                if (mId != null && !mId.equals(chairmanId) && !mId.equals(secretaryId)) {
                    Lecture mem = lectureRepository.findById(mId).orElse(null);
                    if (mem != null) {
                        if (!departmentId.equals(mem.getDepartment().getId())) {
                            throw new IllegalArgumentException("Tất cả Ủy viên phải thuộc khoa quản lý của hội đồng");
                        }
                        ReviewCouncilMember m = new ReviewCouncilMember();
                        m.setCouncil(saved);
                        m.setLecturer(mem);
                        m.setRole(CommitteeRole.MEMBER);
                        memberRepository.save(m);
                    }
                }
            }
        }

        long totalMembers = memberRepository.findByCouncilId(saved.getId()).size();
        if (totalMembers < 3 || totalMembers > 5) {
            throw new IllegalArgumentException(
                    "Hội đồng phải có từ 3 đến 5 giảng viên (Hiện có: " + totalMembers + ")");
        }

        return saved;
    }

    @Transactional
    /** Phân công đăng ký đề tài vào hội đồng sau khi kiểm tra toàn bộ điều kiện. */
    public TopicAssignment assignTopic(Long councilId, Long registrationId) {
        // Dùng cùng khóa hội đồng với luồng chốt điểm; khóa đăng ký ngăn hai hội đồng nhận cùng đề tài.
        ReviewCouncil council = councilRepository.findForUpdate(councilId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy Hội đồng"));
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
        return assignmentRepository.save(assignment);
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

        for (ReviewCouncilMember member : memberRepository.findByCouncilId(council.getId())) {
            Long lecturerId = member.getLecturer().getId();
            boolean isSupervisor = topic.getLecturer() != null
                    && topic.getLecturer().getId().equals(lecturerId);
            boolean isCoSupervisor = topic.getCoLecturer() != null
                    && topic.getCoLecturer().getId().equals(lecturerId);
            boolean isAssignedSupervisor = supervisorRepository.existsByTopicIdAndLecturerId(topic.getId(), lecturerId);
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
