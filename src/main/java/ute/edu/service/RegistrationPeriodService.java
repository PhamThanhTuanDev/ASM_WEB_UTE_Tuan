package ute.edu.service;

import java.util.List;
import java.time.LocalDate;
import java.time.ZoneId;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ute.edu.entity.RegistrationPeriod;
import ute.edu.enums.RegistrationType;
import ute.edu.enums.PeriodStatus;
import ute.edu.repository.RegistrationPeriodRepository;

@Service
/** Service quản lý các đợt đăng ký đề tài và thời hạn nghiệp vụ. */
public class RegistrationPeriodService {
    /** Ngày nghiệp vụ theo múi giờ Việt Nam, dùng chung cho mọi kiểm tra thời hạn. */
    public static LocalDate today() {
        return LocalDate.now(ZoneId.of("Asia/Ho_Chi_Minh"));
    }

    /** Cửa sổ đăng ký sinh viên, bao gồm cả ngày bắt đầu và ngày kết thúc. */
    public static boolean isStudentWindow(RegistrationPeriod period) {
        LocalDate today = today();
        return period != null && period.isActive() && period.getStatus() == PeriodStatus.OPEN
                && period.getStudentStartDate() != null && period.getStudentEndDate() != null
                && !today.isBefore(period.getStudentStartDate()) && !today.isAfter(period.getStudentEndDate());
    }

    /** Chỉ cho đề xuất khi đợt hoạt động và còn trong thời gian giảng viên đề xuất. */
    public static boolean isLecturerWindow(RegistrationPeriod period) {
        LocalDate today = today();
        return period != null && period.isActive() && period.getStatus() == PeriodStatus.OPEN
                && period.getLecturerStartDate() != null && period.getLecturerEndDate() != null
                && !today.isBefore(period.getLecturerStartDate()) && !today.isAfter(period.getLecturerEndDate());
    }

    /** Danh sách cho ô chọn đợt trong form giảng viên, đợt mới nhất trước. */
    public List<RegistrationPeriod> getOpenLecturerPeriods() {
        return getAll().stream().filter(RegistrationPeriodService::isLecturerWindow).toList();
    }

    /** Hội đồng dùng ngày báo cáo của đợt; cho phép tạo đến hết chính ngày báo cáo. */
    public static boolean canCreateCouncil(RegistrationPeriod period) {
        return period != null && period.isActive() && period.getStatus() == PeriodStatus.OPEN
                && period.getCouncilReportDate() != null && !period.getCouncilReportDate().isBefore(today());
    }

    /** Lọc riêng cho form tạo hội đồng, không ảnh hưởng bộ lọc tra cứu lịch sử. */
    public List<RegistrationPeriod> getCouncilCreationPeriods() {
        return getAll().stream().filter(RegistrationPeriodService::canCreateCouncil).toList();
    }

    public static void requireStudentWindow(RegistrationPeriod period) {
        if (!isStudentWindow(period)) {
            throw new IllegalStateException("Đợt chưa mở hoặc đã hết thời hạn sinh viên đăng ký!");
        }
    }

    private final RegistrationPeriodRepository registrationPeriodRepository;

    public RegistrationPeriodService(RegistrationPeriodRepository registrationPeriodRepository) {
        this.registrationPeriodRepository = registrationPeriodRepository;
    }

    /** Ưu tiên đợt đang mở, sau đó sắp xếp đợt mới nhất trước. */
    public List<RegistrationPeriod> getAll() {
        return registrationPeriodRepository.findAll().stream()
                .sorted(java.util.Comparator.comparing((RegistrationPeriod period) -> period.getStatus() != PeriodStatus.OPEN)
                        .thenComparing(RegistrationPeriod::getId, java.util.Comparator.reverseOrder()))
                .toList();
    }

    /** Tìm đợt đăng ký theo mã. */
    public RegistrationPeriod findById(Long id) {
        return registrationPeriodRepository.findById(id).orElse(null);
    }

    public List<RegistrationPeriod> getOpenStudentPeriods() {
        return registrationPeriodRepository.findAll().stream()
                .filter(RegistrationPeriodService::isStudentWindow)
                .sorted(java.util.Comparator.comparing(RegistrationPeriod::getStudentStartDate).reversed()
                        .thenComparing(RegistrationPeriod::getId, java.util.Comparator.reverseOrder()))
                .toList();
    }

    /** Lấy đợt đang mở hoặc được đánh dấu hoạt động. */
    public RegistrationPeriod getActivePeriod() {
        return registrationPeriodRepository.findAll().stream()
                .filter(p -> p.getStatus() == PeriodStatus.OPEN && p.isActive())
                .sorted(java.util.Comparator.comparing((RegistrationPeriod p) -> RegistrationPeriodService.isStudentWindow(p) ? 0 : 1)
                        .thenComparing(RegistrationPeriod::getStudentStartDate,
                                java.util.Comparator.nullsLast(java.util.Comparator.reverseOrder())))
                .findFirst()
                .orElse(null);
    }

    @Transactional
    /** Kiểm tra thời hạn bắt buộc và lưu đợt đăng ký. */
    public RegistrationPeriod save(RegistrationPeriod period) {
        if (period.getName() == null || period.getName().isBlank() || period.getType() == null
                || period.getStatus() == null || period.getLecturerStartDate() == null
                || period.getLecturerEndDate() == null || period.getStudentStartDate() == null
                || period.getStudentEndDate() == null) {
            throw new IllegalArgumentException("Tên, loại, trạng thái và các mốc đăng ký là bắt buộc!");
        }
        if (period.getLecturerEndDate().isBefore(period.getLecturerStartDate())
                || !period.getStudentStartDate().isAfter(period.getLecturerEndDate())
                || period.getStudentEndDate().isBefore(period.getStudentStartDate())
                || (period.getCouncilReportDate() != null
                        && !period.getCouncilReportDate().isAfter(period.getStudentEndDate()))
                || (period.getReviewerDeadline() != null
                        && !period.getReviewerDeadline().isAfter(period.getStudentEndDate()))) {
            throw new IllegalArgumentException("Các mốc thời gian của đợt không đúng thứ tự!");
        }
        period.setActive(period.getStatus() == PeriodStatus.OPEN);
        // Business Validation Rule:
        // Hạn chót GVPB nộp điểm (reviewer_score_deadline): Bắt buộc với TLCN hoặc KLTN
        if (period.getType() == RegistrationType.PROJECT || period.getType() == RegistrationType.THESIS) {
            if (period.getReviewerDeadline() == null) {
                throw new IllegalArgumentException(
                        "Đợt tiểu luận chuyên ngành hoặc khóa luận tốt nghiệp phải có hạn GVPB nộp điểm!");
            }
        }

        // Ngày báo cáo hội đồng (council_date): Bắt buộc với KLTN
        if (period.getType() == RegistrationType.THESIS) {
            if (period.getCouncilReportDate() == null) {
                throw new IllegalArgumentException(
                        "Đợt Khóa luận tốt nghiệp (KLTN) bắt buộc phải thiết lập Ngày báo cáo hội đồng!");
            }
        }

        if (period.getCouncilReportDate() != null && period.getReviewerDeadline() != null
                && !period.getReviewerDeadline().isAfter(period.getCouncilReportDate())) {
            throw new IllegalArgumentException("Hạn GVPB nộp điểm phải sau ngày báo cáo hội đồng!");
        }

        return registrationPeriodRepository.save(period);
    }

    @Transactional
    /** Xóa đợt đăng ký theo mã. */
    public void delete(Long id) {
        registrationPeriodRepository.deleteById(id);
    }
}
