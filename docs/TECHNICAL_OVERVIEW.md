# TECHNICAL OVERVIEW: Riverpod Authentication Implementation

## Executive Summary

This document provides a comprehensive technical overview of a production-ready authentication system implemented using Riverpod state management in Flutter. The implementation follows clean architecture principles with clear separation of concerns across multiple layers.

**Target Audience**: Senior Developers, Technical Reviewers, New Team Members, AI Agents

**Key Technologies**: Flutter, Riverpod 2.4.9, Dart 3.0+

---

## Architecture Overview

### High-Level Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                        USER INTERFACE                        │
│       features/*/presentation/screens/*_screen.dart          │
│  (login_screen.dart, home_dashboard_screen.dart, etc.)      │
└────────────────────┬────────────────────────────────────────┘
                     │ ref.watch() / ref.read() / ref.listen()
                     ↓
┌─────────────────────────────────────────────────────────────┐
│                    STATE MANAGEMENT LAYER                    │
│         features/*/presentation/providers/*_provider.dart    │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ @riverpod Notifier with sealed class states          │  │
│  │   - Exposes: AuthState, SplashState (sealed classes) │  │
│  │   - Manages: Feature state & business logic          │  │
│  └──────────────────────────────────────────────────────┘  │
└────────────────────┬────────────────────────────────────────┘
                     │ Method calls
                     ↓
┌─────────────────────────────────────────────────────────────┐
│                     REPOSITORY LAYER                         │
│            features/*/data/repository/*_repository.dart      │
│  - Handles API communication via core/services/api_services │
│  - Implements data transformation                            │
│  - Returns domain models or primitives                       │
└────────────────────┬────────────────────────────────────────┘
                     │ HTTP/API calls (Dio)
                     ↓
┌─────────────────────────────────────────────────────────────┐
│                      EXTERNAL API                            │
│              FakeStore API (fakestoreapi.com)               │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                      DATA MODELS LAYER                       │
│              features/*/data/models/*_model.dart             │
│  - Immutable data structures (User, Expense)                 │
│  - Type-safe state representations                           │
│  - JSON serialization (fromJson/toJson)                      │
│  - copyWith for immutable updates                            │
└─────────────────────────────────────────────────────────────┘
```

### Layer Responsibilities

| Layer | Location | Primary Responsibility | Key Concepts |
|-------|----------|----------------------|--------------|
| **Entities** | `features/*/domain/entities/` | Pure business objects | Immutability, No dependencies |
| **Repositories (Interface)** | `features/*/domain/repositories/` | Define data contracts | Abstract class, Domain-level API |
| **Use Cases** | `features/*/domain/usecases/` | Single business actions | Business validation, Orchestration |
| **Models** | `features/*/data/models/` | DTOs for API/DB | JSON serialization, Model-to-Entity |
| **Data Sources** | `features/*/data/datasources/` | API/Database calls | Remote/Local data access |
| **Repository (Impl)** | `features/*/data/repository/` | Implement domain contract | Data transformation, Caching |
| **Providers** | `features/*/presentation/providers/` | State management | @riverpod Notifier, Sealed states |
| **Screens** | `features/*/presentation/screens/` | Full page widgets | ConsumerWidget, Navigation |
| **Widgets** | `features/*/presentation/widgets/` | Reusable UI components | Stateless, Data via constructor |
| **Core Services** | `core/services/` | API client & infrastructure | Dio client, HTTP abstraction |
| **Core Themes** | `core/themes/` | Design system | Colors, Typography, Spacing |
| **Core Utils** | `core/utils/` | Utility functions | Formatters, Helpers |
| **Core Constants** | `core/constants/` | App-wide constants | API URLs, Configuration |
| **Shared Widgets** | `shared/widgets/` | Cross-feature widgets | Background effects, Common UI |
| **Shared Extensions** | `shared/extensions/` | Dart extensions | Currency formatting |

---

## Core Components Deep Dive

### 1. Data Models Layer

#### 1.1 User Model (`features/profile/data/models/user_response_model.dart`)

**Purpose**: Represents authenticated user data throughout the application.

**Key Features**:
- Immutable data structure
- JSON serialization/deserialization support
- `copyWith` method for creating modified copies

**Implementation Pattern**:
```dart
class User {
  final String id;
  final String email;
  final String name;
  final String? token;
  
