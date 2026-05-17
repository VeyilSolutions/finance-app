import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportsScreen extends StatefulWidget {
  final bool isDark;

  final List<Map<String, dynamic>> monthlyData;
  final List<Map<String, dynamic>> savingsTrend;
  final List<Map<String, dynamic>> spendingByCategory;

  final double income;
  final double expenses;
  final double savings;

  const ReportsScreen({
    super.key,
    required this.isDark,
    required this.monthlyData,
    required this.savingsTrend,
    required this.spendingByCategory,
    required this.income,
    required this.expenses,
    required this.savings,
  });

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String activeSection = 'overview';
  String dateRange = 'month';

  final List<Map<String, String>> tabs = [
    {'id': 'overview', 'label': 'Overview'},
    {'id': 'spending', 'label': 'Spending'},
    {'id': 'savings', 'label': 'Savings'},
    {'id': 'yearly', 'label': 'Trends'},
  ];

  String formatCurrency(num value) {
    return NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    ).format(value);
  }

  @override
  Widget build(BuildContext context) {
    final cardBg =
        widget.isDark ? const Color(0xFF1E293B) : Colors.white;

    final mainText =
        widget.isDark ? Colors.white : const Color(0xFF0F172A);

    final subText =
        widget.isDark ? const Color(0xFF64748B) : const Color(0xFF9CA3AF);

    final borderColor =
        widget.isDark
            ? Colors.white.withOpacity(0.06)
            : Colors.black.withOpacity(0.06);

    final savingsRate =
        widget.income > 0
            ? ((widget.savings / widget.income) * 100)
                .toStringAsFixed(1)
            : '0';

    return Scaffold(
      backgroundColor:
          widget.isDark
              ? const Color(0xFF0F172A)
              : const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            children: [
              /// HEADER
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
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
                        'Reports & Analytics',
                        style: TextStyle(
                          color: mainText,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(
                          0xFF2979FF,
                        ).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.download,
                            size: 16,
                            color: Color(0xFF2979FF),
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Export',
                            style: TextStyle(
                              color: Color(0xFF2979FF),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              /// DATE RANGE
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children:
                        ['week', 'month', 'quarter', 'year']
                            .map(
                              (range) => Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      dateRange = range;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          dateRange == range
                                              ? const Color(
                                                0xFF2979FF,
                                              ).withOpacity(0.15)
                                              : Colors.transparent,
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Text(
                                        range.toUpperCase(),
                                        style: TextStyle(
                                          color:
                                              dateRange == range
                                                  ? const Color(
                                                    0xFF2979FF,
                                                  )
                                                  : subText,
                                          fontSize: 11,
                                          fontWeight:
                                              dateRange == range
                                                  ? FontWeight.w600
                                                  : FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              /// KPI STRIP
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    buildKpiCard(
                      title: 'Income',
                      value: formatCurrency(widget.income),
                      color: const Color(0xFF00C853),
                      subText: '+12%',
                      cardBg: cardBg,
                      borderColor: borderColor,
                    ),

                    const SizedBox(width: 10),

                    buildKpiCard(
                      title: 'Expenses',
                      value: formatCurrency(widget.expenses),
                      color: const Color(0xFFFF5252),
                      subText: '-8%',
                      cardBg: cardBg,
                      borderColor: borderColor,
                    ),

                    const SizedBox(width: 10),

                    buildKpiCard(
                      title: 'Savings',
                      value: formatCurrency(widget.savings),
                      color: const Color(0xFF2979FF),
                      subText: '$savingsRate%',
                      cardBg: cardBg,
                      borderColor: borderColor,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              /// TABS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children:
                        tabs.map((tab) {
                          final selected =
                              activeSection == tab['id'];

                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  activeSection = tab['id']!;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      selected
                                          ? const Color(
                                            0xFF2979FF,
                                          ).withOpacity(0.15)
                                          : Colors.transparent,
                                  borderRadius:
                                      BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    tab['label']!,
                                    style: TextStyle(
                                      color:
                                          selected
                                              ? const Color(
                                                0xFF2979FF,
                                              )
                                              : subText,
                                      fontSize: 11,
                                      fontWeight:
                                          selected
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// OVERVIEW
              if (activeSection == 'overview')
                buildOverviewCard(
                  cardBg,
                  borderColor,
                  mainText,
                  subText,
                ),

              /// SPENDING
              if (activeSection == 'spending')
                buildSpendingCard(
                  cardBg,
                  borderColor,
                  mainText,
                  subText,
                ),

              /// SAVINGS
              if (activeSection == 'savings')
                buildSavingsCard(
                  cardBg,
                  borderColor,
                  mainText,
                  subText,
                ),

              /// YEARLY
              if (activeSection == 'yearly')
                buildTrendCard(
                  cardBg,
                  borderColor,
                  mainText,
                  subText,
                ),

              const SizedBox(height: 20),

              /// EXPORT BUTTONS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: buildExportButton(
                        icon: Icons.table_chart,
                        text: 'Export Excel',
                        color: const Color(0xFF00C853),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: buildExportButton(
                        icon: Icons.picture_as_pdf,
                        text: 'Export PDF',
                        color: const Color(0xFFFF5252),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildKpiCard({
    required String title,
    required String value,
    required Color color,
    required String subText,
    required Color cardBg,
    required Color borderColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subText,
              style: TextStyle(
                color: color.withOpacity(0.7),
                fontSize: 9,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOverviewCard(
    Color cardBg,
    Color borderColor,
    Color mainText,
    Color subText,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Income vs Expenses',
              style: TextStyle(
                color: mainText,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 220,
              child: BarChart(
                BarChartData(
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  alignment: BarChartAlignment.spaceAround,
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final month =
                              widget.monthlyData[value.toInt()]['month'];

                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              month,
                              style: TextStyle(
                                color: subText,
                                fontSize: 10,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups:
                      widget.monthlyData.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;

                        return BarChartGroupData(
                          x: index,
                          barsSpace: 4,
                          barRods: [
                            BarChartRodData(
                              toY:
                                  (item['income'] as num).toDouble(),
                              color: const Color(0xFF00C853),
                              width: 8,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            BarChartRodData(
                              toY:
                                  (item['expense'] as num).toDouble(),
                              color: const Color(0xFFFF5252),
                              width: 8,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ],
                        );
                      }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSpendingCard(
    Color cardBg,
    Color borderColor,
    Color mainText,
    Color subText,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Spending by Category',
              style: TextStyle(
                color: mainText,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              height: 220,
              child: PieChart(
                PieChartData(
                  sections:
                      widget.spendingByCategory.map((item) {
                        return PieChartSectionData(
                          value:
                              (item['value'] as num).toDouble(),
                          title: '',
                          radius: 60,
                          color: Color(item['color']),
                        );
                      }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 20),

            ...widget.spendingByCategory.map((item) {
              final percent =
                  widget.expenses > 0
                      ? ((item['value'] / widget.expenses) * 100)
                          .toStringAsFixed(0)
                      : '0';

              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Color(item['color']),
                        shape: BoxShape.circle,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        item['name'],
                        style: TextStyle(
                          color: mainText,
                          fontSize: 13,
                        ),
                      ),
                    ),

                    Text(
                      '$percent%',
                      style: TextStyle(
                        color: subText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget buildSavingsCard(
    Color cardBg,
    Color borderColor,
    Color mainText,
    Color subText,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Savings Trend',
              style: TextStyle(
                color: mainText,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 220,
              child: LineChart(
                LineChartData(
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      color: const Color(0xFF2979FF),
                      barWidth: 4,
                      spots:
                          widget.savingsTrend
                              .asMap()
                              .entries
                              .map(
                                (e) => FlSpot(
                                  e.key.toDouble(),
                                  (e.value['savings'] as num)
                                      .toDouble(),
                                ),
                              )
                              .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTrendCard(
    Color cardBg,
    Color borderColor,
    Color mainText,
    Color subText,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '6 Month Trends',
              style: TextStyle(
                color: mainText,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 220,
              child: LineChart(
                LineChartData(
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  lineBarsData: [
                    buildLine(
                      widget.monthlyData,
                      'income',
                      const Color(0xFF00C853),
                    ),

                    buildLine(
                      widget.monthlyData,
                      'expense',
                      const Color(0xFFFF5252),
                    ),

                    buildLine(
                      widget.monthlyData,
                      'savings',
                      const Color(0xFF2979FF),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LineChartBarData buildLine(
    List<Map<String, dynamic>> data,
    String key,
    Color color,
  ) {
    return LineChartBarData(
      isCurved: true,
      color: color,
      barWidth: 3,
      spots:
          data.asMap().entries.map((e) {
            return FlSpot(
              e.key.toDouble(),
              (e.value[key] as num).toDouble(),
            );
          }).toList(),
    );
  }

  Widget buildExportButton({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}