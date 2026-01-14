# Design System Singkat – Expense Tracker (Flutter)

> **Implementation**: `lib/core/themes/`

## 1. Colors (core)
> File: `lib/core/themes/app_colors.dart`

- Primary: `primaryBlue = #2196F3`, `primaryBlueDark = #1976D2`, `accentBlue = #64B5F6`
- Semantic: `incomeGreen = #4CAF50`, `expenseRed = #EF5350`, `warningOrange = #FF9800`
- Background & text utama secukupnya:
  - `backgroundLight = #F5F7FA`, `surfaceWhite = #FFFFFF`
  - `textPrimary = #1A1D1F`, `textSecondary = #6B7280`
  - `borderLight = #E5E7EB`
- Category pakai soft‑bg (contoh: food, salary, entertainment, fuel, shopping) sesuai kebutuhan.
- Gradient: `primaryGradient` (LinearGradient dari primaryBlue ke primaryBlueDark)

## 2. Typography (core)
> File: `lib/core/themes/app_typography.dart`

- Font: `Plus Jakarta Sans` via `google_fonts` package.
- Heading utama:
  - `displayLarge`: 48 / bold (untuk amount besar)
  - `headlineLarge`: 32 / bold (h1)
  - `headlineMedium`: 24 / bold (h2)
  - `headlineSmall`: 20 / semibold (h3)
- Body:
  - `bodyLarge`: 16 / medium
  - `bodyMedium`: 14 / regular
  - `bodySmall`: 12 / regular
- Labels:
  - `labelLarge`: 14 / semibold
  - `labelMedium`: 12 / medium
  - `labelSmall`: 10 / medium
- Custom styles: `displayAmount`, `amountLarge`, `amountMedium`

## 3. Spacing & Radius
> File: `lib/core/themes/app_spacing.dart`

**AppSpacing** (base 4px):
- `xs = 4`, `sm = 8`, `md = 12`, `lg = 16`, `xl = 24`, `xxl = 32`
- `paddingScreen = 24`, `paddingCard = 20`
- Helper: `AppSpacing.screenPadding`, `AppSpacing.cardPadding`, `AppSpacing.horizontalPadding`

**AppRadius**:
- `small = 12`, `medium = 16`, `large = 20`, `card = 24`, `button = 24`, `full = 999`
- Helper: `AppRadius.smallRadius`, `AppRadius.cardRadius`, etc.

**AppShadow**:
- `cardShadow`: subtle shadow untuk cards
- `buttonShadow`: primary button shadow dengan hint biru

## 4. Komponen Inti (pola)
- Primary Button: tinggi 56, radius 24, gradient biru (2196F3 → 1976D2), shadow ringan; state: default, pressed (scale 0.97), disabled (opacity 0.5).
- Text Input: tinggi 56, radius 16, border abu (#E5E7EB) → biru saat fokus, merah saat error.
- Transaction Card: card putih, radius 16, shadow ringan, kiri icon dalam container 48×48 dengan bg kategori, kanan teks dan amount (merah untuk expense, hijau untuk income).
- Bottom Nav: tinggi ±80, background putih, top radius 32, icon + label kecil; item aktif pakai primaryBlue.

## 5. ThemeData (ringkas)
> File: `lib/core/themes/app_theme.dart`

- Pakai `useMaterial3: false` (untuk kontrol lebih).
- `primaryColor`: `AppColors.primaryBlue`
- `scaffoldBackgroundColor`: `Colors.white`
- `textTheme`: `GoogleFonts.plusJakartaSansTextTheme()`
- `elevatedButtonTheme`: min height 56, StadiumBorder shape
- `inputDecorationTheme`: filled, radius 30, borderless
- `appBarTheme`: primaryBlue background, white foreground, no elevation

## 6. Import & Usage
```dart
// Barrel import
import 'package:cash_vit/core/themes/index.dart';

// Direct imports
import 'package:cash_vit/core/themes/app_colors.dart';
import 'package:cash_vit/core/themes/app_typography.dart';
import 'package:cash_vit/core/themes/app_spacing.dart';

// Usage examples
AppColors.primaryBlue
AppTypography.textTheme.headlineLarge
AppSpacing.screenPadding
AppRadius.cardRadius
AppShadow.cardShadow
```

Cukup implement bagian ini dulu; detail lain seperti animasi kompleks, micro‑interaction, responsive breakpoints, dan checklist bisa ditambahkan belakangan jika diperlukan.
