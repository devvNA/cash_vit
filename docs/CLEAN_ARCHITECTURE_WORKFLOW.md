# Clean Architecture Workflow Guide

> **Best Practice Flow Pengerjaan Fitur Baru**
> Panduan lengkap untuk mengembangkan fitur dengan Clean Architecture di Flutter

---

## 🎯 Urutan Pengerjaan: **Domain → Data → Presentation**

Mulai dari **inti bisnis logic** (Domain), implementasi detail teknis (Data), terakhir UI (Presentation).

---

## 1️⃣ DOMAIN LAYER (Start Here!)

**Kenapa domain dulu?**
- Domain adalah **inti bisnis logic** yang tidak bergantung pada UI atau API
- Mendefinisikan **apa yang aplikasi lakukan**, bukan bagaimana melakukannya
- Paling stabil (jarang berubah)
- Pure Dart (mudah di-test, no Flutter dependencies)

### 📁 Struktur Domain Layer

```
lib/features/transaction/domain/
├── entities/                       # Business objects
│   └── transaction_entity.dart
├── repositories/                   # Contracts/Interfaces
│   └── transaction_repository.dart
└── usecases/                       # Business logic
    ├── get_transactions_usecase.dart
    ├── add_transaction_usecase.dart
    └── delete_transaction_usecase.dart
```

### 📝 A) Entities (Business Objects)

**Apa itu Entity?**
- Pure business object
- Tidak ada logic khusus platform (no JSON parsing, no API calls)
- Represent konsep bisnis (Transaction, User, Product, etc.)

**Contoh:**

```dart
// lib/features/transaction/domain/entities/transaction_entity.dart

class TransactionEntity {
  final String id;
  final String title;
  final double amount;
  final TransactionType type; // income/expense
  final DateTime date;
  final int userId;
  final String? category;

  const TransactionEntity({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.date,
    required this.userId,
    this.category,
  });

  // ✅ Business logic methods (if needed)
  bool isIncome() => type == TransactionType.income;
  bool isExpense() => type == TransactionType.expense;
}

enum TransactionType { income, expense }
```

**✅ Karakteristik Entity:**
- Immutable (final fields)
- No dependencies (pure Dart)
- No JSON/API logic
- Focus on business concepts

---

### 📝 B) Repository Interfaces (Contracts)

**Apa itu Repository Interface?**
- Contract yang mendefinisikan **apa yang bisa dilakukan** dengan data
- BUKAN implementasi (hanya signature methods)
- Data layer akan implement interface ini

**Contoh:**

```dart
// lib/features/transaction/domain/repositories/transaction_repository.dart

abstract class TransactionRepository {
  /// Get all transactions for a user
  Future<List<TransactionEntity>> getTransactions({required int userId});

  /// Add new transaction
  Future<void> addTransaction(TransactionEntity transaction);

  /// Update existing transaction
  Future<void> updateTransaction(TransactionEntity transaction);

  /// Delete transaction by ID
  Future<void> deleteTransaction(String id);

  /// Get transaction by ID
  Future<TransactionEntity?> getTransactionById(String id);
}
```

**✅ Karakteristik Repository Interface:**
- Abstract class (pure interface)
- Return domain entities
- No implementation details
- Focus on **what**, not **how**

---

### 📝 C) Use Cases (Business Logic)

**Apa itu Use Case?**
- Represent **satu action spesifik** dalam sistem
- Contains business rules & validation
- Orchestrate antara entities dan repositories
- Single Responsibility Principle

**Contoh:**

```dart
// lib/features/transaction/domain/usecases/add_transaction_usecase.dart

class AddTransactionUseCase {
  final TransactionRepository repository;

  AddTransactionUseCase(this.repository);

  /// Execute use case
  /// Returns the added transaction
  Future<void> call(TransactionEntity transaction) async {
    // ✅ Business validation
    if (transaction.amount <= 0) {
      throw InvalidAmountException('Amount must be positive');
    }

    if (transaction.title.trim().isEmpty) {
      throw InvalidTitleException('Title cannot be empty');
    }

    if (transaction.title.length > 50) {
      throw InvalidTitleException('Title max 50 characters');
    }

    // ✅ Call repository
    return repository.addTransaction(transaction);
  }
}

// Custom exceptions
class InvalidAmountException implements Exception {
  final String message;
  InvalidAmountException(this.message);
}

class InvalidTitleException implements Exception {
  final String message;
  InvalidTitleException(this.message);
}
```

