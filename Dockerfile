# Build
FROM openjdk:11-jdk as builder

ENV APP_HOME=/usr/app/
WORKDIR $APP_HOME

COPY gradlew $APP_HOME
COPY gradle $APP_HOME/gradle

COPY build.gradle settings.gradle $APP_HOME
RUN ./gradlew build || return 0

COPY src src
RUN ./gradlew build

# Run
FROM openjdk:11-jre
ENV ARTIFACT_NAME=demo-0.0.1-SNAPSHOT.jar
ENV APP_HOME=/usr/app/
WORKDIR $APP_HOME
COPY --from=builder $APP_HOME/build/libs/$ARTIFACT_NAME ./app.jar

EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
