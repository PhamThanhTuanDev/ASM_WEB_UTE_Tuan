package ute.edu.model;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class MailInfo {
	String from = "tranvandu19971029@gmail.com";
	String []to;
	String[] cc;
	String[] bcc;
	String subject;
	String body;
	List<File> files=new ArrayList<>();

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
