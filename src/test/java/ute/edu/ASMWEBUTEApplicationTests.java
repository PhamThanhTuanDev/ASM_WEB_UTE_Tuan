package ute.edu;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.security.web.FilterChainProxy;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import jakarta.servlet.http.Cookie;
import ute.edu.service.AuthTokenService;
import ute.edu.repository.UserAccountRepository;
import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.condition.EnabledIfSystemProperty;
import org.springframework.test.context.DynamicPropertySource;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.jdbc.core.JdbcTemplate;
import ute.edu.service.TopicRegistrationService;
import ute.edu.enums.RegistrationStatus;
import java.util.concurrent.*;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT, properties = {
        "spring.mail.password=test-only",
        "spring.security.oauth2.client.registration.google.client-id=test-client",
        "spring.security.oauth2.client.registration.google.client-secret=test-secret"
})
@EnabledIfSystemProperty(named = "seed.test.jdbc.url", matches = "jdbc:mysql://127\\.0\\.0\\.1:14336/.*")
class ASMWEBUTEApplicationTests {
    // Test tích hợp không gửi thư ra các địa chỉ của dữ liệu mẫu.
    @org.springframework.test.context.bean.override.mockito.MockitoBean
    ute.edu.service.MailerService mailerService;
    @org.springframework.boot.test.web.server.LocalServerPort
    int port;

    /** Chạy HTTP thật để JSP được biên dịch, thay vì chỉ kiểm tra model của controller. */
    @Test
    void rolePagesRenderThroughRealHttpAndExposeCsrfTokens() throws Exception {
        var client = java.net.http.HttpClient.newBuilder()
                .connectTimeout(java.time.Duration.ofSeconds(10)).build();
        String[][] routes = {
            {"admin", "admin", "dashboard", "periods", "topics", "groups", "councils", "results", "reports", "notifications", "users"},
            {"lecturer01", "lecturer", "dashboard", "topics", "groups", "councils", "reports", "notifications"},
            {"student01", "student", "dashboard", "group", "topics", "reports", "results", "notifications", "profile"}
        };
        for (String[] account : routes) {
            String token = tokens.issue(users.findByUsername(account[0]));
            try {
                for (int i = 2; i < account.length; i++) {
                    String path = "/" + account[1] + "/" + account[i];
                    var request = java.net.http.HttpRequest.newBuilder(java.net.URI.create("http://127.0.0.1:" + port + path))
                            .header("Cookie", AuthTokenService.COOKIE_NAME + "=" + token)
                            .timeout(java.time.Duration.ofSeconds(30)).GET().build();
                    var response = client.send(request, java.net.http.HttpResponse.BodyHandlers.ofString());
                    assertEquals(200, response.statusCode(), path);
                    assertTrue(response.body().contains("<html"), path);
                    assertFalse(response.body().contains("JasperException"), path);
                    if (response.body().contains("method=\"post\"") || response.body().contains("method=\"POST\""))
                        assertTrue(response.body().contains("name=\"_csrf\""), path);
                }
            } finally { tokens.revoke(token); }
        }
    }

    @Test
    void stateChangingRequestWithoutCsrfTokenIsRejected() throws Exception {
        var mvc = MockMvcBuilders.webAppContextSetup(context).addFilters(security).build();
        var result = mvc.perform(MockMvcRequestBuilders.post("/student/group/create")
                .param("name", "CSRF test").param("periodId", "1")
                .cookie(new Cookie(AuthTokenService.COOKIE_NAME, tokens.issue(users.findByUsername("student01"))))).andReturn();
        assertEquals(403, result.getResponse().getStatus());
    }

