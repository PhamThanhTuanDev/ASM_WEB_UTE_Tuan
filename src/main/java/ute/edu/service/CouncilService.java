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
public class CouncilService {
    private final ReviewCouncilRepository councilRepository;
    private final ReviewCouncilMemberRepository memberRepository;
    private final TopicAssignmentRepository assignmentRepository;
    private final TopicRegistrationRepository registrationRepository;
    private final LectureRepository lectureRepository;

    public CouncilService(ReviewCouncilRepository councilRepository,
                          ReviewCouncilMemberRepository memberRepository,
                          TopicAssignmentRepository assignmentRepository,
                          TopicRegistrationRepository registrationRepository,
                          LectureRepository lectureRepository) {
        this.councilRepository = councilRepository;
        this.memberRepository = memberRepository;
        this.assignmentRepository = assignmentRepository;
        this.registrationRepository = registrationRepository;
        this.lectureRepository = lectureRepository;
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
    public ReviewCouncil createCouncil(ReviewCouncil council, Long chairmanId, Long secretaryId, List<Long> memberIds) {
        if (chairmanId == null || secretaryId == null) {
            throw new IllegalArgumentException("Chủ tịch và Thư ký hội đồng là bắt buộc");
        }
        if (chairmanId.equals(secretaryId)) {
            throw new IllegalArgumentException("Chủ tịch và Thư ký không được trùng nhau");
        }
        
        Lecture chairman = lectureRepository.findById(chairmanId).orElseThrow(() -> new IllegalArgumentException("Không tìm thấy Chủ tịch"));
        Lecture secretary = lectureRepository.findById(secretaryId).orElseThrow(() -> new IllegalArgumentException("Không tìm thấy Thư ký"));
        
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
    public TopicAssignment assignTopic(Long councilId, Long registrationId) {
        ReviewCouncil council = councilRepository.findById(councilId).orElseThrow(() -> new IllegalArgumentException("Không tìm thấy Hội đồng"));
        TopicRegistration registration = registrationRepository.findById(registrationId).orElseThrow(() -> new IllegalArgumentException("Không tìm thấy Đăng ký đề tài"));

        if (assignmentRepository.existsByCouncilIdAndTopicRegistrationId(councilId, registrationId)) {
            throw new IllegalStateException("Đề tài đã được phân công cho Hội đồng này");
        }

        TopicAssignment assignment = new TopicAssignment();
        assignment.setCouncil(council);
        assignment.setTopicRegistration(registration);
        assignment.setStatus(AssignmentStatus.ASSIGNED);
        return assignmentRepository.save(assignment);
    }

    public List<ReviewCouncilMember> getMembers(Long councilId) {
        return memberRepository.findByCouncilId(councilId);
    }

    public List<TopicAssignment> getAssignments(Long councilId) {
        return assignmentRepository.findByCouncilId(councilId);
    }

    public List<ReviewCouncilMember> getCouncilsForLecturer(Long lecturerId) {
        return memberRepository.findByLecturerId(lecturerId);
    }

    @Transactional
    public void deleteCouncil(Long councilId) {
        assignmentRepository.deleteByCouncilId(councilId);
        memberRepository.deleteByCouncilId(councilId);
        councilRepository.deleteById(councilId);
    }
}
