package ute.edu.service;

import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ute.edu.entity.*;
import ute.edu.enums.CommitteeRole;
import ute.edu.enums.CouncilStatus;
import ute.edu.enums.AssignmentStatus;
import ute.edu.repository.*;

@Service
/** Service quản lý hội đồng, thành viên hội đồng và phân công đề tài. */
public class CouncilService {
    private final ReviewCouncilRepository councilRepository;
    private final ReviewCouncilMemberRepository memberRepository;
    private final TopicAssignmentRepository assignmentRepository;
    private final TopicRegistrationRepository registrationRepository;
    private final LectureRepository lectureRepository;
    private final TopicSupervisorRepository supervisorRepository;
    private final ReportRepository reportRepository;
    private final TopicEvaluationRepository evaluationRepository;

    public CouncilService(ReviewCouncilRepository councilRepository,
                          ReviewCouncilMemberRepository memberRepository,
                          TopicAssignmentRepository assignmentRepository,
                          TopicRegistrationRepository registrationRepository,
                          LectureRepository lectureRepository,
                          TopicSupervisorRepository supervisorRepository,
                          ReportRepository reportRepository,
                          TopicEvaluationRepository evaluationRepository) {
        this.councilRepository = councilRepository;
        this.memberRepository = memberRepository;
        this.assignmentRepository = assignmentRepository;
        this.registrationRepository = registrationRepository;
        this.lectureRepository = lectureRepository;
        this.supervisorRepository = supervisorRepository;
        this.reportRepository = reportRepository;
        this.evaluationRepository = evaluationRepository;
    }

    public List<ReviewCouncil> getAll() {
        return councilRepository.findAll();
    }

    public List<ReviewCouncil> getByPeriod(Long periodId) {
        return councilRepository.findByRegistrationPeriodId(periodId);
    }

    public ReviewCouncil findById(Long id) {
        return councilRepository.findById(id).orElse(null);
    }

    @Transactional
    /** Tạo hội đồng, kiểm tra khoa và bảo đảm có từ 3 đến 5 thành viên. */
    public ReviewCouncil createCouncil(ReviewCouncil council, Long chairmanId, Long secretaryId, List<Long> memberIds) {
        if (chairmanId == null || secretaryId == null) {
            throw new IllegalArgumentException("Chủ tịch và Thư ký hội đồng là bắt buộc");
        }
        if (chairmanId.equals(secretaryId)) {
            throw new IllegalArgumentException("Chủ tịch và Thư ký không được trùng nhau");
        }
        
        Lecture chairman = lectureRepository.findById(chairmanId).orElseThrow(() -> new IllegalArgumentException("Không tìm thấy Chủ tịch"));
        Lecture secretary = lectureRepository.findById(secretaryId).orElseThrow(() -> new IllegalArgumentException("Không tìm thấy Thư ký"));

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
        if (council.getStatus() == null) {
            council.setStatus(CouncilStatus.PLANNED);
        }
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
            for (Long mId : memberIds) {
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
            throw new IllegalArgumentException("Hội đồng phải có từ 3 đến 5 giảng viên (Hiện có: " + totalMembers + ")");
        }

        return saved;
    }

    @Transactional
    /** Phân công đăng ký đề tài vào hội đồng sau khi kiểm tra toàn bộ điều kiện. */
    public TopicAssignment assignTopic(Long councilId, Long registrationId) {
        ReviewCouncil council = councilRepository.findById(councilId).orElseThrow(() -> new IllegalArgumentException("Không tìm thấy Hội đồng"));
        TopicRegistration registration = registrationRepository.findById(registrationId).orElseThrow(() -> new IllegalArgumentException("Không tìm thấy Đăng ký đề tài"));

        if (council.getDepartment() == null || registration.getTopic() == null
                || registration.getTopic().getDepartment() == null
                || !council.getDepartment().getId().equals(registration.getTopic().getDepartment().getId())) {
            throw new IllegalArgumentException("Đề tài phải thuộc cùng khoa với hội đồng");
        }

        if (assignmentRepository.existsByCouncilIdAndTopicRegistrationId(councilId, registrationId)) {
            throw new IllegalStateException("Đề tài đã được phân công cho Hội đồng này");
        }

        if (!isEligibleForCouncil(registration)) {
            throw new IllegalStateException("Nhóm chưa đủ điều kiện vào Hội đồng: đăng ký phải được duyệt và điểm quá trình của GVHD phải lớn hơn 5");
        }

        Topic topic = registration.getTopic();
        List<ReviewCouncilMember> councilMembers = memberRepository.findByCouncilId(councilId);
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
        if (registration == null || registration.getTopic() == null) return false;
        if (registration.getStatus() != ute.edu.enums.RegistrationStatus.APPROVED) return false;
        Topic topic = registration.getTopic();
        if (topic.getLecturer() == null) return false;

        TopicEvaluation supervisorEvaluation = evaluationRepository
            .findByTopicIdAndReviewerId(topic.getId(), topic.getLecturer().getId())
            .orElse(null);
        return supervisorEvaluation != null
            && supervisorEvaluation.getScore() != null
            && supervisorEvaluation.getScore() > 5.0;
    }

    /** Kiểm tra thêm việc GVHD không được là thành viên của hội đồng đang chọn. */
    /** Kiểm tra thêm điều kiện cùng khoa và loại GVHD khỏi hội đồng được chọn. */
    public boolean canAssignToCouncil(ReviewCouncil council, TopicRegistration registration) {
        if (council == null || !isEligibleForCouncil(registration)) return false;

        Topic topic = registration.getTopic();
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
            if (isSupervisor || isCoSupervisor || isAssignedSupervisor) return false;
        }
        return true;
    }

    /** Lấy danh sách thành viên của một hội đồng. */
    public List<ReviewCouncilMember> getMembers(Long councilId) {
        return memberRepository.findByCouncilId(councilId);
    }

    /** Lấy các đề tài đã được phân công cho hội đồng. */
    public List<TopicAssignment> getAssignments(Long councilId) {
        return assignmentRepository.findByCouncilId(councilId);
    }

    /** Lấy các hội đồng mà một giảng viên đang tham gia. */
    public List<ReviewCouncilMember> getCouncilsForLecturer(Long lecturerId) {
        return memberRepository.findByLecturerId(lecturerId);
    }

    @Transactional
    /** Xóa hội đồng cùng các thành viên và phân công liên quan. */
    public void deleteCouncil(Long councilId) {
        assignmentRepository.deleteByCouncilId(councilId);
        memberRepository.deleteByCouncilId(councilId);
        councilRepository.deleteById(councilId);
    }
}
