# Product Requirements Document

## Expense Tracker Mobile App

---

## 1. Overview

**Aplikasi:** Expense Tracker dengan autentikasi  
**Platform:** Flutter Mobile  
**State Management:** Riverpod  
**API:** FakeStore API (https://fakestoreapi.com)  
**Storage:** In-Memory only

---

## 2. Features

### 2.1 Authentication

- Login dengan username & password
- Tampilkan data user setelah login
- Logout (clear state)

**API Endpoints:**

- `POST /auth/login` - Login
- `GET /users/{id}` - Get user data
- `DELETE /users/{id}` - Logout simulation

### 2.2 Expense Management

- Lihat daftar expense/income
- Tambah expense/income baru
- Edit expense/income
- Delete expense/income
- Tampilkan total balance

**Data disimpan:** In-memory (hilang saat app restart)

---

## 3. Screens

### Screen 1: Login

- Username field
- Password field
- Login button
- Loading indicator
- Error message display

### Screen 2: Expense List

- User info di header
- Balance summary (Total Income, Total Expense, Balance)
- List expenses
- FAB button untuk add
- Logout button

### Screen 3: Expense Form

- Title field
- Amount field
- Type selector (Income/Expense)
- Date picker
- Save button

---

## 4. Data Models

### User

```dart
- id: int
- username: string
- email: string
- name: string
```

### Expense

```dart
- id: string
- title: string
- amount: double
- type: enum (income/expense)
- date: DateTime
- userId: int
```

---

## 5. Animations (Required)

1. **Hero Animation:** User avatar dari login ke expense list
2. **Page Transition:** Slide animation untuk form screen
3. **Micro-interactions:**
   - FAB scale animation on tap
   - List item fade-in
   - Form field focus animation
   - Swipe to delete gesture

---

## 6. Folder Structure (Clean Architecture)

```
lib/
├── main.dart                           # App entry point with ProviderScope
│
├── core/                               # Shared infrastructure (app-wide)
│   ├── AGENTS.md                       # AI agent instructions for core layer
│   ├── constants/
│   │   └── api_constants.dart          # API endpoints, timeouts
│   ├── services/
│   │   └── api_services.dart           # Dio-based HTTP client
│   ├── themes/                         # Design system implementation
│   │   ├── app_colors.dart
│   │   ├── app_typography.dart
│   │   ├── app_spacing.dart
│   │   ├── app_theme.dart
│   │   └── index.dart                  # Barrel export
│   └── utils/
│       └── currency_formatter.dart     # Number formatting utilities
│
├── features/                           # Feature modules (Clean Architecture)
│   ├── AGENTS.md                       # AI agent instructions for features
│   │
│   ├── auth/                           # Authentication feature
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── auth_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── auth_response_model.dart
│   │   │   └── repository/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── auth_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── login_usecase.dart
│   │   │       └── logout_usecase.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   ├── auth_provider.dart
│   │       │   └── auth_provider.g.dart
│   │       ├── screens/
│   │       │   └── login_screen.dart
│   │       └── widgets/
│   │           ├── forgot_password_link.dart
│   │           ├── index.dart
│   │           ├── login_button.dart
│   │           ├── login_header.dart
│   │           ├── login_text_field.dart
│   │           └── sign_up_link.dart
│   │
│   ├── splash_screen/                  # Splash screen feature
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── providers/
│   │       │   ├── splash_provider.dart
│   │       │   └── splash_provider.g.dart
│   │       ├── screens/
│   │       │   └── splash_screen.dart
│   │       └── widgets/
│   │           ├── footer_content.dart
│   │           └── logo_brand.dart
│   │
│   ├── base/                           # Tab navigation shell
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── providers/
│   │       ├── screens/
│   │       │   └── base_screen.dart    # IndexedStack + BottomNav
│   │       └── widgets/
│   │           └── custom_bottom_nav.dart
│   │
│   ├── home_dashboard/                 # Home/Dashboard feature
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   │   └── expense_model.dart
│   │   │   └── repository/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── providers/
│   │       │   ├── transaction_provider.dart
│   │       │   └── transaction_provider.g.dart
│   │       ├── screens/
│   │       │   └── home_dashboard_screen.dart
│   │       └── widgets/
│   │           ├── filter_chips.dart
│   │           ├── home_balance_card.dart
│   │           ├── home_header.dart
│   │           └── recent_transactions_list.dart
│   │
│   ├── add_transaction/                # Add transaction feature
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── providers/
│   │       ├── screens/
│   │       │   └── add_transaction_screen.dart
│   │       └── widgets/
│   │           ├── add_transaction_actions.dart
│   │           ├── add_transaction_header.dart
│   │           ├── amount_input_card.dart
│   │           ├── category_selector.dart
│   │           ├── expense_type_selector.dart
│   │           ├── payment_method_selector.dart
│   │           ├── success_dialog.dart
│   │           └── title_input_card.dart
│   │
│   └── profile/                        # User profile feature
│       ├── data/
│       │   ├── datasources/
│       │   │   └── profile_remote_datasource.dart
│       │   ├── models/
│       │   │   └── user_response_model.dart
│       │   └── repository/
│       │       └── profile_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── profile_entity.dart
│       │   ├── repositories/
│       │   │   └── profile_repository.dart
│       │   └── usecases/
│       │       └── get_profile_usecase.dart
│       └── presentation/
│           ├── providers/
│           │   ├── profile_provider.dart
│           │   └── profile_provider.g.dart
│           ├── screens/
│           │   └── profile_screen.dart
│           └── widgets/
│               ├── logout_button.dart
│               ├── profile_avatar_info.dart
│               ├── profile_header.dart
│               ├── profile_menu_tile.dart
│               ├── profile_section_title.dart
│               └── profile_stat_card.dart
│
└── shared/                             # Cross-feature shared code
    ├── AGENTS.md                       # AI agent instructions for shared
    ├── extensions/                     # Dart extensions
    │   └── currency_extension.dart
    └── widgets/                        # Reusable UI components
        └── background_glows.dart
```

**Architecture Principles:**

- **Clean Architecture** per feature: data → domain → presentation layers
- **Feature-first organization**: Each feature is self-contained module
- **Dependency Rule**: Presentation depends on Domain, Domain is independent
- **Riverpod providers** in `presentation/providers/` per feature
- **Shared infrastructure** in `core/` (services, themes, constants, utils)
- **Cross-feature widgets** in `shared/widgets/`
- **AGENTS.md files** in key directories for AI agent context

---

## 7. Technical Requirements

### Must Have

- Riverpod untuk state management
- HTTP client untuk API calls
- Form validation
- Error handling untuk network failures
- Loading states
- Material Design widgets

- Title: required, max 50 characters
- Amount: required, > 0

---

## 8. User Flows

### Login Flow

```
1. Input username & password
2. Tap login → Show loading
3. API call POST /auth/login
4. Success → Navigate to Expense List
5. Error → Show error message
```

### Add Expense Flow

```
1. Tap FAB di Expense List
2. Form screen slides up
3. Fill form → Tap save
4. Validate input
5. Success → Add to list, navigate back
6. Error → Show error message
```

### Delete Flow

```
1. Swipe expense card
2. Show confirmation dialog
3. Confirm → Delete from list
4. Cancel → Dismiss dialog
```

---

## 9. Acceptance Criteria

**Functional:**

- ✓ Login dengan API berhasil
- ✓ Display user data
- ✓ CRUD expense (Create, Read, Update, Delete)
- ✓ Calculate balance correctly
- ✓ Logout clear state

**Technical:**

- ✓ 3 screens implemented
- ✓ 3 API endpoints hit (POST, GET, DELETE)
- ✓ Riverpod digunakan
- ✓ Hero animation implemented
- ✓ Min 3 micro-interactions
- ✓ Code terstruktur & clean
- ✓ README.md ada

---

## 10. README.md Structure

```markdown
# Expense Tracker App

## Fitur

- Login/Logout
- Manage Expenses & Income
- Balance Summary

## Tech Stack

- Flutter
- Riverpod
- FakeStore API

## Folder Structure

[Penjelasan folder]

## How to Run

[Setup steps]

## API Endpoints

[List endpoints used]

## Limitations

- Data in-memory only
- FakeStore API constraints
```

---

## 11. Test Credentials

```
Username: johnd
Password: m38rmF$
```

---

## 12. Out of Scope

- Persistent database
- Real backend
- Export data
- Analytics
- Multi-language
- Dark mode

---

**Estimation:** 8-10 jam development  
**Version:** 1.1  
**Last Updated:** 2026-01-16
