FROM maven:3.10.0-eclipse-temurin-25 AS build

WORKDIR /app

COPY pom.xml .
COPY .mvn .mvn
COPY mvnw .
COPY src src

RUN mvn -DskipTests clean package

# Reuse the build image for the runtime so Railway does not need to pull
# a second Docker Hub image during deployment.
FROM maven:3.10.0-eclipse-temurin-25

WORKDIR /app

COPY --from=build /app/target/*.war app.war

EXPOSE 8080

ENTRYPOINT ["sh", "-c", "java -Dserver.port=${PORT:-8080} -jar app.war"]
