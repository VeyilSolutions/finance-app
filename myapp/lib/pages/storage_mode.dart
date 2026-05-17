import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageModeScreen extends StatefulWidget {
  const StorageModeScreen({super.key});

  @override
  State<StorageModeScreen> createState() => _StorageModeScreenState();
}

class _StorageModeScreenState extends State<StorageModeScreen>
    with TickerProviderStateMixin {
  String selected = 'local';

  Future<void> handleContinue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('petpro_storage_mode', selected);

    if (!mounted) return;
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF0F172A);
    const primaryBlue = Color(0xFF2979FF);
    const primaryGreen = Color(0xFF00C853);
    const textPrimary = Color(0xFFF8FAFC);
    const textSecondary = Color(0xFF64748B);
    const textMuted = Color(0xFF475569);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              /// HEADER
              Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'STEP 2 OF 2',
                      style: TextStyle(
                        color: primaryBlue,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Choose Storage\nMode',
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'How would you like to store your financial data?',
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              /// OPTIONS
              Expanded(
                child: Column(
                  children: [
                    StorageCard(
                      isSelected: selected == 'local',
                      title: 'Local Only',
                      icon: Icons.storage_rounded,
                      iconColor: primaryGreen,
                      borderColor: primaryGreen,
                      badgeIcon: Icons.shield_rounded,
                      badgeText: 'Recommended for privacy',
                      badgeColor: primaryGreen,
                      points: const [
                        'All data stored on your device',
                        'Works fully offline',
                        'Complete privacy',
                        '0 data charges',
                      ],
                      onTap: () {
                        setState(() {
                          selected = 'local';
                        });
                      },
                    ),

                    const SizedBox(height: 18),

                    StorageCard(
                      isSelected: selected == 'cloud',
                      title: 'Supabase Cloud Sync',
                      icon: Icons.cloud_rounded,
                      iconColor: primaryBlue,
                      borderColor: primaryBlue,
                      badgeIcon: Icons.wifi_rounded,
                      badgeText: 'Requires internet connection',
                      badgeColor: primaryBlue,
                      points: const [
                        'Sync across all devices',
                        'Auto cloud backup',
                        'Access anywhere',
                        'Multi-device support',
                      ],
                      onTap: () {
                        setState(() {
                          selected = 'cloud';
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'You can change this anytime in Settings',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textMuted,
                        fontSize: 11,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              /// CONTINUE BUTTON
              Padding(
                padding: const EdgeInsets.only(bottom: 24, top: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: handleContinue,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        gradient: const LinearGradient(
                          colors: [
                            primaryGreen,
                            primaryBlue,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: primaryBlue.withOpacity(0.3),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Continue',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: Colors.white,
                              size: 22,
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
      ),
    );
  }
}

class StorageCard extends StatelessWidget {
  final bool isSelected;
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color borderColor;
  final List<String> points;
  final String badgeText;
  final IconData badgeIcon;
  final Color badgeColor;
  final VoidCallback onTap;

  const StorageCard({
    super.key,
    required this.isSelected,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.borderColor,
    required this.points,
    required this.badgeText,
    required this.badgeIcon,
    required this.badgeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const textPrimary = Color(0xFFF8FAFC);
    const textSecondary = Color(0xFF94A3B8);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? borderColor
                : Colors.white.withOpacity(0.06),
            width: 1.5,
          ),
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    borderColor.withOpacity(0.15),
                    borderColor.withOpacity(0.05),
                  ],
                )
              : null,
          color: isSelected
              ? null
              : const Color(0xFF1E293B).withOpacity(0.8),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: iconColor.withOpacity(0.15),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 26,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                color: textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          if (isSelected)
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: borderColor,
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      ...points.map(
                        (point) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: borderColor,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  point,
                                  style: const TextStyle(
                                    color: textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: badgeColor.withOpacity(0.1),
              ),
              child: Row(
                children: [
                  Icon(
                    badgeIcon,
                    size: 14,
                    color: badgeColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      badgeText,
                      style: TextStyle(
                        color: badgeColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}