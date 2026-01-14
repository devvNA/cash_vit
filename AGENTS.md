# Cash Vit - Expense Tracker

## Project Snapshot
Flutter mobile expense tracker with authentication and CRUD operations.
- **State**: Riverpod (StateNotifierProvider pattern)
- **API**: FakeStore API (https://fakestoreapi.com)
- **Storage**: In-memory only
- **Structure**: Flat, feature-based organization

**Important**: Each major directory has its own AGENTS.md with specific patterns and examples.

## Root Setup Commands
```bash
flutter pub get              # Install dependencies
flutter analyze              # Static analysis
flutter test                 # Run all tests
flutter run                  # Run app (debug)
flutter build apk            # Build Android APK
```

## Universal Conventions
- **Code Style**: Follow `flutter_lints` rules
- **Imports**: Use `package:cash_vit/...` for absolute paths
- **State**: ALL state via Riverpod providers (no setState in StatefulWidget)
- **Const**: Use `const` constructors wherever possible
- **Commits**: Conventional Commits format (`feat:`, `fix:`, `refactor:`)

## Documentation References
- **Product Requirements**: [docs/PRD.md](docs/PRD.md)
- **Design System**: [docs/DESIGN_SYSTEMS.md](docs/DESIGN_SYSTEMS.md)
- **Riverpod Architecture**: [docs/TECHNICAL_OVERVIEW.md](docs/TECHNICAL_OVERVIEW.md)

## Security & Secrets
- Never commit API keys or tokens
- Use `.env` files for sensitive config (not committed)
- In-memory storage only (no persistent data)

## JIT Index

### Package Structure
- **Models**: `lib/models/` → [see lib/models/AGENTS.md](lib/models/AGENTS.md)
- **Providers**: `lib/providers/` → [see lib/providers/AGENTS.md](lib/providers/AGENTS.md)
- **Screens**: `lib/screens/` → [see lib/screens/AGENTS.md](lib/screens/AGENTS.md)
- **Utils**: `lib/utils/` → [see lib/utils/AGENTS.md](lib/utils/AGENTS.md)
- **Widgets**: `lib/widgets/` → [see lib/widgets/AGENTS.md](lib/widgets/AGENTS.md)

### Quick Find Commands
```bash
# Find screen
find lib/screens -name "*_screen.dart"

# Find provider
find lib/providers -name "*_provider.dart"

# Find model
find lib/models -name "*_model.dart"

# Search for widget usage
grep -rn "WidgetName" lib/

# Search for provider usage
grep -rn "providerName" lib/
```

## Definition of Done
```bash
flutter analyze && flutter test
```
No warnings, no test failures.
