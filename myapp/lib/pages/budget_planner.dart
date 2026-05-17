// pages/budget_planner.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';

class BudgetPlannerPage extends StatefulWidget {
  const BudgetPlannerPage({super.key});

  @override
  State<BudgetPlannerPage> createState() => _BudgetPlannerPageState();
}

class _BudgetPlannerPageState extends State<BudgetPlannerPage> {
  final String currentMonth = '2026-05';

  bool showAddBudget = false;

  String newCatId = '';
  final TextEditingController limitController = TextEditingController();

  String fmt(num n) {
    return '₹${n.toStringAsFixed(0)}';
  }

  final List<Map<String, dynamic>> goals = [
    {
      'name': 'Emergency Fund',
      'target': 150000,
      'current': 97500,
      'color': const Color(0xFF2979FF),
      'icon': '🏦',
    },
    {
      'name': 'Goa Trip',
      'target': 25000,
      'current': 18000,
      'color': const Color(0xFFA29BFE),
      'icon': '✈️',
    },
    {
      'name': 'New MacBook',
      'target': 120000,
      'current': 45000,
      'color': const Color(0xFFFFD54F),
      'icon': '💻',
    },
    {
      'name': 'Car Down Payment',
      'target': 200000,
      'current': 62000,
      'color': const Color(0xFF00C853),
      'icon': '🚗',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();

    final isDark = app.settings.darkMode;

    final cardBg =
        isDark ? const Color(0xFF1E293B) : Colors.white;

    final mainText =
        isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);

    final subText =
        isDark ? const Color(0xFF64748B) : const Color(0xFF9CA3AF);

    final borderColor =
        isDark
            ? Colors.white.withOpacity(0.06)
            : Colors.black.withOpacity(0.06);

    final inputBg =
        isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);

    final monthBudgets = app.budgets
        .where((b) => b.month == currentMonth)
        .toList();

    final totalLimit = monthBudgets.fold<double>(
      0,
      (s, b) => s + b.limit,
    );

    final totalSpent = monthBudgets.fold<double>(
      0,
      (s, b) => s + app.getBudgetSpent(b.categoryId, currentMonth),
    );

