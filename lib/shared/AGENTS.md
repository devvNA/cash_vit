<coding_guidelines>
# Shared Components

## Package Identity
Cross-feature reusable code: widgets, extensions, utilities that don't belong to a specific feature.

## Directory Structure
```
shared/
├── extensions/
│   └── currency_extension.dart  # Currency formatting extensions
└── widgets/
    └── background_glows.dart    # Decorative background blobs
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

### Extension Pattern
Location: `shared/extensions/*.dart`

```dart
// Currency formatting extensions
import 'package:cash_vit/shared/extensions/currency_extension.dart';

// Usage examples
final amount = 1500000.0;
amount.toRupiah          // "Rp 1.500.000"
amount.toRupiahCompact   // "Rp 1,5 jt" (for large amounts)

// On int
final intAmount = 500000;
intAmount.toRupiah       // "Rp 500.000"
```

## Key Files
- **Background Effect**: `widgets/background_glows.dart` - Used in splash/login screens
- **Currency Extension**: `extensions/currency_extension.dart` - Rupiah formatting for amounts

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
