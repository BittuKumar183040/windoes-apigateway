FROM alpine/java:21-jdk AS build
WORKDIR /app
COPY . .
RUN chmod +x gradlew
RUN ./gradlew clean build -x test

FROM alpine/java:21-jre
RUN apk update && apk upgrade
RUN adduser -D windoesapp
WORKDIR /app
COPY --from=build /app/build/libs/*.jar /app/application.jar
RUN chown -R windoesapp:windoesapp /app
USER windoesapp
EXPOSE 8090
ENTRYPOINT ["java", "-jar", "application.jar"]
