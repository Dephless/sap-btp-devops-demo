# SAP BTP DevOps Demo

A portfolio project demonstrating SAP BTP application development, ABAP RAP, OData V4, automated testing and CI/CD with GitHub Actions.

The project combines an **SAP RAP Sales Order application** with a small **Node.js service** used to demonstrate automated testing and CI/CD.

---

## Overview

This project was created as a practical SAP development and DevOps portfolio project.

The main goal is to demonstrate that I can work across the application lifecycle:

* design and implement an SAP RAP business object
* create CDS data models and projections
* implement RAP behavior and business validation
* work with managed numbering and draft handling
* expose the application through OData V4
* write and execute ABAP Unit tests
* use abapGit for source-code synchronization
* build automated tests with Node.js
* execute tests automatically with GitHub Actions
* document technical results and test evidence

---

## Architecture

```text
                         GitHub Repository
                               │
                               │
                         GitHub Actions
                               │
                         npm test / CI
                               │
                               ▼
                        Node.js Application
                               │
                               │
                    ┌──────────┴──────────┐
                    │                     │
                    ▼                     ▼
              Express API            Automated Tests
                    │
                    │
                    ▼
              SAP BTP / ABAP
                    │
                    ▼
              OData V4 Service
                    │
                    ▼
             SAP RAP Business Object
                    │
          ┌─────────┴─────────┐
          │                   │
          ▼                   ▼
       CDS Views        RAP Behavior
          │                   │
          │                   ├── Create
          │                   ├── Update
          │                   ├── Delete
          │                   ├── Draft
          │                   └── Validation
          │
          ▼
       Database Tables
```

---

## Technology Stack

### SAP

* SAP BTP / ABAP environment
* ABAP RAP
* ABAP CDS
* OData V4
* Fiori Elements preview
* ABAP Unit
* ADT / Eclipse
* abapGit

### DevOps / Development

* Git
* GitHub
* GitHub Actions
* Node.js
* Express
* Jest
* npm

---

# CI/CD Pipeline

A central part of this project is the implementation of a GitHub Actions CI pipeline.

The pipeline demonstrates how automated quality checks can be integrated into a Git-based development workflow.

## Pipeline Flow

```text
Developer
    │
    │ git push
    ▼
GitHub Repository
    │
    │ workflow trigger
    ▼
┌──────────────────────────────┐
│       GitHub Actions         │
│                              │
│  1. Checkout repository      │
│  2. Setup Node.js             │
│  3. Install dependencies      │
│  4. Run automated tests       │
│                              │
│          npm test             │
└──────────────┬───────────────┘
               │
               ▼
        Automated Test Result
               │
          ┌────┴────┐
          │         │
        PASS       FAIL
          │         │
          ▼         ▼
       ✓ Green    ✗ Red
```

## What the Pipeline Demonstrates

The CI pipeline automatically verifies the Node.js application after changes are pushed to GitHub.

The current pipeline performs the following steps:

1. Checks out the repository
2. Sets up the Node.js environment
3. Installs the project dependencies
4. Executes the Jest test suite
5. Reports the test result directly in GitHub Actions

This creates an automated quality gate for the application.

## Current CI Result

The current pipeline successfully executes:

```text
Test Suites: 4 passed, 4 total
Tests:       7 passed, 7 total
```

The latest GitHub Actions workflow completed successfully.

This means that the repository contains a reproducible automated test process rather than relying only on manually executed local tests.

## Why CI/CD Is Part of This Project

The purpose of the pipeline is to demonstrate the transition from local development to an automated development workflow:

```text
Local Development
       │
       ▼
      Git
       │
       ▼
    GitHub
       │
       ▼
 GitHub Actions
       │
       ▼
 Automated Tests
       │
       ▼
 Quality Feedback
```

This approach is applicable to enterprise development environments where changes should be automatically validated before they are considered ready for further deployment or integration.

## SAP Development and CI/CD

The SAP part of the project is developed in the ABAP environment using:

* ABAP RAP
* CDS
* OData V4
* ABAP Unit
* ADT
* abapGit

The GitHub-based pipeline complements this SAP development workflow by demonstrating Git-based version control and automated CI.

The current project therefore combines:

```text
SAP Application Development
        +
Git-based Version Control
        +
Automated Testing
        +
CI Pipeline
```

## Pipeline Evidence

A successful pipeline run can be verified directly in the repository under:

```text
GitHub → Actions
```

Recommended screenshot:

```text
docs/evidence/github-actions-success.png
```

The screenshot should show the successful workflow run and the passing test result.

---

# DevOps Workflow

The complete development workflow demonstrated by this project is:

