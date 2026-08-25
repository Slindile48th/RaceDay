# RaceDay

RaceDay is a full-stack web-based event management system for the South African road running, walking and cycling community.

## Project Overview

Many road events still rely on paper-based registration, spreadsheets and disconnected communication. This creates difficulties for both organisers and participants when managing event information, registrations and results.

RaceDay provides a centralised platform for managing events, categories, enrolments and results.

## User Roles

### Organiser

- Manage events
- Manage categories
- View event enrolments
- Capture participant results

### Participant

- Register and log in
- Browse events
- Enter events
- Select categories
- View own enrolments
- View personal results

## Part 1 - System Planning and Database

Part 1 established the system's foundation through:

- ERD and database design
- RESTful API planning
- SQL Server database schema and seed data
- Role-based system planning

The six approved database entities are Users, Events, Categories, Routes, Entries and Results.

## Repository Structure

```text
RaceDay/
|-- docs/
|   |-- RaceDay_ERD.png
|   `-- RaceDay_API_Endpoint_Plan.md
|-- src/
|   `-- RaceDay_Database.sql
|-- tests/
|-- .github/workflows/
|   `-- raceday-ci.yml
|-- README.md
`-- .gitignore
```

The `docs` directory contains the approved Part 1 planning documentation. The SQL Server database script is currently stored in `src`.

## Technology

- SQL Server
- SQL Server Management Studio (SSMS)
- GitHub
- GitHub Actions

## CI/CD

GitHub Actions automatically validates the required RaceDay repository structure whenever changes are pushed or a pull request is opened or updated.

The successful GitHub Actions build screenshot will be added here after the workflow runs successfully:

![GitHub Actions CI Build](docs/github-actions-success.png)

## Development Status

Part 1 - System Planning and Database has been completed and verified.

Part 2 will focus on implementing the planned RESTful API.
