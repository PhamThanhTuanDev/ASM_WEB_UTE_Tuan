package ute.edu.service;

import java.util.List;
import java.time.LocalDateTime;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionSynchronization;
import org.springframework.transaction.support.TransactionSynchronizationManager;
import org.springframework.web.util.HtmlUtils;
import ute.edu.enums.RegistrationStatus;
import ute.edu.enums.GroupStatus;
import ute.edu.entity.StudentGroup;
import ute.edu.entity.Topic;
import ute.edu.entity.TopicRegistration;
import ute.edu.entity.UserAccount;
import ute.edu.repository.TopicRegistrationRepository;
import ute.edu.repository.StudentGroupRepository;
import ute.edu.repository.TopicRepository;
import ute.edu.enums.TopicStatus;

@Service
/** Service xử lý nhóm gửi đăng ký đề tài và quy trình duyệt. */
public class TopicRegistrationService {
    private final TopicRegistrationRepository registrationRepository;
    private final StudentGroupRepository groupRepository;
    private final TopicRepository topicRepository;
    private final MailerService mailerService;

    public TopicRegistrationService(TopicRegistrationRepository registrationRepository,
            StudentGroupRepository groupRepository, TopicRepository topicRepository, MailerService mailerService) {
        this.registrationRepository = registrationRepository;
        this.groupRepository = groupRepository;
        this.topicRepository = topicRepository;
        this.mailerService = mailerService;
    }

    /** Lấy tất cả đăng ký đề tài. */
    public List<TopicRegistration> getAll() {
        return registrationRepository.findAll(org.springframework.data.domain.Sort.by(
                org.springframework.data.domain.Sort.Direction.DESC, "createdAt", "id"));
    }

    /** Tìm đăng ký theo mã. */
    public TopicRegistration findById(Long id) {
        return registrationRepository.findById(id).orElse(null);
    }

    /** Lọc đăng ký theo trạng thái. */
    public List<TopicRegistration> getByStatus(RegistrationStatus status) {
        return registrationRepository.findByStatusOrderByCreatedAtDescIdDesc(status);
    }

    /** Lấy các đăng ký của một nhóm. */
    public List<TopicRegistration> getByGroupId(Long groupId) {
        return registrationRepository.findByGroupIdOrderByCreatedAtDescIdDesc(groupId);
    }

    /** Lấy các đăng ký đã được duyệt. */
    public List<TopicRegistration> getApprovedRegistrations() {
        return registrationRepository.findByStatusOrderByCreatedAtDescIdDesc(RegistrationStatus.APPROVED);
    }

    /** Lấy đăng ký đang hoạt động của nhóm. */
    public TopicRegistration getActiveRegistrationForGroup(Long groupId) {
        List<TopicRegistration> list = registrationRepository.findByGroupIdOrderByCreatedAtDescIdDesc(groupId);
        return list.stream()
                .filter(r -> r.getStatus() == RegistrationStatus.APPROVED
                        || r.getStatus() == RegistrationStatus.PENDING)
                .findFirst()
                .orElse(null);
    }

