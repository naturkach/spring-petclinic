FROM openjdk:11.0.1-jre-slim-stretch
EXPOSE 8080
ARG JAR=spring-petclinic-2.4.2.jar
COPY project/target/$JAR /app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