**Contoh Use Case Lain:**

```dart
// lib/features/transaction/domain/usecases/get_transactions_usecase.dart

class GetTransactionsUseCase {
  final TransactionRepository repository;

  GetTransactionsUseCase(this.repository);

  Future<List<TransactionEntity>> call({
    required int userId,
    TransactionType? filterByType,
  }) async {
    // Get all transactions
    final transactions = await repository.getTransactions(userId: userId);

    // Apply filter if provided
    if (filterByType != null) {
      return transactions.where((t) => t.type == filterByType).toList();
    }

    return transactions;
  }
}
```

**✅ Karakteristik Use Case:**
- Single responsibility
- Contains validation
- Reusable across presentation layer
- Easy to test (mock repository)

---

## 2️⃣ DATA LAYER (Implementation)

**Kenapa data kedua?**
- Implement **contract yang sudah dibuat di domain**
- Handle detail teknis (API, database, caching)
- Bisa di-test dengan mock API
- Dependency sudah jelas dari domain interface

### 📁 Struktur Data Layer

```
lib/features/transaction/data/
├── datasources/                    # API/Database calls
│   ├── transaction_remote_datasource.dart
│   └── transaction_local_datasource.dart (optional)
├── models/                         # DTOs (Data Transfer Objects)
│   └── transaction_model.dart
└── repository/                     # Implementation dari domain interface
    └── transaction_repository_impl.dart
```

### 📝 A) Models (DTO - Data Transfer Object)

**Apa itu Model?**
- Representation data dari external source (API, Database)
- Handle JSON parsing (fromJson/toJson)
- Convert to/from domain entities
- Coupled dengan data structure API/DB

**Contoh:**

```dart
// lib/features/transaction/data/models/transaction_model.dart

class TransactionModel {
  final String id;
  final String title;
  final double amount;
  final String type; // "income" or "expense" (from API)
  final String date; // ISO8601 string (from API)
  final int userId;
  final String? category;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.date,
    required this.userId,
    this.category,
  });

  // ✅ Parse dari JSON (API response)
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] as String,
      date: json['date'] as String,
      userId: json['userId'] as int,
      category: json['category'] as String?,
    );
  }

  // ✅ Convert ke JSON (untuk POST/PUT request)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type,
      'date': date,
      'userId': userId,
      'category': category,
    };
  }

  // ✅ Convert ke Domain Entity
  TransactionEntity toEntity() {
    return TransactionEntity(
      id: id,
      title: title,
      amount: amount,
      type: type == 'income'
          ? TransactionType.income
          : TransactionType.expense,
      date: DateTime.parse(date),
      userId: userId,
      category: category,
    );
  }

  // ✅ Create dari Domain Entity
  factory TransactionModel.fromEntity(TransactionEntity entity) {
    return TransactionModel(
      id: entity.id,
      title: entity.title,
      amount: entity.amount,
      type: entity.type == TransactionType.income ? 'income' : 'expense',
      date: entity.date.toIso8601String(),
      userId: entity.userId,
      category: entity.category,
    );
  }
}
```

**✅ Karakteristik Model:**
- Handle JSON serialization
- Coupled dengan API structure
- Contains conversion logic (toEntity/fromEntity)
- Not part of domain (implementation detail)

---

### 📝 B) Data Sources (Remote/Local)

**Apa itu Data Source?**
- Handle direct communication dengan external systems
- Remote: API calls (HTTP, GraphQL, gRPC)
- Local: Database, SharedPreferences, File storage
- Return models (not entities)

**Contoh Remote Data Source:**

