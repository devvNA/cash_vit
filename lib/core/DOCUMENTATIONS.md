# Core Module

## Purpose
Foundation layer containing models, providers, services, and constants.

## Structure
```
core/
├── constants/     # API URLs, app constants
├── models/        # Data models (User, Expense)
├── providers/     # Riverpod providers
└── services/      # API service layer
```

## Models

### User Model
```dart
class User {
  final int id;
  final String username;
  final String email;
  final String name;
}
```

### Expense Model
```dart
class Expense {
  final String id;
  final String title;
  final double amount;
  final ExpenseType type;  // income / expense
  final DateTime date;
  final int userId;
}
```

## Providers Pattern
- Use `@riverpod` annotation or manual provider creation
- Auth state: `StateNotifierProvider`
- Expense list: `StateNotifierProvider<ExpenseNotifier, List<Expense>>`
- User data: `FutureProvider`

## Services
- `ApiService`: HTTP client wrapper for FakeStore API
- Base URL: `https://fakestoreapi.com`
- Handle loading states and errors

## Constants
```dart
// api_constants.dart
const String baseUrl = 'https://fakestoreapi.com';
const String loginEndpoint = '/auth/login';
const String usersEndpoint = '/users';
```

## Validations
- Username: min 3 characters
- Password: min 6 characters
- Title: required, max 50 characters
- Amount: required, > 0
