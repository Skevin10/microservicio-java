# Build stage
FROM maven:3.9-eclipse-temurin-17 AS builder

WORKDIR /build

# Copiar pom.xml
COPY pom.xml .

# Descargar dependencias
RUN mvn dependency:resolve

# Copiar código fuente
COPY src/ ./src/

# Compilar y empaquetar
RUN mvn clean package -DskipTests

# Runtime stage
FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

# Copiar JAR desde builder
COPY --from=builder /build/target/microservicio-1.0.0.jar app.jar

# Puerto
EXPOSE 8081

# Variable de entorno por defecto
ENV APP_VERSION=1.0.0

# Comando de inicio
ENTRYPOINT ["java", "-jar", "app.jar"]
