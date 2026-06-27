# Microservicio DevOps (Java)

API HTTP mínima con dos endpoints para demostración y aprendizaje de DevOps con Spring Boot.

## Requisitos

- Java 17+
- Maven 3.8+
- Docker (para contenerización)
- Git (para control de versiones)

## Instalación y ejecución local

### Opción 1: Ejecutar directamente con Maven

```bash
# Compilar el proyecto
mvn clean package

# Ejecutar la aplicación
java -jar target/microservicio-1.0.0.jar
```

O sin empaquetar:

```bash
mvn spring-boot:run
```

La app estará disponible en `http://localhost:8081`

### Opción 2: Con Docker

```bash
# Construir imagen
docker build -t microservicio:latest .

# Ejecutar contenedor
docker run -p 8081:8081 -e APP_VERSION=1.0.0 microservicio:latest
```

## Endpoints disponibles

### GET /health
Verifica que el servicio está corriendo correctamente.

```bash
curl http://localhost:8081/health
# {"status":"ok"}
```

**Respuesta esperada:**
- Código HTTP: `200`
- Body: JSON con campo `status`

### GET /version
Devuelve la versión actual del servicio inyectada como variable de entorno.

```bash
curl http://localhost:8081/version
# {"version":"1.0.0"}
```

**Respuesta esperada:**
- Código HTTP: `200`
- Body: JSON con campo `version`

## Variables de entorno

- `APP_VERSION`: Versión de la aplicación (default: `1.0.0`)

Se pueden pasar al ejecutar:

```bash
# Con Docker
docker run -p 8081:8081 -e APP_VERSION=2.5.1 microservicio:latest

# Con Java directo
APP_VERSION=2.5.1 java -jar target/microservicio-1.0.0.jar
```

## Pipeline CI/CD

El repositorio cuenta con un pipeline automático en GitHub Actions que se ejecuta en cada push y pull request:

1. **Checkout** del código
2. **Setup Java 17** y Maven
3. **Build y tests** — compila y ejecuta tests unitarios
4. **Build Docker** — construye la imagen
5. **Test Docker** — levanta el contenedor y verifica los endpoints

Puedes ver el estado en la pestaña **Actions** del repositorio:
https://github.com/Skevin10/microservicio-java/actions

El pipeline falla si alguno de estos pasos no se completa correctamente.

## Health Check Automatizado

Se incluye un script en Bash para monitorear la salud del servicio en tiempo real.

### Uso básico

```bash
./healthcheck.sh
```

El script generará un archivo `healthcheck.log` con los resultados.

### Personalizar host y puerto

```bash
HC_HOST=192.168.1.100 HC_PORT=8081 ./healthcheck.sh
```

### Programar chequeos periódicos con cron

Para ejecutar cada 5 minutos:

```bash
*/5 * * * * /path/to/healthcheck.sh
```

### Variables soportadas

| Variable | Default | Descripción |
|----------|---------|-------------|
| `HC_HOST` | localhost | Host del servicio |
| `HC_PORT` | 8080 | Puerto del servicio |
| `HC_LOG` | healthcheck.log | Archivo de log |

Para este proyecto (puerto 8081):

```bash
HC_PORT=8081 ./healthcheck.sh
```

## Seguridad — Manejo de Secretos

### En GitHub Actions

Los secretos nunca se hardcodean en el código. Se definen en GitHub y se inyectan solo durante la ejecución del pipeline.

**Configuración en GitHub:**
1. Ve a tu repositorio
2. **Settings** → **Secrets and variables** → **Actions**
3. Click en **"New repository secret"**
4. Agrega tu secreto (ej: `API_KEY_SECRET`)

**Uso en el workflow:**

```yaml
- name: API Call with secret
  run: |
    curl -H "Authorization: Bearer ${{ secrets.API_KEY_SECRET }}" https://api.example.com
```

**Ventajas:**
- No aparecen en logs ni historial de Git
- Encriptados en GitHub
- Se inyectan solo al ejecutar

### En desarrollo local

Crear archivo `.env.local` en la raíz del proyecto (está en `.gitignore`):

```bash
# .env.local
API_KEY=sk-test-1234567890
DATABASE_URL=localhost:5432
ANOTHER_SECRET=my-secret-value
```

Cargar las variables:

```bash
export $(cat .env.local | xargs)
java -jar target/microservicio-1.0.0.jar
```

### Buenas prácticas

- Usar GitHub Secrets para CI/CD
- Usar variables de entorno para desarrollo local
- Guardar secretos en `.env.local` (en `.gitignore`)
- Rotar secretos regularmente
- Nunca hardcodear credenciales en el código
- Nunca commitear archivos `.env` o `.env.local`

## Comandos útiles

```bash
# Compilar
mvn clean package

# Compilar sin tests
mvn clean package -DskipTests

# Ejecutar tests
mvn test

# Ejecutar localmente
mvn spring-boot:run

# Limpiar artefactos
mvn clean

# Ver dependencias
mvn dependency:tree

# Build Docker
docker build -t microservicio:latest .

# Run Docker
docker run -p 8081:8081 -e APP_VERSION=1.0.0 microservicio:latest

# Health check
HC_PORT=8081 ./healthcheck.sh
```

## Troubleshooting

### Puerto ya está en uso

Si ves error `Port 8081 already in use`:

```bash
# Encuentra qué proceso usa el puerto
lsof -i :8081

# O cambia el puerto en Docker
docker run -p 9090:8081 microservicio:latest
```

### Tests fallan

Asegúrate de que tienes Java 17+ y Maven actualizado:

```bash
java -version
mvn -version
```

### Docker no construye

Verifica que Docker daemon está corriendo:

```bash
docker info
```

##Comando para levanta el contenedor 

docker build -t microservicio-java:latest .
docker run -p 8081:8081 -e APP_VERSION=1.0.0 microservicio-java:latest
