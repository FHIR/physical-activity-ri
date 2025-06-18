# Docker Compose Setup for Keycloak and HAPI FHIR Server

This project provides a Docker Compose configuration to run **Keycloak** (an identity and access management server) alongside **HAPI FHIR Server** (a popular open-source FHIR implementation) with a PostgreSQL backend. It enables secure, OAuth2-protected FHIR API server deployments for development, testing, or demonstration purposes.

---

## Components

- **Keycloak**: Authentication and authorization server. Manages users, roles, and OAuth2 clients.
- **PostgreSQL**: Database service used by both Keycloak and HAPI FHIR server for data persistence.
- **HAPI FHIR Server**: Clinical data server implementing HL7 FHIR standard with OAuth2 security integrated with Keycloak.
- **PG Admin Client**: Database client for accessing postgres DB

---

## Prerequisites

- Docker and Docker Compose installed on your development machine.
- Basic understanding of Docker, OAuth2, and FHIR concepts.

---

## Getting Started

### 1. Clone or download this repository

```bash
git clone https://github.com/behnishmann85/securefhirserver.git
cd setup
```

.env contains the setup variables needed for running application successfully

Get the ip address for the local machine or domain address if it has the register domain. Populate the information in .env file.

Physical Activity realm is reloaded part of the docker compose deployment

To start the applications

```bash
docker-compose up -d 
```

Stop applications

```bash
docker-compose down 
```

### 2. Keycloak Configuration
Create a admin user with password under "physical_acctivity" realm. Disable the password setting "Temporary". This user can 
be used for getting the token while using API testing tools like postman

## Trouble Shooting

Using Host IP is important rather than localhost while running on local machine. Auth token validation would fail due to issuer missing match.
 
Choose non conflicting ports for FHIR and KeyCloak servers