  // Immutable constructor
  User({required this.id, required this.email, required this.name, this.token});
  
  // Factory constructor for JSON parsing (API responses)
  factory User.fromJson(Map<String, dynamic> json) { ... }
  
  // Serialization for storage/transmission
  Map<String, dynamic> toJson() { ... }
  
  // Immutable updates via copyWith pattern
  User copyWith({String? id, String? email, String? name, String? token}) { ... }
}
```

**Why Immutability**: Prevents accidental state mutations, enables time-travel debugging, makes state changes predictable and traceable.

#### 1.2 Authentication State (in `features/auth/presentation/providers/auth_provider.dart`)

**Purpose**: Type-safe representation of all possible authentication states.

**Implementation Pattern**: Sealed Class Hierarchy
```dart
sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState { }        // App just started
class AuthLoading extends AuthState { }        // Processing authentication
class AuthAuthenticated extends AuthState {    // User successfully authenticated
  final User user;
  const AuthAuthenticated(this.user);
}
class AuthUnauthenticated extends AuthState { } // No authenticated user
class AuthError extends AuthState {             // Authentication failed
  final String message;
  const AuthError(this.message);
}
```

**Why Sealed Classes**: 
- Compile-time exhaustiveness checking (must handle all cases)
- Pattern matching support
- Clear state transitions
- Prevents invalid states

**State Transition Diagram**:
```
AuthInitial
    ↓ (checkAuthStatus called)
AuthLoading
    ↓
    ├─→ AuthAuthenticated (token valid)
    └─→ AuthUnauthenticated (no token)

AuthUnauthenticated
    ↓ (user triggers login)
AuthLoading
    ↓
    ├─→ AuthAuthenticated (login success)
    └─→ AuthError (login failed)
            ↓ (after 3 seconds)
        AuthUnauthenticated

AuthAuthenticated
    ↓ (user triggers logout)
AuthLoading
    ↓
AuthUnauthenticated
```

---

### 2. Repository Layer

#### AuthRepository (`features/auth/data/repository/auth_repository.dart`)

**Purpose**: Abstraction layer for all authentication-related external operations.

**Key Responsibilities**:
1. API communication (HTTP requests)
2. Data transformation (JSON ↔ Domain Models)
3. Error handling and validation
4. Business rule enforcement

**Public API**:
```dart
class AuthRepository {
  // Authenticate user with credentials
  Future<User> login({required String email, required String password});
  
  // Terminate user session
  Future<void> logout();
  
  // Retrieve currently authenticated user (from saved token)
  Future<User?> getCurrentUser();
  