    @Test
    void loginFormWithSessionCsrfTokenStillWorks() throws Exception {
        var mvc = MockMvcBuilders.webAppContextSetup(context).addFilters(security).build();
        var loginPage = mvc.perform(MockMvcRequestBuilders.get("/login")).andReturn();
        var csrf = (org.springframework.security.web.csrf.CsrfToken) loginPage.getRequest().getAttribute(
                org.springframework.security.web.csrf.CsrfToken.class.getName());
        String token = csrf.getToken();
        var session = (org.springframework.mock.web.MockHttpSession) loginPage.getRequest().getSession();
        var result = mvc.perform(MockMvcRequestBuilders.post("/login").session(session)
                .param(csrf.getParameterName(), token).param("email", "admin").param("password", "admin123")).andReturn();
        assertEquals(302, result.getResponse().getStatus());
        assertEquals("/admin/dashboard", result.getResponse().getRedirectedUrl());
    }

    /** Các bất biến liên bảng mà khóa ngoại riêng lẻ chưa thể biểu diễn. */
    @Test
    void sampleDataPreservesWorkflowInvariants() {
        String[] checks = {
            "SELECT COUNT(*) FROM (SELECT gm.student_id,g.reg_period_id FROM group_members gm JOIN student_groups g ON g.id=gm.group_id WHERE g.reg_period_id IS NOT NULL GROUP BY gm.student_id,g.reg_period_id HAVING COUNT(*)>1) x",
            "SELECT COUNT(*) FROM (SELECT group_id FROM group_members GROUP BY group_id HAVING COUNT(*)>3) x",
            "SELECT COUNT(*) FROM student_groups g LEFT JOIN group_members m ON m.group_id=g.id AND m.student_id=g.leader_id AND m.leader=1 WHERE m.id IS NULL",
            "SELECT COUNT(*) FROM topic_registrations r JOIN student_groups g ON g.id=r.group_id JOIN topics t ON t.id=r.topic_id WHERE g.reg_period_id<>t.reg_period_id",
            "SELECT COUNT(*) FROM topic_assignments a JOIN councils c ON c.id=a.council_id JOIN topic_registrations r ON r.id=a.topic_registration_id JOIN topics t ON t.id=r.topic_id WHERE c.reg_period_id<>t.reg_period_id",
            "SELECT COUNT(*) FROM topic_assignments a JOIN topic_registrations r ON r.id=a.topic_registration_id JOIN topic_supervisors s ON s.topic_id=r.topic_id JOIN council_members m ON m.council_id=a.council_id AND m.lecturer_id=s.lecturer_id",
            "SELECT COUNT(*) FROM group_members m JOIN students s ON s.id=m.student_id JOIN student_groups g ON g.id=m.group_id JOIN students l ON l.id=g.leader_id WHERE s.department_id<>l.department_id",
            "SELECT COUNT(*) FROM scores s JOIN topic_assignments a ON a.id=s.topic_assignment_id JOIN council_members m ON m.id=s.council_member_id WHERE m.council_id<>a.council_id",
            "SELECT COUNT(*) FROM registration_periods WHERE lecturer_end_date<lecturer_start_date OR student_start_date<=lecturer_end_date OR student_end_date<student_start_date OR council_report_date<=student_end_date OR reviewer_deadline<=COALESCE(council_report_date,student_end_date)"
        };
        for (String sql : checks) assertEquals(0, jdbc.queryForObject(sql, Integer.class), sql);
    }

    @Test
    void seedCouncilDatesMatchPeriods() {
        assertEquals(0, jdbc.queryForObject("SELECT COUNT(*) FROM councils c JOIN registration_periods p "
                + "ON p.id=c.reg_period_id WHERE NOT (c.council_date <=> p.council_report_date)", Integer.class));
    }
    @DynamicPropertySource
    static void temporaryDatabase(DynamicPropertyRegistry properties) {
        properties.add("spring.datasource.url", () -> System.getProperty("seed.test.jdbc.url"));
        properties.add("spring.datasource.username", () -> "root");
        properties.add("spring.datasource.password", () -> "");
    }
    @Autowired WebApplicationContext context;
    @Autowired FilterChainProxy security;
    @Autowired AuthTokenService tokens;
    @Autowired UserAccountRepository users;
    @Autowired JdbcTemplate jdbc;
    @Autowired TopicRegistrationService registrations;
    @Autowired ute.edu.service.CouncilService councilService;

