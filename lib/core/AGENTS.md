<coding_guidelines>
# Core Infrastructure

## Package Identity
Shared infrastructure used across all features: API client, local storage, design system, constants.

## Directory Structure
```
core/
├── constants/
│   └── api_constants.dart      # API endpoints, timeouts
├── services/
│   ├── api_services.dart       # Dio HTTP client wrapper
│   └── local_storage_services.dart  # SharedPreferences singleton
└── themes/
    ├── app_colors.dart         # Color constants
    ├── app_typography.dart     # Text styles (Plus Jakarta Sans)
    ├── app_spacing.dart        # Spacing, radius, shadows
    ├── app_theme.dart          # ThemeData configuration
    └── index.dart              # Barrel export
```

## Patterns & Conventions

### API Service (`services/api_services.dart`)
- Dio-based HTTP client with logging
- Methods: `get()`, `post()`, `put()`, `patch()`, `delete()`
- All methods return `Future<Response>`
- Base URL from `ApiConstants.baseUrl`

```dart
// Usage in repository
final response = await _apiRequest.post(
  '/auth/login',
  data: {'username': username, 'password': password},
);
```

### Local Storage (`services/local_storage_services.dart`)
- Singleton pattern: `LocalStorageService()`
- Must call `init()` in main.dart before usage
- Pre-defined methods: `saveAuthToken()`, `getUser()`, `saveExpenses()`, etc.

```dart
// In main.dart
await LocalStorageService().init();

// Usage anywhere
final token = LocalStorageService().getAuthToken();
await LocalStorageService().saveUser(user);
```

### Theme System (`themes/`)
```dart
// Import via barrel
import 'package:cash_vit/core/themes/index.dart';

// Or direct imports
import 'package:cash_vit/core/themes/app_colors.dart';

// Usage
AppColors.primaryBlue
AppTypography.textTheme.headlineLarge
AppSpacing.screenPadding
AppRadius.cardRadius
AppShadow.cardShadow
```

### Constants (`constants/api_constants.dart`)
```dart
ApiConstants.baseUrl          // https://fakestoreapi.com
ApiConstants.loginEndpoint    // /auth/login
ApiConstants.userDetailEndpoint(userId)  // /users/{id}
```

## Key Files
- **API Client**: `services/api_services.dart` - All HTTP requests go through here
- **Storage**: `services/local_storage_services.dart` - Token, user, expenses persistence
- **Colors**: `themes/app_colors.dart` - Primary, semantic, category colors
- **Typography**: `themes/app_typography.dart` - Plus Jakarta Sans text theme

## Common Gotchas
- LocalStorageService MUST be initialized before use: `await LocalStorageService().init()`
- Use `ApiConstants` for endpoints, never hardcode URLs
- Theme imports: prefer barrel `index.dart` or specific file, avoid wildcards
</coding_guidelines>