  // Create new user account
  Future<User> register({required String email, required String password, required String name});
}
```

**Error Handling Strategy**:
- Throws exceptions for all error cases
- Caller (AuthNotifier) responsible for catching and state management
- Specific exception messages for different failure scenarios

**Current Implementation**: Simulated network delays and mock responses
**Production Upgrade Path**: Replace simulation with actual HTTP client (http/dio package)

```dart
// Production implementation example
Future<User> login({required String email, required String password}) async {
  final response = await http.post(
    Uri.parse('$baseUrl/auth/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );
  
  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Login failed: ${response.body}');
  }
}
```

**Design Benefits**:
- UI layer never directly touches API logic
- Easy to mock for testing
- Can swap implementations (REST → GraphQL) without UI changes
- Centralized error handling and retry logic

---

### 3. Provider Layer (State Management Core)

#### Auth Provider (`features/auth/presentation/providers/auth_provider.dart`)

**Purpose**: Central state management hub for authentication flow.

**Components**:

##### 3.1 Repository Provider
```dart
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});
```
- **Type**: `Provider` (for immutable dependencies)
- **Lifecycle**: Created once, never changes
- **Purpose**: Dependency injection for repository

##### 3.2 Auth Notifier Provider
```dart
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});
```
- **Type**: `StateNotifierProvider` (for mutable state)
- **State Type**: `AuthState` (sealed class)
- **Notifier Type**: `AuthNotifier` (state management logic)
- **Dependency**: Watches `authRepositoryProvider`

##### 3.3 AuthNotifier Class

**Inheritance**: `StateNotifier<AuthState>`

**Core Concept**: 
- Extends `StateNotifier` to manage authentication state
- Exposes methods for state transitions
- Notifies all listeners when state changes
- Immutable state updates only

**Public API**:
```dart
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  
  AuthNotifier(this._repository) : super(const AuthInitial()) {
    checkAuthStatus(); // Auto-check on initialization
  }
  
  Future<void> checkAuthStatus();  // Check saved session on app start
  Future<void> login({required String email, required String password});
  Future<void> logout();
  Future<void> register({required String email, required String password, required String name});
}
```

**State Update Pattern**:
```dart
Future<void> login({required String email, required String password}) async {
  // STEP 1: Set loading state
  state = const AuthLoading();
  
  try {
    // STEP 2: Perform async operation
    final user = await _repository.login(email: email, password: password);
    
    // STEP 3: Update to success state
    state = AuthAuthenticated(user);
    
  } catch (e) {
    // STEP 4: Handle error state
    state = AuthError(e.toString());
    
    // STEP 5: Auto-recovery after delay
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        state = const AuthUnauthenticated();
      }
    });
  }
}
```

**Key Implementation Details**:

1. **Automatic Session Check**:
   - Constructor calls `checkAuthStatus()` immediately
   - Checks for saved token/session on app launch
   - Sets appropriate initial state

2. **Error Recovery**:
   - Error states automatically reset to unauthenticated after 3 seconds
   - Prevents users from getting stuck in error state
   - Uses `mounted` check to prevent memory leaks

3. **State Immutability**:
   - Never mutates state directly
   - Always assigns new state instance
   - Riverpod handles notification and cleanup

---

### 4. UI Layer

#### 4.1 Main Entry Point (`main.dart`)

**Key Components**:

##### ProviderScope (Required Root Widget)
```dart
void main() {
  runApp(
    const ProviderScope(  // CRITICAL: Must wrap entire app
      child: MyApp(),
    ),
  );
}
```
**Purpose**: Container for all Riverpod providers
**Scope**: Application-wide
**Consequence of Omission**: Runtime crash when accessing providers

##### AuthGate Pattern (Declarative Navigation)
```dart
class AuthGate extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    
    return switch (authState) {
      AuthInitial() || AuthLoading() => LoadingScreen(),
      AuthAuthenticated() => HomeScreen(),
      AuthUnauthenticated() || AuthError() => LoginScreen(),
    };
  }
}
```

**Design Benefits**:
- Single source of truth for navigation
- No manual navigation calls needed
- Type-safe routing (exhaustive pattern matching)
- Automatic screen transitions on state change
- Impossible to show wrong screen for given state

**Flow Diagram**:
```
App Launch
    ↓
ProviderScope initialized
    ↓
authNotifierProvider created
    ↓
AuthNotifier constructor runs
    ↓
checkAuthStatus() called
    ↓
state = AuthLoading
    ↓
AuthGate renders LoadingScreen
    ↓
getCurrentUser() completes
    ↓
    ├─→ state = AuthAuthenticated → AuthGate renders HomeScreen
    └─→ state = AuthUnauthenticated → AuthGate renders LoginScreen
```

#### 4.2 Login Screen (`features/auth/presentation/screens/login_screen.dart`)

**Widget Type**: `ConsumerWidget` (provides WidgetRef)

**Key Concepts**:

##### ref.watch() - Subscribe to State
```dart
final authState = ref.watch(authNotifierProvider);
```
- **Purpose**: Subscribe to provider and rebuild on state changes
- **Use Case**: Rendering UI based on current state
- **Behavior**: Widget rebuilds when watched provider emits new state
- **Location**: Inside `build()` method only

##### ref.read() - One-time Access (Actions)
```dart
ref.read(authNotifierProvider.notifier).login(email: email, password: password);
```
- **Purpose**: Access provider without subscribing
- **Use Case**: Triggering actions (button callbacks, event handlers)
- **Behavior**: No rebuild when provider changes
- **Location**: Event handlers (onPressed, onTap, callbacks)
- **Critical**: `.notifier` suffix accesses AuthNotifier instance, not state

##### ref.listen() - Side Effects
```dart
ref.listen<AuthState>(authNotifierProvider, (previous, next) {
  if (next is AuthError) {
    showDialog(...); // Side effect
  }
  if (next is AuthAuthenticated) {
    showSnackBar(...); // Side effect
  }
});
```
- **Purpose**: React to state changes with side effects
- **Use Case**: Dialogs, snackbars, navigation, analytics
- **Behavior**: Callback executes on each state change
- **No Rebuild**: Does not cause widget rebuild

**Critical Pattern Distinctions**:
| Method | Subscribe? | Rebuild? | Use Case | Location |
|--------|-----------|----------|----------|----------|
| `ref.watch()` | Yes | Yes | Render based on state | `build()` method |
| `ref.read()` | No | No | Trigger actions | Event handlers |
| `ref.listen()` | Yes | No | Side effects | `build()` method (top level) |

**Common Pitfall**:
```dart
// ❌ WRONG - Causes infinite rebuild loop
ElevatedButton(
  onPressed: () {
    final notifier = ref.watch(authNotifierProvider.notifier); // DON'T DO THIS
    notifier.login(...);
  },
)