    final overallPct =
        totalLimit > 0 ? (totalSpent / totalLimit) * 100 : 0;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),

      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.only(bottom: 30),
              children: [
                // HEADER
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: borderColor),
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: mainText,
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Text(
                          'Budget Planner',
                          style: TextStyle(
                            color: mainText,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showAddBudget = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF2979FF)
                                    .withOpacity(0.15),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: const Color(0xFF2979FF)
                                  .withOpacity(0.3),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.add,
                                size: 16,
                                color: Color(0xFF2979FF),
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Add',
                                style: TextStyle(
                                  color: Color(0xFF2979FF),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // OVERALL BUDGET CARD
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF0D2137),
                          Color(0xFF0A1F3A),
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Total Budget Used',
                                    style: TextStyle(
                                      color: Color(0xFF94A3B8),
                                      fontSize: 12,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  Text(
                                    fmt(totalSpent),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  Text(
                                    'of ${fmt(totalLimit)}',
                                    style: const TextStyle(
                                      color: Color(0xFF94A3B8),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              width: 90,
                              height: 90,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    value:
                                        (overallPct / 100)
                                            .clamp(0, 1),
                                    strokeWidth: 8,
                                    backgroundColor:
                                        Colors.white10,
                                    valueColor:
                                        AlwaysStoppedAnimation(
                                      overallPct > 90
                                          ? Colors.red
                                          : overallPct > 75
                                              ? Colors.amber
                                              : Colors.green,
                                    ),
                                  ),
                                  Text(
                                    '${overallPct.round()}%',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        LinearProgressIndicator(
                          value:
                              (overallPct / 100).clamp(0, 1),
                          minHeight: 8,
                          borderRadius:
                              BorderRadius.circular(20),
                          backgroundColor: Colors.white10,
                        ),

                        const SizedBox(height: 10),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${fmt(totalLimit - totalSpent)} remaining this month',
                            style: const TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // CATEGORY BUDGETS
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Category Budgets',
                    style: TextStyle(
                      color: mainText,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                ...monthBudgets.map((budget) {
                  final cat =
                      app.getCategoryById(budget.categoryId);

                  final spent = app.getBudgetSpent(
                    budget.categoryId,
                    currentMonth,
                  );

                  final pct = budget.limit > 0
                      ? (spent / budget.limit) * 100
                      : 0;

                  final isOver = pct > 100;
                  final isWarning = pct > 80;

                  Color statusColor =
                      isOver
                          ? Colors.red
                          : isWarning
                              ? Colors.amber
                              : Colors.green;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 6,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius:
                            BorderRadius.circular(20),
                        border: Border.all(
                          color: isOver
                              ? Colors.red.withOpacity(0.3)
                              : borderColor,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: cat.color
                                      .withOpacity(0.18),
                                  borderRadius:
                                      BorderRadius.circular(
                                    14,
                                  ),
                                ),
                                child: Text(
                                  cat.icon,
                                  style:
                                      const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cat.name,
                                      style: TextStyle(
                                        color: mainText,
                                        fontWeight:
                                            FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'Limit: ${fmt(budget.limit)}',
                                      style: TextStyle(
                                        color: subText,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    fmt(spent),
                                    style: TextStyle(
                                      color: statusColor,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${pct.round()}%',
                                    style: TextStyle(
                                      color: statusColor,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(20),
                            child: LinearProgressIndicator(
                              value:
                                  (pct / 100).clamp(0, 1),
                              minHeight: 7,
                              backgroundColor:
                                  isDark
                                      ? const Color(
                                        0xFF0F172A,
                                      )
                                      : const Color(
                                        0xFFF1F5F9,
                                      ),
                              valueColor:
                                  AlwaysStoppedAnimation(
                                statusColor,
                              ),
                            ),
                          ),

                          if (isOver) ...[
                            const SizedBox(height: 8),
                            Align(
                              alignment:
                                  Alignment.centerLeft,
                              child: Text(
                                '⚠️ Over budget by ${fmt(spent - budget.limit)}',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 28),

                // GOALS
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Text(
                    '🎯 Financial Goals',
                    style: TextStyle(
                      color: mainText,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                ...goals.map((goal) {
                  final pct =
                      (goal['current'] / goal['target']) *
                          100;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 6,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius:
                            BorderRadius.circular(20),
                        border: Border.all(
                          color: borderColor,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                goal['icon'],
                                style: const TextStyle(
                                  fontSize: 30,
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                      children: [
                                        Text(
                                          goal['name'],
                                          style: TextStyle(
                                            color: mainText,
                                            fontWeight:
                                                FontWeight
                                                    .w600,
                                          ),
                                        ),
                                        Text(
                                          '${pct.round()}%',
                                          style: TextStyle(
                                            color:
                                                goal['color'],
                                            fontWeight:
                                                FontWeight
                                                    .bold,
                                          ),
                                        ),
                                      ],
                                    ),

                                    Text(
                                      '${fmt(goal['current'])} of ${fmt(goal['target'])}',
                                      style: TextStyle(
                                        color: subText,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(20),
                            child: LinearProgressIndicator(
                              value: pct / 100,
                              minHeight: 7,
                              backgroundColor:
                                  isDark
                                      ? const Color(
                                        0xFF0F172A,
                                      )
                                      : const Color(
                                        0xFFF1F5F9,
                                      ),
                              valueColor:
                                  AlwaysStoppedAnimation(
                                goal['color'],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),

            // ADD BUDGET SHEET
            if (showAddBudget)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      showAddBudget = false;
                    });
                  },
                  child: Container(
                    color: Colors.black54,
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color:
                              isDark
                                  ? const Color(
                                    0xFF1E293B,
                                  )
                                  : Colors.white,
                          borderRadius:
                              const BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Set Category Budget',
                              style: TextStyle(
                                color: mainText,
                                fontSize: 18,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 20),

                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: app.categories
                                  .where(
                                    (c) =>
                                        c.type ==
                                        'expense',
                                  )
                                  .map((cat) {
                                final selected =
                                    newCatId == cat.id;

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      newCatId = cat.id;
                                    });
                                  },
                                  child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 10,
                                    ),
                                    decoration:
                                        BoxDecoration(
                                      color: selected
                                          ? cat.color
                                              .withOpacity(
                                                0.15,
                                              )
                                          : inputBg,
                                      borderRadius:
                                          BorderRadius.circular(
                                        14,
                                      ),
                                      border:
                                          Border.all(
                                        color: selected
                                            ? cat.color
                                            : borderColor,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize:
                                          MainAxisSize.min,
                                      children: [
                                        Text(cat.icon),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Text(
                                          cat.name,
                                          style:
                                              TextStyle(
                                            color: selected
                                                ? cat.color
                                                : subText,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),

                            const SizedBox(height: 20),

                            TextField(
                              controller: limitController,
                              keyboardType:
                                  TextInputType.number,
                              style: TextStyle(
                                color: mainText,
                              ),
                              decoration: InputDecoration(
                                hintText:
                                    'Monthly Limit',
                                hintStyle: TextStyle(
                                  color: subText,
                                ),
                                filled: true,
                                fillColor: inputBg,
                                border:
                                    OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                    16,
                                  ),
                                  borderSide:
                                      BorderSide.none,
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        showAddBudget =
                                            false;
                                      });
                                    },
                                    child:
                                        const Text(
                                      'Cancel',
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (newCatId
                                              .isEmpty ||
                                          limitController
                                              .text
                                              .isEmpty) {
                                        return;
                                      }

                                      app.addBudget(
                                        categoryId:
                                            newCatId,
                                        limit: double.parse(
                                          limitController
                                              .text,
                                        ),
                                        month:
                                            currentMonth,
                                      );

                                      setState(() {
                                        showAddBudget =
                                            false;
                                        newCatId = '';
                                        limitController
                                            .clear();
                                      });
                                    },
                                    style:
                                        ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color(
                                        0xFF00C853,
                                      ),
                                    ),
                                    child:
                                        const Text(
                                      'Set Budget',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}