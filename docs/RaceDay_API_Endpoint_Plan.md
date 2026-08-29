# RaceDay RESTful API Endpoint Plan

## RESTful API Plan

This document defines the planned RESTful API endpoints for the RaceDay event management system. The plan is based on the approved RaceDay Entity Relationship Diagram (ERD) and the Functional Requirements for Part 2.

The API will support two distinct user roles:

- **Organiser** – can create, update, and delete events; manage event categories; view participant enrolments for their events; and capture and manage participant results.
- **Participant** – can create an account, browse events and categories, enter events by selecting a category, view their own enrolments, and view their own results.

The implemented API in Part 2 should closely follow this plan. Any deliberate deviation should be documented and justified in the project README.

---

## Endpoint Specification

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| POST | `/api/auth/register` | Creates a new RaceDay user account and assigns the selected user role. | None (public) | `{ FirstName, LastName, Email, Password, Role }` | **201 Created** – account created. **400 Bad Request** – invalid data. **409 Conflict** – email already registered. |
| POST | `/api/auth/login` | Authenticates a user and returns authentication information for subsequent protected requests. | None (public) | `{ Email, Password }` | **200 OK** – authentication token and user information. **401 Unauthorized** – invalid credentials. |
| GET | `/api/users/me` | Retrieves the profile information of the currently authenticated user. | Any logged-in user | None | **200 OK** – current user's profile. **401 Unauthorized** – authentication required. |
| PUT | `/api/users/me` | Updates the currently authenticated user's profile information. | Any logged-in user | `{ FirstName, LastName, Email }` | **200 OK** – updated profile. **400 Bad Request** – invalid data. **401 Unauthorized** – authentication required. |
| GET | `/api/events` | Retrieves the available RaceDay events so users can browse upcoming events. | None (public) | None | **200 OK** – list of events. |
| GET | `/api/events/{eventId}` | Retrieves detailed information about a specific event. | None (public) | None | **200 OK** – event details. **404 Not Found** – event does not exist. |
| POST | `/api/events` | Creates a new event managed by the authenticated organiser. | Organiser | `{ EventName, Description, EventDate, Location, DistanceKM, EventType, RegistrationDeadline }` | **201 Created** – event created. **400 Bad Request** – invalid data. **401 Unauthorized** – authentication required. **403 Forbidden** – user is not an organiser. |
| PUT | `/api/events/{eventId}` | Updates an existing event managed by the authenticated organiser. | Organiser | `{ EventName, Description, EventDate, Location, DistanceKM, EventType, RegistrationDeadline }` | **200 OK** – updated event. **400 Bad Request** – invalid data. **403 Forbidden** – organiser does not manage the event. **404 Not Found** – event does not exist. |
| DELETE | `/api/events/{eventId}` | Deletes an event managed by the authenticated organiser. | Organiser | None | **204 No Content** – event deleted. **403 Forbidden** – organiser does not manage the event. **404 Not Found** – event does not exist. |
| GET | `/api/events/{eventId}/categories` | Retrieves all categories available for a specific event. | None (public) | None | **200 OK** – list of categories. **404 Not Found** – event does not exist. |
| GET | `/api/categories/{categoryId}` | Retrieves details of a specific event category. | None (public) | None | **200 OK** – category details. **404 Not Found** – category does not exist. |
| POST | `/api/events/{eventId}/categories` | Creates a new age or distance category for an event managed by the authenticated organiser. | Organiser | `{ CategoryName, DistanceKM, MaxParticipants, EntryFee }` | **201 Created** – category created. **400 Bad Request** – invalid data. **403 Forbidden** – organiser does not manage the event. **404 Not Found** – event does not exist. |
| PUT | `/api/categories/{categoryId}` | Updates an existing category belonging to an event managed by the authenticated organiser. | Organiser | `{ CategoryName, DistanceKM, MaxParticipants, EntryFee }` | **200 OK** – updated category. **400 Bad Request** – invalid data. **403 Forbidden** – insufficient permission. **404 Not Found** – category does not exist. |
| DELETE | `/api/categories/{categoryId}` | Deletes an event category managed by the authenticated organiser. | Organiser | None | **204 No Content** – category deleted. **403 Forbidden** – insufficient permission. **404 Not Found** – category does not exist. |
| POST | `/api/events/{eventId}/enrolments` | Creates an enrolment for the authenticated participant in the selected category of an event. | Participant | `{ CategoryID }` | **201 Created** – enrolment created. **400 Bad Request** – invalid category or data. **401 Unauthorized** – authentication required. **404 Not Found** – event or category does not exist. **409 Conflict** – participant is already enrolled or the category is full. |
| GET | `/api/enrolments/me` | Retrieves all event enrolments belonging to the currently authenticated participant. | Participant | None | **200 OK** – participant's enrolments. **401 Unauthorized** – authentication required. |
| GET | `/api/events/{eventId}/enrolments` | Retrieves all participant enrolments for an event managed by the authenticated organiser. | Organiser | None | **200 OK** – list of enrolments. **403 Forbidden** – organiser does not manage the event. **404 Not Found** – event does not exist. |
| GET | `/api/results/me` | Retrieves the authenticated participant's personal race results and performance history. | Participant | None | **200 OK** – participant's results. **401 Unauthorized** – authentication required. |
| GET | `/api/events/{eventId}/results` | Retrieves results for participants in an event managed by the authenticated organiser. | Organiser | None | **200 OK** – event results. **403 Forbidden** – organiser does not manage the event. **404 Not Found** – event does not exist. |
| GET | `/api/results/{resultId}` | Retrieves a specific race result for an authorised user. | Participant/Organiser | None | **200 OK** – result details. **403 Forbidden** – user does not have access. **404 Not Found** – result does not exist. |
| POST | `/api/entries/{entryId}/results` | Records a participant's finish time and finishing positions for an event entry. | Organiser | `{ FinishTime, OverallPosition, CategoryPosition, ResultStatus }` | **201 Created** – result recorded. **400 Bad Request** – invalid result data. **403 Forbidden** – organiser does not manage the entry's event. **404 Not Found** – entry does not exist. **409 Conflict** – result already exists. |
| PUT | `/api/results/{resultId}` | Updates an existing race result, allowing an organiser to correct recorded result information. | Organiser | `{ FinishTime, OverallPosition, CategoryPosition, ResultStatus }` | **200 OK** – updated result. **400 Bad Request** – invalid data. **403 Forbidden** – insufficient permission. **404 Not Found** – result does not exist. |
| GET | `/api/events/{eventId}/route` | Retrieves route information configured for an event. | None (public) | None | **200 OK** – route information. **404 Not Found** – event or route does not exist. |
| POST | `/api/events/{eventId}/route` | Creates route information for an event managed by the authenticated organiser. | Organiser | `{ RouteName, DistanceKM, ElevationGainM, RouteDescription, MapURL }` | **201 Created** – route created. **400 Bad Request** – invalid data. **403 Forbidden** – organiser does not manage the event. **404 Not Found** – event does not exist. **409 Conflict** – event already has a route. |
| PUT | `/api/routes/{routeId}` | Updates route information for an event managed by the authenticated organiser. | Organiser | `{ RouteName, DistanceKM, ElevationGainM, RouteDescription, MapURL }` | **200 OK** – route updated. **400 Bad Request** – invalid data. **403 Forbidden** – insufficient permission. **404 Not Found** – route does not exist. |
| DELETE | `/api/routes/{routeId}` | Removes route information from an event managed by the authenticated organiser. | Organiser | None | **204 No Content** – route deleted. **403 Forbidden** – insufficient permission. **404 Not Found** – route does not exist. |

