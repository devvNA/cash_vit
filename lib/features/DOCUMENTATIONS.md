# Features Module

## Purpose
Feature-based organization for screens and presentation logic.

## Structure
```
features/
├── auth/
│   └── presentation/    # Login screen
└── expenses/
    └── presentation/    # List & form screens
```

## Screens

### 1. Login Screen (`auth/presentation/`)
- Username & password fields
- Login button with loading state
- Error message display
- Hero animation on user avatar

### 2. Expense List Screen (`expenses/presentation/`)
- User info header
- Balance summary card (Income, Expense, Balance)
- ListView of expenses
- FAB for adding new expense
- Logout button
- Swipe-to-delete gesture

### 3. Expense Form Screen (`expenses/presentation/`)
- Title field (max 50 chars)
- Amount field (> 0)
- Type selector (Income/Expense)
- Date picker
- Save button

## Animation Requirements

### Hero Animation
```dart
Hero(
  tag: 'user-avatar',
  child: CircleAvatar(...),
)
```

### Page Transitions
```dart
// Slide up for form screen
PageRouteBuilder(
  pageBuilder: (_, __, ___) => ExpenseFormScreen(),
  transitionsBuilder: (_, animation, __, child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  },
)
```

### Micro-interactions
- FAB: `ScaleTransition` on tap
- List items: `FadeTransition` on appear
- Form fields: focus animation
- Delete: swipe gesture with `Dismissible`

## Design Tokens
- Button height: 56px, radius: 24
- Input height: 56px, radius: 16
- Card radius: 16
- Income color: `#4CAF50`
- Expense color: `#EF5350`
