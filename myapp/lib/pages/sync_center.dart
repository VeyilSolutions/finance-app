import 'dart:async';
import 'package:flutter/material.dart';

class SyncCenterPage extends StatefulWidget {
  const SyncCenterPage({super.key});

  @override
  State<SyncCenterPage> createState() => _SyncCenterPageState();
}

class _SyncCenterPageState extends State<SyncCenterPage> {
  bool isDark = true;
  bool isSyncing = false;
  bool isOnline = true;

  double syncProgress = 0;

  final String lastSynced = '2026-05-08 at 4:32 PM';

  final List<Map<String, dynamic>> transactions = [
    {
      'id': 1,
      'title': 'Salary',
      'amount': 45000,
      'type': 'income',
      'syncStatus': 'synced',
    },
    {
      'id': 2,
      'title': 'Groceries',
      'amount': 2400,
      'type': 'expense',
      'syncStatus': 'pending',
    },
    {
      'id': 3,
      'title': 'Electricity Bill',
      'amount': 1800,
      'type': 'expense',
      'syncStatus': 'failed',
    },
  ];

  List<Map<String, dynamic>> get pendingTxns =>
      transactions.where((t) => t['syncStatus'] == 'pending').toList();

  List<Map<String, dynamic>> get failedTxns =>
      transactions.where((t) => t['syncStatus'] == 'failed').toList();

  List<Map<String, dynamic>> get syncedTxns =>
      transactions.where((t) => t['syncStatus'] == 'synced').toList();

  List<Map<String, dynamic>> get syncQueue => [
        ...pendingTxns,
        ...failedTxns,
      ];