```dart
// lib/features/transaction/data/datasources/transaction_remote_datasource.dart

abstract class TransactionRemoteDatasource {
  Future<List<TransactionModel>> getTransactions({required int userId});
  Future<void> addTransaction(TransactionModel transaction);
  Future<void> updateTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String id);
  Future<TransactionModel?> getTransactionById(String id);
}

class TransactionRemoteDatasourceImpl implements TransactionRemoteDatasource {
  final ApiRequest apiRequest;

  TransactionRemoteDatasourceImpl({required this.apiRequest});

  @override
  Future<List<TransactionModel>> getTransactions({required int userId}) async {
    try {
      final response = await apiRequest.get(
        '/transactions',
        queryParameters: {'userId': userId},
      );

      return (response.data as List)
          .map((json) => TransactionModel.fromJson(json))
          .toList();
    } catch (e) {
      throw DataSourceException('Failed to fetch transactions: $e');
    }
  }

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      await apiRequest.post(
        '/transactions',
        data: transaction.toJson(),
      );
    } catch (e) {
      throw DataSourceException('Failed to add transaction: $e');
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    try {
      await apiRequest.delete('/transactions/$id');
    } catch (e) {
      throw DataSourceException('Failed to delete transaction: $e');
    }
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    try {
      await apiRequest.put(
        '/transactions/${transaction.id}',
        data: transaction.toJson(),
      );
    } catch (e) {
      throw DataSourceException('Failed to update transaction: $e');
    }
  }

  @override
  Future<TransactionModel?> getTransactionById(String id) async {
    try {
      final response = await apiRequest.get('/transactions/$id');
      return TransactionModel.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }
}

class DataSourceException implements Exception {
  final String message;
  DataSourceException(this.message);
}
```

**Contoh Local Data Source (Optional):**

```dart
// lib/features/transaction/data/datasources/transaction_local_datasource.dart

abstract class TransactionLocalDatasource {
  Future<List<TransactionModel>> getCachedTransactions();
  Future<void> cacheTransactions(List<TransactionModel> transactions);
  Future<void> clearCache();
}

class TransactionLocalDatasourceImpl implements TransactionLocalDatasource {
  final LocalStorageService localStorage;

  // Implementation using SharedPreferences, Hive, etc.
}
```

**✅ Karakteristik Data Source:**
- Direct API/DB calls
- Return models (not entities)
- Handle errors & exceptions
- Single source of data (remote OR local)

---

### 📝 C) Repository Implementation

**Apa itu Repository Implementation?**
- Implement interface dari domain layer
- Orchestrate antara multiple data sources
- Convert models to entities
- Handle caching strategy
- Single source of truth untuk presentation layer

**Contoh:**

```dart
// lib/features/transaction/data/repository/transaction_repository_impl.dart

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDatasource remoteDatasource;
  final TransactionLocalDatasource? localDatasource; // Optional cache

  TransactionRepositoryImpl({
    required this.remoteDatasource,
    this.localDatasource,
  });

  @override
  Future<List<TransactionEntity>> getTransactions({required int userId}) async {
    try {
      // ✅ Try remote first
      final models = await remoteDatasource.getTransactions(userId: userId);

      // ✅ Cache locally (if available)
      await localDatasource?.cacheTransactions(models);

      // ✅ Convert to entities
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      // ✅ Fallback to cache on error
      if (localDatasource != null) {
        final cachedModels = await localDatasource!.getCachedTransactions();
        return cachedModels.map((m) => m.toEntity()).toList();
      }

      rethrow;
    }
  }

  @override
  Future<void> addTransaction(TransactionEntity transaction) async {
    // ✅ Convert entity to model
    final model = TransactionModel.fromEntity(transaction);

    // ✅ Call remote datasource
    await remoteDatasource.addTransaction(model);

    // ✅ Invalidate cache (refresh data)
    await localDatasource?.clearCache();
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await remoteDatasource.deleteTransaction(id);
    await localDatasource?.clearCache();
  }

  @override
  Future<void> updateTransaction(TransactionEntity transaction) async {
    final model = TransactionModel.fromEntity(transaction);
    await remoteDatasource.updateTransaction(model);
    await localDatasource?.clearCache();
  }

  @override
  Future<TransactionEntity?> getTransactionById(String id) async {
    final model = await remoteDatasource.getTransactionById(id);
    return model?.toEntity();
  }
}
```

