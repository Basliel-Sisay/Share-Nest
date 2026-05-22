# Share Nest App

Share Nest App is a Flutter-based mobile application designed to provide a simple and modern platform for sharing and connecting users.

## 🚀 Getting Started

## auth by Tsion alemu

ShareNest is built using Flutter and follows a clean architecture structure. The app does not use a real backend server yet. Instead, it uses a fake backend inside the app itself to simulate API calls.

The app has three main storage systems:

1. Mock API (fake backend in memory)
2. SQLite database for local caching
3. SharedPreferences for small data like tokens

Here is how the whole system works step by step.

When the app starts, `main.dart` launches the application and wraps everything with Riverpod using `ProviderScope`. Riverpod is used for state management across the app.

Then `go_router` handles navigation and checks if the user is already logged in.

The app tries to restore the previous session:

- It checks SharedPreferences to see if a token already exists
- If a token is found, it checks the SQLite database for the saved user data
- If both exist, the app automatically logs the user in
- Otherwise, the app stays unauthenticated and sends the user to the login or landing page

For signup or login:

- The user enters email and password
- The request goes through the AuthNotifier (Riverpod state)
- Then to the Repository layer
- Then to the Remote Datasource

The “remote datasource” currently talks to a fake backend called `ApiClient`.

This ApiClient is NOT a real server.
It is just a Dart class holding data in memory using Maps and Lists.

Example:

- users are stored in memory
- tokens are stored in memory
- resources and reservations are also stored in memory

The fake API simulates a network delay of around 800ms to behave like a real backend.

After successful login:

- user data is saved into SQLite
- token is saved into SharedPreferences
- session information is also saved locally
- Riverpod updates the authentication state
- user is redirected to `/home`

SQLite is used as local persistence.
This means:

- data survives app restarts
- users remain cached
- offline support becomes possible

SharedPreferences is only used for very small simple data:

- auth token
- user id
- session flags

Once logged in, the app shows the main shell layout:

- Home
- Browse
- Add
- Loans
- Profile

using a bottom navigation bar.

When the user logs out:

- token is removed from the fake ApiClient
- SQLite tables are cleared
- SharedPreferences is cleared
- authentication state becomes unauthenticated
- user returns to the landing page

The architecture follows Clean Architecture:

Presentation Layer

- UI screens
- Riverpod providers
- state management

Domain Layer

- business logic
- entities
- repository contracts

Data Layer

- repositories
- datasources
- SQLite operations
- fake API operations

The important thing to understand is:

Currently there is NO real backend server.
No real HTTP requests leave the device.

Everything works locally:

- fake backend in memory
- SQLite for persistence
- SharedPreferences for tokens

If the project later moves to production:

- ApiClient will be replaced with real HTTP API calls
- backend server will handle authentication and database operations
- Flutter frontend will communicate with the backend through REST APIs

### Prerequisites

Before running the project, make sure you have installed:

- Flutter SDK
- Dart SDK
- Android Studio or VS Code
- Android Emulator or Physical Device

## ▶️ Run the Project

Clone the repository and run the following commands:

```bash
flutter pub get
flutter run
```