```text
┌──────────────────────┐
│ SAP / Local          │
│ Development          │
│                      │
│ ABAP RAP             │
│ CDS                  │
│ ABAP Unit            │
└──────────┬───────────┘
           │
           │ Source synchronization
           ▼
┌──────────────────────┐
│ Git / GitHub         │
│                      │
│ Version Control      │
│ Repository           │
└──────────┬───────────┘
           │
           │ Push / Pull Request
           ▼
┌──────────────────────┐
│ GitHub Actions       │
│                      │
│ CI Pipeline          │
│                      │
│ npm test             │
└──────────┬───────────┘
           │
           ▼
      Quality Gate
           │
      ┌────┴────┐
      ▼         ▼
    PASS       FAIL
      │         │
      ▼         ▼
   Continue   Fix Code
```

This demonstrates the fundamental DevOps principle of obtaining automated feedback from the source repository after changes are introduced.

---

# SAP RAP Application

## Business Object

The main SAP application is a Sales Order business object.

The RAP business object is based on:

```text
ZI_DEVOPS_SO
```

with the projection:

```text
ZC_DEVOPS_SO
```

The persistence is provided by:

```text
ZDEVOPS_SO
```

and the draft table:

```text
ZDEVOPS_SO_D
```

---

## Sales Order Data Model

The Sales Order contains the following business fields:

| Field                   | Description                       |
| ----------------------- | --------------------------------- |
| `SALES_ORDER_ID`        | UUID-based Sales Order identifier |
| `CUSTOMER_NAME`         | Customer name                     |
| `ORDER_DATE`            | Order date                        |
| `STATUS`                | Sales Order status                |
| `AMOUNT`                | Order amount                      |
| `CURRENCY_CODE`         | Currency                          |
| `LOCAL_LAST_CHANGED_AT` | Local last-change timestamp       |
| `LAST_CHANGED_AT`       | Last-change timestamp             |

The technical timestamps are used for RAP change tracking / ETag handling.

---

# RAP Behavior

The RAP behavior is implemented as a managed, draft-enabled business object.

Implemented operations include:

* Create
* Update
* Delete
* Draft Edit
* Draft Resume
* Draft Activate
* Draft Discard
* Draft Prepare

The Sales Order identifier uses RAP managed numbering:

```abap
field ( readonly, numbering : managed ) sales_order_id;
```

This means the RAP framework is responsible for generating the key instead of the application manually overwriting the protected key field.

---

# Business Validation

A RAP validation was implemented for the Sales Order amount.

The rule is:

```text
Amount must be greater than zero.
```

The validation is executed on save for create and update:

```abap
validation validate_amount on save { create; update; field amount; }
```

The handler checks the amount and reports a RAP validation error when the amount is invalid.

Example business rule:

```abap
IF order-amount <= 0.
  ...
ENDIF.
```

This demonstrates implementation of business logic directly in the RAP behavior layer.

---

# OData V4 Service

The projection is exposed through an OData V4 service:

```text
ZUI_DEVOPS_SO
```

Service binding:

```text
ZUI_DEVOPS_SO_O4
```

The service binding uses:

```text
OData V4 - UI
```

The service is activated and published and can be opened through the SAP Fiori Elements preview.

The service endpoint follows the SAP OData V4 service structure:

```text
/sap/opu/odata4/...
```

---

# Testing

Testing is an important part of this project.

The project currently contains two testing layers:

1. Node.js automated tests
2. ABAP Unit tests

---

## Node.js Tests

The Node.js application is tested with Jest.

Current test suites:

```text
test/
├── health.test.js
├── root.test.js
├── error-handling.test.js
└── server.test.js
```

The current local test result is:

```text
Test Suites: 4 passed, 4 total
Tests:       7 passed, 7 total
```

This verifies:

* application health endpoint
* root endpoint
* server behavior
* error handling
* application responses

---

## Continuous Integration

The Node.js tests are executed automatically with GitHub Actions.

The latest GitHub Actions workflow completed successfully:

```text
✓ Workflow successful
✓ 4 test suites passed
✓ 7 tests passed
```

This provides a reproducible CI check instead of relying only on local test execution.

The GitHub Actions workflow can be inspected directly in the repository under:

```text
Actions
```

---

# ABAP Unit

The SAP RAP application also contains an ABAP Unit test class:

```text
ZCL_DEVOPS_SO_TEST
```

The class is configured as an ABAP Unit test class with:

```abap
FOR TESTING
DURATION SHORT
RISK LEVEL HARMLESS
```

---

## RAP Create Test

The test class contains an EML-based create test.

The test executes:

```abap
MODIFY ENTITIES OF zi_devops_so
```

and creates a Sales Order through the RAP business object.

The test verifies that:

```text
FAILED is initial
```

and that:

```text
MAPPED is not initial
```

Therefore the test verifies that the RAP Create operation can successfully create an entity through EML.

