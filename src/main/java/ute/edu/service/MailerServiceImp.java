package ute.edu.service;

import java.io.File;
import java.util.ArrayList;
import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.Queue;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import ute.edu.helper.MailInfo;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;

@Service
/** Cài đặt gửi email qua SMTP và xử lý hàng đợi định kỳ. */
public class MailerServiceImp implements MailerService {
	private static final Logger log = LoggerFactory.getLogger(MailerServiceImp.class);

	/** Số lần gửi tối đa cho mỗi email (lần đầu + 2 lần thử lại). */
	static final int MAX_ATTEMPTS = 3;

	/** Một email trong hàng đợi kèm số lần đã thử gửi. */
	record PendingMail(MailInfo mail, int attempt) {
	}

	/** Hàng đợi an toàn đa luồng: luồng request gọi queue() trong khi luồng @Scheduled gọi run(). */
	final Queue<PendingMail> listEmails = new ConcurrentLinkedQueue<>();
	private final JavaMailSender sender;
	private final String defaultFrom;

	public MailerServiceImp(JavaMailSender sender, @Value("${spring.mail.username}") String defaultFrom) {
		this.sender = sender;
		this.defaultFrom = defaultFrom;
	}

	@Override
	/** Tạo MIME email, thêm người nhận/tệp đính kèm và gửi qua SMTP. */
	public void send(MailInfo mail) throws MessagingException {
		MimeMessage message = sender.createMimeMessage();
		// Sử dụng Helper để thiết lập các thông tin cần thiết cho message
		MimeMessageHelper helper = new MimeMessageHelper(message, true, "utf-8");

		String from = mail.getFrom() == null || mail.getFrom().isBlank() ? defaultFrom : mail.getFrom();
		helper.setFrom(from);
		helper.setTo(mail.getTo());
		helper.setSubject(mail.getSubject());
		helper.setText(mail.getBody(), true);
		helper.setReplyTo(from);

		String[] cc = mail.getCc();
		// Kiểm tra mảng cc có tồn tại hay không
		if (cc != null && cc.length > 0) {
			helper.setCc(cc);
		}

		String[] bcc = mail.getBcc();
		// Kiểm tra mảng bcc có tồn tại hay không
		if (bcc != null && bcc.length > 0) {
			helper.setBcc(bcc);
		}
		// Mảng file (có thể null nếu MailInfo tạo bằng constructor đầy đủ tham số)
		List<File> files = mail.getFiles();
		if (files != null && !files.isEmpty()) {
			for (File file : files) {
				helper.addAttachment(file.getName(), file);
			}
		}
		// Gửi message đến SMTP server
		sender.send(message);
	}

	@Override
	/** Tạo và gửi email đơn giản. */
	public void send(String[] to, String subject, String body) throws MessagingException {
		this.send(new MailInfo(to, subject, body));
	}

	@Override
	/** Thêm email vào danh sách chờ gửi. */
	public void queue(MailInfo mail) {
		if (mail != null) {
			listEmails.add(new PendingMail(mail, 1));
		}
	}

	@Override
	/** Tạo email đơn giản rồi thêm vào hàng đợi. */
	public void queue(String[] to, String subject, String body) {
		queue(new MailInfo(to, subject, body));
	}

	@Scheduled(fixedDelay = 5000)
	/**
	 * Cứ 5 giây lấy email trong hàng đợi để gửi.
	 * Gửi lỗi (mất mạng, SMTP từ chối...) thì đưa lại vào hàng đợi để thử ở lượt sau,
	 * tối đa MAX_ATTEMPTS lần rồi mới bỏ và ghi nhật ký.
	 */
	public void run() {
		List<PendingMail> retry = new ArrayList<>();
		PendingMail item;
		while ((item = listEmails.poll()) != null) {
			try {
				this.send(item.mail());
			} catch (Exception e) {
				if (item.attempt() < MAX_ATTEMPTS) {
					log.warn("Gửi mail '{}' lỗi lần {}/{}: {} -> sẽ thử lại", item.mail().getSubject(),
							item.attempt(), MAX_ATTEMPTS, e.getMessage());
					retry.add(new PendingMail(item.mail(), item.attempt() + 1));
				} else {
					log.error("Bỏ mail '{}' sau {} lần gửi lỗi", item.mail().getSubject(), MAX_ATTEMPTS, e);
				}
			}
		}
		// Đưa mail lỗi trở lại hàng đợi SAU vòng lặp để lượt sau mới thử lại (tránh lặp vô hạn)
		listEmails.addAll(retry);
	}
}
