# ATM Application Docker Setup Guide

## Prerequisites
- Docker installed (Windows/Mac, Linux)
- Docker Compose v2.10+
- Git

## Quick Start
Clone Repository
```bash
git clone git@github.com:azuaraj/atm-api-rails.git
cd atm-api-rails
```
Initial Setup
```bash
docker-compose build

# Start services (DB + Rails + Nginx)
docker-compose up -d

# Create and migrate databases
docker-compose exec rails rails db:create
docker-compose exec rails rails db:migrate
docker-compose exec rails rails db:seed

# Verify application
curl http://localhost:80/up  # Should return "OK"
```
Test Suite
```bash
# Run full test suite
docker-compose run --rm tests
```
## API Endpoints
🔑  **Authentication**
```bash
curl -X POST http://localhost/login \
     -H "Content-Type: application/json" \
     -d '{"atm_account_number": "12345678", "pin": "1234"}'
```
Successful Response:
```bash
{
  "token": "eyJhbGciOiJIUzI1..."
}
```
**Account Operations**
1. Check Balance
    ```bash
    curl -X GET http://localhost/accounts/show \
     -H "Authorization: Bearer YOUR_JWT_TOKEN"
    ```
    Response:
    ```bash
    {
    "balance": 1000.0
    }
    ```
2. Deposit Money
    ```bash
    curl -X POST http://localhost/accounts/deposit \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer YOUR_JWT_TOKEN" \
     -d '{"amount": 500.0}'
    ```
    Response:
    ```bash
    {
    "balance": 1500.0,
    "message": "Deposit successful"
    }
    ```
3. Withdraw Money
    ```bash
    curl -X POST http://localhost/accounts/withdraw \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer YOUR_JWT_TOKEN" \
     -d '{"amount": 300.0}'
    ```
    Response:
    ```bash
    {
    "balance": 1200.0,
    "message": "Withdrawal successful"
    }
    ```
**Testing with Pre-configured Account**

Use these credentials for testing:
```bash
ATM Account Number: 12345678
PIN: 1234
```