---

## Coverage Summary

| Resource | Planned Endpoints |
|---|---:|
| Authentication | 2 |
| User Profiles | 2 |
| Events | 5 |
| Categories | 5 |
| Event Enrolments | 3 |
| Results | 5 |
| Routes | 4 |
| **Total** | **26** |

---

## Data Types and Field Requirements

### Common Field Types

- **string** – text (max length specified in request body)
- **integer** – whole number
- **decimal** – decimal number (e.g., 10.50 for distance in kilometres)
- **date** – ISO 8601 format (YYYY-MM-DD)
- **time** – ISO 8601 format (HH:MM:SS)
- **datetime** – ISO 8601 format (YYYY-MM-DDTHH:MM:SS)

### Request Body Field Status

- **Required fields** are included in the request body tables above.
- **Optional fields** (e.g., `DistanceKM` in Categories, `ElevationGainM` in Routes) are marked `NULL` in the database schema and may be omitted from requests.

---

## Request and Response Examples

### Example 1: User Registration (POST /api/auth/register)

**Request:**
```json
{
  "FirstName": "Sipho",
  "LastName": "Nkosi",
  "Email": "sipho.nkosi@example.com",
  "Password": "SecurePassword123!",
  "Role": "Participant"
}
```

**Success Response (201 Created):**
```json
{
  "UserID": 5,
  "FirstName": "Sipho",
  "LastName": "Nkosi",
  "Email": "sipho.nkosi@example.com",
  "Role": "Participant",
  "CreatedAt": "2026-08-29T10:30:00"
}
```

