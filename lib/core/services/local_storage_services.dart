import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

import '../../features/home_dashboard/data/models/expense_model.dart';

/// Service untuk mengelola penyimpanan lokal menggunakan SharedPreferences
///
/// Class ini menggunakan Singleton pattern untuk memastikan hanya ada satu instance yang digunakan di seluruh aplikasi.
class LocalStorageService {
  LocalStorageService._privateConstructor();
  static final LocalStorageService _instance =
      LocalStorageService._privateConstructor();

  /// Factory constructor untuk mendapatkan instance singleton
  factory LocalStorageService() => _instance;

  SharedPreferences? _preferences;

  /// Inisialisasi SharedPreferences
  ///
  /// Method ini harus dipanggil saat aplikasi dimulai (biasanya di main.dart)
  /// sebelum menggunakan method lainnya.
  ///
  /// Example:
  /// ```dart
  /// await LocalStorageService().init();
  /// ```
  Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  /// Memastikan SharedPreferences sudah diinisialisasi
  SharedPreferences get prefs {
    if (_preferences == null) {
      throw Exception(
        'LocalStorageService belum diinisialisasi. Panggil init() terlebih dahulu.',
      );
    }
    return _preferences!;
  }

  // ==================== STORAGE KEYS ====================
  // Definisi key untuk mempermudah maintenance dan menghindari typo

  static const String _keyAuthToken = 'auth_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUserData = 'user_data';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyExpenses = 'expenses';

  // ==================== GENERIC METHODS ====================

  /// Menyimpan string
  Future<bool> setString(String key, String value) async {
    return await prefs.setString(key, value);
  }

  /// Mengambil string
  String? getString(String key) {
    return prefs.getString(key);
  }

  /// Menyimpan integer
  Future<bool> setInt(String key, int value) async {
    return await prefs.setInt(key, value);
  }

  /// Mengambil integer
  int? getInt(String key) {
    return prefs.getInt(key);
  }

  /// Menyimpan boolean
  Future<bool> setBool(String key, bool value) async {
    return await prefs.setBool(key, value);
  }

  /// Mengambil boolean
  bool? getBool(String key) {
    return prefs.getBool(key);
  }

  /// Menyimpan double
  Future<bool> setDouble(String key, double value) async {
    return await prefs.setDouble(key, value);
  }

  /// Mengambil double
  double? getDouble(String key) {
    return prefs.getDouble(key);
  }

  /// Menyimpan list string
  Future<bool> setStringList(String key, List<String> value) async {
    return await prefs.setStringList(key, value);
  }

  /// Mengambil list string
  List<String>? getStringList(String key) {
    return prefs.getStringList(key);
  }

  /// Menghapus data berdasarkan key
  Future<bool> remove(String key) async {
    return await prefs.remove(key);
  }

  /// Menghapus semua data
  Future<bool> clear() async {
    return await prefs.clear();
  }

  /// Mengecek apakah key exists
  bool containsKey(String key) {
    return prefs.containsKey(key);
  }

  // ==================== AUTHENTICATION METHODS ====================

  /// Menyimpan auth token
  Future<bool> saveAuthToken(String token) async {
    return await setString(_keyAuthToken, token);
  }

  /// Mengambil auth token
  String? getAuthToken() {
    return getString(_keyAuthToken);
  }

  /// Menyimpan refresh token
  Future<bool> saveRefreshToken(String token) async {
    return await setString(_keyRefreshToken, token);
  }

  /// Mengambil refresh token
  String? getRefreshToken() {
    return getString(_keyRefreshToken);
  }

  /// Mengeset status login
  Future<bool> setLoggedIn(bool value) async {
    return await setBool(_keyIsLoggedIn, value);
  }

  /// Mengecek apakah user sudah login
  bool isLoggedIn() {
    return getBool(_keyIsLoggedIn) ?? false;
  }

  /// Logout - menghapus semua data authentication
  Future<bool> logout() async {
    await remove(_keyAuthToken);
    await remove(_keyRefreshToken);
    await remove(_keyUserId);
    await remove(_keyUserData);
    return await setLoggedIn(false);
  }

  // ==================== EXPENSE DATA METHODS ====================

  /// Menyimpan list expenses
  Future<bool> saveExpenses(List<Expense> expenses) async {
    try {
      final expensesJson = expenses.map((e) => e.toJson()).toList();
      final expensesString = jsonEncode(expensesJson);
      return await setString(_keyExpenses, expensesString);
    } catch (e) {
      log('Error saving expenses: $e');
      return false;
    }
  }

  /// Mengambil list expenses
  List<Expense>? getExpenses() {
    try {
      final expensesString = getString(_keyExpenses);
      if (expensesString == null) return null;

      final expensesList = jsonDecode(expensesString) as List<dynamic>;
      return expensesList
          .map((e) => Expense.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      log('Error getting expenses: $e');
      return null;
    }
  }

  /// Menambah expense baru ke list yang sudah ada
  Future<bool> addExpense(Expense expense) async {
    try {
      final currentExpenses = getExpenses() ?? [];
      currentExpenses.add(expense);
      return await saveExpenses(currentExpenses);
    } catch (e) {
      log('Error adding expense: $e');
      return false;
    }
  }

  /// Update expense berdasarkan ID
  Future<bool> updateExpense(Expense updatedExpense) async {
    try {
      final currentExpenses = getExpenses() ?? [];
      final index = currentExpenses.indexWhere(
        (e) => e.id == updatedExpense.id,
      );

      if (index == -1) return false;

      currentExpenses[index] = updatedExpense;
      return await saveExpenses(currentExpenses);
    } catch (e) {
      log('Error updating expense: $e');
      return false;
    }
  }

  /// Hapus expense berdasarkan ID
  Future<bool> deleteExpense(String expenseId) async {
    try {
      final currentExpenses = getExpenses() ?? [];
      currentExpenses.removeWhere((e) => e.id == expenseId);
      return await saveExpenses(currentExpenses);
    } catch (e) {
      log('Error deleting expense: $e');
      return false;
    }
  }

  /// Menghapus semua expenses
  Future<bool> clearExpenses() async {
    return await remove(_keyExpenses);
  }

  // ==================== UTILITY METHODS ====================

  /// Mendapatkan semua keys yang tersimpan
  Set<String> getAllKeys() {
    return prefs.getKeys();
  }

  /// Reload preferences dari storage
  Future<void> reload() async {
    await prefs.reload();
  }

  /// log semua data yang tersimpan (untuk debugging)
  void debuglogAll() {
    final keys = getAllKeys();
    log('=== LocalStorage Debug ===');
    for (final key in keys) {
      log('$key: ${prefs.get(key)}');
    }
    log('========================');
  }
}
