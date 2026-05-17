import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/app_provider.dart';

class ProfileScreen extends StatelessWidget {
  final AppProvider app;

  const ProfileScreen({
    super.key,
    required this.app,
  });

  String fmt(num value) {
    return "₹${value.toStringAsFixed(0)}";
  }

  @override
  Widget build(BuildContext context) {
    final isDark = app.settings.darkMode;

    final cardBg =
        isDark ? const Color(0xFF1E293B) : Colors.white;

    final bg =
        isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);

    final mainText =
        isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);

    final subText =
        isDark ? const Color(0xFF64748B) : const Color(0xFF9CA3AF);

    final borderColor =
        isDark
            ? Colors.white.withOpacity(0.06)
            : Colors.black.withOpacity(0.06);

    final now = DateTime.now();

    final currentMonth =
        "${now.year}-${now.month.toString().padLeft(2, '0')}";

    final income = app.getMonthlyIncome(currentMonth);

    final expenses = app.getMonthlyExpenses(currentMonth);

    final savings = app.getMonthlySavings(currentMonth);

    final totalBalance = app.getTotalBalance();

    final totalTransactions = app.transactions.length;

    final totalCategories = app.categories.length;

    final achievements = [
      {
        "icon": "🏆",
        "title": "Budget Master",
        "desc": "Stayed under budget 3 months",
        "unlocked": savings > 0,
      },
      {
        "icon": "💰",
        "title": "Savings Champ",
        "desc": "Saved over target",
        "unlocked": savings > 50000,
      },
      {
        "icon": "📊",
        "title": "Analytics Pro",
        "desc": "Tracked 30+ transactions",
        "unlocked": totalTransactions >= 30,
      },
      {
        "icon": "🎯",
        "title": "Goal Getter",
        "desc": "Completed goals",
        "unlocked": app.goals.isNotEmpty,
      },
      {
        "icon": "⚡",
        "title": "Speed Tracker",
        "desc": "Added 100 transactions",
        "unlocked": totalTransactions >= 100,
      },
      {
        "icon": "🌟",
        "title": "Power User",
        "desc": "Used all features",
        "unlocked": false,
      },
    ];

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            children: [
              /// HEADER
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: borderColor,
                          ),
                        ),
                        child: Icon(
                          LucideIcons.arrowLeft,
                          color: mainText,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Profile",
                      style: TextStyle(
                        color: mainText,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              /// HERO CARD
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF0D2137),
                      Color(0xFF0A1F3A),
                    ],
                  ),
                  border: Border.all(
                    color: const Color(0x332979FF),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 74,
                          height: 74,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF00C853),
                                Color(0xFF2979FF),
                              ],
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            app.user.name.isNotEmpty
                                ? app.user.name[0].toUpperCase()
                                : "U",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                app.user.name,
                                style: const TextStyle(
                                  color: Color(0xFFF8FAFC),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Row(
                                children: [
                                  const Icon(
                                    LucideIcons.mail,
                                    size: 12,
                                    color: Color(0xFF94A3B8),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      app.user.email,
                                      style: const TextStyle(
                                        color:
                                            Color(0xFF94A3B8),
                                        fontSize: 12,
                                      ),
                                      overflow:
                                          TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 4),

                              Row(
                                children: [
                                  const Icon(
                                    LucideIcons.phone,
                                    size: 12,
                                    color: Color(0xFF94A3B8),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    app.user.phone,
                                    style: const TextStyle(
                                      color:
                                          Color(0xFF94A3B8),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        _badge(
                          icon: LucideIcons.star,
                          text: "Premium",
                          color: const Color(0xFFFFD54F),
                        ),
                        const SizedBox(width: 10),
                        _badge(
                          icon: LucideIcons.shield,
                          text: "Verified",
                          color: const Color(0xFF00C853),
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fade().slideY(begin: 0.1),

              const SizedBox(height: 24),

              /// SUMMARY
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      "This Month Summary",
                      style: TextStyle(
                        color: mainText,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 14),

                    GridView.count(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.3,
                      children: [
                        _summaryCard(
                          title: "Total Balance",
                          value: fmt(totalBalance),
                          color: const Color(0xFF2979FF),
                          icon: LucideIcons.wallet,
                          bg: cardBg,
                          borderColor: borderColor,
                          subText: subText,
                        ),
                        _summaryCard(
                          title: "Monthly Income",
                          value: fmt(income),
                          color: const Color(0xFF00C853),
                          icon: LucideIcons.trendingUp,
                          bg: cardBg,
                          borderColor: borderColor,
                          subText: subText,
                        ),
                        _summaryCard(
                          title: "Monthly Expenses",
                          value: fmt(expenses),
                          color: const Color(0xFFFF5252),
                          icon: LucideIcons.trendingDown,
                          bg: cardBg,
                          borderColor: borderColor,
                          subText: subText,
                        ),
                        _summaryCard(
                          title: "Net Savings",
                          value: fmt(savings),
                          color: const Color(0xFFFFD54F),
                          icon: LucideIcons.award,
                          bg: cardBg,
                          borderColor: borderColor,
                          subText: subText,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// QUICK STATS
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceAround,
                  children: [
                    _stat(
                      "Transactions",
                      totalTransactions.toString(),
                      mainText,
                      subText,
                    ),
                    _divider(borderColor),
                    _stat(
                      "Categories",
                      totalCategories.toString(),
                      mainText,
                      subText,
                    ),
                    _divider(borderColor),
                    _stat(
                      "Member Since",
                      app.user.createdAt != null
                          ? "${app.user.createdAt!.year}"
                          : "2025",
                      mainText,
                      subText,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// ACHIEVEMENTS
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      "🏆 Achievements",
                      style: TextStyle(
                        color: mainText,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 14),

                    GridView.builder(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      itemCount: achievements.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.9,
                      ),
                      itemBuilder: (_, index) {
                        final ach = achievements[index];

                        final unlocked =
                            ach['unlocked'] as bool;

                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: unlocked
                                ? cardBg
                                : cardBg.withOpacity(0.4),
                            borderRadius:
                                BorderRadius.circular(22),
                            border: Border.all(
                              color: borderColor,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Text(
                                ach['icon'].toString(),
                                style: TextStyle(
                                  fontSize: 30,
                                  color: unlocked
                                      ? null
                                      : Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                ach['title'].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: mainText,
                                  fontSize: 10,
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),
                              if (!unlocked)
                                Padding(
                                  padding:
                                      const EdgeInsets.only(
                                          top: 4),
                                  child: Text(
                                    "Locked",
                                    style: TextStyle(
                                      color: subText,
                                      fontSize: 9,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// SETTINGS LINKS
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _menuItem(
                      icon: LucideIcons.user,
                      title: "Edit Profile",
                      color: const Color(0xFF2979FF),
                      onTap: () {},
                      bg: cardBg,
                      borderColor: borderColor,
                      textColor: mainText,
                      subText: subText,
                    ),
                    _menuItem(
                      icon: LucideIcons.shield,
                      title: "Privacy & Security",
                      color: const Color(0xFF00C853),
                      onTap: () {},
                      bg: cardBg,
                      borderColor: borderColor,
                      textColor: mainText,
                      subText: subText,
                    ),
                    _menuItem(
                      icon: LucideIcons.helpCircle,
                      title: "Help & Support",
                      color: const Color(0xFFA29BFE),
                      onTap: () {},
                      bg: cardBg,
                      borderColor: borderColor,
                      textColor: mainText,
                      subText: subText,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// LOGOUT
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await app.logout();

                        if (context.mounted) {
                          context.go('/login');
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0x14FF5252,
                          ),
                          borderRadius:
                              BorderRadius.circular(22),
                          border: Border.all(
                            color: const Color(
                              0x33FF5252,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: const [
                            Icon(
                              LucideIcons.logOut,
                              color: Color(0xFFFF5252),
                              size: 18,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Sign Out",
                              style: TextStyle(
                                color: Color(0xFFFF5252),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      "v${app.appVersion}",
                      style: TextStyle(
                        color: subText,
                        fontSize: 11,
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

  Widget _badge({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: color.withOpacity(0.25),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
    required Color bg,
    required Color borderColor,
    required Color subText,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              size: 16,
              color: color,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: subText,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(
    String title,
    String value,
    Color mainText,
    Color subText,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: mainText,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            color: subText,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _divider(Color color) {
    return Container(
      width: 1,
      height: 34,
      color: color,
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
    required Color bg,
    required Color borderColor,
    required Color textColor,
    required Color subText,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: color,
                size: 18,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              LucideIcons.chevronRight,
              color: subText,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}