**✅ Karakteristik Repository Implementation:**
- Implement domain interface
- Coordinate multiple data sources
- Handle caching logic
- Convert models ↔ entities
- Error handling & recovery

---

## 3️⃣ PRESENTATION LAYER (UI)

**Kenapa presentation terakhir?**
- Sudah ada **business logic (domain)** yang teruji
- Sudah ada **data handling (data)** yang siap
- Tinggal **tampilkan ke UI**
- UI paling sering berubah (redesign, A/B testing)
- Dependency jelas: Domain + Data sudah stabil

### 📁 Struktur Presentation Layer

```
lib/features/transaction/presentation/
├── providers/                      # State management
│   ├── transaction_provider.dart
│   └── transaction_provider.g.dart (generated)
├── screens/                        # Pages/Routes
│   ├── transaction_list_screen.dart
│   └── add_transaction_screen.dart
└── widgets/                        # Reusable UI components
    ├── transaction_card.dart
    └── transaction_filter_chips.dart
```

### 📝 A) Providers (State Management - Riverpod)

**Apa itu Provider?**
- Manage UI state
- Call use cases dari domain
- Notify UI when state changes
- Handle loading/error states

**Contoh State Class:**

```dart
// lib/features/transaction/presentation/providers/transaction_provider.dart

/// Sealed class representing all possible states
sealed class TransactionState {
  const TransactionState();
}

class TransactionInitial extends TransactionState {
  const TransactionInitial();
}

class TransactionLoading extends TransactionState {
  const TransactionLoading();
}

class TransactionLoaded extends TransactionState {
  final List<TransactionEntity> transactions;
  final double totalIncome;
  final double totalExpense;
  final double balance;

  const TransactionLoaded({
    required this.transactions,
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
  });
}

class TransactionError extends TransactionState {
  final String message;
  const TransactionError(this.message);
}
```

**Contoh Provider:**

```dart
// Dependency injection for use cases
@riverpod
GetTransactionsUseCase getTransactionsUseCase(Ref ref) {
  return GetTransactionsUseCase(ref.watch(transactionRepositoryProvider));
}

@riverpod
AddTransactionUseCase addTransactionUseCase(Ref ref) {
  return AddTransactionUseCase(ref.watch(transactionRepositoryProvider));
}

@riverpod
DeleteTransactionUseCase deleteTransactionUseCase(Ref ref) {
  return DeleteTransactionUseCase(ref.watch(transactionRepositoryProvider));
}

// Main provider
@riverpod
class TransactionNotifier extends _$TransactionNotifier {
  @override
  TransactionState build() {
    loadTransactions();
    return const TransactionInitial();
  }

  /// Load all transactions
  Future<void> loadTransactions({TransactionType? filter}) async {
    state = const TransactionLoading();

    try {
      // ✅ Get use case
      final useCase = ref.read(getTransactionsUseCaseProvider);

      // ✅ Execute
      final transactions = await useCase(
        userId: 1, // TODO: Get from auth
        filterByType: filter,
      );

      // ✅ Calculate totals
      final income = transactions
          .where((t) => t.isIncome())
          .fold(0.0, (sum, t) => sum + t.amount);

      final expense = transactions
          .where((t) => t.isExpense())
          .fold(0.0, (sum, t) => sum + t.amount);

      // ✅ Update state
      state = TransactionLoaded(
        transactions: transactions,
        totalIncome: income,
        totalExpense: expense,
        balance: income - expense,
      );
    } catch (e) {
      state = TransactionError(e.toString());
    }
  }

  /// Add new transaction
  Future<void> addTransaction(TransactionEntity transaction) async {
    try {
      final useCase = ref.read(addTransactionUseCaseProvider);
      await useCase(transaction);

      // ✅ Reload after success
      await loadTransactions();
    } catch (e) {
      state = TransactionError(e.toString());

      // ✅ Auto-recover after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (state is TransactionError) {
          loadTransactions();
        }
      });
    }
  }

  /// Delete transaction
  Future<void> deleteTransaction(String id) async {
    try {
      final useCase = ref.read(deleteTransactionUseCaseProvider);
      await useCase(id);
      await loadTransactions();
    } catch (e) {
      state = TransactionError(e.toString());
    }
  }
}
```

