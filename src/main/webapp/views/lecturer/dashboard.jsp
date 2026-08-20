<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Giảng viên</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container py-5">
    <h2 class="mb-4">Trang giảng viên</h2>
    <div class="row g-4">
        <div class="col-md-4">
            <div class="card h-100 border-0 shadow-sm">
                <div class="card-body">
                    <h5><a href="/lecturer/topics" class="text-decoration-none">Đề tài đăng ký</a></h5>
                    <p>Quản lý đề tài do giảng viên đề xuất hoặc hướng dẫn.</p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card h-100 border-0 shadow-sm">
                <div class="card-body">
                    <h5>Nhóm sinh viên</h5>
                    <p>Xem danh sách nhóm đang thực hiện đề tài dưới sự hướng dẫn.</p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card h-100 border-0 shadow-sm">
                <div class="card-body">
                    <h5><a href="/lecturer/reviews" class="text-decoration-none">Chấm điểm</a></h5>
                    <p>Nhập điểm, nhận xét và đánh giá kết quả phản biện.</p>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
