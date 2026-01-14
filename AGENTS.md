<coding_guidelines>
# Cash Vit - Expense Tracker

## Project Snapshot
Flutter mobile expense tracker with Clean Architecture.
- **State**: Riverpod (@riverpod annotation, sealed class states)
- **API**: FakeStore API (https://fakestoreapi.com)
- **HTTP**: Dio with PrettyDioLogger
- **Storage**: SharedPreferences via LocalStorageService singleton
- **Architecture**: Feature-first Clean Architecture (data → domain → presentation)

**Important**: Each major directory has its own AGENTS.md with specific patterns.

## Root Setup Commands
```bash
flutter pub get                        # Install dependencies
dart run build_runner build            # Generate Riverpod code
flutter analyze                        # Static analysis
flutter test                           # Run all tests
flutter run                            # Run app (debug)
flutter build apk                      # Build Android APK
```

## Universal Conventions
- **Code Style**: Follow `flutter_lints` rules
- **Imports**: Use `package:cash_vit/...` for absolute paths
- **State**: ALL feature state via Riverpod (sealed classes in providers)
- **Const**: Use `const` constructors wherever possible
- **Commits**: Conventional Commits format (`feat:`, `fix:`, `refactor:`)
- **Immutability**: Models use `copyWith()` pattern, never mutate state directly

## Documentation References
- **Product Requirements**: [docs/PRD.md](docs/PRD.md)
- **Design System**: [docs/DESIGN_SYSTEMS.md](docs/DESIGN_SYSTEMS.md)
- **Riverpod Architecture**: [docs/TECHNICAL_OVERVIEW.md](docs/TECHNICAL_OVERVIEW.md)

## Security & Secrets
- Never commit API keys or tokens
- Use `.env` files for sensitive config (not committed)
- Token stored via LocalStorageService (SharedPreferences)

## JIT Index

### Package Structure
- **Core Infrastructure**: `lib/core/` → [see lib/core/AGENTS.md](lib/core/AGENTS.md)
- **Feature Modules**: `lib/features/` → [see lib/features/AGENTS.md](lib/features/AGENTS.md)
- **Shared Components**: `lib/shared/` → [see lib/shared/AGENTS.md](lib/shared/AGENTS.md)

### Quick Find Commands
```bash
# Find screen by name
find lib/features -name "*_screen.dart"

# Find provider
find lib/features -path "*/providers/*_provider.dart"

# Find model
find lib/features -path "*/models/*_model.dart"

# Find repository
find lib/features -path "*/repository/*_repository.dart"

# Search for widget usage
grep -rn "WidgetName" lib/

# Search for provider usage
grep -rn "Provider" lib/features/*/presentation/providers/
```

## Definition of Done
```bash
flutter analyze && flutter test
```
No warnings, no test failures, code generation up-to-date.
</coding_guidelines>
