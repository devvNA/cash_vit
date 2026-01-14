# Shared Module

## Purpose
Reusable widgets and components used across features.

## Structure
```
shared/
└── widgets/    # Reusable UI components
```

## Widget Patterns

### Primary Button
```dart
// Height: 56, Radius: 24
// Gradient: #2196F3 → #1976D2
// States: default, pressed (scale 0.97), disabled (opacity 0.5)
```

### Text Input
```dart
// Height: 56, Radius: 16
// Border: #E5E7EB (normal), #2196F3 (focus), #EF5350 (error)
// Filled background
```

### Transaction Card
```dart
// White card, radius: 16, shadow
// Left: Icon (48x48) with category color bg
// Right: Title, amount (green income, red expense)
```

### Balance Summary Card
```dart
// Shows: Total Income, Total Expense, Balance
// Use design system colors
```

## Design System Reference
- See: `docs/DESIGN_SYSTEM.md`
- Primary: `#2196F3`
- Income: `#4CAF50`
- Expense: `#EF5350`
- Background: `#F5F7FA`
- Surface: `#FFFFFF`
- Text Primary: `#1A1D1F`
- Text Secondary: `#6B7280`

## Typography
- Font: Plus Jakarta Sans
- H1: 32/bold, H2: 24/bold, H3: 20/semibold
- Body: 16/medium, 14/regular, 12/regular
- Amount display: 48/bold