**Error Response (409 Conflict):**
```json
{
  "error": "Email already registered"
}
```

### Example 2: Create Event (POST /api/events)

**Request:**
```json
{
  "EventName": "Cape Town Trail Run",
  "Description": "A scenic trail running event in the Cape Town area.",
  "EventDate": "2026-10-15",
  "Location": "Cape Town, Western Cape",
  "DistanceKM": 21.5,
  "EventType": "Run",
  "RegistrationDeadline": "2026-10-05"
}
```

**Success Response (201 Created):**
```json
{
  "EventID": 4,
  "OrganizerID": 1,
  "EventName": "Cape Town Trail Run",
  "Description": "A scenic trail running event in the Cape Town area.",
  "EventDate": "2026-10-15",
  "Location": "Cape Town, Western Cape",
  "DistanceKM": 21.5,
  "EventType": "Run",
  "RegistrationDeadline": "2026-10-05",
  "CreatedAt": "2026-08-29T10:30:00"
}
```

### Example 3: Retrieve Event Enrolments (GET /api/enrolments/me)

**Success Response (200 OK):**
```json
[
  {
    "EntryID": 1,
    "EventID": 1,
    "EventName": "Durban Sunrise Run",
    "CategoryID": 2,
    "CategoryName": "Senior 10km",
    "EntryDate": "2026-08-20T14:30:00"
  },
  {
    "EntryID": 5,
    "EventID": 3,
    "EventName": "Cape Town Coastal Cycle",
    "CategoryID": 7,
    "CategoryName": "Senior Cycle",
    "EntryDate": "2026-08-25T09:15:00"
  }
]
```

---

## Implementation Notes

### Authentication

- Protected endpoints require an **Authorization** header with a Bearer token: `Authorization: Bearer <token>`
- The token is returned by the `/api/auth/login` endpoint.
- Without a valid token, protected endpoints return **401 Unauthorized**.

### Date and Time Formats

- Dates use **ISO 8601** format: `YYYY-MM-DD` (e.g., `2026-10-15`)
- Times use **ISO 8601** format: `HH:MM:SS` (e.g., `00:52:34`)
- DateTimes use **ISO 8601** format: `YYYY-MM-DDTHH:MM:SS` (e.g., `2026-08-29T10:30:00`)
- All times are in UTC or the server's configured timezone.

### Validation

- Distances and positions must be greater than zero.
- Email addresses must be unique.
- Registration deadlines cannot be after event dates.
- Roles must be `Organiser` or `Participant`.
- Event types must be `Run`, `Walk`, or `Cycle`.
- Result statuses must be `Finished`, `DNF`, `DNS`, or `Disqualified`.

---

## Design Notes

- The authenticated user's identity is obtained from the authentication context for protected operations. Participants therefore do not submit a `UserID` when creating an enrolment.
- `Entries` is the database entity used to represent the API concept of an event **Enrolment**.
- The Event API includes `DistanceKM` because the Part 2 Functional Requirements explicitly require every event to capture a distance.
- Categories support both age-based and distance-based categories, such as `Under 20`, `Senior`, `10km`, and `21km`.
- Results are associated with an `EntryID`, ensuring that each result belongs to a specific participant's event entry.
- Routes are included because `Routes` is an approved entity in the ERD and route information forms part of the RaceDay system background.
- Participants can only access their own enrolments and results through the protected participant endpoints.
- Organisers can access enrolments and results for events that they manage.
- The endpoint plan is intended to be the implementation blueprint for Part 2. Any deliberate deviation should be documented and justified in the project README.