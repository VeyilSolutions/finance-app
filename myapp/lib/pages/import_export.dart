import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ImportExportScreen extends StatefulWidget {
  final List<Map<String, dynamic>> transactions;
  final bool isDark;

  const ImportExportScreen({
    super.key,
    required this.transactions,
    this.isDark = false,
  });

  @override
  State<ImportExportScreen> createState() => _ImportExportScreenState();
}

class _ImportExportScreenState extends State<ImportExportScreen> {
  final Map<String, String> actions = {
    'importExcel': 'idle',
    'exportExcel': 'idle',
    'exportCSV': 'idle',
    'exportPDF': 'idle',
    'backup': 'idle',
    'restore': 'idle',
  };

  bool dragOver = false;

  late bool isDark;
  late Color cardBg;
  late Color mainText;
  late Color subText;
  late Color borderColor;

  @override
  void initState() {
    super.initState();

    isDark = widget.isDark;

    cardBg = isDark
        ? const Color(0xFF1E293B)
        : Colors.white;

    mainText = isDark
        ? const Color(0xFFF8FAFC)
        : const Color(0xFF0F172A);

    subText = isDark
        ? const Color(0xFF64748B)
        : const Color(0xFF9CA3AF);

    borderColor = isDark
        ? Colors.white.withOpacity(0.06)
        : Colors.black.withOpacity(0.06);
  }

  Future<void> simulateAction(String key) async {
    setState(() {
      actions[key] = 'loading';
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      actions[key] = 'success';
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      actions[key] = 'idle';
    });
  }