// ✅ CORRECT - One-time access for action
ElevatedButton(
  onPressed: () {
    ref.read(authNotifierProvider.notifier).login(...);
  },
)
```

**UI State Handling**:
```dart
// Disable input during loading
enabled: authState is! AuthLoading,

// Conditional button content
child: authState is AuthLoading
  ? CircularProgressIndicator()
  : Text('Login'),

// Conditional button enable
onPressed: authState is AuthLoading ? null : () { ... },
```

#### 4.3 Home Screen (`features/home_dashboard/presentation/screens/home_dashboard_screen.dart`)

**Purpose**: Post-authentication screen demonstrating:
- Safe data extraction from authenticated state
- User profile display
- Logout flow with confirmation

**Pattern Matching for Data Extraction**:
```dart
final authState = ref.watch(authNotifierProvider);
final user = authState is AuthAuthenticated ? authState.user : null;
```

---

## Complete Flow Examples

### Flow 1: App Launch (Cold Start)

```
1. main() executes
   └─→ ProviderScope created

2. MyApp widget builds
   └─→ AuthGate (ConsumerWidget) builds

3. AuthGate calls ref.watch(authNotifierProvider)
   └─→ authNotifierProvider created (first access)
       └─→ AuthNotifier constructor runs
           ├─→ state = AuthInitial (super constructor)
           └─→ checkAuthStatus() called

4. checkAuthStatus() executes
   ├─→ state = AuthLoading
   │   └─→ AuthGate rebuilds → Shows LoadingScreen
   │
   └─→ await _repository.getCurrentUser()
       │
       ├─→ Success: Returns User object
       │   ├─→ state = AuthAuthenticated(user)
       │   └─→ AuthGate rebuilds → Shows HomeScreen
       │
       └─→ No token: Returns null
           ├─→ state = AuthUnauthenticated
           └─→ AuthGate rebuilds → Shows LoginScreen
```

### Flow 2: User Login Attempt

```
1. User enters email/password in LoginScreen
   └─→ User taps "Login" button

2. onPressed callback executes
   └─→ ref.read(authNotifierProvider.notifier).login(email, password)

3. AuthNotifier.login() executes
   ├─→ state = AuthLoading
   │   └─→ LoginScreen rebuilds
   │       ├─→ Button disabled
   │       └─→ Shows CircularProgressIndicator
   │
   └─→ await _repository.login(email, password)
       │
       ├─→ SUCCESS SCENARIO
       │   ├─→ Repository returns User object
       │   ├─→ state = AuthAuthenticated(user)
       │   ├─→ LoginScreen rebuilds
       │   ├─→ AuthGate detects AuthAuthenticated state
       │   ├─→ AuthGate rebuilds → Shows HomeScreen
       │   └─→ ref.listen() callback executes → Shows success SnackBar
       │
       └─→ ERROR SCENARIO
           ├─→ Repository throws Exception
           ├─→ catch block executes
           ├─→ state = AuthError(message)
           ├─→ LoginScreen rebuilds (button enabled again)
           ├─→ ref.listen() callback executes → Shows error Dialog
           └─→ After 3 seconds:
               └─→ state = AuthUnauthenticated
                   └─→ LoginScreen rebuilds (ready for retry)
