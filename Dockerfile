# 1단계: Gradle로 빌드하는 이미지
FROM gradle:8.7-jdk17-alpine AS builder
WORKDIR /workspace/app

# Gradle 설정 및 소스 복사
COPY build.gradle settings.gradle ./
COPY src ./src

# bootJar 빌드
RUN gradle bootJar --no-daemon

# 2단계: 실행용 가벼운 이미지
FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app

# 위에서 빌드된 jar 복사
COPY --from=builder /workspace/app/build/libs/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