    @Transactional(isolation = org.springframework.transaction.annotation.Isolation.READ_COMMITTED)
    /** Tạo yêu cầu đăng ký đề tài mới cho nhóm. */
    public TopicRegistration register(StudentGroup group, Topic topic, String note) {
        if (group == null || topic == null) {
            throw new IllegalArgumentException("Nhóm và đề tài không được để trống");
        }
        topic = topicRepository.findForUpdate(topic.getId()).orElseThrow();
        group = groupRepository.findForUpdate(group.getId()).orElseThrow();
        RegistrationPeriodService.requireStudentWindow(topic.getRegistrationPeriod());
        if (group.getRegistrationPeriod() == null || !group.getRegistrationPeriod().getId()
                .equals(topic.getRegistrationPeriod().getId())) {
            throw new IllegalStateException("Vui lòng chọn đề tài thuộc đúng đợt đăng ký của nhóm!");
        }
        if (topic.getStatus() != TopicStatus.PUBLISHED && topic.getStatus() != TopicStatus.APPROVED) {
            throw new IllegalStateException("Đề tài chưa được công bố!");
        }
        if (group.getTopic() != null) {
            throw new IllegalStateException("QUY ĐỊNH: Nhóm đã được gán một đề tài chính thức!");
        }
        if (registrationRepository.existsByGroupIdAndTopicId(group.getId(), topic.getId())) {
            throw new IllegalStateException("Nhóm đã gửi yêu cầu đăng ký cho đề tài này!");
        }
        if (group.getMembers().isEmpty() || group.getMembers().size() > Math.min(3, topic.getMaxStudents())) {
            throw new IllegalStateException("Số thành viên vượt giới hạn đề tài (tối đa 3 sinh viên)!");
        }
        for (var member : group.getMembers()) {
            if (member.getStudent().getDepartment() == null || topic.getDepartment() == null
                    || !member.getStudent().getDepartment().getId().equals(topic.getDepartment().getId())) {
                throw new IllegalStateException("Tất cả thành viên phải thuộc khoa quản lý đề tài!");
            }
        }
        // Kiểm tra BIZ-05: Nhóm đang có đơn chờ duyệt
        List<TopicRegistration> existingRegs = registrationRepository.findByGroupIdOrderByCreatedAtDescIdDesc(group.getId());
        for (TopicRegistration reg : existingRegs) {
            if (reg.getStatus() == RegistrationStatus.PENDING || reg.getStatus() == RegistrationStatus.APPROVED) {
                throw new IllegalStateException("Nhóm đang có đơn chờ duyệt, không thể đăng ký thêm!");
            }
        }

        for (var member : group.getMembers()) {
            if (groupRepository.existsByMembersStudentIdAndRegistrationPeriodIdAndIdNot(
                    member.getStudent().getId(), topic.getRegistrationPeriod().getId(), group.getId())) {
                throw new IllegalStateException("Có thành viên đã tham gia nhóm khác trong đợt này!");
            }
        }
        TopicRegistration registration = new TopicRegistration();
        registration.setGroup(group);
        registration.setTopic(topic);
        registration.setNote(note);
        registration.setStatus(RegistrationStatus.PENDING);
        registration.setCreatedAt(LocalDateTime.now());
        return registrationRepository.save(registration);
    }

    @Transactional(isolation = org.springframework.transaction.annotation.Isolation.READ_COMMITTED)
    /** Cập nhật kết quả duyệt đăng ký và gán đề tài cho nhóm khi được duyệt. */
    public TopicRegistration updateStatus(Long id, RegistrationStatus status,
            UserAccount approver, String rejectionReason) {
        if (status != RegistrationStatus.APPROVED && status != RegistrationStatus.REJECTED) {
            throw new IllegalArgumentException("Chỉ được duyệt hoặc từ chối đăng ký đang chờ!");
        }
        // Từ chối bắt buộc có lý do: kiểm tra cả ở máy chủ, không chỉ dựa vào hộp nhập trên trình duyệt
        if (status == RegistrationStatus.REJECTED && (rejectionReason == null || rejectionReason.isBlank())) {
            throw new IllegalArgumentException("Bắt buộc nhập lý do khi từ chối nhóm đăng ký!");
        }
        rejectionReason = rejectionReason == null ? null : rejectionReason.trim();
        TopicRegistration registration = registrationRepository.findForUpdate(id)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy đăng ký đề tài"));
        Topic topic = topicRepository.findForUpdate(registration.getTopic().getId()).orElseThrow();
        StudentGroup lockedGroup = groupRepository.findForUpdate(registration.getGroup().getId()).orElseThrow();
        if (registration.getStatus() != RegistrationStatus.PENDING) {
            throw new IllegalStateException("Đơn này đã được xử lý!");
        }

        if (status == RegistrationStatus.APPROVED) {
            if (lockedGroup.getTopic() != null
                    || registrationRepository.existsByTopicIdAndStatus(topic.getId(), RegistrationStatus.APPROVED)) {
                throw new IllegalStateException("Nhóm hoặc đề tài đã có đăng ký được duyệt!");
            }
            if (topic.getRegistrationPeriod().getStatus() != ute.edu.enums.PeriodStatus.OPEN
                    || !topic.getRegistrationPeriod().isActive()) {
                throw new IllegalStateException("Không thể duyệt đăng ký của đợt đã đóng!");
            }
            if (lockedGroup.getMembers().isEmpty()
                    || lockedGroup.getMembers().size() > Math.min(3, topic.getMaxStudents())) {
                throw new IllegalStateException("Số thành viên không phù hợp với giới hạn đề tài!");
            }
            if (topic.getStatus() != TopicStatus.PUBLISHED && topic.getStatus() != TopicStatus.APPROVED) {
                throw new IllegalStateException("Đề tài không còn khả dụng!");
            }
            StudentGroup group = lockedGroup;
            group.setTopic(topic);
            group.setStatus(GroupStatus.ASSIGNED);
            groupRepository.save(group);
            topic.setStatus(TopicStatus.ASSIGNED);
            topicRepository.save(topic);
        }
        registration.setStatus(status);
        registration.setApprovedBy(approver);
        registration.setRejectionReason(status == RegistrationStatus.REJECTED ? rejectionReason : null);
        registration.setApprovedAt(status == RegistrationStatus.APPROVED ? LocalDateTime.now() : null);
        TopicRegistration saved = registrationRepository.save(registration);
        notifyGroupAfterDecision(lockedGroup, topic, status, rejectionReason);
        return saved;
    }