```

### Flow 3: User Logout

```
1. User taps logout button in HomeScreen
   └─→ Confirmation dialog appears (showDialog)

2. User confirms logout
   └─→ ref.read(authNotifierProvider.notifier).logout()

3. AuthNotifier.logout() executes
   ├─→ state = AuthLoading
   │   └─→ HomeScreen rebuilds (could show loading overlay)
   │
   └─→ await _repository.logout()
       │
       └─→ Completes (success or error, doesn't matter)
           ├─→ state = AuthUnauthenticated
           ├─→ HomeScreen rebuilds
           ├─→ AuthGate detects AuthUnauthenticated state
           └─→ AuthGate rebuilds → Shows LoginScreen
```

---

## State Management Best Practices

### 1. Provider Design Patterns

#### When to Use Each Provider Type

| Provider Type | Use Case | Example |
|--------------|----------|---------|
| `Provider` | Immutable dependencies, services | Repository, API client, Logger |
| `StateProvider` | Simple mutable state (single value) | Theme mode, selected tab index |
| `StateNotifierProvider` | Complex state with business logic | Authentication, shopping cart |
| `FutureProvider` | Async data loading | Fetch user profile on init |
| `StreamProvider` | Realtime data streams | Firestore listeners, WebSocket |

#### Provider Dependency Injection
```dart
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider); // Dependency injection
  return AuthNotifier(repository);
});
```

**Benefits**:
- Testable (can mock dependencies)
- Loosely coupled (swap implementations easily)
- Automatic lifecycle management

### 2. State Update Principles

#### Immutability is Mandatory
```dart
// ❌ WRONG - Mutating state
state.user.name = "New Name";

// ✅ CORRECT - Creating new state
state = AuthAuthenticated(state.user.copyWith(name: "New Name"));
```

#### Single State Assignment
```dart
// ❌ WRONG - Multiple rapid assignments
state = AuthLoading();
state = AuthAuthenticated(user); // Previous state skipped

// ✅ CORRECT - Use intermediate states intentionally
state = AuthLoading();
await Future.delayed(Duration(seconds: 2)); // Actual async work
state = AuthAuthenticated(user);
```

### 3. Error Handling Strategy

#### Repository Level
- Throw exceptions for all error cases
- Provide meaningful error messages
- Don't catch errors here (let caller handle)

#### Provider Level (AuthNotifier)
- Catch repository exceptions
- Convert to AuthError state
- Implement recovery logic (auto-reset)

#### UI Level
- Display user-friendly error messages
- Use `ref.listen()` for error dialogs/snackbars
- Provide retry mechanisms

---

## Testing Strategy

### Unit Testing Providers

```dart
void main() {
  test('login should update state to authenticated on success', () async {
    // Setup
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(MockAuthRepository()),
      ],
    );
    
    // Execute
    await container.read(authNotifierProvider.notifier).login(
      email: 'test@example.com',
      password: 'password123',
    );
    
    // Verify
    final state = container.read(authNotifierProvider);
    expect(state, isA<AuthAuthenticated>());
    expect((state as AuthAuthenticated).user.email, 'test@example.com');
    
    // Cleanup
    container.dispose();
  });
}
```

### Widget Testing with Providers

```dart
testWidgets('login screen should show loading indicator during login', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(MockAuthRepository()),
      ],
      child: MaterialApp(home: LoginScreen()),
    ),
  );
  
  // Enter credentials
  await tester.enterText(find.byType(TextField).first, 'test@example.com');
  await tester.enterText(find.byType(TextField).last, 'password');
  
  // Tap login
  await tester.tap(find.text('Login'));
  await tester.pump(); // Trigger rebuild
  
  // Verify loading state
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
});
```

---

## Production Readiness Checklist

### Security
- [ ] Use HTTPS for all API calls
- [ ] Store tokens in secure storage (flutter_secure_storage)
- [ ] Implement token refresh mechanism
- [ ] Add request signing/authentication headers
- [ ] Implement certificate pinning for sensitive data

### Error Handling
- [ ] Network error handling (timeout, no connection)
- [ ] API error parsing (4xx, 5xx responses)
- [ ] User-friendly error messages
- [ ] Error logging and reporting (Sentry, Firebase Crashlytics)

### Performance
- [ ] Implement token caching
- [ ] Add request debouncing for rapid actions
- [ ] Optimize state update frequency
- [ ] Profile and reduce unnecessary rebuilds

### User Experience
- [ ] Add form validation
- [ ] Implement biometric authentication option
- [ ] Add "Remember Me" functionality
- [ ] Implement password reset flow
- [ ] Add loading states for all async operations

### Code Quality
- [ ] Write unit tests for all providers
- [ ] Write widget tests for critical flows
- [ ] Add integration tests
- [ ] Document public APIs
- [ ] Set up CI/CD pipeline

---

## Migration and Scaling Patterns

### Adding New Authentication Methods

To add OAuth/Social login:

```dart
// 1. Extend repository
class AuthRepository {
  Future<User> loginWithGoogle() async { ... }
  Future<User> loginWithApple() async { ... }
}

