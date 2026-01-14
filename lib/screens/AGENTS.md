# Screens Directory

## Package Identity
Feature-based UI screens organized by domain (splash, auth, base, expenses).

## Structure
```
screens/
├── splash_screen/
│   └── splash_screen.dart
├── auth/
│   └── login_screen.dart
├── base/
│   ├── base_screen.dart
│   └── widgets/              # Screen-specific widgets
│       └── custom_bottom_nav.dart
└── expenses/
    ├── expense_list_screen.dart
    └── expense_form_screen.dart (future)
```

## Patterns & Conventions

### Screen Widget Structure
```dart
// 1. Use ConsumerStatefulWidget for Riverpod + local state
class FeatureScreen extends ConsumerStatefulWidget {
  const FeatureScreen({super.key});
  
  @override
  ConsumerState<FeatureScreen> createState() => _FeatureScreenState();
}

class _FeatureScreenState extends ConsumerState<FeatureScreen> {
  // Local state (controllers, focus nodes)
  final _controller = TextEditingController();
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    // Watch provider state
    final state = ref.watch(featureProvider);
    
    // Listen for side effects
    ref.listen(featureProvider, (previous, next) {
      if (next is FeatureError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message)),
        );
      }
    });
    
    return Scaffold(
      appBar: AppBar(title: const Text('Feature')),
      body: _buildBody(state),
    );
  }
  
  Widget _buildBody(FeatureState state) {
    return switch (state) {
      FeatureLoading() => const Center(child: CircularProgressIndicator()),
      FeatureSuccess(:final data) => _buildContent(data),
      FeatureError(:final message) => Center(child: Text(message)),
      _ => const SizedBox(),
    };
  }
}
```

### Examples
- **Splash**: See `splash_screen/splash_screen.dart` for loading animation
- **Login**: See `auth/login_screen.dart` for form validation
- **Base**: See `base/base_screen.dart` for bottom navigation

### Naming Conventions
- File: `{feature}_screen.dart` (snake_case)
- Class: `{Feature}Screen` (PascalCase)
- Private widgets: `_{WidgetName}` prefix

### Design System Usage
```dart
import 'package:cash_vit/utils/themes/index.dart';

// Colors
AppColors.primaryBlue
AppColors.incomeGreen
AppColors.expenseRed

// Typography
AppTypography.textTheme.headlineLarge
AppTypography.displayAmount

// Spacing
AppSpacing.screenPadding
AppSpacing.xl

// Radius
AppRadius.cardRadius
AppRadius.buttonRadius
```

### Navigation Patterns
```dart
// Push
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const NextScreen()),
);

// Replace (no back button)
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (_) => const NextScreen()),
);

// Custom transition (slide up)
Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (_, __, ___) => const FormScreen(),
    transitionsBuilder: (_, animation, __, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        )),
        child: child,
      );
    },
  ),
);
```

### Required Animations
From `docs/PRD.md` section 5:
- **Hero Animation**: User avatar login → expense list
- **Page Transition**: Slide animation for form screen
- **Micro-interactions**: FAB scale, list fade-in, swipe delete

### Reference
- **UI Guidelines**: `docs/DESIGN_SYSTEMS.md`
- **User Flows**: `docs/PRD.md` section 8
- **Riverpod in UI**: `docs/TECHNICAL_OVERVIEW.md` section 4

## Common Gotchas
- Use `ref.read()` in callbacks, NOT `ref.watch()`
- Always dispose controllers in dispose()
- Use `const` for static widgets
- Wrap `ref.listen()` side effects in build method

## Pre-Check
All screens must:
- Extend `ConsumerStatefulWidget` or `ConsumerWidget`
- Use design system (no magic numbers)
- Handle loading/error states
- Follow animation requirements
