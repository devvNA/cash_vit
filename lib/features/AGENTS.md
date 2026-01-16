<coding_guidelines>
# Features (Clean Architecture)

## Package Identity
Feature-first organization following Clean Architecture. Each feature is self-contained with data, domain, and presentation layers.

## Directory Structure
```
features/
├── auth/                       # Authentication feature
│   ├── data/
│   │   ├── datasources/        # Remote data sources
│   │   ├── models/             # DTOs, API response models
│   │   └── repository/         # Repository implementations
│   ├── domain/
│   │   ├── entities/           # Business entities
│   │   ├── repositories/       # Repository interfaces
│   │   └── usecases/           # Business logic use cases
│   └── presentation/
│       ├── providers/          # Riverpod state management
│       ├── screens/            # UI screens
│       └── widgets/            # Feature-specific widgets
├── splash_screen/              # Splash screen feature
├── base/                       # Tab navigation shell
├── home_dashboard/             # Home dashboard with transactions
├── add_transaction/            # Add new transaction
└── profile/                    # User profile
```

## Patterns & Conventions

### Provider Pattern (Presentation Layer)
Location: `features/*/presentation/providers/*_provider.dart`

```dart
// 1. Sealed class states (type-safe, exhaustive)
sealed class AuthState {
  const AuthState();
}
class AuthInitial extends AuthState { const AuthInitial(); }
class AuthLoading extends AuthState { const AuthLoading(); }
class AuthAuthenticated extends AuthState {
  final String token;
  const AuthAuthenticated(this.token);
}
class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

// 2. @riverpod Notifier
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    return const AuthUnauthenticated();
  }

  Future<void> login({required String username, required String password}) async {
    state = const AuthLoading();
    try {
      final repository = ref.read(authRepositoryProvider);
      final token = await repository.login(username: username, password: password);
      state = AuthAuthenticated(token);
    } catch (e) {
      state = AuthError(e.toString());
      _autoResetError();
    }
  }
}
```

### Repository Pattern (Data Layer)
Location: `features/*/data/repository/*_repository.dart`

```dart
class AuthRepository {
  final ApiRequest _apiRequest;
  AuthRepository({ApiRequest? apiRequest}) : _apiRequest = apiRequest ?? ApiRequest();

  Future<String> login({required String username, required String password}) async {
    try {
      final response = await _apiRequest.post(
        ApiConstants.loginEndpoint,
        data: {'username': username, 'password': password},
      );
      return response.data['token'] as String;
    } on DioException catch (e) {
      throw Exception('Login failed: ${e.response?.statusMessage}');
    }
  }
}
```

### Screen Pattern (Presentation Layer)
Location: `features/*/presentation/screens/*_screen.dart`

```dart
class LoginScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    // ref.watch() - Subscribe to state changes (in build)
    final authState = ref.watch(authProvider);

    // ref.listen() - Side effects (snackbars, navigation)
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(...);
      }
      if (next is AuthAuthenticated) {
        Navigator.pushReplacement(context, ...);
      }
    });

    // UI based on state
    return ...;
  }

  void _handleLogin() {
    // ref.read() - Trigger actions (in callbacks)
    ref.read(authProvider.notifier).login(
      username: _usernameController.text,
      password: _passwordController.text,
    );
  }
}
```

### Model Pattern (Data Layer)
Location: `features/*/data/models/*_model.dart`

```dart
class User {
  final int id;
  final String username;
  final String email;

  User({required this.id, required this.username, required this.email});

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as int,
    username: json['username'] as String,
    email: json['email'] as String,
  );

  Map<String, dynamic> toJson() => {'id': id, 'username': username, 'email': email};

  User copyWith({int? id, String? username, String? email}) => User(
    id: id ?? this.id,
    username: username ?? this.username,
    email: email ?? this.email,
  );
}
```

## Key Files
- **Auth Provider**: `auth/presentation/providers/auth_provider.dart`
- **Auth Repository**: `auth/data/repository/auth_repository_impl.dart`
- **Login Screen**: `auth/presentation/screens/login_screen.dart`
- **Splash Provider**: `splash_screen/presentation/providers/splash_provider.dart`
- **Base Screen**: `base/presentation/screens/base_screen.dart` (tab navigation)
- **Home Dashboard**: `home_dashboard/presentation/screens/home_dashboard_screen.dart`
- **Add Transaction**: `add_transaction/presentation/screens/add_transaction_screen.dart`
- **Profile Screen**: `profile/presentation/screens/profile_screen.dart`
- **User Model**: `profile/data/models/user_response_model.dart`
- **Expense Model**: `home_dashboard/data/models/expense_model.dart`

## JIT Index Hints
```bash
# Find all providers
find lib/features -path "*/providers/*.dart"

# Find all screens
find lib/features -path "*/screens/*_screen.dart"

# Find all repositories
find lib/features -path "*/repository/*.dart"

# Find all models
find lib/features -path "*/models/*_model.dart"

# Search provider usage
grep -rn "@riverpod" lib/features/
```

## Common Gotchas
- Generated files: Run `dart run build_runner build` after modifying @riverpod classes
- Provider naming: `authNotifierProvider` becomes `authProvider` after generation
- ref.watch() ONLY in build(), ref.read() ONLY in callbacks
- Sealed classes must handle ALL states (use pattern matching)
- Always dispose controllers in StatefulWidget.dispose()
</coding_guidelines>