// 2. Add methods to AuthNotifier
class AuthNotifier extends StateNotifier<AuthState> {
  Future<void> loginWithGoogle() async {
    state = const AuthLoading();
    try {
      final user = await _repository.loginWithGoogle();
      state = AuthAuthenticated(user);
    } catch (e) {
      state = AuthError(e.toString());
    }
  }
}

// 3. Add UI button
ElevatedButton(
  onPressed: () => ref.read(authNotifierProvider.notifier).loginWithGoogle(),
  child: Text('Login with Google'),
)
```

### Multi-State Applications (Clean Architecture)

For apps with multiple independent state domains (current structure):

```
lib/
├── main.dart
├── core/
│   ├── AGENTS.md
│   ├── constants/
│   │   └── api_constants.dart
│   ├── services/
│   │   └── api_services.dart
│   ├── themes/
│   │   ├── app_colors.dart
│   │   ├── app_spacing.dart
│   │   ├── app_theme.dart
│   │   ├── app_typography.dart
│   │   └── index.dart
│   └── utils/
│       └── currency_formatter.dart
├── features/
│   ├── AGENTS.md
│   ├── add_transaction/
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
│   ├── auth/
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
│   ├── base/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── providers/
│   │       ├── screens/
│   │       │   └── base_screen.dart
│   │       └── widgets/
│   │           └── custom_bottom_nav.dart
│   ├── home_dashboard/
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
│   ├── profile/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── profile_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── user_response_model.dart
│   │   │   └── repository/
│   │   │       └── profile_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── profile_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── profile_repository.dart
│   │   │   └── usecases/
│   │   │       └── get_profile_usecase.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   ├── profile_provider.dart
│   │       │   └── profile_provider.g.dart
│   │       ├── screens/
│   │       │   └── profile_screen.dart
│   │       └── widgets/
│   │           ├── logout_button.dart
│   │           ├── profile_avatar_info.dart
│   │           ├── profile_header.dart
│   │           ├── profile_menu_tile.dart
│   │           ├── profile_section_title.dart
│   │           └── profile_stat_card.dart
│   └── splash_screen/
│       ├── data/
│       ├── domain/
│       └── presentation/
│           ├── providers/
│           │   ├── splash_provider.dart
│           │   └── splash_provider.g.dart
│           ├── screens/
│           │   └── splash_screen.dart
│           └── widgets/
│               ├── footer_content.dart
│               └── logo_brand.dart
└── shared/
    ├── AGENTS.md
    ├── extensions/
    │   └── currency_extension.dart
    └── widgets/
        └── background_glows.dart
