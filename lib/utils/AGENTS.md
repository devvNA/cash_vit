# Utils Directory

## Package Identity
Infrastructure utilities: constants, services, themes.

## Structure
```
utils/
├── constants/
│   └── api_constants.dart        # API URLs, endpoints
├── services/
│   ├── api_services.dart         # Dio HTTP client
│   └── local_storage_services.dart  # Future storage
└── themes/                        # Design system implementation
    ├── app_colors.dart
    ├── app_typography.dart
    ├── app_spacing.dart
    ├── app_theme.dart
    └── index.dart                 # Barrel export
```

## Patterns & Conventions

### Constants (`constants/`)
```dart
// api_constants.dart
class ApiConstants {
  ApiConstants._(); // Private constructor
  
  static const String baseUrl = 'https://fakestoreapi.com';
  static const String loginEndpoint = '/auth/login';
  static const String usersEndpoint = '/users';
}
```
**DO**: Group related constants in classes
**DON'T**: Use magic strings in code

### Services (`services/`)
```dart
// Singleton pattern
class ServiceName {
  ServiceName._(); // Private constructor
  static final instance = ServiceName._();
  
  Future<Result> method() async {
    // Implementation
  }
}
```
**Example**: See `api_services.dart` for Dio setup

### Themes (`themes/`)
**CRITICAL**: All UI must use design system tokens, no magic values.

#### Import Pattern
```dart
import 'package:cash_vit/utils/themes/index.dart';
```

#### Usage Examples
```dart
// Colors
Container(color: AppColors.primaryBlue)
Text('Income', style: TextStyle(color: AppColors.incomeGreen))
Text('Expense', style: TextStyle(color: AppColors.expenseRed))

// Typography
Text('Heading', style: AppTypography.textTheme.headlineLarge)
Text('Amount', style: AppTypography.displayAmount)

// Spacing
Padding(padding: AppSpacing.screenPadding)
SizedBox(height: AppSpacing.xl)
EdgeInsets.all(AppSpacing.paddingCard)

// Radius
BorderRadius.circular(AppRadius.cardRadius)
BorderRadius radius: AppRadius.buttonRadius

// Shadow
boxShadow: AppShadow.cardShadow
```

### Design System Reference
From `docs/DESIGN_SYSTEMS.md`:

| Token | Value | Usage |
|-------|-------|-------|
| `primaryBlue` | `#2196F3` | Primary actions, buttons |
| `incomeGreen` | `#4CAF50` | Income amounts |
| `expenseRed` | `#EF5350` | Expense amounts |
| `backgroundLight` | `#F5F7FA` | Screen background |
| `surfaceWhite` | `#FFFFFF` | Cards, inputs |

| Spacing | Value | Usage |
|---------|-------|-------|
| `xs` | 4px | Minimal gap |
| `sm` | 8px | Small gap |
| `md` | 12px | Medium gap |
| `lg` | 16px | Large gap |
| `xl` | 24px | Extra large gap |
| `xxl` | 32px | Huge gap |

| Radius | Value | Usage |
|--------|-------|-------|
| `small` | 12 | Small elements |
| `medium` | 16 | Inputs, cards |
| `large` | 20 | Large cards |
| `button` | 24 | Buttons |
| `card` | 24 | Cards |

### Theme Customization
To modify theme:
1. Update token in `app_colors.dart`, `app_spacing.dart`, etc.
2. Run `flutter analyze` to catch usage
3. NO direct color/spacing values in screens

## Common Gotchas
- Never hardcode colors: `Color(0xFF...)` ❌ → `AppColors.primaryBlue` ✅
- Never magic numbers: `16.0` ❌ → `AppSpacing.lg` ✅
- Always use barrel import: `themes/index.dart`

## Pre-Check
- No magic colors in screens/widgets
- No magic spacing values
- All services are singletons
- Constants grouped logically
