<coding_guidelines>
# Core Infrastructure

## Package Identity
Shared infrastructure used across all features: API client, design system, constants, utilities.

## Directory Structure
```
core/
├── constants/
│   └── api_constants.dart      # API endpoints, timeouts
├── services/
│   └── api_services.dart       # Dio HTTP client wrapper
├── themes/
│   ├── app_colors.dart         # Color constants
│   ├── app_typography.dart     # Text styles (Plus Jakarta Sans)
│   ├── app_spacing.dart        # Spacing, radius, shadows
│   ├── app_theme.dart          # ThemeData configuration
│   └── index.dart              # Barrel export
└── utils/
    └── currency_formatter.dart # Number formatting with thousand separators
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

### Currency Formatter (`utils/currency_formatter.dart`)
- TextInputFormatter for thousand separators (Indonesian format)
- Use in TextFormField inputFormatters property

```dart
// Usage in form field
TextFormField(
  inputFormatters: [CurrencyFormatter()],
)
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
- **Colors**: `themes/app_colors.dart` - Primary, semantic, category colors
- **Typography**: `themes/app_typography.dart` - Plus Jakarta Sans text theme
- **Spacing**: `themes/app_spacing.dart` - AppSpacing, AppRadius, AppShadow
- **Currency**: `utils/currency_formatter.dart` - Number input formatting

## Common Gotchas
- Use `ApiConstants` for endpoints, never hardcode URLs
- Theme imports: prefer barrel `index.dart` or specific file, avoid wildcards
- CurrencyFormatter: Indonesian format with dots as thousand separators
</coding_guidelines>