**✅ Karakteristik Provider:**
- Manage sealed state classes
- Call use cases (not repositories directly!)
- Handle loading/success/error
- Auto-recovery on error
- Notify listeners on state change

---

### 📝 B) Screens (UI Pages)

**Apa itu Screen?**
- Full page/route dalam app
- Consume providers (watch state)
- Handle navigation
- Compose widgets

**Contoh:**

```dart
// lib/features/transaction/presentation/screens/transaction_list_screen.dart

class TransactionListScreen extends ConsumerStatefulWidget {
  const TransactionListScreen({super.key});

  @override
  ConsumerState<TransactionListScreen> createState() =>
      _TransactionListScreenState();
}

class _TransactionListScreenState extends ConsumerState<TransactionListScreen> {
  TransactionType? _filter;

  @override
  Widget build(BuildContext context) {
    // ✅ Watch provider state
    final state = ref.watch(transactionNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          // Filter button
          PopupMenuButton<TransactionType?>(
            onSelected: (filter) {
              setState(() => _filter = filter);
              ref.read(transactionNotifierProvider.notifier)
                  .loadTransactions(filter: filter);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: null, child: Text('All')),
              const PopupMenuItem(
                value: TransactionType.income,
                child: Text('Income'),
              ),
              const PopupMenuItem(
                value: TransactionType.expense,
                child: Text('Expense'),
              ),
            ],
          ),
        ],
      ),
      body: switch (state) {
        TransactionInitial() => const Center(
            child: Text('Loading transactions...'),
          ),
        TransactionLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
        TransactionLoaded(:final transactions) => transactions.isEmpty
            ? const Center(child: Text('No transactions'))
            : ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  return TransactionCard(
                    transaction: transactions[index],
                    onDelete: () {
                      ref
                          .read(transactionNotifierProvider.notifier)
                          .deleteTransaction(transactions[index].id);
                    },
                  );
                },
              ),
        TransactionError(:final message) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: $message'),
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(transactionNotifierProvider.notifier)
                        .loadTransactions();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
      },
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddTransactionScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

**✅ Karakteristik Screen:**
- ConsumerWidget/ConsumerStatefulWidget
- Watch provider state
- Pattern matching on state (switch/when)
- Handle navigation
- Compose widgets

---

### 📝 C) Widgets (Reusable Components)

**Apa itu Widget?**
- Reusable UI components
- Accept data via constructor
- Emit events via callbacks
- No business logic (stateless/minimal state)

**Contoh:**

```dart
// lib/features/transaction/presentation/widgets/transaction_card.dart

