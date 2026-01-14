# Design System Singkat – Expense Tracker (Flutter)

## 1. Colors (core)
- Primary: `primaryBlue = #2196F3`, `primaryBlueDark = #1976D2`, `accentBlue = #64B5F6`
- Semantic: `incomeGreen = #4CAF50`, `expenseRed = #EF5350`, `warningOrange = #FF9800`
- Background & text utama secukupnya:
  - `backgroundLight = #F5F7FA`, `surfaceWhite = #FFFFFF`
  - `textPrimary = #1A1D1F`, `textSecondary = #6B7280`
- Category pakai soft‑bg (contoh: food, salary, entertainment, fuel, shopping) sesuai kebutuhan.

## 2. Typography (core)
- Font: `Plus Jakarta Sans` (fallback ke font sistem).
- Heading utama:
  - `h1`: 32 / bold
  - `h2`: 24 / bold
  - `h3`: 20 / semibold
- Body:
  - `bodyLarge`: 16 / medium
  - `bodyMedium`: 14 / regular
  - `bodySmall`: 12 / regular
- Amount besar: `displayAmount`: 48 / bold.

## 3. Spacing & Radius
- Base spacing 4 px: gunakan 8, 12, 16, 24, 32 sebagai jarak standar.
- Contoh: `paddingScreen = 24`, `paddingCard = 20`, `spacingListItem = 16`.
- Radius utama:
  - `12` (small), `16` (medium), `20–24` (card/button), `full` untuk circle/FAB.

## 4. Komponen Inti (pola)
- Primary Button: tinggi 56, radius 24, gradient biru (2196F3 → 1976D2), shadow ringan; state: default, pressed (scale 0.97), disabled (opacity 0.5).
- Text Input: tinggi 56, radius 16, border abu (#E5E7EB) → biru saat fokus, merah saat error.
- Transaction Card: card putih, radius 16, shadow ringan, kiri icon dalam container 48×48 dengan bg kategori, kanan teks dan amount (merah untuk expense, hijau untuk income).
- Bottom Nav: tinggi ±80, background putih, top radius 32, icon + label kecil; item aktif pakai primaryBlue.

## 5. ThemeData (ringkas)
- Pakai `useMaterial3: true`.
- Set `primaryColor` & `colorScheme.primary` ke `primaryBlue`, `background` ke `backgroundLight`, `surface` ke `surfaceWhite`, `error` ke `expenseRed`.
- `textTheme` mapping ke `h1, h2, h3, bodyLarge, bodyMedium, bodySmall`.
- `elevatedButtonTheme`: min height 56, radius 24.
- `inputDecorationTheme`: filled, radius 16, border abu saat normal, biru saat fokus.

Cukup implement bagian ini dulu; detail lain seperti animasi kompleks, micro‑interaction, responsive breakpoints, dan checklist bisa ditambahkan belakangan jika diperlukan.
