import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../layouts/mobile_layout.dart';

import '../screens/splash_screen.dart';
import '../screens/onboarding.dart';
import '../screens/storage_mode.dart';
import '../screens/login.dart';
import '../screens/dashboard.dart';
import '../screens/add_transaction.dart';
import '../screens/transaction_history.dart';
import '../screens/calendar_view.dart';
import '../screens/reports.dart';
import '../screens/budget_planner.dart';
import '../screens/categories.dart';
import '../screens/import_export.dart';
import '../screens/sync_center.dart';
import '../screens/settings.dart';
import '../screens/profile.dart';
import '../screens/notifications.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',

  routes: [
    /// Splash Screen
    GoRoute(
      path: '/',
      builder: (context, state) =>
          const SplashScreen(),
    ),

    /// Onboarding
    GoRoute(
      path: '/onboarding',
      builder: (context, state) =>
          const Onboarding(),
    ),

    /// Storage Mode
    GoRoute(
      path: '/storage-mode',
      builder: (context, state) =>
          const StorageMode(),
    ),

    /// Login
    GoRoute(
      path: '/login',
      builder: (context, state) =>
          const Login(),
    ),

    /// Main App Layout
    ShellRoute(
      builder: (
        context,
        state,
        child,
      ) {
        return MobileLayout(
          child: child,
        );
      },

      routes: [
        /// Dashboard
        GoRoute(
          path: '/app/home',
          builder: (context, state) =>
              const Dashboard(),
        ),

        /// Add Transaction
        GoRoute(
          path: '/app/add-transaction',
          builder: (context, state) =>
              const AddTransaction(),
        ),

        /// Transactions
        GoRoute(
          path: '/app/transactions',
          builder: (context, state) =>
              const TransactionHistory(),
        ),

        /// Calendar
        GoRoute(
          path: '/app/calendar',
          builder: (context, state) =>
              const CalendarView(),
        ),

        /// Reports
        GoRoute(
          path: '/app/reports',
          builder: (context, state) =>
              const Reports(),
        ),

        /// Budget
        GoRoute(
          path: '/app/budget',
          builder: (context, state) =>
              const BudgetPlanner(),
        ),

        /// Categories
        GoRoute(
          path: '/app/categories',
          builder: (context, state) =>
              const Categories(),
        ),

        /// Import Export
        GoRoute(
          path: '/app/import-export',
          builder: (context, state) =>
              const ImportExport(),
        ),

        /// Sync Center
        GoRoute(
          path: '/app/sync',
          builder: (context, state) =>
              const SyncCenter(),
        ),

        /// Settings
        GoRoute(
          path: '/app/settings',
          builder: (context, state) =>
              const Settings(),
        ),

        /// Profile
        GoRoute(
          path: '/app/profile',
          builder: (context, state) =>
              const Profile(),
        ),

        /// Notifications
        GoRoute(
          path: '/app/notifications',
          builder: (context, state) =>
              const Notifications(),
        ),
      ],
    ),
  ],

  /// 404 Redirect
  errorBuilder: (
    context,
    state,
  ) {
    return const SplashScreen();
  },
);