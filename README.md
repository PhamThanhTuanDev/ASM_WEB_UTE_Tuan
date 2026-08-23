# Hệ thống quản lý đề tài NCKH / TLCN / KLTN

## Mục tiêu

Hệ thống hỗ trợ quản lý toàn bộ quy trình đăng ký, phê duyệt, phân công, phản biện và công bố kết quả đề tài trong khoa CNTT.

## Cấu trúc chính

- `src/main/java/ute/edu/config`: cấu hình Spring Boot, security, locale
- `src/main/java/ute/edu/controller`: controller cho admin, giảng viên, sinh viên
- `src/main/java/ute/edu/model`: entity nghiệp vụ
- `src/main/java/ute/edu/repository`: repository JPA
- `src/main/java/ute/edu/service`: service xử lý nghiệp vụ
- `src/main/java/ute/edu/dto`: DTO giao tiếp
- `src/main/java/ute/edu/enums`: enum trạng thái, vai trò
- `src/main/resources/templates`: giao diện MVC theo module

## Các module nghiệp vụ

1. Quản lý đợt đăng ký
2. Quản lý đề tài theo bộ môn
3. Nhóm sinh viên đăng ký đề tài
4. Phê duyệt và phân công GVHD/GVPB
5. Quản lý hội đồng phản biện
6. Chấm điểm và công bố kết quả
7. Quản lý tài khoản và thông báo nhà trường

## Chạy ứng dụng

```bash
mvnw.cmd spring-boot:run
```

## Cấu hình database

Ứng dụng dùng MySQL. Tạo database trước khi chạy:

```sql
CREATE DATABASE asm_web_ute CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

Cập nhật `spring.datasource.username` và `spring.datasource.password` trong
`src/main/resources/application.properties`. Hibernate sẽ tự tạo/cập nhật các
bảng từ toàn bộ entity khi `spring.jpa.hibernate.ddl-auto=update`.

Lần chạy đầu tiên tự tạo dữ liệu mẫu nếu chưa tồn tại:

- `admin` / `admin123`
- `lecturer01` / `lecturer123`
- `student01` / `student123`

## Lưu ý

Dự án này đang được tổ chức lại theo mô hình nghiệp vụ quản lý đề tài thay cho mô hình bán hàng cũ.
