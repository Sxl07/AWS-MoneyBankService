# AWS MoneyBankService

> 🇪🇸 API REST académica para la administración de cuentas bancarias, operaciones de depósito y retiro, construida con .NET 8, arquitectura limpia, Entity Framework Core, MySQL y despliegue con Docker.
>
> 🇺🇸 Academic REST API for managing bank accounts, deposit and withdrawal operations, built with .NET 8, Clean Architecture, Entity Framework Core, MySQL, and Docker-based deployment.

---

## 🇪🇸 Descripción

**AWS MoneyBankService** es un microservicio académico desarrollado como práctica de backend, arquitectura limpia y despliegue en la nube. El proyecto expone una API REST para administrar cuentas bancarias y ejecutar operaciones básicas de cajero como depósitos y retiros.

La solución está organizada por capas, separando responsabilidades entre API, aplicación, dominio e infraestructura. Además, incluye scripts SQL para preparar la base de datos, una colección de Postman para pruebas, un `Dockerfile` para contenerizar el servicio y un workflow de GitHub Actions para construir y publicar la imagen Docker.

## 🇺🇸 Description

**AWS MoneyBankService** is an academic microservice developed as a backend, Clean Architecture, and cloud deployment practice. The project exposes a REST API to manage bank accounts and perform basic ATM operations such as deposits and withdrawals.

The solution is organized in layers, separating responsibilities between API, application, domain, and infrastructure. It also includes SQL scripts to prepare the database, a Postman collection for testing, a `Dockerfile` to containerize the service, and a GitHub Actions workflow to build and publish the Docker image.

---

## 🇪🇸 Características principales

- CRUD de cuentas bancarias.
- Consulta de cuentas por ID.
- Consulta de cuentas por número de cuenta.
- Creación de cuentas de ahorro y cuentas corrientes.
- Operación de depósito.
- Operación de retiro.
- Validación de datos con FluentValidation y Data Annotations.
- Manejo centralizado de excepciones mediante middleware.
- Persistencia con MySQL y Entity Framework Core.
- Documentación interactiva con Swagger en ambiente de desarrollo.
- Soporte para ejecución en Docker.
- Workflow de CI/CD para construir y publicar la imagen Docker.

## 🇺🇸 Main features

- Bank account CRUD.
- Account lookup by ID.
- Account lookup by account number.
- Creation of savings and checking accounts.
- Deposit operation.
- Withdrawal operation.
- Data validation with FluentValidation and Data Annotations.
- Centralized exception handling through middleware.
- Persistence with MySQL and Entity Framework Core.
- Interactive Swagger documentation in development environment.
- Docker execution support.
- CI/CD workflow to build and publish the Docker image.

---

## 🇪🇸 Tecnologías utilizadas

- .NET 8
- ASP.NET Core Web API
- Entity Framework Core
- MySQL
- AutoMapper
- FluentValidation
- Swagger / Swashbuckle
- Docker
- GitHub Actions
- Postman

## 🇺🇸 Technologies used

- .NET 8
- ASP.NET Core Web API
- Entity Framework Core
- MySQL
- AutoMapper
- FluentValidation
- Swagger / Swashbuckle
- Docker
- GitHub Actions
- Postman

---

## 🇪🇸 Arquitectura del proyecto

El proyecto sigue una separación por capas inspirada en Clean Architecture:

```text
MoneyBankService/
├── MoneyBankService.Api/             # Controladores, Program.cs, middleware y configuración HTTP
├── MoneyBankService.Application/     # DTOs, servicios, validadores, mapeos e interfaces
├── MoneyBankService.Domain/          # Modelos de dominio y entidades base
├── MoneyBankService.Infrastructure/  # DbContext, repositorios y acceso a datos
└── MoneyBankService.sln

Scripts/
├── 01_Create_Database.sql
├── 02_Create_User.sql
├── 03_TAB_Accounts.sql
├── 04_INS_Accounts.sql
└── CLEAN.sql

.github/workflows/
└── deploy.yml

Dockerfile
MoneyBankService.postman_collection.json
```

## 🇺🇸 Project architecture

The project follows a layered separation inspired by Clean Architecture:

