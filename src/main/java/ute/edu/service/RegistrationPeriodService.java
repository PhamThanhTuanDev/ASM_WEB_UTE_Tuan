package ute.edu.service;

import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ute.edu.entity.RegistrationPeriod;
import ute.edu.enums.RegistrationType;
import ute.edu.enums.PeriodStatus;
import ute.edu.repository.RegistrationPeriodRepository;

@Service
/** Service quản lý các đợt đăng ký đề tài và thời hạn nghiệp vụ. */
public class RegistrationPeriodService {
    private final RegistrationPeriodRepository registrationPeriodRepository;

    public RegistrationPeriodService(RegistrationPeriodRepository registrationPeriodRepository) {
        this.registrationPeriodRepository = registrationPeriodRepository;
    }

    /** Lấy toàn bộ đợt đăng ký. */
    public List<RegistrationPeriod> getAll() {
        return registrationPeriodRepository.findAll();
    }

    /** Tìm đợt đăng ký theo mã. */
    public RegistrationPeriod findById(Long id) {
        return registrationPeriodRepository.findById(id).orElse(null);
    }

    /** Lấy đợt đang mở hoặc được đánh dấu hoạt động. */
    public RegistrationPeriod getActivePeriod() {
        return registrationPeriodRepository.findAll().stream()
                .filter(p -> p.getStatus() == PeriodStatus.OPEN || p.isActive())
                .findFirst()
                .orElse(null);
    }

    @Transactional
    /** Kiểm tra thời hạn bắt buộc và lưu đợt đăng ký. */
    public RegistrationPeriod save(RegistrationPeriod period) {
        // Business Validation Rule:
        // Hạn chót GVPB nộp điểm (reviewer_score_deadline): Bắt buộc với TLCN hoặc KLTN
        if (period.getType() == RegistrationType.PROJECT || period.getType() == RegistrationType.THESIS) {
            if (period.getReviewerDeadline() == null) {
                throw new IllegalArgumentException("Đợt " + period.getType().name() + " bắt buộc phải thiết lập Hạn chót GVPB nộp điểm!");
            }
        }

        // Ngày báo cáo hội đồng (council_date): Bắt buộc với KLTN
        if (period.getType() == RegistrationType.THESIS) {
            if (period.getCouncilReportDate() == null) {
                throw new IllegalArgumentException("Đợt Khóa luận tốt nghiệp (KLTN) bắt buộc phải thiết lập Ngày báo cáo hội đồng!");
            }
        }

        return registrationPeriodRepository.save(period);
    }

    @Transactional
    /** Xóa đợt đăng ký theo mã. */
    public void delete(Long id) {
        registrationPeriodRepository.deleteById(id);
    }
}
