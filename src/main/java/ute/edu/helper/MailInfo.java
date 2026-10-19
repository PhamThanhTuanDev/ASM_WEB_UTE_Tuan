package ute.edu.helper;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import lombok.Data;

@Data
public class MailInfo {
	// Không chỉ định riêng thì dịch vụ gửi dùng tài khoản SMTP đã cấu hình.
	String from;
	String []to;
	String[] cc;
	String[] bcc;
	String subject;
	String body;
	List<File> files=new ArrayList<>();

	public MailInfo() {
	}

	public MailInfo(String from, String[] to, String[] cc, String[] bcc,
			String subject, String body, List<File> files) {
		this.from = from;
		this.to = to;
		this.cc = cc;
		this.bcc = bcc;
		this.subject = subject;
		this.body = body;
		this.files = files;
	}

	public MailInfo(String []to, String subject, String body) {
		this.to = to;
		this.subject = subject;
		this.body = body;
	}

	public String getFrom() { return from; }
	public String[] getTo() { return to; }
	public String[] getCc() { return cc; }
	public String[] getBcc() { return bcc; }
	public String getSubject() { return subject; }
	public String getBody() { return body; }
	public List<File> getFiles() { return files; }
}