### Result

```text
ABAP Unit: PASS
```

This is evidence that the RAP create operation works at the application behavior level.

---

## Validation Test

A separate ABAP Unit test is being used to verify the amount validation.

The intended negative test uses:

```text
Amount = 0.00
```

and verifies that the RAP save operation rejects the invalid amount.

The validation is an `ON SAVE` validation, so the test needs to execute the RAP save phase before checking the failure result.

This test is currently being refined and is therefore **not claimed as a completed passing test yet**.

---

# Test Evidence

The repository can contain screenshots and other evidence under:

```text
docs/evidence/
```

Recommended evidence includes:

```text
docs/
├── architecture.md
└── evidence/
    ├── github-actions-success.png
    ├── node-tests-success.png
    ├── abap-unit-create-success.png
    ├── rap-behavior-definition.png
    ├── service-binding.png
    └── fiori-preview.png
```

The purpose of these screenshots is to make the technical results independently understandable to someone reviewing the repository.

---

# Repository Structure

```text
sap-btp-devops-demo/
│
├── .github/
│   └── workflows/
│
├── abap/
│   └── sales_order/
│       ├── behavior/
│       ├── data_model/
│       ├── projection/
│       ├── service/
│       └── test_data/
│
├── src/
│   └── server.js
│
├── test/
│   ├── health.test.js
│   ├── root.test.js
│   ├── error-handling.test.js
│   └── server.test.js
│
├── .abapgit.xml
├── .gitignore
├── manifest.yml
├── package.json
├── package-lock.json
└── README.md
```

---

# Test Data

The project also contains an ABAP test-data utility:

```text
ZCL_DEVOPS_TESTDATA
```

It creates example Sales Orders for development and testing.

Example data includes customers such as:

```text
ACME GmbH
SAP Demo Customer
Example Corp
```

The test data contains different statuses, amounts and dates to support development and service testing.

---

# Node.js Application

The Node.js application is implemented with Express.

The root endpoint returns application information:

```json
{
  "application": "SAP BTP DevOps Demo",
  "status": "running",
  "version": "1.0.0"
}
```

The health endpoint returns:

```json
{
  "status": "healthy"
}
```

The application is intentionally small because its primary purpose in this project is to demonstrate automated testing and CI/CD.

---

# CI/CD Approach

The current CI workflow demonstrates the following development cycle:

```text
Developer
    │
    ▼
Git Commit
    │
    ▼
GitHub
    │
    ▼
GitHub Actions
    │
    ▼
npm test
    │
    ▼
Automated Test Result
    │
    ├── PASS ✓
    └── FAIL ✗
```

The successful workflow provides an automated quality gate for the Node.js part of the repository.

The SAP ABAP part is developed and tested in the SAP development environment and synchronized through abapGit.

---

# What I Implemented

This project demonstrates practical experience with:

### SAP Development

* ABAP development
* ABAP CDS
* RAP managed business objects
* RAP draft handling
* RAP behavior definitions
* RAP validations
* EML
* ABAP Unit
* OData V4
* Service bindings
* Fiori Elements preview
* SAP test-data generation

### DevOps / Software Engineering

* Git and GitHub
* repository structure
* source-code versioning
* automated testing
* GitHub Actions
* CI pipelines
* Node.js
* Express
* Jest
* abapGit

---

# What I Learned

The project helped me understand the relationship between SAP application development and modern software engineering practices.

In particular:

* how CDS views form the data model for RAP applications
* how managed RAP behavior handles standard CRUD operations
* how draft-enabled applications work
* how RAP validations enforce business rules
* how EML can be used to test RAP behavior
* how ABAP Unit can verify application logic
* how OData V4 exposes a RAP business object
* how automated tests can be integrated into GitHub Actions
* how Git and abapGit can be used together for source-code management
* how technical implementation can be documented with reproducible evidence

---

# Future Improvements

Possible future improvements include:

* additional ABAP Unit tests for positive and negative validation scenarios
* additional RAP business actions
* stronger authorization handling
* additional Fiori Elements annotations
* expanded CI quality checks
* automated ABAP quality checks
* deployment automation to SAP BTP
* improved application monitoring
* additional test coverage

# Conclusion

This project demonstrates a practical end-to-end development approach combining **SAP ABAP RAP development with modern Git-based DevOps practices**.

The focus is not on using as many technologies as possible, but on demonstrating a complete development workflow:

```text
Implement
   ↓
Test
   ↓
Version Control
   ↓
Automated CI
   ↓
Document Evidence
```

The project is intended as a technical portfolio demonstrating practical skills relevant to roles such as:

* Junior SAP Developer
* SAP BTP Developer
* Junior SAP DevOps Developer
* ABAP Developer
* SAP Application Developer
