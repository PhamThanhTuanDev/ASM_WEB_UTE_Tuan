package ute.edu.service;

import ute.edu.model.MailInfo;

import jakarta.mail.MessagingException;


/** Hợp đồng gửi email trực tiếp hoặc đưa email vào hàng đợi. */
public interface MailerService {
	/** Gửi một email đầy đủ thông tin và tệp đính kèm nếu có. */
	void send(MailInfo mail) throws MessagingException;
	/** Gửi email đơn giản đến danh sách địa chỉ nhận. */
	void send(String []to, String subject, String body) throws MessagingException;
	/** Đưa email đầy đủ vào hàng đợi gửi sau. */
	void queue(MailInfo mail);
	/** Đưa email đơn giản vào hàng đợi gửi sau. */
	void queue(String []to, String subject, String body);
}