class TransactionCard extends StatelessWidget {
  final TransactionEntity transaction;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const TransactionCard({
    required this.transaction,
    this.onDelete,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.isIncome();
    final amountColor = isIncome
        ? AppColors.incomeGreen
        : AppColors.expenseRed;

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isIncome
              ? AppColors.incomeGreen.withOpacity(0.1)
              : AppColors.expenseRed.withOpacity(0.1),
          child: Icon(
            isIncome ? Icons.arrow_upward : Icons.arrow_downward,
            color: amountColor,
          ),
        ),
        title: Text(transaction.title),
        subtitle: Text(
          DateFormat('dd MMM yyyy').format(transaction.date),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${isIncome ? '+' : '-'} ${transaction.amount.toRupiah}',
              style: TextStyle(
                color: amountColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: onDelete,
              ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
```

**✅ Karakteristik Widget:**
- Stateless (atau minimal state)
- Data via constructor
- Events via callbacks
- Reusable across screens
- No business logic

---

### ✅ Checklist Presentation Layer

- [ ] State classes defined (sealed classes)
- [ ] Providers created (Riverpod)
- [ ] Screens implemented
- [ ] Widgets created (reusable)
- [ ] Navigation working
- [ ] Loading/error states handled
- [ ] Widget tests written

---

## 📊 Summary Flow Chart

```
┌─────────────────────────────────────────────────────────────┐
│                    1️⃣ DOMAIN LAYER                          │
│                  (Pure Business Logic)                      │
├─────────────────────────────────────────────────────────────┤
│  Entities          → Business objects                       │
│  Repositories      → Contracts/Interfaces                   │
│  Use Cases         → Business logic & validation            │
│                                                              │
│  ✅ No dependencies                                          │
│  ✅ Easy to test (pure Dart)                                 │
│  ✅ Stable (rarely changes)                                  │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                    2️⃣ DATA LAYER                            │
│              (Implementation Details)                       │
├─────────────────────────────────────────────────────────────┤
│  Models            → DTOs (JSON parsing)                    │
│  Data Sources      → API/Database calls                     │
│  Repository Impl   → Implement domain interface             │
│                                                              │
│  ✅ Implements domain contracts                              │
│  ✅ Can be mocked for testing                                │
│  ✅ Swappable (different APIs/DBs)                           │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                  3️⃣ PRESENTATION LAYER                      │
│                    (User Interface)                         │
├─────────────────────────────────────────────────────────────┤
│  Providers         → State management (Riverpod)            │
│  Screens           → Pages/Routes                           │
│  Widgets           → UI components                          │
│                                                              │
│  ✅ Uses domain use cases                                    │
│  ✅ Reactive to state changes                                │
│  ✅ Easy to redesign                                         │
└─────────────────────────────────────────────────────────────┘
```

---

## 🎯 Practical Example: "Delete Transaction" Feature

### Step 1: Domain Layer

```dart
// domain/repositories/transaction_repository.dart
abstract class TransactionRepository {
  Future<void> deleteTransaction(String id);
}

// domain/usecases/delete_transaction_usecase.dart
class DeleteTransactionUseCase {
  final TransactionRepository repository;

  DeleteTransactionUseCase(this.repository);

  Future<void> call(String id) async {
    if (id.isEmpty) {
      throw InvalidIdException('Transaction ID cannot be empty');
    }
    return repository.deleteTransaction(id);
  }
}
```

### Step 2: Data Layer

```dart
// data/datasources/transaction_remote_datasource.dart
abstract class TransactionRemoteDatasource {
  Future<void> deleteTransaction(String id);
}

class TransactionRemoteDatasourceImpl implements TransactionRemoteDatasource {
  final ApiRequest apiRequest;

  @override
  Future<void> deleteTransaction(String id) async {
    await apiRequest.delete('/transactions/$id');
  }
}

// data/repository/transaction_repository_impl.dart
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDatasource remoteDatasource;

  @override
  Future<void> deleteTransaction(String id) async {
    await remoteDatasource.deleteTransaction(id);
  }
}
```

### Step 3: Presentation Layer

```dart
// presentation/providers/transaction_provider.dart
@riverpod
class TransactionNotifier extends _$TransactionNotifier {
  Future<void> deleteTransaction(String id) async {
    try {
      final useCase = ref.read(deleteTransactionUseCaseProvider);
      await useCase(id);
      await loadTransactions(); // Refresh
    } catch (e) {
      state = TransactionError(e.toString());
    }
  }
}

// presentation/screens/transaction_list_screen.dart
IconButton(
  icon: const Icon(Icons.delete),
  onPressed: () {
    ref.read(transactionNotifierProvider.notifier)
        .deleteTransaction(transaction.id);
  },
)
```

---

## ⚡ Tips & Best Practices

### 1. **Test Each Layer Independently**

```dart
// Domain: Unit test use cases
test('should throw exception when amount is negative', () async {
  final useCase = AddTransactionUseCase(mockRepository);
  expect(
    () => useCase(transactionWithNegativeAmount),
    throwsA(isA<InvalidAmountException>()),
  );
});

// Data: Test with mock datasource
test('should return entities from remote datasource', () async {
  when(mockRemoteDatasource.getTransactions(userId: 1))
      .thenAnswer((_) async => [mockModel]);

  final result = await repository.getTransactions(userId: 1);
  expect(result, [mockEntity]);
});

// Presentation: Widget test
testWidgets('should show loading indicator', (tester) async {
  when(mockProvider.build()).thenReturn(const TransactionLoading());
  await tester.pumpWidget(TransactionListScreen());
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
});
```

### 2. **Dependency Injection (Riverpod)**

Setup all providers at app level:

```dart
// lib/core/providers/providers.dart

// Domain providers
@riverpod
TransactionRepository transactionRepository(Ref ref) {
  return TransactionRepositoryImpl(
    remoteDatasource: ref.watch(transactionRemoteDatasourceProvider),
  );
}

@riverpod
TransactionRemoteDatasource transactionRemoteDatasource(Ref ref) {
  return TransactionRemoteDatasourceImpl(
    apiRequest: ref.watch(apiRequestProvider),
  );
}

@riverpod
GetTransactionsUseCase getTransactionsUseCase(Ref ref) {
  return GetTransactionsUseCase(
    ref.watch(transactionRepositoryProvider),
  );
}
```

### 3. **Error Handling Strategy**

```dart
// Domain: Business exceptions
class DomainException implements Exception {
  final String message;
  DomainException(this.message);
}

// Data: Technical exceptions
class DataSourceException implements Exception {
  final String message;
  DataSourceException(this.message);
}

// Presentation: User-friendly messages
void _handleError(Exception e) {
  final message = switch (e) {
    InvalidAmountException() => 'Amount must be positive',
    InvalidTitleException() => 'Title cannot be empty',
    DataSourceException() => 'Network error. Please try again.',
    _ => 'Something went wrong',
  };

  state = TransactionError(message);
}
```

### 4. **Iterasi Cepat**

Bisa mulai dengan mock/dummy data:

```dart
// Domain: Pure logic, no real API
class MockTransactionRepository implements TransactionRepository {
  final List<TransactionEntity> _data = [];

  @override
  Future<List<TransactionEntity>> getTransactions() async {
    return _data;
  }
}

// Presentation: Test UI dengan mock provider
ref.read(transactionRepositoryProvider.overrideWithValue(
  MockTransactionRepository(),
));
```

### 5. **Code Generation**

```bash
# Generate Riverpod providers
dart run build_runner build --delete-conflicting-outputs

# Watch mode (auto-regenerate)
dart run build_runner watch
```

---

## 📚 Additional Resources

- **Clean Architecture Book**: Robert C. Martin
- **Flutter Clean Architecture**: Reso Coder (YouTube)
- **Riverpod Documentation**: https://riverpod.dev
- **Project Reference**: `docs/TECHNICAL_OVERVIEW.md`

---

## ✅ Final Checklist (Complete Feature)

### Domain Layer
- [ ] Entities created
- [ ] Repository interfaces defined
- [ ] Use cases implemented
- [ ] Business validation added
- [ ] Unit tests written

### Data Layer
- [ ] Models created (JSON parsing)
- [ ] Remote datasource implemented
- [ ] Repository implementation done
- [ ] Error handling implemented
- [ ] Integration tests written

### Presentation Layer
- [ ] State classes defined
- [ ] Providers created
- [ ] Screens implemented
- [ ] Widgets created
- [ ] Navigation working
- [ ] Widget tests written

### Integration
- [ ] All layers connected via DI
- [ ] Code generation run
- [ ] `flutter analyze` passes
- [ ] All tests pass
- [ ] Feature works end-to-end

---

## 🎯 Kesimpulan

**Best Practice Flow:**
1. **Domain First** → Define business logic (what)
2. **Data Second** → Implement technical details (how)
3. **Presentation Last** → Build user interface (show)

**Benefits:**
- ✅ Clear separation of concerns
- ✅ Easy to test each layer
- ✅ Easy to change (UI, API, Database)
- ✅ Easy to scale (team collaboration)
- ✅ Maintainable & readable code

**Remember:** Start simple, iterate fast, add complexity when needed!

---

**Last Updated:** 2026-01-16
**Author:** Cash Vit Development Team
