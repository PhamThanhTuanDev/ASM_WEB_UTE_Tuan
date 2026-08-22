package ute.edu.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "reports")
public class Report {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "topic_registration_id")
    private TopicRegistration topicRegistration;

    @Column(nullable = false)
    private String fileName;
    @Column(nullable = false, length = 1000)
    private String filePath;
    @Column(length = 1000)
    private String note;

    @ManyToOne(optional = false)
    @JoinColumn(name = "submitted_by")
    private Student submittedBy;
    @Column(nullable = false)
    private LocalDateTime submittedAt = LocalDateTime.now();

    public Long getId() { return id; }
    public TopicRegistration getTopicRegistration() { return topicRegistration; }
    public void setTopicRegistration(TopicRegistration value) { topicRegistration = value; }
    public String getFileName() { return fileName; }
    public void setFileName(String value) { fileName = value; }
    public String getFilePath() { return filePath; }
    public void setFilePath(String value) { filePath = value; }
    public String getNote() { return note; }
    public void setNote(String value) { note = value; }
    public Student getSubmittedBy() { return submittedBy; }
    public void setSubmittedBy(Student value) { submittedBy = value; }
    public LocalDateTime getSubmittedAt() { return submittedAt; }
}