    /** Chụp thông tin thư trong giao dịch, chỉ đưa vào hàng đợi khi kết quả duyệt đã commit. */
    private void notifyGroupAfterDecision(StudentGroup group, Topic topic, RegistrationStatus status, String rejectionReason) {
        String[] recipients = group.getMembers().stream()
                .map(member -> member.getStudent().getUser())
                .filter(java.util.Objects::nonNull)
                .map(UserAccount::getEmail)
                .filter(email -> email != null && !email.isBlank())
                .map(String::trim)
                .distinct()
                .toArray(String[]::new);
        if (recipients.length == 0) return;

        boolean approved = status == RegistrationStatus.APPROVED;
        String subject = (approved ? "Đăng ký đề tài đã được duyệt: " : "Đăng ký đề tài bị từ chối: ") + topic.getCode();
        String body = "<p>Chào các bạn sinh viên,</p>"
                + "<p>Đăng ký đề tài của nhóm <strong>" + mailText(group.getName())
                + (approved ? "</strong> đã được giảng viên chấp nhận.</p>"
                        : "</strong> đã bị giảng viên từ chối.</p>")
                + "<p><strong>Mã đề tài:</strong> " + mailText(topic.getCode())
                + "<br><strong>Tên đề tài:</strong> " + mailText(topic.getTitle())
                + "<br><strong>Đợt đăng ký:</strong> " + mailText(topic.getRegistrationPeriod().getName())
                + "<br><strong>Giảng viên hướng dẫn:</strong> "
                + mailText(topic.getLecturer() != null && topic.getLecturer().getUser() != null
                        ? topic.getLecturer().getUser().getFullName() : null)
                + "</p>"
                + (approved ? "<p>Các bạn đăng nhập hệ thống để theo dõi đề tài và nộp báo cáo.</p>"
                        : "<p><strong>Lý do từ chối:</strong> "
                                + mailText(rejectionReason == null || rejectionReason.isBlank()
                                        ? "Giảng viên chưa cung cấp lý do." : rejectionReason.trim())
                                + "</p><p>Các bạn đăng nhập hệ thống để xem lại đăng ký hoặc liên hệ giảng viên hướng dẫn.</p>")
                + "<p>Hệ thống quản lý đề tài sinh viên HCMUTE.</p>";

        TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {
            @Override
            public void afterCommit() {
                // Lỗi thông báo không được làm giao diện hiểu nhầm rằng kết quả duyệt chưa lưu.
                try {
                    mailerService.queue(recipients, subject, body);
                } catch (RuntimeException error) {
                    org.slf4j.LoggerFactory.getLogger(TopicRegistrationService.class)
                            .error("Không thể đưa thư duyệt đăng ký vào hàng đợi", error);
                }
            }
        });
    }

    /** Nội dung người dùng được mã hóa trước khi đưa vào email HTML. */
    private static String mailText(String value) {
        return value == null ? "Chưa cập nhật" : HtmlUtils.htmlEscape(value, "UTF-8");
    }
}
