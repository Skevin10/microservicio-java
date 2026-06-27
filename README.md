# Microservicio DevOps (Java)

API HTTP mínima con dos endpoints para demostración.

## Requisitos

- Java 17+
- Maven 3.8+
- Docker (para contenerización)

## Instalación y ejecución local

### Compilar y ejecutar

```bash
# Compilar el proyecto
mvn clean package

# Ejecutar la aplicación
java -jar target/microservicio-1.0.0.jar
```

O directamente sin empaquetar:

```bash
mvn spring-boot:run
```

La app estará disponible en `http://localhost:8080`

## Endpoints disponibles

### GET /health
Verifica que el servicio está corriendo.

```bash
curl http://localhost:8080/health
# {"status":"ok"}
```

### GET /version
Devuelve la versión del servicio.

```bash
curl http://localhost:8080/version
# {"version":"1.0.0"}
```

## Variables de entorno

- `APP_VERSION`: Versión de la aplicación (default: "1.0.0")
