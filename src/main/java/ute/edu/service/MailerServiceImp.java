package ute.edu.service;


import java.io.File;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import ute.edu.model.MailInfo;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;

@Service
/** Cài đặt gửi email qua SMTP và xử lý hàng đợi định kỳ. */
public class MailerServiceImp implements MailerService {
	List<MailInfo> listEmails = new ArrayList<>();
	@Autowired
	JavaMailSender sender;

	@Override
	/** Tạo MIME email, thêm người nhận/tệp đính kèm và gửi qua SMTP. */
	public void send(MailInfo mail) throws MessagingException {
		MimeMessage message = sender.createMimeMessage();
		// Sử dụng Helper để thiết lập các thông tin cần thiết cho message
		MimeMessageHelper helper = new MimeMessageHelper(message, true, "utf-8");
		
		helper.setFrom(mail.getFrom());
		helper.setTo(mail.getTo());
		helper.setSubject(mail.getSubject());
		helper.setText(mail.getBody(), true);
		helper.setReplyTo(mail.getFrom());

		String[] cc = mail.getCc();
		//Kiểm tra mảng cc có tồn tại hay không
		if (cc != null && cc.length > 0) {
			helper.setCc(cc);
		}
		
		String[] bcc = mail.getBcc();
		//Kiểm tra mảng bcc có tồn tại hay không
		if (bcc != null && bcc.length > 0) {
			helper.setBcc(bcc);
		}
		//Mảng file
		List<File> files = mail.getFiles();
		if (files.size()>0) {
			for (File file:files) {
				helper.addAttachment(file.getName(), file);
			}
		}
		// Gửi message đến SMTP server
		sender.send(message);
	}

	@Override
	/** Tạo và gửi email đơn giản. */
	public void send(String []to, String subject, String body) throws MessagingException {
		this.send(new MailInfo(to, subject, body));
	}

	@Override
	/** Thêm email vào danh sách chờ gửi. */
	public void queue(MailInfo mail) {
		listEmails.add(mail);
	}

	@Override
	/** Tạo email đơn giản rồi thêm vào hàng đợi. */
	public void queue(String []to, String subject, String body) {
		queue(new MailInfo(to, subject, body));
	}

	@Scheduled(fixedDelay = 5000)
	/** Cứ 5 giây lấy email trong hàng đợi để gửi. */
	public void run() {
		while (!listEmails.isEmpty()) {
			MailInfo mail = listEmails.remove(0);
			try {
				this.send(mail);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
}
