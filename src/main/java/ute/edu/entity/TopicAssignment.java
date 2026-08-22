package ute.edu.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import ute.edu.enums.AssignmentStatus;

@Entity
@Table(name = "topic_assignments", uniqueConstraints = @UniqueConstraint(columnNames = {"council_id", "topic_registration_id"}))
public class TopicAssignment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "council_id")
    private ReviewCouncil council;
    @ManyToOne(optional = false)
    @JoinColumn(name = "topic_registration_id")
    private TopicRegistration topicRegistration;
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private AssignmentStatus status = AssignmentStatus.ASSIGNED;
    @Column(nullable = false)
    private LocalDateTime assignedAt = LocalDateTime.now();

    public Long getId() { return id; }
    public ReviewCouncil getCouncil() { return council; }
    public void setCouncil(ReviewCouncil value) { council = value; }
    public TopicRegistration getTopicRegistration() { return topicRegistration; }
    public void setTopicRegistration(TopicRegistration value) { topicRegistration = value; }
    public AssignmentStatus getStatus() { return status; }
    public void setStatus(AssignmentStatus value) { status = value; }
    public LocalDateTime getAssignedAt() { return assignedAt; }
}
