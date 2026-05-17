import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  final List<dynamic> transactions;
  final dynamic settings;
  final dynamic user;

  final int unreadCount;

  final double Function(String month) getMonthlyIncome;
  final double Function(String month) getMonthlyExpenses;
  final double Function(String month) getMonthlySavings;
  final double Function() getTotalBalance;

  final List<dynamic> Function(String month, String type)
      getTransactionsByCategory;

  final dynamic Function(String id) getCategoryById;

  const DashboardPage({
    super.key,
    required this.transactions,
    required this.settings,
    required this.user,
    required this.unreadCount,
    required this.getMonthlyIncome,
    required this.getMonthlyExpenses,
    required this.getMonthlySavings,
    required this.getTotalBalance,
    required this.getTransactionsByCategory,
    required this.getCategoryById,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool balanceVisible = true;

  String fmt(num n) {
    return "₹${NumberFormat('#,##,###').format(n)}";
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.settings.darkMode ?? false;

    final currentMonth =
        "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}";

    final income = widget.getMonthlyIncome(currentMonth);
    final expenses = widget.getMonthlyExpenses(currentMonth);
    final savings = widget.getMonthlySavings(currentMonth);
    final totalBalance = widget.getTotalBalance();

    final savingsRate =
        income > 0 ? ((savings / income) * 100).round() : 0;

    final pieData =
        widget.getTransactionsByCategory(currentMonth, 'expense');

    final recentTxns = widget.transactions.take(6).toList();

    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;

    final bgColor = isDark
        ? const Color(0xFF0F172A)
        : const Color(0xFFF8FAFC);

    final subText =
        isDark ? const Color(0xFF64748B) : const Color(0xFF9CA3AF);

    final mainText =
        isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);

    final borderColor = isDark
        ? Colors.white.withOpacity(0.06)
        : Colors.black.withOpacity(0.06);

    final now = DateTime.now();

    String greeting = "Good Evening";

    if (now.hour < 12) {
      greeting = "Good Morning";
    } else if (now.hour < 17) {
      greeting = "Good Afternoon";
    }

    final dayName =
        DateFormat('EEEE, d MMM').format(now);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            children: [
              /// HEADER
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            dayName,
                            style: TextStyle(
                              color: subText,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "$greeting, ${widget.user.name.split(" ")[0]} 👋",
                            style: TextStyle(
                              color: mainText,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// notification
                    Stack(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, '/notifications');
                          },
                          icon: Icon(
                            Icons.notifications_none_rounded,
                            color: subText,
                          ),
                        ),
                        if (widget.unreadCount > 0)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                widget.unreadCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ],
                    ),

                    const SizedBox(width: 8),

                    CircleAvatar(
                      radius: 18,
                      backgroundColor:
                          const Color(0xFF2979FF),
                      child: Text(
                        widget.user.name[0],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),

              /// BALANCE CARD
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
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
                          const Text(
                            "Total Balance",
                            style: TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 12,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                balanceVisible =
                                    !balanceVisible;
                              });
                            },
                            icon: Icon(
                              balanceVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color:
                                  const Color(0xFF94A3B8),
                              size: 18,
                            ),
                          )
                        ],
                      ),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          balanceVisible
                              ? fmt(totalBalance)
                              : "₹ ••••••",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: _infoCard(
                              title: "Income",
                              value: balanceVisible
                                  ? fmt(income)
                                  : "••••",
                              color: Colors.green,
                              icon: Icons.trending_up,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _infoCard(
                              title: "Expenses",
                              value: balanceVisible
                                  ? fmt(expenses)
                                  : "••••",
                              color: Colors.red,
                              icon: Icons.trending_down,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      Row(
                        children: [
                          const Icon(
                            Icons.savings,
                            color: Color(0xFFFFD54F),
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Savings Rate",
                            style: TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 12,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(30),
                              color: const Color(
                                      0xFFFFD54F)
                                  .withOpacity(0.1),
                            ),
                            child: Text(
                              "$savingsRate%",
                              style: const TextStyle(
                                color: Color(0xFFFFD54F),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// SUMMARY GRID
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20),
                child: GridView(
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.4,
                  ),
                  children: [
                    _summaryTile(
                      "Monthly Income",
                      fmt(income),
                      Colors.green,
                      Icons.trending_up,
                      cardBg,
                      borderColor,
                    ),
                    _summaryTile(
                      "Monthly Expenses",
                      fmt(expenses),
                      Colors.red,
                      Icons.trending_down,
                      cardBg,
                      borderColor,
                    ),
                    _summaryTile(
                      "Net Savings",
                      fmt(savings),
                      Colors.blue,
                      Icons.savings,
                      cardBg,
                      borderColor,
                    ),
                    _summaryTile(
                      "Balance",
                      fmt(totalBalance),
                      Colors.orange,
                      Icons.account_balance_wallet,
                      cardBg,
                      borderColor,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// PIE CHART
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Spending Breakdown",
                        style: TextStyle(
                          color: mainText,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20),

                      if (pieData.isEmpty)
                        Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.all(30),
                            child: Text(
                              "No expense data",
                              style: TextStyle(
                                color: subText,
                              ),
                            ),
                          ),
                        )
                      else
                        SizedBox(
                          height: 220,
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 3,
                              centerSpaceRadius: 45,
                              sections: pieData
                                  .map<PieChartSectionData>(
                                      (item) {
                                return PieChartSectionData(
                                  value: item.value
                                      .toDouble(),
                                  color: Color(
                                    int.parse(
                                      item.color
                                          .replaceAll(
                                              "#", "0xff"),
                                    ),
                                  ),
                                  title: '',
                                  radius: 70,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// RECENT TRANSACTIONS
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Recent Transactions",
                          style: TextStyle(
                            color: mainText,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context,
                                '/transactions');
                          },
                          child: const Text("See All"),
                        )
                      ],
                    ),

                    const SizedBox(height: 12),

                    ...recentTxns.map((tx) {
                      final cat =
                          widget.getCategoryById(tx.category);

                      return Container(
                        margin:
                            const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius:
                              BorderRadius.circular(22),
                          border:
                              Border.all(color: borderColor),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(14),
                                color: Color(
                                  int.parse(cat.color
                                      .replaceAll(
                                          "#", "0xff")),
                                ).withOpacity(0.12),
                              ),
                              child: Text(
                                cat.icon,
                                style: const TextStyle(
                                  fontSize: 22,
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  Text(
                                    tx.title,
                                    style: TextStyle(
                                      color: mainText,
                                      fontWeight:
                                          FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${tx.date} • ${tx.paymentMethod}",
                                    style: TextStyle(
                                      color: subText,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Text(
                              "${tx.type == 'income' ? '+' : '-'}${fmt(tx.amount)}",
                              style: TextStyle(
                                color: tx.type ==
                                        'income'
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      );
                    }).toList()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: color.withOpacity(0.1),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 11,
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  Widget _summaryTile(
    String title,
    String value,
    Color color,
    IconData icon,
    Color bg,
    Color border,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius:
                  BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: color,
              size: 18,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}