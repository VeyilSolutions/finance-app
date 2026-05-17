import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../models/app_notification.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();

    final notifications = app.notifications;
    final unread =
        notifications.where((n) => !n.read).toList();

    final isDark = app.settings.darkMode;

    final bgColor =
        isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);

    final cardBg =
        isDark ? const Color(0xFF1E293B) : Colors.white;

    final mainText =
        isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);

    final subText =
        isDark ? const Color(0xFF64748B) : const Color(0xFF9CA3AF);

    final borderColor = isDark
        ? const Color.fromRGBO(255, 255, 255, 0.06)
        : const Color.fromRGBO(0, 0, 0, 0.06);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            /// HEADER
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
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
                        border: Border.all(color: borderColor),
                      ),
                      child: Icon(
                        LucideIcons.arrowLeft,
                        size: 20,
                        color: mainText,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          'Notifications',
                          style: TextStyle(
                            color: mainText,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        if (unread.isNotEmpty) ...[
                          const SizedBox(width: 8),

                          Container(
                            width: 22,
                            height: 22,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF5252),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              unread.length.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  if (unread.isNotEmpty)
                    GestureDetector(
                      onTap: app.markAllNotificationsRead,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(
                            41,
                            121,
                            255,
                            0.1,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color.fromRGBO(
                              41,
                              121,
                              255,
                              0.2,
                            ),
                          ),
                        ),
                        child: Row(
                          children: const [
                            Icon(
                              LucideIcons.checkCheck,
                              size: 14,
                              color: Color(0xFF2979FF),
                            ),
                            SizedBox(width: 6),
                            Text(
                              'All Read',
                              style: TextStyle(
                                color: Color(0xFF2979FF),
                                fontSize: 11,
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

            /// UNREAD CARD
            if (unread.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(
                      41,
                      121,
                      255,
                      0.08,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color.fromRGBO(
                        41,
                        121,
                        255,
                        0.15,
                      ),
                    ),
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: Color(0xFF2979FF),
                        fontSize: 13,
                      ),
                      children: [
                        const TextSpan(text: 'You have '),
                        TextSpan(
                          text: unread.length.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: unread.length > 1
                              ? ' unread notifications'
                              : ' unread notification',
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            /// LIST
            Expanded(
              child: notifications.isEmpty
                  ? _EmptyState(
                      mainText: mainText,
                      subText: subText,
                      isDark: isDark,
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      itemCount: notifications.length + 1,
                      itemBuilder: (context, index) {
                        if (index == notifications.length) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              top: 20,
                              bottom: 30,
                            ),
                            child: Text(
                              'Tap a notification to mark as read',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: subText,
                                fontSize: 11,
                              ),
                            ),
                          );
                        }

                        final notif = notifications[index];

                        final config =
                            NotificationConfig.fromType(notif.type);

                        return GestureDetector(
                          onTap: () {
                            app.markNotificationRead(notif.id);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: notif.read
                                  ? cardBg
                                  : isDark
                                      ? const Color.fromRGBO(
                                          41,
                                          121,
                                          255,
                                          0.06,
                                        )
                                      : const Color.fromRGBO(
                                          41,
                                          121,
                                          255,
                                          0.03,
                                        ),
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: notif.read
                                    ? borderColor
                                    : const Color.fromRGBO(
                                        41,
                                        121,
                                        255,
                                        0.15,
                                      ),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                /// ICON
                                Container(
                                  width: 46,
                                  height: 46,
                                  decoration: BoxDecoration(
                                    color: config.bg,
                                    borderRadius:
                                        BorderRadius.circular(14),
                                  ),
                                  child: Icon(
                                    config.icon,
                                    size: 20,
                                    color: config.color,
                                  ),
                                ),

                                const SizedBox(width: 14),

                                /// CONTENT
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              notif.title,
                                              maxLines: 1,
                                              overflow:
                                                  TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: mainText,
                                                fontSize: 14,
                                                fontWeight:
                                                    notif.read
                                                        ? FontWeight.w500
                                                        : FontWeight.w700,
                                              ),
                                            ),
                                          ),

                                          if (!notif.read)
                                            Container(
                                              width: 8,
                                              height: 8,
                                              margin:
                                                  const EdgeInsets.only(
                                                left: 8,
                                              ),
                                              decoration:
                                                  const BoxDecoration(
                                                color:
                                                    Color(0xFF2979FF),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                        ],
                                      ),

                                      const SizedBox(height: 4),

                                      Text(
                                        notif.message,
                                        style: TextStyle(
                                          color: subText,
                                          fontSize: 12,
                                          height: 1.5,
                                        ),
                                      ),

                                      const SizedBox(height: 12),

                                      Row(
                                        children: [
                                          Container(
                                            padding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: config.bg,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      999),
                                            ),
                                            child: Text(
                                              config.label,
                                              style: TextStyle(
                                                color: config.color,
                                                fontSize: 10,
                                                fontWeight:
                                                    FontWeight.w600,
                                              ),
                                            ),
                                          ),

                                          const SizedBox(width: 10),

                                          Text(
                                            formatTime(notif.time),
                                            style: TextStyle(
                                              color: subText,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                              .animate()
                              .fade(duration: 350.ms)
                              .slideX(begin: -0.1),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String formatTime(DateTime date) {
    final now = DateTime.now();

    final diff = now.difference(date);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    }

    if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    }

    if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    }

    return DateFormat('dd MMM').format(date);
  }
}

class _EmptyState extends StatelessWidget {
  final Color mainText;
  final Color subText;
  final bool isDark;

  const _EmptyState({
    required this.mainText,
    required this.subText,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? const Color.fromRGBO(255, 255, 255, 0.05)
                    : const Color(0xFFF1F5F9),
              ),
              child: Icon(
                LucideIcons.bell,
                size: 42,
                color: subText,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'No notifications',
              style: TextStyle(
                color: mainText,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "We'll alert you about budgets,\nsyncs and achievements",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: subText,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// CONFIG

class NotificationConfig {
  final IconData icon;
  final Color color;
  final Color bg;
  final String label;

  NotificationConfig({
    required this.icon,
    required this.color,
    required this.bg,
    required this.label,
  });

  factory NotificationConfig.fromType(String type) {
    switch (type) {
      case 'budget_alert':
        return NotificationConfig(
          icon: LucideIcons.alertTriangle,
          color: const Color(0xFFFFD54F),
          bg: const Color.fromRGBO(255, 213, 79, 0.1),
          label: 'Budget Alert',
        );

      case 'sync_failed':
        return NotificationConfig(
          icon: LucideIcons.refreshCw,
          color: const Color(0xFFFF5252),
          bg: const Color.fromRGBO(255, 82, 82, 0.1),
          label: 'Sync Issue',
        );

      case 'achievement':
        return NotificationConfig(
          icon: LucideIcons.trophy,
          color: const Color(0xFF00C853),
          bg: const Color.fromRGBO(0, 200, 83, 0.1),
          label: 'Achievement',
        );

      case 'reminder':
        return NotificationConfig(
          icon: LucideIcons.clock,
          color: const Color(0xFF2979FF),
          bg: const Color.fromRGBO(41, 121, 255, 0.1),
          label: 'Reminder',
        );

      default:
        return NotificationConfig(
          icon: LucideIcons.bell,
          color: const Color(0xFF2979FF),
          bg: const Color.fromRGBO(41, 121, 255, 0.1),
          label: 'Notification',
        );
    }
  }
}