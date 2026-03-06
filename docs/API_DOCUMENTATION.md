# MyFitness API Documentation

## 1. Overview

MyFitness does not expose a public HTTP REST API in this repository.
The app uses:
- Internal Dart service APIs (under `lib/services/`)
- Firebase Firestore collections as the backend data API
- Shared Preferences for local session persistence

This document describes those APIs and the expected data contracts.

## 2. Service API (Dart)

### 2.1 `SessionService`
File: `lib/services/session_service.dart`

Purpose:
- Stores and reads login session details locally using `shared_preferences`

Methods:
- `Future<void> saveLoginSession({required String email, required String name})`
  - Saves keys:
    - `email`
    - `Name`
- `Future<String?> getUserEmail()`
  - Returns stored user email or `null`
- `Future<String?> getUserName()`
  - Returns stored user name or `null`
- `Future<bool> isLoggedIn()`
  - Returns `true` when email exists and is not empty
- `Future<void> clearSession()`
  - Clears all local shared preferences used by the app session

### 2.2 `PasswordService`
File: `lib/services/password_service.dart`

Purpose:
- Hashes and verifies user passwords using SHA-256

Methods:
- `static String hashPassword({required String email, required String password})`
  - Normalizes `email` with trim + lowercase
  - Normalizes `password` with trim
  - Hash input format: `<normalized_email>::<normalized_password>`
  - Returns SHA-256 hash string
- `static bool verifyPassword({required String email, required String enteredPassword, required String storedHash})`
  - Computes hash from input and compares with `storedHash`

### 2.3 `PlanService`
File: `lib/services/plan_service.dart`

Purpose:
- CRUD operations for user workout plans in Firestore

Methods:
- `Future<void> addPlan({required String planName, required String planTime, required String userEmail})`
  - Creates a new document in `plans` collection with:
    - `plan_name`
    - `plan_time`
    - `user_email`
    - `created_at` (`FieldValue.serverTimestamp()`)
- `Future<List<planModel>> getPlansByUserEmail(String userEmail)`
  - Reads all plans where `user_email == userEmail`
  - Maps data to `planModel` objects
- `Future<void> deletePlanById(String planId)`
  - Deletes one plan document by id

## 3. Firestore Data API

## 3.1 `Users` collection
Used in:
- `lib/RegistrationScreen.dart`
- `lib/LoginScreen.dart`
- `lib/ForgotpassScreen.dart`

Write payload on registration:
- `Name` (String)
- `email` (String)
- `password_hash` (String)
- `Phone Number` (String)
- `Gender` (String; expected values: `male` or `female`)

Read/query patterns:
- Query by `email` for login and password reset

Password migration behavior:
- Legacy field `password` can still be read in login flow for backward compatibility
- On successful legacy login/reset, app writes `password_hash` and removes legacy `password`

## 3.2 `plans` collection
Used in:
- `lib/services/plan_service.dart`
- `lib/addplanScreen.dart`
- `lib/myplanScreen.dart`

Document fields:
- `plan_name` (String)
- `plan_time` (String)
- `user_email` (String)
- `created_at` (Timestamp)

Supported operations:
- Create
- Query by `user_email`
- Delete by document id

## 3.3 `workout_progress` collection
Used in:
- `lib/workout_module_screen.dart`

Document id format:
- `<user_email>_<collectionName>`

Document fields:
- `user_email` (String)
- `module` (String)
- `completed_ids` (Array<String>)
- `updated_at` (Timestamp)

Behavior:
- Tracks completed exercise ids per user per workout module
- Supports reset by replacing `completed_ids` with empty array

## 3.4 Workout module collections
Used dynamically in:
- `lib/workout_module_screen.dart`

Known collection names from module screens:
- `abs_workouts`
- `back_workouts`
- `Biceps_workouts`
- `chest_workouts`
- `Forearms_workouts`
- `legs_workouts`
- `Shoulders_workouts`
- `Triceps_workouts`

Expected document fields for each workout item:
- `name` (String)
- `image` (String URL)
- `intro_image` (String URL)
- `muscles` (String)
- `instructions` (Array<String>)

Notes:
- App internally uses Firestore document id as stable item id when available
- Fallback item id order: `doc.id` -> `name` -> generated `workout_<index>`

## 3.5 `mind_relaxation` collection
Used in:
- `lib/Mind_relaxation_excercises.dart`

Expected document fields:
- `title` (String)
- `image` (String URL)

Read pattern:
- Real-time stream via `.snapshots()`

## 4. API Usage Examples

### Add a plan
```dart
final planService = PlanService();
await planService.addPlan(
  planName: 'Morning Cardio',
  planTime: '06:30 AM',
  userEmail: 'user@example.com',
);
```

### Fetch plans for current user
```dart
final planService = PlanService();
final plans = await planService.getPlansByUserEmail('user@example.com');
```

### Save login session
```dart
await SessionService.saveLoginSession(
  email: 'user@example.com',
  name: 'User Name',
);
```

### Verify password hash
```dart
final isValid = PasswordService.verifyPassword(
  email: 'user@example.com',
  enteredPassword: 'mySecret',
  storedHash: '<hash-from-firestore>',
);
```

## 5. Security and Consistency Notes

- Passwords should only be stored as `password_hash`; avoid writing plain text `password`.
- Firestore rules should enforce user-level access by authenticated identity.
- Collection names are currently case-sensitive and mixed-case in some modules; keep names exact to avoid query failures.
- If you want stronger contracts, consider introducing typed model classes for `Users`, `Workout`, and `MindRelaxation` documents.