	@Test
	void contextLoads() {
	}

    @Test
    void plannedCouncilHasTwoEligibleDemoRegistrations() {
        var council = councilService.findById(2L);
        assertTrue(councilService.canAssignToCouncil(council, registrations.findById(2L)));
        assertTrue(councilService.canAssignToCouncil(council, registrations.findById(17L)));
        assertFalse(councilService.canAssignToCouncil(councilService.findById(1L), registrations.findById(17L)));
    }

    @Test
    @org.springframework.transaction.annotation.Transactional
    void canAssignMultipleDemoTopicsToThreePlannedCouncils() {
        long[][] examples = {{2,2,17,9,15},{5,5,11},{6,6,12}};
        for (long[] example : examples) {
            var council = councilService.findById(example[0]);
            assertEquals(ute.edu.enums.CouncilStatus.PLANNED, council.getStatus());
            assertTrue(councilService.getAssignments(example[0]).isEmpty());
            for (int i=1; i<example.length; i++) {
                var registration = registrations.findById(example[i]);
                assertTrue(councilService.canAssignToCouncil(council, registration), "Council " + example[0] + ", registration " + example[i]);
                councilService.assignTopic(example[0], example[i]);
            }
            assertEquals(example.length-1, councilService.getAssignments(example[0]).size());
        }
        assertThrows(IllegalStateException.class, () -> councilService.assignTopic(2L, 2L));
    }

    @Test
    void minhCanSeeCompletedResultThroughAuthenticatedRoute() throws Exception {
        var mvc = MockMvcBuilders.webAppContextSetup(context).addFilters(security).build();
        var user = users.findByUsername("student01");
        var result = mvc.perform(MockMvcRequestBuilders.get("/student/results")
                .cookie(new Cookie(AuthTokenService.COOKIE_NAME, tokens.issue(user)))).andReturn();
        assertEquals(200, result.getResponse().getStatus());
        assertNotNull(result.getModelAndView());
        assertEquals(8.75, (Double) result.getModelAndView().getModel().get("avgScore"));
    }

    @Test
    void minhCanDownloadRealDemoPdfThroughAuthenticatedRoute() throws Exception {
        var mvc = MockMvcBuilders.webAppContextSetup(context).addFilters(security).build();
        var result = mvc.perform(MockMvcRequestBuilders.get("/reports/download/1")
                .cookie(new Cookie(AuthTokenService.COOKIE_NAME,tokens.issue(users.findByUsername("student01"))))).andReturn();
        assertEquals(200,result.getResponse().getStatus());
        assertEquals("application/pdf",result.getResponse().getContentType());
        assertEquals("%PDF-",new String(result.getResponse().getContentAsByteArray(),0,5,java.nio.charset.StandardCharsets.US_ASCII));
        assertTrue(result.getResponse().getHeader("Content-Disposition").contains("BaoCao_DT001_demo.pdf"));
    }

    @Test
    @org.springframework.transaction.annotation.Transactional
    void openingNavbarNotificationUpdatesAllBadgesInSameResponse() throws Exception {
        var mvc = MockMvcBuilders.webAppContextSetup(context).addFilters(security).build();
        for (String[] account : new String[][]{{"student01","student"},{"lecturer01","lecturer"},{"admin","admin"}}) {
            String token = tokens.issue(users.findByUsername(account[0]));
            var before = mvc.perform(MockMvcRequestBuilders.get("/"+account[1]+"/notifications")
                    .cookie(new Cookie(AuthTokenService.COOKIE_NAME,token))).andReturn();
            int count = (Integer) before.getModelAndView().getModel().get("unreadNotifCount");
            assertTrue(count>0);
            var after = mvc.perform(MockMvcRequestBuilders.get("/"+account[1]+"/notifications").param("notificationId","20")
                    .cookie(new Cookie(AuthTokenService.COOKIE_NAME,token))).andReturn();
            assertEquals(200,after.getResponse().getStatus());
            var model = after.getModelAndView().getModel();
            assertEquals(count-1,model.get("unreadNotifCount"),account[0]);
            assertEquals(count-1,model.get("unreadNotifyCount"));
            assertTrue(((java.util.List<ute.edu.entity.Notification>)model.get("topNotifications")).stream().noneMatch(n->n.getId()==20L));
            var repeat = mvc.perform(MockMvcRequestBuilders.get("/"+account[1]+"/notifications").param("notificationId","20")
                    .cookie(new Cookie(AuthTokenService.COOKIE_NAME,token))).andReturn();
            assertEquals(count-1,repeat.getModelAndView().getModel().get("unreadNotifCount"));
        }
    }

