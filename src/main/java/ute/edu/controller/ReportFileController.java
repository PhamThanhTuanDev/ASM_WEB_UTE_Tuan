package ute.edu.controller;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.charset.StandardCharsets;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.MediaTypeFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import ute.edu.entity.Report;
import ute.edu.service.ReportService;

@Controller
/** Controller tải xuống hoặc mở file báo cáo đã lưu. */
public class ReportFileController {
    private static final Path REPORT_DIR = Paths.get("uploads", "reports").toAbsolutePath().normalize();

    private final ReportService reportService;

    public ReportFileController(ReportService reportService) {
        this.reportService = reportService;
    }

    @GetMapping("/reports/download/{id}")
    /** Tải file báo cáo theo mã báo cáo. */
    public ResponseEntity<Resource> download(@PathVariable Long id) throws IOException {
        Report report = reportService.getById(id);
        Resource resource = resolveResource(report.getFilePath());
        if (resource == null || !resource.exists() || !resource.isReadable()) {
            // Fallback: serve a generated demo file so seed data never 404
            resource = ensureDemoFile(report);
        }
        if (resource == null || !resource.exists() || !resource.isReadable()) {
            return ResponseEntity.notFound().build();
        }

        String downloadName = report.getFileName() != null ? report.getFileName() : "bao-cao.pdf";
        MediaType mediaType = MediaTypeFactory.getMediaType(downloadName)
                .orElse(MediaType.APPLICATION_OCTET_STREAM);

        return ResponseEntity.ok()
                .contentType(mediaType)
                .header(HttpHeaders.CONTENT_DISPOSITION,
                        ContentDisposition.attachment()
                                .filename(downloadName, StandardCharsets.UTF_8)
                                .build()
                                .toString())
                .body(resource);
    }

    @GetMapping("/reports/files/{fileName:.+}")
    /** Mở file đã tải lên từ thư mục lưu trữ báo cáo. */
    public ResponseEntity<Resource> openUploadedFile(@PathVariable String fileName) throws IOException {
        Path file = REPORT_DIR.resolve(fileName).normalize();
        if (!file.startsWith(REPORT_DIR) || !Files.isRegularFile(file)) {
            return ResponseEntity.notFound().build();
        }
        Resource resource = new FileSystemResource(file);
        return ResponseEntity.ok()
                .contentType(MediaTypeFactory.getMediaType(resource).orElse(MediaType.APPLICATION_OCTET_STREAM))
                .body(resource);
    }

    private Resource resolveResource(String filePath) {
        if (filePath == null || filePath.isBlank()) {
            return null;
        }
        String normalized = filePath.replace('\\', '/').trim();

        // Stored by ReportService.storeFile -> /reports/files/{name}
        if (normalized.startsWith("/reports/files/")) {
            Path file = REPORT_DIR.resolve(normalized.substring("/reports/files/".length())).normalize();
            if (file.startsWith(REPORT_DIR)) {
                return new FileSystemResource(file);
            }
        }

        // Seed SQL / legacy -> /uploads/reports/{name}
        if (normalized.startsWith("/uploads/reports/")) {
            Path file = REPORT_DIR.resolve(normalized.substring("/uploads/reports/".length())).normalize();
            if (file.startsWith(REPORT_DIR)) {
                return new FileSystemResource(file);
            }
        }

        // Relative path under uploads/reports
        if (!normalized.contains("..")) {
            String name = Paths.get(normalized).getFileName().toString();
            Path file = REPORT_DIR.resolve(name).normalize();
            if (Files.isRegularFile(file)) {
                return new FileSystemResource(file);
            }
        }

        // Optional classpath static fallback
        String classpathPath = normalized.replaceFirst("^/", "");
        ClassPathResource classpath = new ClassPathResource("static/" + classpathPath);
        if (classpath.exists()) {
            return classpath;
        }
        return null;
    }

    private Resource ensureDemoFile(Report report) throws IOException {
        Files.createDirectories(REPORT_DIR);
        String rawName = report.getFileName() != null ? report.getFileName() : "bao-cao-demo.pdf";
        String safeName = Paths.get(rawName).getFileName().toString().replaceAll("[^a-zA-Z0-9._-]", "_");
        if (safeName.isBlank()) {
            safeName = "bao-cao-demo.pdf";
        }

        // Prefer filename from stored path
        String path = report.getFilePath();
        if (path != null && !path.isBlank()) {
            String fromPath = Paths.get(path.replace('\\', '/')).getFileName().toString();
            if (!fromPath.isBlank()) {
                safeName = fromPath.replaceAll("[^a-zA-Z0-9._-]", "_");
            }
        }

        Path target = REPORT_DIR.resolve(safeName).normalize();
        if (!target.startsWith(REPORT_DIR)) {
            return null;
        }
        if (!Files.exists(target)) {
            String content = """
                    %%PDF-1.4
                    %% HCMUTE Thesis Portal - Demo report placeholder
                    %% File: %s
                    %% Report ID: %s
                    %% This is a generated demo file for local testing.
                    """.formatted(safeName, report.getId());
            Files.writeString(target, content, StandardCharsets.UTF_8);
        }
        return new FileSystemResource(target);
    }
}