```

Each feature has its own state management, but can access shared providers:

```dart
final profileNotifierProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  final authState = ref.watch(authNotifierProvider); // Access auth state
  final repository = ref.watch(profileRepositoryProvider);
  return ProfileNotifier(repository, authState);
});
```

---

## Common Pitfalls and Solutions

### 1. Infinite Rebuild Loop

**Problem**: Using `ref.watch()` inside event handler
```dart
// ❌ WRONG
onPressed: () {
  ref.watch(authNotifierProvider.notifier).login(...); // Causes rebuild loop
}
```

**Solution**: Use `ref.read()` for actions
```dart
// ✅ CORRECT
onPressed: () {
  ref.read(authNotifierProvider.notifier).login(...);
}
```

### 2. State Not Updating

**Problem**: Mutating state directly
```dart
// ❌ WRONG
state.user.name = "New Name"; // Does not notify listeners
```

**Solution**: Assign new state instance
```dart
// ✅ CORRECT
state = AuthAuthenticated(state.user.copyWith(name: "New Name"));
```

### 3. Memory Leaks

**Problem**: Not checking `mounted` before delayed state updates
```dart
// ❌ RISKY
Future.delayed(Duration(seconds: 3), () {
  state = AuthUnauthenticated(); // Might crash if notifier disposed
});
```

**Solution**: Check `mounted` property
```dart
// ✅ SAFE
Future.delayed(Duration(seconds: 3), () {
  if (mounted) {
    state = AuthUnauthenticated();
  }
});
```

### 4. Provider Not Found

**Problem**: Forgetting ProviderScope
```dart
// ❌ WRONG
void main() {
  runApp(MyApp()); // No ProviderScope
}
```

**Solution**: Wrap with ProviderScope
```dart
// ✅ CORRECT
void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}
```

---

## Performance Optimization

### 1. Selective Watching

Instead of watching entire provider, watch specific properties:

```dart
// ❌ Less efficient - rebuilds on any state change
final authState = ref.watch(authNotifierProvider);
final isLoading = authState is AuthLoading;

// ✅ More efficient - only rebuilds when loading status changes
final isLoading = ref.watch(
  authNotifierProvider.select((state) => state is AuthLoading),
);
```

### 2. Provider Scoping

Use `ProviderScope` to limit provider lifecycle:

```dart
// Limit provider to specific subtree
ProviderScope(
  overrides: [
    // Override for this subtree only
  ],
  child: FeatureWidget(),
)
```

### 3. Lazy Loading

Providers are created on first access, not eagerly:

```dart
// This provider only created when first accessed
final expensiveProvider = Provider((ref) {
  return ExpensiveService(); // Not created until needed
});
```

---

## Debugging Tips

### 1. Provider Observer

Monitor all provider changes:

```dart
class MyObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    print('Provider: ${provider.name ?? provider.runtimeType}');
    print('Previous: $previousValue');
    print('New: $newValue');
  }
}

void main() {
  runApp(
    ProviderScope(
      observers: [MyObserver()],
      child: MyApp(),
    ),
  );
}
```

### 2. State Logging

Log state transitions in AuthNotifier:

```dart
@override
set state(AuthState value) {
  print('State transition: ${state.runtimeType} → ${value.runtimeType}');
  super.state = value;
}
```

### 3. DevTools Integration

Riverpod integrates with Flutter DevTools for:
- Provider dependency graph
- State inspection
- Time-travel debugging

---

## Glossary

**Provider**: Container that holds a value and notifies dependents when it changes

**ConsumerWidget**: Widget that can watch providers and rebuild when they change

**StateNotifier**: Class that manages a state and notifies listeners on changes

**Ref**: Object that provides access to providers (via watch/read/listen)

**Sealed Class**: Class that can only be extended within the same library (enables exhaustive pattern matching)

**Immutability**: Property of data that cannot be modified after creation

**Repository Pattern**: Design pattern that abstracts data access logic

**Clean Architecture**: Software design philosophy that separates concerns into layers

---

## References and Resources

### Official Documentation
- [Riverpod Documentation](https://riverpod.dev)
- [Flutter State Management](https://docs.flutter.dev/development/data-and-backend/state-mgmt)

### Related Patterns
- Repository Pattern
- Provider Pattern
- Dependency Injection
- Clean Architecture

### Recommended Reading
- "Flutter in Action" by Eric Windmill
- "Effective Dart" Style Guide
- "Clean Architecture" by Robert C. Martin

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.1 | 2026-01-16 | Updated folder structure documentation to match actual project layout |
| 1.0 | 2026-01-14 | Initial documentation |

---

## Contact and Support

For questions or clarifications about this implementation, please refer to:
- README.md for user-facing documentation
- PRD.md for product requirements and folder structure overview
- CLEAN_ARCHITECTURE_WORKFLOW.md for development workflow
- DESIGN_SYSTEMS.md for theming and design tokens
- Inline code comments for specific implementation details

---

**Document End**