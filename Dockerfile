FROM gradle:8.13.0-jdk21-alpine AS build
WORKDIR /app
COPY . .
RUN chmod +x gradlew
RUN ./gradlew clean build -x test

FROM openjdk:21-alpine
RUN apk update && apk upgrade
RUN adduser -D bqphyapp
WORKDIR /app
COPY --from=build /app/build/libs/*.jar /app/application.jar
RUN chown -R bqphyapp:bqphyapp /app
USER bqphyapp
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "application.jar"]
