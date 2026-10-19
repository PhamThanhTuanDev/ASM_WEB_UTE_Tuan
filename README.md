# Hệ thống quản lý đề tài sinh viên HCMUTE

Ứng dụng quản lý quá trình đề xuất, đăng ký, hướng dẫn, báo cáo và đánh giá đề tài sinh viên. Hỗ trợ khóa luận tốt nghiệp, tiểu luận chuyên ngành, nghiên cứu khoa học và môn học chuyên đề.

Tài liệu hướng dẫn cài đặt trên Windows bằng PowerShell. Các lệnh phải chạy tại thư mục gốc dự án, nơi có `pom.xml`, trừ khi có ghi chú khác.

## Mục lục

1. [Chức năng và vai trò](#1-chức-năng-và-vai-trò)
2. [Công nghệ và yêu cầu môi trường](#2-công-nghệ-và-yêu-cầu-môi-trường)
3. [Cấu trúc dự án](#3-cấu-trúc-dự-án)
4. [Chuẩn bị cơ sở dữ liệu](#4-chuẩn-bị-cơ-sở-dữ-liệu)
5. [Cấu hình ứng dụng](#5-cấu-hình-ứng-dụng)
6. [Khởi động ứng dụng](#6-khởi-động-ứng-dụng)
7. [Tài khoản và dữ liệu mẫu](#7-tài-khoản-và-dữ-liệu-mẫu)
8. [Hướng dẫn quy trình sử dụng](#8-hướng-dẫn-quy-trình-sử-dụng)
9. [Quy tắc nghiệp vụ](#9-quy-tắc-nghiệp-vụ)
10. [Kiểm thử](#10-kiểm-thử)
11. [Đóng gói và chạy WAR](#11-đóng-gói-và-chạy-war)
12. [Lỗi thường gặp](#12-lỗi-thường-gặp)
13. [Lưu trữ và vận hành](#13-lưu-trữ-và-vận-hành)
14. [Triển khai Docker / Railway](#14-triển-khai-docker--railway)

## 1. Chức năng và vai trò

| Vai trò | Chức năng chính |
| --- | --- |
| Quản trị viên | Quản lý đợt, duyệt đề xuất đề tài, theo dõi nhóm và báo cáo, tạo hội đồng, phân công đề tài, công bố kết quả, quản lý thông báo và xem tài khoản |
| Trưởng khoa / phụ trách khoa | Truy cập khu vực quản lý theo phân quyền của ứng dụng; duyệt đề xuất và điều phối hội đồng |
| Giảng viên | Đề xuất đề tài, duyệt đăng ký của nhóm được hướng dẫn, xem và duyệt báo cáo, chấm điểm quá trình, chấm hội đồng được phân công |
| Sinh viên | Cập nhật hồ sơ, tạo nhóm, thêm thành viên, đăng ký đề tài, nộp báo cáo, xem lịch và kết quả, đọc thông báo |

Các khu vực chính:

| Đường dẫn | Nội dung |
| --- | --- |
| `/` | Trang chủ |
| `/login` | Đăng nhập |
| `/admin/dashboard` | Bảng điều khiển quản lý |
| `/lecturer/dashboard` | Bảng điều khiển giảng viên |
| `/student/dashboard` | Bảng điều khiển sinh viên |

## 2. Công nghệ và yêu cầu môi trường

| Thành phần | Yêu cầu của dự án |
| --- | --- |
| Java | **JDK 25**, theo `java.version` trong `pom.xml` |
| Spring Boot | 4.1.1, theo phiên bản đang khai báo trong `pom.xml` |
| Maven | Có thể dùng Maven cài sẵn; Maven Wrapper của dự án tải Maven 3.9.9 |
| Database | MySQL 8; bộ dữ liệu mẫu đã được kiểm tra trên MySQL 8.0.33 |
| Giao diện | JSP, JSTL, Tailwind CSS, Bootstrap, SweetAlert2 và JavaScript |
| Đóng gói | WAR chạy trực tiếp hoặc triển khai vào servlet container tương thích |
| Node.js | Không bắt buộc để chạy ứng dụng; dùng khi kiểm tra cú pháp JavaScript |
| Kết nối Internet | Cần khi tải dependency lần đầu, dùng tài nguyên CDN, đăng nhập Google hoặc gửi email |

Kiểm tra Java và Maven:

```powershell
java -version
mvn -version
```

Nếu chưa cài Maven, dùng Wrapper:

```powershell
.\mvnw.cmd -version
```

Java trong kết quả `mvn -version` phải là JDK 25. Trên máy có nhiều JDK, Java trong `PATH` có thể khác Java mà Maven sử dụng.

Ví dụ chọn JDK cho phiên PowerShell hiện tại; thay đường dẫn bằng thư mục JDK thực tế:

```powershell
$env:JAVA_HOME = 'C:\Program Files\Java\jdk-25'
$env:Path = "$env:JAVA_HOME\bin;$env:Path"
java -version
mvn -version
```

## 3. Cấu trúc dự án

```text
ASM_WEB_UTE/
├── database/
│   └── asm_web_ute_data.sql       # Schema và dữ liệu mẫu
├── src/main/java/ute/edu/
│   ├── ASMWEBUTEApplication.java # Điểm khởi động
│   ├── config/                   # Bảo mật, OAuth, khởi tạo dữ liệu
│   ├── controller/               # Tiếp nhận yêu cầu theo vai trò
│   ├── entity/                   # Ánh xạ bảng dữ liệu
│   ├── enums/                    # Vai trò và trạng thái nghiệp vụ
│   ├── helper/                   # Định dạng ngày, nhãn và thông báo lỗi
│   ├── repository/               # Truy vấn JPA và khóa bản ghi
│   └── service/                  # Quy tắc nghiệp vụ và giao dịch
├── src/main/resources/
│   ├── application.properties    # Cấu hình ứng dụng
│   └── demo-reports/             # Báo cáo PDF mẫu
├── src/main/webapp/
│   ├── assets/                   # CSS, JavaScript và hình ảnh
│   └── views/
│       ├── common/               # Header, menu, thanh điều hướng, footer
│       ├── admin/
│       ├── lecturer/
│       └── student/
├── src/test/java/                # Test đơn vị và tích hợp
├── uploads/reports/              # Tệp người dùng tải lên, sinh khi chạy
├── target/                      # Kết quả build, không chỉnh sửa trực tiếp
├── pom.xml
└── README.md                     # Cài đặt, sử dụng và kiểm thử
```

## 4. Chuẩn bị cơ sở dữ liệu

### 4.1. Tạo database

Khởi động MySQL. Dùng MySQL Workbench hoặc MySQL CLI để chạy:

```sql
CREATE DATABASE IF NOT EXISTS asm_web_ute
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
```

Kết nối mặc định của ứng dụng là MySQL tại `localhost:3306`, database `asm_web_ute`.

### 4.2. Dữ liệu mẫu được nạp như thế nào?

`DataInitializer` kiểm tra database khi ứng dụng khởi động:

- Database trống: nhập schema và dữ liệu mẫu nếu bật `app.seed.enabled`.
- Database đã có dữ liệu: mặc định giữ lại dữ liệu hiện có, có thể bổ sung bảng dự án còn thiếu.
- Không tự nhập lại toàn bộ dữ liệu khi khởi động bình thường.
- Hibernate đang dùng `spring.jpa.hibernate.ddl-auto=update` để cập nhật ánh xạ entity.

Cấu hình mặc định:

```properties
app.seed.enabled=true
app.seed.every-run=false
```

**File `database/asm_web_ute_data.sql` chứa `DROP TABLE`.** Không nhập thủ công file này vào database cần giữ. Không bật `app.seed.every-run=true` trên database đang sử dụng. Muốn làm lại dữ liệu mẫu, hãy dùng database thử nghiệm riêng và sao lưu dữ liệu cần giữ trước.

Các thay đổi trong file SQL mẫu không tự áp lại vào những dòng dữ liệu đã tồn tại. Khi cần chỉnh dữ liệu đang dùng, thực hiện thao tác quản trị hoặc một bản cập nhật dữ liệu riêng có kiểm tra.

## 5. Cấu hình ứng dụng

Cấu hình gốc nằm trong [application.properties](src/main/resources/application.properties).

### 5.1. Biến môi trường

| Biến | Ý nghĩa |
| --- | --- |
| `PORT` | Cổng HTTP; mặc định `14090` |
| `DB_HOST`, `DB_PORT`, `DB_NAME` | Máy chủ, cổng, tên database; mặc định `localhost`, `3306`, `asm_web_ute` |
| `DB_USERNAME` | Tên người dùng MySQL; mặc định `root` |
| `DB_PASSWORD` | Mật khẩu MySQL của bạn |
| `SPRING_DATASOURCE_URL` | Ghi đè toàn bộ URL kết nối khi đổi máy chủ, cổng hoặc tên database |
| `DDL_AUTO` | Chế độ cập nhật schema của Hibernate; mặc định `update`, hosting đã import SQL nên đặt `none` |
| `LAZY_INIT` | `true` để khởi tạo bean khi cần, giúp khởi động nhanh trên cloud; mặc định `false` |
| `SHOW_SQL` | `true` để in câu SQL ra console khi gỡ lỗi; mặc định `false` |
| `MAIL_USERNAME` | Tài khoản gửi email |
| `MAIL_PASSWORD` | Thông tin xác thực SMTP phù hợp với tài khoản gửi |
| `GOOGLE_CLIENT_ID` | Client ID của ứng dụng Google OAuth |
| `GOOGLE_CLIENT_SECRET` | Client secret của ứng dụng Google OAuth |

Ví dụ cấu hình cho phiên PowerShell hiện tại; thay các giá trị minh họa bằng cấu hình của bạn:

```powershell
$env:PORT = '14090'
$env:DB_USERNAME = 'root'
$env:DB_PASSWORD = 'mat-khau-mysql-cua-ban'
$env:MAIL_USERNAME = 'tai-khoan-gui-thu@example.com'
$env:MAIL_PASSWORD = 'thong-tin-xac-thuc-smtp'
$env:GOOGLE_CLIENT_ID = 'client-id-cua-ban'
$env:GOOGLE_CLIENT_SECRET = 'client-secret-cua-ban'
```

Nếu MySQL chạy ở cổng khác:

```powershell
$env:SPRING_DATASOURCE_URL = 'jdbc:mysql://localhost:3307/asm_web_ute?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Ho_Chi_Minh&useUnicode=true&characterEncoding=UTF-8'
```

Ứng dụng tự nạp `.env` trong thư mục làm việc qua `spring.config.import`. Dùng định dạng `TEN_BIEN=gia-tri`, không bọc giá trị bằng dấu nháy. Với Gmail, nhập mật khẩu ứng dụng liền mạch, không có khoảng trắng phân cách. Biến môi trường của tiến trình được ưu tiên hơn `.env`; nếu từng đặt giá trị thử nghiệm trong IDE/PowerShell, cần xóa hoặc thay giá trị đó. `.env` được bỏ qua bởi Git. Khi chạy WAR ngoài thư mục dự án, đặt `.env` tại thư mục chạy hoặc truyền biến môi trường.

### 5.2. Chạy bằng IDE

1. Mở dự án Maven và chờ IDE tải dependency.
2. Chọn JDK 25 cho dự án và cấu hình chạy.
3. Đặt working directory là thư mục chứa `pom.xml`.
4. Khai báo các biến môi trường ở bảng trên trong cấu hình chạy.
5. Chạy lớp `ute.edu.ASMWEBUTEApplication`.

Nếu khởi động từ IDE, các biến vừa đặt ở một cửa sổ PowerShell khác không tự cập nhật vào IDE đang mở.

### 5.3. Đăng nhập Google

Ứng dụng cần thông tin của một OAuth client dạng ứng dụng web. Khai báo `GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET` và cấu hình callback khớp với địa chỉ chạy:

```text
http://localhost:14090/login/oauth2/code/google
```

Khi đổi cổng hoặc triển khai trên địa chỉ khác, cập nhật callback tương ứng. Luồng hiện tại yêu cầu email Google đã được xác minh và thuộc miền `hcmute.edu.vn`, `student.hcmute.edu.vn` hoặc `teacher.hcmute.edu.vn`.

- Tài khoản đã có hồ sơ hợp lệ: chuyển đến khu vực theo vai trò.
- Email sinh viên hợp lệ nhưng chưa có tài khoản: chuyển đến trang hoàn thiện hồ sơ.
- Email sai miền, chưa xác minh, tài khoản bị khóa hoặc thiếu hồ sơ bắt buộc: từ chối đăng nhập và hiện thông báo.

### 5.4. Email

Cấu hình hiện tại dùng SMTP Gmail, cổng `587`, STARTTLS. Điền thông tin xác thực được nhà cung cấp hỗ trợ; không đưa thông tin thật vào tài liệu hoặc Git.

Email được đưa vào hàng đợi và xử lý định kỳ trong ứng dụng. Việc đăng nhập hệ thống bằng tài khoản mẫu không chứng minh SMTP đã hoạt động; cần thực hiện một thao tác gửi thư và kiểm tra nhật ký/kết quả nhận thư.

Hiện có các thời điểm đưa thư vào hàng đợi:

- Giảng viên chấp nhận đăng ký đề tài: gửi thông báo đến email của các sinh viên trong nhóm, kèm mã và tên đề tài, đợt đăng ký và GVHD.
- Giảng viên từ chối đăng ký đề tài: gửi thông báo từ chối đến các sinh viên trong nhóm, kèm thông tin đề tài và lý do; nếu chưa nhập lý do, thư ghi rõ giảng viên chưa cung cấp lý do.
- Chốt và công bố điểm hội đồng: gửi kết quả tổng kết cho các thành viên nhóm.

Thư chỉ được đưa vào hàng đợi sau khi giao dịch lưu dữ liệu thành công. Từ chối đăng ký hoặc duyệt bị lỗi không gửi thư chấp nhận. Địa chỉ người gửi mặc định lấy từ `spring.mail.username` (`MAIL_USERNAME`). Hàng đợi hiện lưu trong bộ nhớ, chưa tự thử lại thư gửi thất bại và không tồn tại qua lần khởi động lại ứng dụng.

### 5.5. Chỉ chạy thử các chức năng cục bộ

Nếu chưa có Google OAuth hoặc SMTP thật, có thể đặt giá trị giả để ứng dụng giải quyết các cấu hình bắt buộc và thử đăng nhập bằng mật khẩu:

```powershell
$env:MAIL_PASSWORD = 'local-test-only'
$env:GOOGLE_CLIENT_ID = 'local-test-client'
$env:GOOGLE_CLIENT_SECRET = 'local-test-secret'
```

Các giá trị này **không dùng được để đăng nhập Google hoặc gửi email thật**. Vẫn cần kết nối MySQL hợp lệ.

## 6. Khởi động ứng dụng

Với Maven cài sẵn:

```powershell
mvn spring-boot:run
```

Hoặc Maven Wrapper:

```powershell
.\mvnw.cmd spring-boot:run
```

Mở `http://localhost:14090`. Nếu đổi `PORT`, dùng cổng đã cấu hình. Dừng ứng dụng bằng `Ctrl + C` hoặc nút dừng trong IDE.

Sau khi sửa Java, cần chạy lại ứng dụng. Sau khi sửa CSS hoặc JavaScript, có thể cần `Ctrl + F5` để bỏ bản lưu trong bộ nhớ đệm.

## 7. Tài khoản và dữ liệu mẫu

Các tài khoản sau có trong bộ dữ liệu mẫu:

| Tên đăng nhập | Mật khẩu | Vai trò |
| --- | --- | --- |
| `admin` | `admin123` | Quản trị viên |
| `lecturer01` | `123456` | Giảng viên |
| `student01` | `123456` | Sinh viên |

Ô đăng nhập hỗ trợ tên tài khoản hoặc email. Mật khẩu có phân biệt khoảng trắng.

Nếu database đã có dữ liệu khác, tài khoản mẫu có thể không tồn tại vì ứng dụng không tự ghi đè dữ liệu hiện có.

`app.demo.quick-login=true` đang bật chức năng đăng nhập nhanh/chuyển vai trò để trình diễn. Khi triển khai sử dụng thật, đặt `app.demo.quick-login=false`.

Bộ dữ liệu mẫu được chuẩn bị theo ngày **17/10/2026**, gồm nhiều đợt đã đóng và một số đợt đang mở. Ứng dụng kiểm tra ngày hiện tại theo múi giờ Việt Nam; trạng thái “Đang mở” chưa đủ để một đợt xuất hiện trong mọi form.

Ví dụ: đợt còn hạn sinh viên đăng ký nhưng đã hết hạn giảng viên đề xuất sẽ xuất hiện ở form tạo nhóm, nhưng không xuất hiện ở form đề xuất đề tài. Để thử chức năng đề xuất vào ngày khác, tạo một đợt mới có thời gian giảng viên đề xuất bao gồm ngày đang chạy.

## 8. Hướng dẫn quy trình sử dụng

### Bước 1. Tạo đợt đăng ký

Quản trị viên/trưởng khoa vào **Đợt đăng ký**, nhập tên, loại đợt, trạng thái và các mốc thời gian. Muốn người dùng thao tác trong đợt, chọn trạng thái đang mở và thiết lập đúng cửa sổ thời gian của chức năng cần thử.

### Bước 2. Giảng viên đề xuất đề tài

Vào **Đề xuất đề tài**, chọn đợt còn hạn giảng viên đề xuất; nhập mã, tên, mô tả, khoa, số sinh viên và đồng hướng dẫn nếu có. Đề tài được gửi chờ duyệt.

### Bước 3. Duyệt đề xuất

Trưởng khoa/quản trị viên vào **Duyệt đề tài** để chấp nhận hoặc từ chối đề xuất. Sinh viên chỉ tra cứu được đề tài khả dụng phù hợp khoa và đợt của nhóm.

### Bước 4. Sinh viên tạo nhóm

Vào **Đồ án và Nhóm của tôi**, chọn đợt còn hạn sinh viên đăng ký và tạo nhóm. Người tạo tự động là nhóm trưởng. Nhóm trưởng nhập MSSV để thêm trực tiếp thành viên đủ điều kiện.

### Bước 5. Đăng ký đề tài

Nhóm trưởng vào **Tra cứu đề tài**. Đợt được tự lấy và khóa theo đợt của nhóm. Chọn đề tài phù hợp rồi gửi đăng ký. Nhóm có đơn chờ duyệt sẽ bị khóa thay đổi thành viên.

### Bước 6. Giảng viên duyệt nhóm

Giảng viên hướng dẫn vào **Nhóm hướng dẫn** để duyệt hoặc từ chối đăng ký đề tài của nhóm. Khi được duyệt, đề tài được gán chính thức cho nhóm.

### Bước 7. Nộp báo cáo và đánh giá quá trình

Nhóm trưởng nộp báo cáo. Giảng viên hướng dẫn xem báo cáo, nhập điểm quá trình và duyệt báo cáo theo điều kiện của hệ thống.

### Bước 8. Thành lập và phân công hội đồng

Quản trị viên/trưởng khoa tạo hội đồng trong đợt hợp lệ, chọn chủ tịch, thư ký và ủy viên. Sau đó phân công các đăng ký đủ điều kiện vào hội đồng phù hợp.

### Bước 9. Chấm điểm hội đồng

Giảng viên mở **Hội đồng và Chấm điểm**. Danh sách chỉ hiện hội đồng có đề tài được phân công, bao gồm hội đồng đã hoàn tất. Đến ngày báo cáo, thành viên hội đồng nhập điểm trong thời hạn cho phép.

### Bước 10. Công bố kết quả

Khi đủ điểm hợp lệ, quản trị viên/trưởng khoa chốt và công bố kết quả. Sinh viên xem điểm đã công bố tại **Lịch và Điểm số**. Hội đồng đã chốt không được sửa điểm.

## 9. Quy tắc nghiệp vụ

### 9.1. Thời hạn

- Hạn kết thúc giảng viên đề xuất không trước ngày bắt đầu.
- Sinh viên bắt đầu đăng ký sau khi kết thúc giai đoạn giảng viên đề xuất.
- Ngày kết thúc sinh viên đăng ký không trước ngày bắt đầu.
- Ngày báo cáo hội đồng, nếu có, phải sau hạn sinh viên đăng ký.
- Hạn nộp điểm phải sau hạn sinh viên đăng ký và sau ngày báo cáo nếu đợt có ngày báo cáo.
- Tiểu luận chuyên ngành và khóa luận tốt nghiệp bắt buộc có hạn GVPB nộp điểm; khóa luận tốt nghiệp bắt buộc có ngày báo cáo hội đồng.
- Kiểm tra cửa sổ đề xuất/đăng ký tính cả ngày đầu và ngày cuối, theo múi giờ Việt Nam.
- Danh sách đợt ưu tiên đang mở trước; trong mỗi nhóm mở/chưa mở, đợt mới nhất lên trước.

### 9.2. Nhóm sinh viên

- Mỗi sinh viên tối đa một nhóm trong một đợt; có thể có nhóm ở đợt khác.
- Tối đa 3 người, bao gồm nhóm trưởng; phải cùng khoa, có thể khác lớp.
- Thêm trực tiếp bằng MSSV, không có bước đồng ý hoặc từ chối lời mời.
- Chỉ nhóm trưởng được thêm/xóa thành viên, không được xóa nhóm trưởng.
- Nhóm đủ 3 người hoặc có đơn chờ duyệt/đã duyệt thì khóa **cả thêm và xóa** thành viên.
- Đợt hết hạn hoặc nhóm đã nhận đề tài thì không được thay đổi thành viên.
- Nhóm cũ chưa chọn đợt phải chọn đợt và kiểm tra lại toàn bộ thành viên trước khi thêm người hoặc đăng ký đề tài.

### 9.3. Hội đồng và điểm

- Hội đồng có từ 3 đến 5 giảng viên, gồm một chủ tịch và một thư ký khác nhau.
- Thành viên phải thuộc khoa quản lý hội đồng.
- Form tạo hội đồng chỉ chọn đợt đang mở, hoạt động, có ngày báo cáo từ hôm nay trở đi.
- Ngày báo cáo lấy từ đợt, không nhập một ngày riêng cho hội đồng.
- Đăng ký được phân công phải được duyệt, cùng khoa/cùng đợt với hội đồng và có điểm quá trình của GVHD chính **lớn hơn 5**.
- Một đăng ký không được phân công vào nhiều hội đồng.
- GVHD chính, đồng hướng dẫn hoặc người thuộc danh sách hướng dẫn đề tài không được tham gia hội đồng chấm chính đề tài đó.
- Điểm phải hữu hạn và nằm trong khoảng 0–10; chấm hội đồng không được thực hiện trước ngày báo cáo hoặc sau hạn GVPB nộp điểm.
- Điểm tổng kết = 50% điểm quá trình trung bình + 50% điểm hội đồng trung bình, làm tròn theo cách tính trong `ScoringService`.
- Chỉ công bố khi đủ điểm các thành viên và có điểm tổng kết hợp lệ.

### 9.4. Báo cáo

- Chỉ nhóm trưởng nộp báo cáo cho đăng ký đã được duyệt; đề tài hoàn tất không được nộp thêm.
- Hỗ trợ PDF, DOC, DOCX, ZIP, RAR, tối đa 10 MB mỗi tệp; tổng yêu cầu multipart giới hạn 12 MB.
- Có thể lưu liên kết HTTP/HTTPS theo form nộp báo cáo.
- Tải báo cáo phải đi qua đường dẫn có kiểm tra quyền; không chia sẻ trực tiếp thư mục lưu tệp.

## 10. Kiểm thử

### 10.1. Test không cần database

```powershell
mvn test
```

Test đơn vị chạy bình thường. Test tích hợp được bỏ qua khi chưa cung cấp `seed.test.jdbc.url` phù hợp; vì vậy lệnh thành công chưa có nghĩa đã kiểm tra kết nối database hoặc toàn bộ giao diện.

Kiểm tra cú pháp JavaScript nếu đã cài Node.js:

```powershell
node --check src/main/webapp/assets/js/enterprise-ui.js
```

### 10.2. Test tích hợp với MySQL riêng

Bộ test hiện yêu cầu một MySQL cục bộ **riêng ở `127.0.0.1:14336`**, tài khoản `root` không mật khẩu. Đây là cấu hình phục vụ kiểm thử, không phải khuyến nghị cho database sử dụng thật.

1. Chuẩn bị instance MySQL thử nghiệm tại cổng này.
2. Tạo database trống `asm_web_ute` bằng SQL ở mục 4.
3. Chạy:

```powershell
mvn test '-Dseed.test.jdbc.url=jdbc:mysql://127.0.0.1:14336/asm_web_ute'
```

Hoặc kiểm thử và đóng gói trong cùng một lệnh:

```powershell
mvn package '-Dseed.test.jdbc.url=jdbc:mysql://127.0.0.1:14336/asm_web_ute'
```

Không dùng database đang làm việc cho bộ test này. Test đọc dữ liệu mẫu, tạo/xóa bản ghi phục vụ kiểm tra đồng thời và cần đúng dữ liệu ban đầu. Nếu database thử nghiệm đã bị sửa khác mẫu, hãy tạo lại database thử nghiệm trước khi chạy.

Kết quả chi tiết nằm ở `target/surefire-reports/`. Lượt rà soát ngày 17/10/2026 đạt **24 test, không lỗi và không bỏ qua**, có kiểm tra HTTP thật trên 22 trang. Kết quả này tương ứng phiên bản đã rà soát, không thay thế việc chạy lại test sau khi thay đổi mã hoặc dữ liệu.

## 11. Đóng gói và chạy WAR

### 11.1. Đóng gói

```powershell
mvn clean package
```

Lệnh này chạy test đơn vị; thêm tham số mục 10 nếu muốn chạy cả test tích hợp. File đầu ra theo phiên bản hiện tại:

```text
target/ASM_WEB.UTE-0.0.1-SNAPSHOT.war
```

WAR chứa mã Java, dependency, JSP, tài nguyên tĩnh và SQL mẫu. Dự án đã chuyển sang WAR để phù hợp với JSP; không chạy JAR cũ từ những lần build trước.

### 11.2. Chạy trực tiếp trên Windows

Bộ Tomcat hiện tại đã được ghi nhận lỗi đọc thư viện JSP khi WAR nằm trong đường dẫn có khoảng trắng. Hãy sao chép WAR sang thư mục triển khai không có khoảng trắng, chẳng hạn `D:\HCMUTE-App`:

```powershell
New-Item -ItemType Directory -Force 'D:\HCMUTE-App' | Out-Null
Copy-Item -LiteralPath '.\target\ASM_WEB.UTE-0.0.1-SNAPSHOT.war' -Destination 'D:\HCMUTE-App\app.war'
Set-Location 'D:\HCMUTE-App'
# Khai báo biến môi trường như mục 5 trước khi chạy.
& "$env:JAVA_HOME\bin\java.exe" -jar '.\app.war'
```

Dùng đúng JDK 25. Thư mục hiện tại khi chạy cũng là nơi ứng dụng tạo `uploads/reports/`; khi triển khai lại, cần giữ đúng vị trí dữ liệu tệp.

Có thể triển khai WAR vào servlet container Jakarta tương thích. Bản Spring Boot hiện tại đi kèm Tomcat 11; không coi mọi phiên bản Tomcat cũ là tương thích. Khi có context path, URL truy cập và callback Google phải bao gồm context path đó.

## 12. Lỗi thường gặp

| Hiện tượng | Kiểm tra và cách xử lý |
| --- | --- |
| `UnsupportedClassVersionError` hoặc `invalid target release: 25` | Kiểm tra `java -version`, `mvn -version`, JDK của IDE và `JAVA_HOME`; dùng JDK 25 |
| Không kết nối được MySQL | Kiểm tra dịch vụ MySQL, cổng, database và `SPRING_DATASOURCE_URL` |
| `Access denied for user` | Kiểm tra `DB_USERNAME`, `DB_PASSWORD` và quyền của tài khoản MySQL |
| Không tìm thấy giá trị `GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET` hoặc `MAIL_PASSWORD` | Khai báo biến môi trường trong đúng tiến trình chạy, hoặc đặt `.env` ở đúng working directory |
| Cổng `14090` đang được sử dụng | Dừng phiên ứng dụng cũ hoặc đổi `$env:PORT` |
| Không có đợt để giảng viên đề xuất | Đợt phải đang mở, hoạt động và hôm nay nằm trong thời gian giảng viên đề xuất |
| Không có đợt để tạo nhóm | Cần đợt đang mở, hoạt động và còn trong thời gian sinh viên đăng ký |
| Không có đợt để tạo hội đồng | Cần đợt đang mở và có ngày báo cáo chưa qua |
| Không thêm/xóa được thành viên | Kiểm tra quyền nhóm trưởng, đợt, sĩ số 3 người và đơn đăng ký chờ duyệt/đã duyệt |
| Sinh viên đã có nhóm trong đợt | Chọn thành viên chưa có nhóm trong đợt đó; không cố đăng ký đề tài để bỏ qua kiểm tra |
| Không thấy đề tài khi tra cứu | Kiểm tra khoa, đợt của nhóm, thời hạn, trạng thái công bố và đề tài còn khả dụng |
| Không thấy hội đồng ở tài khoản giảng viên | Giảng viên phải là thành viên hội đồng và hội đồng đã có đề tài được phân công |
| Không chấm/công bố được điểm | Kiểm tra ngày báo cáo, hạn nộp điểm, quyền thành viên, xung đột GVHD và số điểm đã nhập |
| HTTP 403 khi gửi form | Tải lại trang, đăng nhập lại nếu cần; form và AJAX phải gửi token CSRF đúng phiên, không tắt bảo vệ để né lỗi |
| Đăng nhập Google báo lỗi callback | Kiểm tra địa chỉ, cổng, context path và callback đã khai báo cho OAuth client |
| Gửi email thất bại | Kiểm tra SMTP, thông tin xác thực, kết nối mạng và nhật ký ứng dụng |
| WAR khởi động nhưng JSP trả 500 | Dùng đúng JDK; trên Windows đặt WAR ở đường dẫn không có khoảng trắng; đọc nguyên nhân trong nhật ký |
| CSS/JavaScript chưa cập nhật | Nhấn `Ctrl + F5`, kiểm tra tài nguyên CDN và Console/Network của trình duyệt |
| Không tải được báo cáo đã nộp | Kiểm tra quyền tài khoản và thư mục `uploads/reports` của đúng lần triển khai |
| Test tích hợp bị bỏ qua | Kiểm tra có truyền `seed.test.jdbc.url` đúng mẫu `jdbc:mysql://127.0.0.1:14336/...` hay chưa |

## 13. Lưu trữ và vận hành

- Sao lưu **cả MySQL và `uploads/reports/`**. Chỉ sao lưu database sẽ không giữ được nội dung tệp báo cáo đã tải lên.
- Báo cáo PDF mẫu ở `src/main/resources/demo-reports/` được đóng gói trong WAR; khác với tệp do người dùng nộp.
- `.env`, `target/` và `uploads/` không được đưa vào Git theo cấu hình hiện tại.
- Token đăng nhập lưu trong bộ nhớ ứng dụng, mặc định có thời hạn 8 giờ. Khởi động lại ứng dụng sẽ cần đăng nhập lại; đây chưa phải cơ chế chia sẻ phiên giữa nhiều máy chủ.
- Trước khi sử dụng thật, tắt đăng nhập nhanh, cấu hình thông tin dịch vụ thật, sao lưu dữ liệu và xem lại chế độ cập nhật schema của Hibernate.
- Kiểm thử HTTP/JSP không thay thế kiểm tra bố cục trên trình duyệt, màn hình điện thoại, Google OAuth thật hoặc nhận email thật. Cần kiểm tra riêng các phần này trên môi trường sử dụng thực tế.

## 14. Triển khai Docker / Railway

`Dockerfile` ở thư mục gốc build WAR bằng Maven (JDK 25) rồi chạy `java -jar app.war` trên cổng `$PORT`.

1. Import `database/asm_web_ute_data.sql` vào database trên hosting (phpMyAdmin → Import). Nếu hosting không cho tạo database, bỏ hai dòng `CREATE DATABASE` và `USE` ở đầu tệp trước khi import.
2. Tạo dịch vụ Railway từ kho GitHub; Railway tự nhận `Dockerfile`.
3. Khai báo biến môi trường: `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USERNAME`, `DB_PASSWORD`, `GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET`, `MAIL_USERNAME`, `MAIL_PASSWORD`. Ảnh Docker đã đặt sẵn `DDL_AUTO=none` và `LAZY_INIT=true`.
4. Thêm tên miền riêng (CNAME về địa chỉ Railway cấp) và khai báo `https://<tên-miền>/login/oauth2/code/google` trong Authorized redirect URIs của Google OAuth.

Truy vấn khóa dòng dùng `SELECT ... FOR UPDATE` thuần nên chạy được trên cả MySQL 8 và MariaDB 10.x. Railway chỉ mở SMTP từ gói Pro trở lên (gói Free/Trial/Hobby bị chặn), nên email chỉ gửi được khi chạy ở máy cá nhân hoặc máy chủ cho phép SMTP.