```text
MoneyBankService/
├── MoneyBankService.Api/             # Controllers, Program.cs, middleware, and HTTP configuration
├── MoneyBankService.Application/     # DTOs, services, validators, mappings, and interfaces
├── MoneyBankService.Domain/          # Domain models and base entities
├── MoneyBankService.Infrastructure/  # DbContext, repositories, and data access
└── MoneyBankService.sln

Scripts/
├── 01_Create_Database.sql
├── 02_Create_User.sql
├── 03_TAB_Accounts.sql
├── 04_INS_Accounts.sql
└── CLEAN.sql

.github/workflows/
└── deploy.yml

Dockerfile
MoneyBankService.postman_collection.json
```

---

## 🇪🇸 Modelo principal: Account

La entidad principal del sistema es `Account`, que representa una cuenta bancaria.

Campos principales:

- `Id`: identificador de la cuenta.
- `AccountType`: tipo de cuenta. Acepta `A` para ahorros y `C` para corriente.
- `CreationDate`: fecha de creación de la cuenta.
- `AccountNumber`: número de cuenta de 10 dígitos.
- `OwnerName`: nombre del propietario.
- `BalanceAmount`: saldo disponible.
- `OverdraftAmount`: valor de sobregiro para cuentas corrientes.

## 🇺🇸 Main model: Account

The main entity of the system is `Account`, which represents a bank account.

Main fields:

- `Id`: account identifier.
- `AccountType`: account type. Accepts `A` for savings and `C` for checking.
- `CreationDate`: account creation date.
- `AccountNumber`: 10-digit account number.
- `OwnerName`: account owner name.
- `BalanceAmount`: available balance.
- `OverdraftAmount`: overdraft amount for checking accounts.

---

## 🇪🇸 Reglas de negocio implementadas

- El número de cuenta debe tener exactamente 10 dígitos.
- El tipo de cuenta solo puede ser `A` o `C`.
- El saldo inicial debe ser mayor a cero.
- No se permite crear una cuenta con un número ya existente.
- El sobregiro máximo para cuentas corrientes es de `$1,000,000`.
- Al crear una cuenta corriente, el saldo inicial se incrementa con el valor máximo de sobregiro.
- En retiros, si el valor solicitado supera el saldo disponible, se retorna error de fondos insuficientes.
- En depósitos y retiros de cuentas corrientes, el valor de sobregiro se recalcula según el saldo resultante.

## 🇺🇸 Implemented business rules

- The account number must contain exactly 10 digits.
- The account type can only be `A` or `C`.
- The initial balance must be greater than zero.
- Creating an account with an existing account number is not allowed.
- The maximum overdraft amount for checking accounts is `$1,000,000`.
- When creating a checking account, the initial balance is increased by the maximum overdraft amount.
- During withdrawals, if the requested amount exceeds the available balance, an insufficient funds error is returned.
- During deposits and withdrawals on checking accounts, the overdraft value is recalculated according to the resulting balance.

---

## 🇪🇸 Endpoints principales

Base URL local sugerida:

```text
http://localhost:80
```

### Cuentas

| Método | Endpoint | Descripción |
|---|---|---|
| GET | `/api/Accounts` | Lista todas las cuentas |
| GET | `/api/Accounts?accountNumber={accountNumber}` | Busca cuentas por número de cuenta |
| GET | `/api/Accounts/{id}` | Obtiene una cuenta por ID |
| POST | `/api/Accounts` | Crea una nueva cuenta |
| PUT | `/api/Accounts/{id}` | Actualiza una cuenta existente |
| DELETE | `/api/Accounts/{id}` | Elimina una cuenta |

### Operaciones de cajero

| Método | Endpoint | Descripción |
|---|---|---|
| PUT | `/api/Accounts/{id}/Deposit` | Realiza un depósito |
| PUT | `/api/Accounts/{id}/Withdrawal` | Realiza un retiro |

## 🇺🇸 Main endpoints

Suggested local base URL:

```text
http://localhost:80
```

### Accounts

| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/Accounts` | Lists all accounts |
| GET | `/api/Accounts?accountNumber={accountNumber}` | Searches accounts by account number |
| GET | `/api/Accounts/{id}` | Gets an account by ID |
| POST | `/api/Accounts` | Creates a new account |
| PUT | `/api/Accounts/{id}` | Updates an existing account |
| DELETE | `/api/Accounts/{id}` | Deletes an account |

### ATM operations

| Method | Endpoint | Description |
|---|---|---|
| PUT | `/api/Accounts/{id}/Deposit` | Performs a deposit |
| PUT | `/api/Accounts/{id}/Withdrawal` | Performs a withdrawal |

---

## 🇪🇸 Ejemplos de requests

### Crear una cuenta

```http
POST /api/Accounts
Content-Type: application/json
```

```json
{
  "id": 0,
  "accountType": "A",
  "creationDate": "2023-10-04",
  "accountNumber": "6087523149",
  "ownerName": "John Doe",
  "balanceAmount": 1000000,
  "overdraftAmount": 0
}
```

### Realizar un depósito

```http
PUT /api/Accounts/1/Deposit
Content-Type: application/json
```

```json
{
  "id": 1,
  "accountNumber": "3016892501",
  "valueAmount": 500000
}
```

### Realizar un retiro

```http
PUT /api/Accounts/1/Withdrawal
Content-Type: application/json
```

```json
{
  "id": 1,
  "accountNumber": "3016892501",
  "valueAmount": 300000
}
```

## 🇺🇸 Request examples

### Create an account

```http
POST /api/Accounts
Content-Type: application/json
```

```json
{
  "id": 0,
  "accountType": "A",
  "creationDate": "2023-10-04",
  "accountNumber": "6087523149",
  "ownerName": "John Doe",
  "balanceAmount": 1000000,
  "overdraftAmount": 0
}
```

### Make a deposit

```http
PUT /api/Accounts/1/Deposit
Content-Type: application/json
```

```json
{
  "id": 1,
  "accountNumber": "3016892501",
  "valueAmount": 500000
}
```

### Make a withdrawal

```http
PUT /api/Accounts/1/Withdrawal
Content-Type: application/json
```

```json
{
  "id": 1,
  "accountNumber": "3016892501",
  "valueAmount": 300000
}
```

---

## 🇪🇸 Configuración de base de datos

El proyecto usa MySQL. En la carpeta `Scripts/` se incluyen archivos SQL para preparar el ambiente:

1. `01_Create_Database.sql`: crea la base de datos `moneybankdb`.
2. `02_Create_User.sql`: crea el usuario de base de datos.
3. `03_TAB_Accounts.sql`: crea la tabla `accounts`.
4. `04_INS_Accounts.sql`: inserta datos iniciales.
5. `CLEAN.sql`: limpia y reinicia la tabla para pruebas.

La cadena de conexión se configura en `MoneyBankService.Api/appsettings.json`:

```json
{
  "ConnectionStrings": {
    "CnnStr": "server=mysql;port=3306;database=moneybankdb;user=moneybankuser;password=your_password"
  }
}
```

> Nota: para uso real o público, evita subir credenciales reales al repositorio. Es mejor usar variables de entorno, secretos de GitHub Actions o configuración externa.

## 🇺🇸 Database configuration

The project uses MySQL. The `Scripts/` folder includes SQL files to prepare the environment:

1. `01_Create_Database.sql`: creates the `moneybankdb` database.
2. `02_Create_User.sql`: creates the database user.
3. `03_TAB_Accounts.sql`: creates the `accounts` table.
4. `04_INS_Accounts.sql`: inserts initial data.
5. `CLEAN.sql`: cleans and resets the table for testing.

The connection string is configured in `MoneyBankService.Api/appsettings.json`:

```json
{
  "ConnectionStrings": {
    "CnnStr": "server=mysql;port=3306;database=moneybankdb;user=moneybankuser;password=your_password"
  }
}
```

> Note: for real or public usage, avoid committing real credentials to the repository. Prefer environment variables, GitHub Actions secrets, or external configuration.

---

## 🇪🇸 Ejecución local

### Requisitos

- .NET SDK 8
- MySQL
- Visual Studio 2022, Visual Studio Code o Rider
- Postman opcional para probar la colección

### Pasos

1. Clonar el repositorio:

```bash
git clone <repository-url>
cd AWS-MoneyBankService
```

2. Ejecutar los scripts SQL ubicados en `Scripts/`.

3. Configurar la cadena de conexión en:

```text
MoneyBankService/MoneyBankService.Api/appsettings.json
```

4. Restaurar dependencias:

```bash
cd MoneyBankService
dotnet restore
```

5. Ejecutar la API:

```bash
dotnet run --project MoneyBankService.Api/MoneyBankService.Api.csproj
```

6. Probar la API en:

```text
http://localhost:80/api/Accounts
```

## 🇺🇸 Local execution

### Requirements

- .NET SDK 8
- MySQL
- Visual Studio 2022, Visual Studio Code, or Rider
- Optional Postman for testing the collection

### Steps

1. Clone the repository:

```bash
git clone <repository-url>
cd AWS-MoneyBankService
```

2. Run the SQL scripts located in `Scripts/`.

3. Configure the connection string in:

```text
MoneyBankService/MoneyBankService.Api/appsettings.json
```

4. Restore dependencies:

```bash
cd MoneyBankService
dotnet restore
```

5. Run the API:

```bash
dotnet run --project MoneyBankService.Api/MoneyBankService.Api.csproj
```

6. Test the API at:

```text
http://localhost:80/api/Accounts
```

---

## 🇪🇸 Ejecución con Docker

El repositorio incluye un `Dockerfile` para construir la imagen del microservicio.

```bash
docker build -t moneybankservice-api .
docker run -d --name moneybankservice-api -p 80:80 moneybankservice-api
```

Si la base de datos también corre en Docker, asegúrate de que ambos contenedores compartan la misma red y que el host configurado en la cadena de conexión coincida con el nombre del contenedor de MySQL.

## 🇺🇸 Docker execution

The repository includes a `Dockerfile` to build the microservice image.

```bash
docker build -t moneybankservice-api .
docker run -d --name moneybankservice-api -p 80:80 moneybankservice-api
```

If the database also runs in Docker, make sure both containers share the same network and that the host configured in the connection string matches the MySQL container name.

---

## 🇪🇸 CI/CD con GitHub Actions

El proyecto incluye un workflow en `.github/workflows/deploy.yml` que:

1. Se ejecuta al hacer push a la rama `main`.
2. Inicia sesión en Docker Hub usando secretos.
3. Construye la imagen Docker de la API.
4. Publica la imagen como `dotnet-api:latest`.
5. Despliega la nueva imagen en un runner self-hosted, por ejemplo una instancia EC2.

Secretos esperados:

- `DOCKER_USERNAME`
- `DOCKER_PASSWORD`

## 🇺🇸 CI/CD with GitHub Actions

The project includes a workflow in `.github/workflows/deploy.yml` that:

1. Runs on push to the `main` branch.
2. Logs in to Docker Hub using secrets.
3. Builds the API Docker image.
4. Pushes the image as `dotnet-api:latest`.
5. Deploys the new image on a self-hosted runner, such as an EC2 instance.

Expected secrets:

- `DOCKER_USERNAME`
- `DOCKER_PASSWORD`

---

## 🇪🇸 Pruebas con Postman

El archivo `MoneyBankService.postman_collection.json` contiene una colección de Postman para validar los endpoints principales del servicio.

Para usarla:

1. Abrir Postman.
2. Importar la colección.
3. Configurar la URL base según el ambiente local o desplegado.
4. Ejecutar las pruebas de CRUD, depósitos y retiros.

## 🇺🇸 Testing with Postman

The `MoneyBankService.postman_collection.json` file contains a Postman collection to validate the main service endpoints.

To use it:

1. Open Postman.
2. Import the collection.
3. Configure the base URL according to the local or deployed environment.
4. Run CRUD, deposit, and withdrawal tests.

---

## 🇪🇸 Estado del proyecto

El proyecto cuenta actualmente con:

- API REST funcional para cuentas bancarias.
- Separación por capas.
- Repositorios e interfaces para acceso a datos.
- Servicios de aplicación con reglas de negocio.
- Validadores para cuentas y transacciones.
- Middleware de excepciones.
- Scripts SQL para inicialización y limpieza de datos.
- Dockerfile para contenerización.
- Workflow de GitHub Actions para build y despliegue.

## 🇺🇸 Project status

The project currently includes:

- Functional REST API for bank accounts.
- Layered separation.
- Repositories and interfaces for data access.
- Application services with business rules.
- Validators for accounts and transactions.
- Exception middleware.
- SQL scripts for data initialization and cleanup.
- Dockerfile for containerization.
- GitHub Actions workflow for build and deployment.

---

## 🇪🇸 Autor

**Sebastián López Montenegro**  
Systems Engineering Student | Backend & Cloud Developer

## 🇺🇸 Author

**Sebastián López Montenegro**  
Systems Engineering Student | Backend & Cloud Developer
