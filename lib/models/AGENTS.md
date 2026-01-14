# Models Directory

## Package Identity
Immutable data models representing domain entities (User, Expense).

## Key Files
- `user_model.dart` - User authentication data
- `expense_model.dart` - Expense/Income transaction data
- `index.dart` - Barrel export for all models

## Patterns & Conventions

### Model Structure (Required)
```dart
class ModelName {
  final String id;
  final String field;
  
  // 1. Immutable constructor
  const ModelName({required this.id, required this.field});
  
  // 2. fromJson factory (API responses)
  factory ModelName.fromJson(Map<String, dynamic> json) {
    return ModelName(
      id: json['id'] as String,
      field: json['field'] as String,
    );
  }
  
  // 3. toJson method (serialization)
  Map<String, dynamic> toJson() {
    return {'id': id, 'field': field};
  }
  
  // 4. copyWith for immutable updates
  ModelName copyWith({String? id, String? field}) {
    return ModelName(
      id: id ?? this.id,
      field: field ?? this.field,
    );
  }
}
```

### Examples
- **DO**: Follow pattern from `user_model.dart`
- **DO**: Follow pattern from `expense_model.dart`
- **DON'T**: Mutable fields (`var`, non-final)
- **DON'T**: Skip `copyWith` method

### Naming Conventions
- File: `{entity}_model.dart` (snake_case)
- Class: `{Entity}` (PascalCase) - e.g., `User`, `Expense`
- No "Model" suffix in class name

### When to Create New Model
1. Represents distinct domain entity
2. Needs JSON serialization
3. Used across multiple providers/screens

### Reference
See `docs/PRD.md` section 4 for all data models required.

## Pre-Check
All models must:
- Be immutable (`final` fields)
- Have `fromJson` factory
- Have `toJson` method
- Have `copyWith` method
