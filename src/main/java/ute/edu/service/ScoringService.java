package ute.edu.service;

import java.util.List;
import java.time.LocalDateTime;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ute.edu.entity.*;
import ute.edu.enums.AssignmentStatus;
import ute.edu.enums.CouncilStatus;
import ute.edu.repository.*;

@Service
/** Service nhập điểm hội đồng, tính điểm và chốt kết quả. */
public class ScoringService {
    private final ScoreRepository scoreRepository;
    private final TopicAssignmentRepository assignmentRepository;
    private final ReviewCouncilMemberRepository memberRepository;
    private final TopicSupervisorRepository supervisorRepository;
    private final ReviewCouncilRepository councilRepository;
    private final TopicEvaluationRepository evaluationRepository;

    public ScoringService(ScoreRepository scoreRepository,
                          TopicAssignmentRepository assignmentRepository,
                          ReviewCouncilMemberRepository memberRepository,
                          TopicSupervisorRepository supervisorRepository,
                          ReviewCouncilRepository councilRepository,
                          TopicEvaluationRepository evaluationRepository) {
        this.scoreRepository = scoreRepository;
        this.assignmentRepository = assignmentRepository;
        this.memberRepository = memberRepository;
        this.supervisorRepository = supervisorRepository;
        this.councilRepository = councilRepository;
        this.evaluationRepository = evaluationRepository;
    }

    /** Lấy các điểm hội đồng của một phân công. */
    public List<Score> getScoresForAssignment(Long assignmentId) {
        return scoreRepository.findByTopicAssignmentId(assignmentId);
    }

    /** Kiểm tra giảng viên có đang hướng dẫn đề tài hay không. */
    public boolean isLecturerSupervisingTopic(Long lecturerId, Long topicId) {
        return supervisorRepository.existsByTopicIdAndLecturerId(topicId, lecturerId);
    }

