# Physical Activity Reference Implementation (physical-activity-ri)

Welcome to the **Physical Activity Reference Implementation** repository.  
This project provides a full-stack reference implementation aligned with the [Physical Activity Implementation Guide](https://build.fhir.org/ig/HL7/physical-activity/). It includes:

- **Patient App** for individuals to track and manage their physical activity.
- **Provider App** for care providers to view, manage, and assign activity-related goals.
- **Docker-based server setup** using Keycloak and HAPI FHIR for identity and data management.
- **User documentation** to assist with setup and navigation of both apps.

---

## 🧍‍♂️ Patient App

The Patient App helps users:

- Log and track their physical activity data
- Set personal goals
- Sync activity data with FHIR-based healthcare systems

---

## 🩺 Provider App

The Provider App enables healthcare professionals to:

- Review patient-submitted activity data
- Prescribe and monitor physical activity goals
- Coordinate care based on shared, real-time data

---

## 🛠️ Server Setup

The `ServerSetup` folder includes a **Docker Compose** configuration that provisions:

- **Keycloak** – for identity and access management
- **HAPI FHIR Server** – for storing and exchanging FHIR resources

This environment allows both apps to securely interact with the FHIR server in accordance with the implementation guide.

---

## 📚 Documentation

Documentation for both apps can be found in the [`/Documentation`](./Documentation) folder.  
It includes user guides for setup, navigation, and general use of the Patient and Provider apps.

