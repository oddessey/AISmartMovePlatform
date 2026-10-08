
FROM gradle:8.7-jdk17 AS build
WORKDIR /app
COPY . .
RUN gradle bootJar --no-daemon

FROM openjdk:17-slim
COPY --from=build /app/build/libs/*.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
