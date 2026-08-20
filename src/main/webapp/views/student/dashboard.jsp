<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Sinh viên</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container py-5">
    <h2 class="mb-4">Trang sinh viên</h2>
    <div class="row g-4">
        <div class="col-md-4">
            <div class="card h-100 border-0 shadow-sm">
                <div class="card-body">
                    <h5><a href="/student/group" class="text-decoration-none">Nhóm của tôi</a></h5>
                    <p>Quản lý thông tin nhóm, trưởng nhóm và thành viên.</p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card h-100 border-0 shadow-sm">
                <div class="card-body">
                    <h5><a href="/student/topics" class="text-decoration-none">Đăng ký đề tài</a></h5>
                    <p>Chọn đề tài phù hợp từ danh sách đã công bố.</p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card h-100 border-0 shadow-sm">
                <div class="card-body">
                    <h5>Kết quả</h5>
                    <p>Xem điểm và đánh giá của đề tài đã hoàn thành.</p>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