    @Test
    void studentCannotOpenAdminDashboard() throws Exception {
        var mvc = MockMvcBuilders.webAppContextSetup(context).addFilters(security).build();
        var result = mvc.perform(MockMvcRequestBuilders.get("/admin/dashboard")
                .cookie(new Cookie(AuthTokenService.COOKIE_NAME, tokens.issue(users.findByUsername("student01"))))).andReturn();
        assertEquals(403, result.getResponse().getStatus());
    }

    @Test
    void simultaneousApprovalsGiveTopicToOnlyOneGroup() throws Exception {
        jdbc.update("INSERT INTO registration_periods (id,name,type,lecturer_start_date,lecturer_end_date,student_start_date,student_end_date,status,active) VALUES (1001,'Concurrency test','NCKH','2026-10-01','2026-10-10','2026-10-11','2026-10-20','OPEN',1)");
        jdbc.update("INSERT INTO topics (id,code,title,description,department_id,reg_period_id,lecturer_id,max_students,status) VALUES (1001,'TEST_RACE','Concurrent approval test','Test only',1,1001,1,3,'PUBLISHED')");
        jdbc.update("INSERT INTO student_groups (id,name,leader_id,reg_period_id,status) VALUES (1001,'Test A',90,1001,'READY'),(1002,'Test B',96,1001,'READY')");
        jdbc.update("INSERT INTO group_members (group_id,student_id,leader) VALUES (1001,90,1),(1002,96,1)");
        jdbc.update("INSERT INTO topic_registrations (id,group_id,topic_id,status) VALUES (1001,1001,1001,'PENDING'),(1002,1002,1001,'PENDING')");
        ExecutorService workers = Executors.newFixedThreadPool(2);
        CountDownLatch ready = new CountDownLatch(2);
        try {
            java.util.function.LongFunction<Callable<Boolean>> approve = id -> () -> {
                ready.countDown();
                if (!ready.await(10, TimeUnit.SECONDS)) throw new IllegalStateException("Barrier timeout");
                try { registrations.updateStatus(id, RegistrationStatus.APPROVED, null, null); return true; }
                catch (IllegalStateException expected) { return false; }
            };
            Future<Boolean> first = workers.submit(approve.apply(1001));
            Future<Boolean> second = workers.submit(approve.apply(1002));
            assertNotEquals(first.get(15,TimeUnit.SECONDS), second.get(15,TimeUnit.SECONDS));
            assertEquals(1, jdbc.queryForObject("SELECT COUNT(*) FROM topic_registrations WHERE topic_id=1001 AND status='APPROVED'", Integer.class));
        } finally {
            workers.shutdownNow();
            jdbc.update("DELETE FROM topic_registrations WHERE id IN (1001,1002)");
            jdbc.update("DELETE FROM group_members WHERE group_id IN (1001,1002)");
            jdbc.update("DELETE FROM student_groups WHERE id IN (1001,1002)");
            jdbc.update("DELETE FROM topics WHERE id=1001");
            jdbc.update("DELETE FROM registration_periods WHERE id=1001");
        }
    }

}