  Future<void> handleSync() async {
    if (isSyncing) return;

    setState(() {
      isSyncing = true;
      syncProgress = 0;
    });

    Timer.periodic(const Duration(milliseconds: 120), (timer) {
      if (syncProgress >= 100) {
        timer.cancel();

        setState(() {
          isSyncing = false;
          syncProgress = 100;
        });
      } else {
        setState(() {
          syncProgress += 5;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);

    final cardBg =
        isDark ? const Color(0xFF1E293B) : Colors.white;

    final mainText =
        isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);

    final subText =
        isDark ? const Color(0xFF64748B) : const Color(0xFF9CA3AF);

    final borderColor =
        isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.06);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            /// HEADER
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
              child: Row(
                children: [
                  _iconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    bg: cardBg,
                    border: borderColor,
                    iconColor: mainText,
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Sync Center',
                      style: TextStyle(
                        color: mainText,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: handleSync,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2979FF).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFF2979FF).withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          isSyncing
                              ? const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFF2979FF),
                                  ),
                                )
                              : const Icon(
                                  Icons.refresh_rounded,
                                  color: Color(0xFF2979FF),
                                  size: 16,
                                ),
                          const SizedBox(width: 6),
                          const Text(
                            'Sync',
                            style: TextStyle(
                              color: Color(0xFF2979FF),
                              fontSize: 12,
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

            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  /// CONNECTIVITY
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isOnline
                          ? const Color(0xFF00C853).withOpacity(0.08)
                          : const Color(0xFFFF5252).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isOnline
                            ? const Color(0xFF00C853).withOpacity(0.2)
                            : const Color(0xFFFF5252).withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isOnline ? Icons.wifi : Icons.wifi_off,
                          color: isOnline
                              ? const Color(0xFF00C853)
                              : const Color(0xFFFF5252),
                          size: 24,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                isOnline
                                    ? 'Connected to Internet'
                                    : 'No Internet Connection',
                                style: TextStyle(
                                  color: isOnline
                                      ? const Color(0xFF00C853)
                                      : const Color(0xFFFF5252),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isOnline
                                    ? 'Ready to sync'
                                    : 'Sync unavailable until reconnected',
                                style: TextStyle(
                                  color: subText,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: isOnline
                                ? const Color(0xFF00C853)
                                : const Color(0xFFFF5252),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// STORAGE MODE
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFFA29BFE).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.cloud_off_rounded,
                            color: Color(0xFFA29BFE),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Storage: Local Only',
                                style: TextStyle(
                                  color: mainText,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Data stored on this device',
                                style: TextStyle(
                                  color: subText,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF2979FF).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Change',
                            style: TextStyle(
                              color: Color(0xFF2979FF),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// SYNC PROGRESS
                  if (isSyncing)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color:
                            const Color(0xFF2979FF).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF2979FF)
                              .withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFF2979FF),
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Syncing...',
                                style: TextStyle(
                                  color: Color(0xFF2979FF),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${syncProgress.toInt()}%',
                                style: const TextStyle(
                                  color: Color(0xFF2979FF),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: LinearProgressIndicator(
                              value: syncProgress / 100,
                              minHeight: 6,
                              backgroundColor: const Color(0xFF2979FF)
                                  .withOpacity(0.1),
                              valueColor:
                                  const AlwaysStoppedAnimation<Color>(
                                Color(0xFF2979FF),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 18),

                  /// STATS
                  Row(
                    children: [
                      Expanded(
                        child: _statCard(
                          label: 'Synced',
                          value: syncedTxns.length.toString(),
                          icon: Icons.check_circle,
                          color: const Color(0xFF00C853),
                          bg: const Color(0xFF00C853).withOpacity(0.1),
                          cardBg: cardBg,
                          borderColor: borderColor,
                          subText: subText,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _statCard(
                          label: 'Pending',
                          value: pendingTxns.length.toString(),
                          icon: Icons.schedule,
                          color: const Color(0xFFFFD54F),
                          bg: const Color(0xFFFFD54F).withOpacity(0.1),
                          cardBg: cardBg,
                          borderColor: borderColor,
                          subText: subText,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _statCard(
                          label: 'Failed',
                          value: failedTxns.length.toString(),
                          icon: Icons.cancel,
                          color: const Color(0xFFFF5252),
                          bg: const Color(0xFFFF5252).withOpacity(0.1),
                          cardBg: cardBg,
                          borderColor: borderColor,
                          subText: subText,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// LAST SYNC
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(0.03)
                          : Colors.black.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          color: subText,
                          size: 16,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Last synced: $lastSynced',
                          style: TextStyle(
                            color: subText,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// SYNC QUEUE
                  if (syncQueue.isNotEmpty) ...[
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Sync Queue (${syncQueue.length})',
                            style: TextStyle(
                              color: mainText,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: handleSync,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF5252)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.refresh_rounded,
                                  color: Color(0xFFFF5252),
                                  size: 14,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Retry All',
                                  style: TextStyle(
                                    color: Color(0xFFFF5252),
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

                    const SizedBox(height: 14),

                    ...syncQueue.map(
                      (item) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: item['syncStatus'] == 'failed'
                                ? const Color(0xFFFF5252)
                                    .withOpacity(0.2)
                                : borderColor,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: item['syncStatus'] == 'failed'
                                    ? const Color(0xFFFF5252)
                                        .withOpacity(0.1)
                                    : const Color(0xFFFFD54F)
                                        .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                item['syncStatus'] == 'failed'
                                    ? Icons.cancel
                                    : Icons.schedule,
                                color: item['syncStatus'] == 'failed'
                                    ? const Color(0xFFFF5252)
                                    : const Color(0xFFFFD54F),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'],
                                    style: TextStyle(
                                      color: mainText,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item['syncStatus'] == 'failed'
                                        ? 'Upload failed - tap to retry'
                                        : 'Waiting to sync',
                                    style: TextStyle(
                                      color: subText,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${item['type'] == 'income' ? '+' : '-'}₹${item['amount']}',
                              style: TextStyle(
                                color: item['type'] == 'income'
                                    ? const Color(0xFF00C853)
                                    : const Color(0xFFFF5252),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  if (syncQueue.isEmpty && !isSyncing)
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF00C853).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_circle,
                            color: Color(0xFF00C853),
                            size: 42,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'All caught up!',
                          style: TextStyle(
                            color: mainText,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'All your transactions are in sync',
                          style: TextStyle(
                            color: subText,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 30),

                  /// SYNC BUTTON
                  SizedBox(
                    height: 58,
                    child: ElevatedButton(
                      onPressed: isSyncing ? null : handleSync,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2979FF),
                        disabledBackgroundColor:
                            const Color(0xFF2979FF).withOpacity(0.4),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.cloud, color: Colors.white),
                          const SizedBox(width: 10),
                          Text(
                            isSyncing ? 'Syncing...' : 'Sync Now',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
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
      ),
    );
  }

  Widget _iconButton({
    required IconData icon,
    required Color bg,
    required Color border,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border),
        ),
        child: Icon(icon, color: iconColor, size: 18),
      ),
    );
  }

  Widget _statCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    required Color bg,
    required Color cardBg,
    required Color borderColor,
    required Color subText,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: subText,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}