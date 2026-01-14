# Widgets Directory

## Package Identity
Shared reusable widgets used across multiple screens.

## Key Files
- `background_glows.dart` - Decorative background gradient blobs

## Patterns & Conventions

### When to Create Shared Widget
Create in `widgets/` if:
1. Used in 2+ different screens
2. Has no screen-specific logic
3. Reusable with props/parameters

**Otherwise**: Keep widget private in screen file (`_{WidgetName}`)

### Widget Structure
```dart
class CustomWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final bool isEnabled;
  
  const CustomWidget({
    super.key,
    required this.title,
    this.onTap,
    this.isEnabled = true,
  });
  
  @override
  Widget build(BuildContext context) {
    // Implementation using design system
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(
          color: AppColors.surfaceWhite,
          borderRadius: AppRadius.cardRadius,
        ),
        child: Text(
          title,
          style: AppTypography.textTheme.bodyLarge,
        ),
      ),
    );
  }
}
```

### Examples
- **DO**: Follow pattern from `background_glows.dart`
- **DO**: Use design system tokens (AppColors, AppSpacing)
- **DON'T**: Access providers directly (pass data via props)
- **DON'T**: Include business logic (keep in providers)

### Naming Conventions
- File: `{widget_name}.dart` (snake_case)
- Class: `{WidgetName}` (PascalCase)
- No "Widget" suffix in file/class name

### Design System Components
From `docs/DESIGN_SYSTEMS.md` section 4:

#### Primary Button Pattern
```dart
Container(
  height: 56,
  decoration: BoxDecoration(
    gradient: AppColors.primaryGradient,
    borderRadius: AppRadius.buttonRadius,
    boxShadow: AppShadow.buttonShadow,
  ),
  child: ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
    ),
    child: Text('Button'),
  ),
)
```

#### Text Input Pattern
```dart
TextFormField(
  decoration: InputDecoration(
    labelText: 'Label',
    hintText: 'Hint',
    prefixIcon: Icon(Icons.icon),
  ),
  // Theme handles styling
)
```

#### Transaction Card Pattern
```dart
Container(
  padding: AppSpacing.cardPadding,
  decoration: BoxDecoration(
    color: AppColors.surfaceWhite,
    borderRadius: AppRadius.cardRadius,
    boxShadow: AppShadow.cardShadow,
  ),
  child: Row(
    children: [
      // Left: Icon 48x48 with category bg
      Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: categoryColor,
          borderRadius: AppRadius.smallRadius,
        ),
        child: Icon(icon),
      ),
      SizedBox(width: AppSpacing.lg),
      // Right: Title + amount
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTypography.textTheme.bodyLarge),
            Text(
              amount,
              style: AppTypography.amountMedium.copyWith(
                color: isIncome ? AppColors.incomeGreen : AppColors.expenseRed,
              ),
            ),
          ],
        ),
      ),
    ],
  ),
)
```

## Common Gotchas
- Always use `const` constructors
- Pass callbacks, don't call `ref.read()` inside widget
- Use design system (no hardcoded values)

## Pre-Check
- Widget is reusable (not screen-specific)
- Uses design system tokens
- No provider access (data via props)
- Has `const` constructor
