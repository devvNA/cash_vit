# Providers Directory

## Package Identity
Riverpod state management using StateNotifierProvider pattern.

## Key Files
- `splash_provider.dart` - Splash screen loading state
- `auth_provider.dart` - Authentication state (future)
- `expense_provider.dart` - Expense CRUD state (future)

## Patterns & Conventions

### Riverpod Pattern (MANDATORY)

#### 1. State Class (Sealed)
```dart
sealed class FeatureState {
  const FeatureState();
}

class FeatureInitial extends FeatureState {}
class FeatureLoading extends FeatureState {}
class FeatureSuccess extends FeatureState {
  final Data data;
  const FeatureSuccess(this.data);
}
class FeatureError extends FeatureState {
  final String message;
  const FeatureError(this.message);
}
```

#### 2. Notifier Class
```dart
class FeatureNotifier extends StateNotifier<FeatureState> {
  final Repository _repository;
  
  FeatureNotifier(this._repository) : super(const FeatureInitial());
  
  Future<void> doAction() async {
    state = const FeatureLoading();
    try {
      final data = await _repository.fetch();
      state = FeatureSuccess(data);
    } catch (e) {
      state = FeatureError(e.toString());
    }
  }
}
```

#### 3. Provider Declaration
```dart
final featureProvider = StateNotifierProvider<FeatureNotifier, FeatureState>(
  (ref) => FeatureNotifier(ref.watch(repositoryProvider)),
);
```

### Examples
- **DO**: Follow sealed class pattern from `splash_provider.dart`
- **DO**: Use `StateNotifierProvider` for mutable state
- **DON'T**: Use `setState` in widgets (use Riverpod)
- **DON'T**: Mutate state directly (`state.field = value`)

### State Update Rules
```dart
// ❌ WRONG - Mutation
state.progress = 0.5;

// ✅ CORRECT - New instance
state = state.copyWith(progress: 0.5);
```

### Reference Architecture
See `docs/TECHNICAL_OVERVIEW.md` for complete Riverpod patterns:
- Provider types (Provider, StateNotifierProvider, FutureProvider)
- State management best practices
- Error handling strategies
- Testing patterns

## Common Gotchas
- Always use `.notifier` when calling methods: `ref.read(provider.notifier).method()`
- Check `mounted` before delayed state updates
- Use `ref.watch()` in build, `ref.read()` in callbacks

## Pre-Check
All providers must:
- Use sealed class for states
- Extend `StateNotifier<State>`
- Never mutate state directly
- Handle errors with try-catch