  Future<void> exportJsonBackup() async {
    try {
      setState(() {
        actions['backup'] = 'loading';
      });

      final dir = await getTemporaryDirectory();

      final file = File(
        '${dir.path}/finance_backup.json',
      );

      await file.writeAsString(
        jsonEncode(widget.transactions),
      );

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Finance Backup',
      );

      setState(() {
        actions['backup'] = 'success';
      });
    } catch (e) {
      setState(() {
        actions['backup'] = 'error';
      });
    }
  }

  Future<void> exportCsv() async {
    try {
      setState(() {
        actions['exportCSV'] = 'loading';
      });

      String csv =
          'Date,Title,Amount,Type,Category,Notes\n';

      for (var tx in widget.transactions) {
        csv +=
            '${tx['date']},${tx['title']},${tx['amount']},${tx['type']},${tx['category']},${tx['notes'] ?? ''}\n';
      }

      final dir = await getTemporaryDirectory();

      final file = File(
        '${dir.path}/transactions.csv',
      );

      await file.writeAsString(csv);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Transactions CSV',
      );

      setState(() {
        actions['exportCSV'] = 'success';
      });
    } catch (e) {
      setState(() {
        actions['exportCSV'] = 'error';
      });
    }
  }

  Future<void> importFile() async {
    try {
      setState(() {
        actions['importExcel'] = 'loading';
      });

      final result =
          await FilePicker.platform.pickFiles();

      if (result == null) {
        setState(() {
          actions['importExcel'] = 'idle';
        });
        return;
      }

      await Future.delayed(
        const Duration(seconds: 2),
      );

      setState(() {
        actions['importExcel'] = 'success';
      });
    } catch (e) {
      setState(() {
        actions['importExcel'] = 'error';
      });
    }
  }

  Widget buildStatus(String status) {
    switch (status) {
      case 'loading':
        return const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        );

      case 'success':
        return const Icon(
          Icons.check_circle,
          color: Color(0xFF00C853),
          size: 18,
        );

      case 'error':
        return const Icon(
          Icons.cancel,
          color: Color(0xFFFF5252),
          size: 18,
        );

      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    final incomeCount = widget.transactions
        .where((e) => e['type'] == 'income')
        .length;

    final expenseCount = widget.transactions
        .where((e) => e['type'] == 'expense')
        .length;

    final sizeKb = (jsonEncode(widget.transactions)
                .length /
            1024)
        .toStringAsFixed(1);

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0F172A)
          : const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            bottom: 20,
          ),
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
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius:
                              BorderRadius.circular(14),
                          border: Border.all(
                            color: borderColor,
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: mainText,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      'Import / Export',
                      style: TextStyle(
                        color: mainText,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),

              /// STATS
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    statCard(
                      'Transactions',
                      widget.transactions.length.toString(),
                      const Color(0xFF2979FF),
                    ),
                    const SizedBox(width: 10),
                    statCard(
                      'Income',
                      incomeCount.toString(),
                      const Color(0xFF00C853),
                    ),
                    const SizedBox(width: 10),
                    statCard(
                      'Expenses',
                      expenseCount.toString(),
                      const Color(0xFFFF5252),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// IMPORT SECTION
              sectionTitle('📥 Import Data'),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: importFile,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius:
                          BorderRadius.circular(28),
                      border: Border.all(
                        color: const Color(0xFF2979FF),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF2979FF,
                            ).withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.upload,
                            color: Color(0xFF2979FF),
                            size: 32,
                          ),
                        ),

                        const SizedBox(height: 16),

                        Text(
                          'Tap to Import File',
                          style: TextStyle(
                            color: mainText,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          'Supports .xlsx, .xls, .csv',
                          style: TextStyle(
                            color: subText,
                            fontSize: 12,
                          ),
                        ),

                        const SizedBox(height: 16),

                        if (actions['importExcel'] !=
                            'idle')
                          buildStatus(
                            actions['importExcel']!,
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// EXPORT SECTION
              sectionTitle('📤 Export Data'),

              exportTile(
                emoji: '📊',
                title: 'Export CSV',
                subtitle: 'Download transaction CSV',
                color: const Color(0xFF4ECDC4),
                onTap: exportCsv,
                status: actions['exportCSV']!,
              ),

              exportTile(
                emoji: '📄',
                title: 'Export PDF',
                subtitle: 'Generate finance report',
                color: const Color(0xFFFF5252),
                onTap: () => simulateAction(
                  'exportPDF',
                ),
                status: actions['exportPDF']!,
              ),

              exportTile(
                emoji: '📁',
                title: 'Export Excel',
                subtitle: 'Generate Excel sheet',
                color: const Color(0xFF00C853),
                onTap: () => simulateAction(
                  'exportExcel',
                ),
                status: actions['exportExcel']!,
              ),

              const SizedBox(height: 24),

              /// BACKUP SECTION
              sectionTitle('🔒 Backup & Restore'),

              exportTile(
                emoji: '💾',
                title: 'Create Backup',
                subtitle: 'Save all app data',
                color: const Color(0xFF2979FF),
                onTap: exportJsonBackup,
                status: actions['backup']!,
              ),

              exportTile(
                emoji: '♻️',
                title: 'Restore Backup',
                subtitle: 'Import previous backup',
                color: const Color(0xFFA29BFE),
                onTap: () => simulateAction(
                  'restore',
                ),
                status: actions['restore']!,
              ),

              Padding(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFF2979FF,
                    ).withOpacity(0.06),
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Data Size: $sizeKb KB',
                    style: TextStyle(
                      color: subText,
                      fontSize: 12,
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

  Widget statCard(
    String label,
    String value,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: borderColor,
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: subText,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 12,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            color: mainText,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget exportTile({
    required String emoji,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    required String status,
  }) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius:
                BorderRadius.circular(22),
            border: Border.all(
              color: borderColor,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius:
                      BorderRadius.circular(18),
                ),
                child: Center(
                  child: Text(
                    emoji,
                    style: const TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: mainText,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: subText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              status == 'idle'
                  ? Icon(
                      Icons.download,
                      color: color,
                    )
                  : buildStatus(status),
            ],
          ),
        ),
      ),
    );
  }
}