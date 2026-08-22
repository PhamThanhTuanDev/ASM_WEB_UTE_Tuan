package ute.edu.service;

import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ute.edu.entity.RegistrationPeriod;
import ute.edu.enums.RegistrationType;
import ute.edu.enums.PeriodStatus;
import ute.edu.repository.RegistrationPeriodRepository;

@Service
public class RegistrationPeriodService {
    private final RegistrationPeriodRepository registrationPeriodRepository;

    public RegistrationPeriodService(RegistrationPeriodRepository registrationPeriodRepository) {
        this.registrationPeriodRepository = registrationPeriodRepository;
    }

    public List<RegistrationPeriod> getAll() {
        return registrationPeriodRepository.findAll();
    }

    public RegistrationPeriod findById(Long id) {
        return registrationPeriodRepository.findById(id).orElse(null);
    }

    public RegistrationPeriod getActivePeriod() {
        return registrationPeriodRepository.findAll().stream()
                .filter(p -> p.getStatus() == PeriodStatus.OPEN || p.isActive())
                .findFirst()
                .orElse(null);
    }

    @Transactional
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
    public void delete(Long id) {
        registrationPeriodRepository.deleteById(id);
    }
}
