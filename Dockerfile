# Bước 1: build WAR bằng Maven + JDK 25
FROM maven:3.10.0-eclipse-temurin-25 AS build

WORKDIR /app

COPY pom.xml .
COPY .mvn .mvn
COPY mvnw .
COPY database database
COPY src src

RUN mvn -DskipTests clean package

# Bước 2: chạy WAR (dùng lại image build để Railway không phải kéo thêm image thứ hai)
FROM maven:3.10.0-eclipse-temurin-25

WORKDIR /app

COPY --from=build /app/target/*.war app.war

# Hosting đã import sẵn database/asm_web_ute_data.sql nên không cho Hibernate sửa schema;
# khởi tạo bean khi cần để khởi động nhanh. Biến môi trường trên Railway có thể ghi đè.
ENV DDL_AUTO=none \
    LAZY_INIT=true \
    TZ=Asia/Ho_Chi_Minh

EXPOSE 8080

ENTRYPOINT ["sh", "-c", "java -Duser.timezone=Asia/Ho_Chi_Minh -Dserver.port=${PORT:-8080} -jar app.war"]