    @Transactional
    /** Lưu hoặc cập nhật điểm của một thành viên hội đồng. */
    public Score gradeTopic(Long assignmentId, Long lecturerId, Double scoreValue, String comment) {
        if (scoreValue == null || scoreValue < 0 || scoreValue > 10) {
            throw new IllegalArgumentException("Điểm số phải từ 0 đến 10");
        }

        TopicAssignment assignment = assignmentRepository.findById(assignmentId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy phân công đề tài"));

        Topic topic = assignment.getTopicRegistration().getTopic();
        Long councilId = assignment.getCouncil().getId();

        // 1. Check anti-supervision constraint
        boolean isSupervisor = false;
        if (topic.getLecturer() != null && topic.getLecturer().getId().equals(lecturerId)) {
            isSupervisor = true;
        }
        if (topic.getCoLecturer() != null && topic.getCoLecturer().getId().equals(lecturerId)) {
            isSupervisor = true;
        }
        if (supervisorRepository.existsByTopicIdAndLecturerId(topic.getId(), lecturerId)) {
            isSupervisor = true;
        }

        if (isSupervisor) {
            throw new IllegalStateException("RÀNG BUỘC BẢO MẬT: Giảng viên hướng dẫn không được phép chấm điểm hoặc phản biện cho đề tài này!");
        }

        // 2. Find council member record
        ReviewCouncilMember councilMember = memberRepository.findByCouncilIdAndLecturerId(councilId, lecturerId)
                .orElseThrow(() -> new IllegalStateException("Bạn không phải là thành viên của Hội đồng này"));

        // 3. Save or update score
        Score score = scoreRepository.findByTopicAssignmentIdAndCouncilMemberId(assignmentId, councilMember.getId())
                .orElseGet(Score::new);

        score.setTopicAssignment(assignment);
        score.setCouncilMember(councilMember);
        score.setScore(scoreValue);
        score.setComment(comment);
        if (score.getId() != null) {
            score.setUpdatedAt(LocalDateTime.now());
        }

        Score saved = scoreRepository.save(score);

        // Update status of assignment if all members have graded
        List<ReviewCouncilMember> members = memberRepository.findByCouncilId(councilId);
        List<Score> scores = scoreRepository.findByTopicAssignmentId(assignmentId);
        if (scores.size() >= members.size()) {
            assignment.setStatus(AssignmentStatus.EVALUATED);
            assignmentRepository.save(assignment);
        }

        return saved;
    }

    /** Tính trung bình điểm của các thành viên hội đồng. */
    public Double calculateAverageScore(Long assignmentId) {
        List<Score> scores = scoreRepository.findByTopicAssignmentId(assignmentId);
        if (scores.isEmpty()) {
            return null;
        }
        double sum = 0.0;
        for (Score s : scores) {
            sum += s.getScore();
        }
        double avg = sum / scores.size();
        return Math.round(avg * 100.0) / 100.0;
    }

    /** Tính trung bình điểm quá trình do GVHD chấm. */
    public Double calculateProcessAverageScore(Long assignmentId) {
        TopicAssignment assignment = assignmentRepository.findById(assignmentId).orElse(null);
        if (assignment == null || assignment.getTopicRegistration() == null
                || assignment.getTopicRegistration().getTopic() == null) {
            return null;
        }

        List<TopicEvaluation> evaluations = evaluationRepository.findByTopicId(
                assignment.getTopicRegistration().getTopic().getId());
        if (evaluations.isEmpty()) {
            return null;
        }

        double sum = 0.0;
        for (TopicEvaluation evaluation : evaluations) {
            sum += evaluation.getScore();
        }
        return Math.round((sum / evaluations.size()) * 100.0) / 100.0;
    }

    /** Lấy chi tiết các đánh giá quá trình để hiển thị cho sinh viên. */
    public List<TopicEvaluation> getProcessEvaluations(Long assignmentId) {
        TopicAssignment assignment = assignmentRepository.findById(assignmentId).orElse(null);
        if (assignment == null || assignment.getTopicRegistration() == null
                || assignment.getTopicRegistration().getTopic() == null) {
            return java.util.Collections.emptyList();
        }
        return evaluationRepository.findByTopicId(assignment.getTopicRegistration().getTopic().getId());
    }

    /** Tính điểm tổng kết theo công thức 50% quá trình và 50% hội đồng. */
    public Double calculateFinalScore(Long assignmentId) {
        Double processScore = calculateProcessAverageScore(assignmentId);
        Double councilScore = calculateAverageScore(assignmentId);
        if (processScore == null || councilScore == null) {
            return null;
        }

        double finalScore = (processScore * 0.5) + (councilScore * 0.5);
        return Math.round(finalScore * 100.0) / 100.0;
    }

    @Transactional
    /** Chốt hội đồng khi tất cả thành viên đã nhập điểm. */
    public void finalizeCouncil(Long councilId) {
        ReviewCouncil council = councilRepository.findById(councilId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy Hội đồng"));

        List<ReviewCouncilMember> members = memberRepository.findByCouncilId(councilId);
        if (members.size() < 3) {
            throw new IllegalStateException("Hội đồng phải có ít nhất 3 thành viên trước khi công bố điểm");
        }

        List<TopicAssignment> assignments = assignmentRepository.findByCouncilId(councilId);
        for (TopicAssignment assignment : assignments) {
            int scoreCount = scoreRepository.findByTopicAssignmentId(assignment.getId()).size();
            if (scoreCount < members.size()) {
                String topicCode = assignment.getTopicRegistration().getTopic().getCode();
                throw new IllegalStateException("Đề tài " + topicCode + " mới có " + scoreCount
                        + "/" + members.size() + " điểm; cần đủ điểm của tất cả thành viên hội đồng");
            }
            assignment.setStatus(AssignmentStatus.EVALUATED);
            assignmentRepository.save(assignment);
        }

        council.setStatus(CouncilStatus.COMPLETED);
        councilRepository.save(council);
    }
}
