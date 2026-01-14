<coding_guidelines>
# Shared Components

## Package Identity
Cross-feature reusable code: widgets, extensions, utilities that don't belong to a specific feature.

## Directory Structure
```
shared/
├── extensions/                 # Dart extensions (future)
└── widgets/
    └── background_glows.dart   # Decorative background blobs
```

## Patterns & Conventions

### Shared Widget Pattern
Location: `shared/widgets/*.dart`

```dart
// Stateless, const-constructible, theme-aware
class BackgroundGlows extends StatelessWidget {
  const BackgroundGlows({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Use AppColors from core/themes
        Positioned(
          top: -100,
          left: -100,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.accentBlue.withValues(alpha: 0.2),
            ),
          ),
        ),
      ],
    );
  }
}
```

### Extension Pattern (Future)
Location: `shared/extensions/*.dart`

```dart
// Example: String extensions
extension StringExtension on String {
  String capitalize() => isEmpty ? '' : '${this[0].toUpperCase()}${substring(1)}';
}

// Example: DateTime extensions
extension DateTimeExtension on DateTime {
  String toDisplayFormat() => '$day/$month/$year';
}
```

## Key Files
- **Background Effect**: `widgets/background_glows.dart` - Used in splash/login screens

## Usage
```dart
import 'package:cash_vit/shared/widgets/background_glows.dart';

// In screen
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        const BackgroundGlows(),  // Background layer
        // ... main content
      ],
    ),
  );
}
```

## When to Add to Shared vs Feature
- **Shared**: Used by 2+ features, generic, no feature-specific logic
- **Feature widgets**: Used only within one feature, contains feature-specific state

## Common Gotchas
- Always use `const` constructor when possible
- Import theme from `core/themes/` for consistency
- Avoid feature-specific imports in shared code
</coding_guidelines>
