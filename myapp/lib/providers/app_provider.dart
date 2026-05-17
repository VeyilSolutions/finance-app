import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// =========================
/// MODELS
/// =========================

class TransactionModel {
  final String id;
  final String type;
  final String title;
  final double amount;
  final String category;
  final String date;
  final String time;
  final String paymentMethod;
  final String notes;
  final List<String> tags;
  final bool isRecurring;
  final String syncStatus;
  final bool hasAttachment;
  final String? location;

  TransactionModel({
    required this.id,
    required this.type,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.time,
    required this.paymentMethod,
    required this.notes,
    required this.tags,
    required this.isRecurring,
    required this.syncStatus,
    required this.hasAttachment,
    this.location,
  });

  factory TransactionModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TransactionModel(
      id: json['id'],
      type: json['type'],
      title: json['title'],
      amount: json['amount'].toDouble(),
      category: json['category'],
      date: json['date'],
      time: json['time'],
      paymentMethod:
          json['paymentMethod'],
      notes: json['notes'],
      tags:
          List<String>.from(json['tags']),
      isRecurring:
          json['isRecurring'],
      syncStatus:
          json['syncStatus'],
      hasAttachment:
          json['hasAttachment'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'amount': amount,
      'category': category,
      'date': date,
      'time': time,
      'paymentMethod': paymentMethod,
      'notes': notes,
      'tags': tags,
      'isRecurring': isRecurring,
      'syncStatus': syncStatus,
      'hasAttachment': hasAttachment,
      'location': location,
    };
  }
}

class CategoryModel {
  final String id;
  final String name;
  final String icon;
  final String color;
  final String type;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
  });
}

class BudgetModel {
  final String id;
  final String categoryId;
  final double limit;
  final String month;

  BudgetModel({
    required this.id,
    required this.categoryId,
    required this.limit,
    required this.month,
  });
}

class AppSettings {
  bool darkMode;
  String currency;
  String storageMode;
  bool notifications;
  bool appLock;
  String language;

  AppSettings({
    required this.darkMode,
    required this.currency,
    required this.storageMode,
    required this.notifications,
    required this.appLock,
    required this.language,
  });
}

class UserProfile {
  final String name;
  final String email;
  final String phone;
  final String avatar;
  final String joinedDate;

  UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.avatar,
    required this.joinedDate,
  });
}

class NotificationModel {
  final String id;
  final String type;
  final String title;
  final String message;
  final String time;
  bool read;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.time,
    required this.read,
  });
}

/// =========================
/// APP PROVIDER
/// =========================

class AppProvider
    extends ChangeNotifier {
  /// =========================
  /// STATE
  /// =========================

  List<TransactionModel>
      transactions = [];

  List<CategoryModel> categories = [
    CategoryModel(
      id: 'food',
      name: 'Food & Dining',
      icon: '🍽️',
      color: '#FF6B6B',
      type: 'expense',
    ),

    CategoryModel(
      id: 'salary',
      name: 'Salary',
      icon: '💼',
      color: '#00C853',
      type: 'income',
    ),
  ];

  List<BudgetModel> budgets = [];

  AppSettings settings =
      AppSettings(
    darkMode: true,
    currency: 'INR',
    storageMode: 'local',
    notifications: true,
    appLock: false,
    language: 'English',
  );

  UserProfile user = UserProfile(
    name: 'Arjun Sharma',
    email: 'arjun.sharma@gmail.com',
    phone: '+91 98765 43210',
    avatar: '',
    joinedDate: '2025-01-15',
  );

  List<NotificationModel>
      notifications = [];

  /// =========================
  /// INIT
  /// =========================

  Future<void> init() async {
    await loadTransactions();
  }

  /// =========================
  /// LOCAL STORAGE
  /// =========================

  Future<void>
      loadTransactions() async {
    final prefs =
        await SharedPreferences
            .getInstance();

    final data = prefs.getString(
      'transactions',
    );

    if (data != null) {
      final List decoded =
          jsonDecode(data);

      transactions =
          decoded
              .map(
                (e) =>
                    TransactionModel
                        .fromJson(e),
              )
              .toList();
    }

    notifyListeners();
  }

  Future<void>
      saveTransactions() async {
    final prefs =
        await SharedPreferences
            .getInstance();

    final data = jsonEncode(
      transactions
          .map((e) => e.toJson())
          .toList(),
    );

    await prefs.setString(
      'transactions',
      data,
    );
  }

  /// =========================
  /// TRANSACTIONS
  /// =========================

  Future<void> addTransaction(
    TransactionModel tx,
  ) async {
    transactions.insert(0, tx);

    await saveTransactions();

    notifyListeners();
  }

  Future<void> deleteTransaction(
    String id,
  ) async {
    transactions.removeWhere(
      (t) => t.id == id,
    );

    await saveTransactions();

    notifyListeners();
  }

  Future<void> updateTransaction(
    String id,
    TransactionModel updated,
  ) async {
    final index =
        transactions.indexWhere(
      (t) => t.id == id,
    );

    if (index != -1) {
      transactions[index] = updated;

      await saveTransactions();

      notifyListeners();
    }
  }

  /// =========================
  /// SETTINGS
  /// =========================

  void toggleDarkMode() {
    settings.darkMode =
        !settings.darkMode;

    notifyListeners();
  }

  void updateCurrency(
    String currency,
  ) {
    settings.currency = currency;

    notifyListeners();
  }

  /// =========================
  /// NOTIFICATIONS
  /// =========================

  void markNotificationRead(
    String id,
  ) {
    for (var n in notifications) {
      if (n.id == id) {
        n.read = true;
      }
    }

    notifyListeners();
  }

  void markAllNotificationsRead() {
    for (var n in notifications) {
      n.read = true;
    }

    notifyListeners();
  }

  int get unreadCount =>
      notifications
          .where((n) => !n.read)
          .length;

  /// =========================
  /// CALCULATIONS
  /// =========================

  double getMonthlyIncome(
    String month,
  ) {
    return transactions
        .where(
          (t) =>
              t.type == 'income' &&
              t.date.startsWith(
                month,
              ),
        )
        .fold(
          0,
          (sum, t) =>
              sum + t.amount,
        );
  }

  double getMonthlyExpenses(
    String month,
  ) {
    return transactions
        .where(
          (t) =>
              t.type ==
                  'expense' &&
              t.date.startsWith(
                month,
              ),
        )
        .fold(
          0,
          (sum, t) =>
              sum + t.amount,
        );
  }

  double getMonthlySavings(
    String month,
  ) {
    return getMonthlyIncome(
          month,
        ) -
        getMonthlyExpenses(month);
  }

  double getTotalBalance() {
    final income = transactions
        .where(
          (t) => t.type == 'income',
        )
        .fold(
          0.0,
          (sum, t) =>
              sum + t.amount,
        );

    final expense = transactions
        .where(
          (t) => t.type == 'expense',
        )
        .fold(
          0.0,
          (sum, t) =>
              sum + t.amount,
        );

    return income - expense;
  }

  CategoryModel? getCategoryById(
    String id,
  ) {
    try {
      return categories.firstWhere(
        (c) => c.id == id,
      );
    } catch (e) {
      return null;
    }
  }

  double getBudgetSpent(
    String categoryId,
    String month,
  ) {
    return transactions
        .where(
          (t) =>
              t.type ==
                  'expense' &&
              t.category ==
                  categoryId &&
              t.date.startsWith(
                month,
              ),
        )
        .fold(
          0.0,
          (sum, t) =>
              sum + t.amount,
        );
  }
}