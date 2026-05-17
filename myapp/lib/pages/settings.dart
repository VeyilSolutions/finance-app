import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  bool darkMode;
  bool notifications;
  bool appLock;
  String currency;
  String language;
  String storageMode;
  String appVersion;

  AppSettings({
    required this.darkMode,
    required this.notifications,
    required this.appLock,
    required this.currency,
    required this.language,
    required this.storageMode,
    required this.appVersion,
  });
}

class AppProvider extends ChangeNotifier {
  AppSettings settings = AppSettings(
    darkMode: false,
    notifications: true,
    appLock: false,
    currency: 'INR',
    language: 'English',
    storageMode: 'local',
    appVersion: '2.4.1',
  );

  Future<void> updateSettings({
    bool? darkMode,
    bool? notifications,
    bool? appLock,
    String? currency,
    String? language,
    String? storageMode,
  }) async {
    settings.darkMode = darkMode ?? settings.darkMode;
    settings.notifications = notifications ?? settings.notifications;
    settings.appLock = appLock ?? settings.appLock;
    settings.currency = currency ?? settings.currency;
    settings.language = language ?? settings.language;
    settings.storageMode = storageMode ?? settings.storageMode;

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('darkMode', settings.darkMode);
    await prefs.setBool('notifications', settings.notifications);
    await prefs.setBool('appLock', settings.appLock);
    await prefs.setString('currency', settings.currency);
    await prefs.setString('language', settings.language);
    await prefs.setString('storageMode', settings.storageMode);
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> resetApp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool showResetConfirm = false;
  bool showClearConfirm = false;

  final List<String> currencies = [
    'INR',
    'USD',
    'EUR',
    'GBP',
  ];

  final List<String> languages = [
    'English',
    'Hindi',
    'Tamil',
    'Telugu',
    'Marathi',
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final settings = provider.settings;

    final isDark = settings.darkMode;

    final cardBg =
        isDark ? const Color(0xFF1E293B) : Colors.white;

    final mainText =
        isDark ? Colors.white : const Color(0xFF0F172A);

    final subText =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    final borderColor =
        isDark ? Colors.white10 : Colors.black12;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [

              /// HEADER
              Row(
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
                        Icons.arrow_back_ios_new,
                        size: 18,
                        color: mainText,
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Text(
                    "Settings",

                    style: TextStyle(
                      color: mainText,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// STORAGE
              buildSection(
                title: "Storage Settings",
                child: Column(
                  children: [

                    buildRow(
                      icon: Icons.storage,
                      iconColor: Colors.blue,
                      title: "Storage Mode",
                      subtitle: settings.storageMode == 'local'
                          ? 'Local device only'
                          : 'Cloud Sync Enabled',

                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),

                        decoration: BoxDecoration(
                          color: settings.storageMode == 'local'
                              ? Colors.green.withOpacity(.1)
                              : Colors.blue.withOpacity(.1),

                          borderRadius: BorderRadius.circular(30),
                        ),

                        child: Text(
                          settings.storageMode.toUpperCase(),

                          style: TextStyle(
                            color: settings.storageMode == 'local'
                                ? Colors.green
                                : Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),

                      mainText: mainText,
                      subText: subText,
                      borderColor: borderColor,
                      cardBg: cardBg,
                    ),

                    buildRow(
                      icon: Icons.sync,
                      iconColor: Colors.deepPurple,
                      title: "Sync Now",
                      subtitle: "Trigger manual sync",

                      trailing: Icon(
                        Icons.chevron_right,
                        color: subText,
                      ),

                      onTap: () {},

                      mainText: mainText,
                      subText: subText,
                      borderColor: borderColor,
                      cardBg: cardBg,
                    ),
                  ],
                ),

                cardBg: cardBg,
                borderColor: borderColor,
                subText: subText,
              ),

              const SizedBox(height: 18),

              /// APP PREFERENCES
              buildSection(
                title: "App Preferences",

                child: Column(
                  children: [

                    buildSwitchRow(
                      title: "Dark Mode",
                      subtitle: isDark
                          ? 'Currently dark'
                          : 'Currently light',

                      value: settings.darkMode,

                      onChanged: (v) {
                        provider.updateSettings(darkMode: v);
                      },

                      icon: isDark
                          ? Icons.dark_mode
                          : Icons.light_mode,

                      iconColor:
                          isDark ? Colors.deepPurple : Colors.amber,

                      mainText: mainText,
                      subText: subText,
                      borderColor: borderColor,
                    ),

                    buildDropdownRow(
                      title: "Currency",
                      subtitle: settings.currency,
                      value: settings.currency,
                      items: currencies,

                      onChanged: (v) {
                        provider.updateSettings(currency: v!);
                      },

                      icon: Icons.currency_rupee,
                      iconColor: Colors.green,

                      mainText: mainText,
                      subText: subText,
                      borderColor: borderColor,
                    ),

                    buildSwitchRow(
                      title: "Notifications",
                      subtitle: "Budget alerts & reminders",

                      value: settings.notifications,

                      onChanged: (v) {
                        provider.updateSettings(notifications: v);
                      },

                      icon: Icons.notifications,
                      iconColor: Colors.orange,

                      mainText: mainText,
                      subText: subText,
                      borderColor: borderColor,
                    ),

                    buildSwitchRow(
                      title: "App Lock",
                      subtitle: "Biometric / PIN lock",

                      value: settings.appLock,

                      onChanged: (v) {
                        provider.updateSettings(appLock: v);
                      },

                      icon: Icons.lock,
                      iconColor: Colors.lightBlue,

                      mainText: mainText,
                      subText: subText,
                      borderColor: borderColor,
                    ),

                    buildDropdownRow(
                      title: "Language",
                      subtitle: settings.language,
                      value: settings.language,
                      items: languages,

                      onChanged: (v) {
                        provider.updateSettings(language: v!);
                      },

                      icon: Icons.language,
                      iconColor: Colors.teal,

                      mainText: mainText,
                      subText: subText,
                      borderColor: borderColor,
                    ),

                    buildRow(
                      icon: Icons.smartphone,
                      iconColor: Colors.deepPurple,
                      title: "App Version",
                      subtitle: "Latest stable build",

                      trailing: Text(
                        "v${settings.appVersion}",

                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      mainText: mainText,
                      subText: subText,
                      borderColor: borderColor,
                      cardBg: cardBg,
                    ),
                  ],
                ),

                cardBg: cardBg,
                borderColor: borderColor,
                subText: subText,
              ),

              const SizedBox(height: 18),

              /// BACKUP
              buildSection(
                title: "Backup",

                child: Column(
                  children: [

                    buildRow(
                      icon: Icons.download,
                      iconColor: Colors.green,
                      title: "Export Backup",
                      subtitle: "Download all app data",

                      trailing: Icon(
                        Icons.chevron_right,
                        color: subText,
                      ),

                      onTap: () {},

                      mainText: mainText,
                      subText: subText,
                      borderColor: borderColor,
                      cardBg: cardBg,
                    ),

                    buildRow(
                      icon: Icons.restore,
                      iconColor: Colors.blue,
                      title: "Restore Backup",
                      subtitle: "Import backup file",

                      trailing: Icon(
                        Icons.chevron_right,
                        color: subText,
                      ),

                      onTap: () {},

                      mainText: mainText,
                      subText: subText,
                      borderColor: borderColor,
                      cardBg: cardBg,
                    ),
                  ],
                ),

                cardBg: cardBg,
                borderColor: borderColor,
                subText: subText,
              ),

              const SizedBox(height: 18),

              /// DATA MANAGEMENT
              buildSection(
                title: "Data Management",

                child: Column(
                  children: [

                    buildRow(
                      icon: Icons.delete_outline,
                      iconColor: Colors.red,
                      title: "Clear Cache",
                      subtitle: "Free up storage space",

                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Colors.red,
                      ),

                      onTap: () {
                        showDialog(
                          context: context,

                          builder: (_) => buildConfirmDialog(
                            context,
                            title: "Clear Cache?",
                            desc:
                                "Temporary cache files will be removed.",

                            confirmText: "Clear",

                            onConfirm: () async {
                              await provider.clearCache();
                              Navigator.pop(context);
                            },

                            isDark: isDark,
                          ),
                        );
                      },

                      mainText: Colors.red,
                      subText: subText,
                      borderColor: borderColor,
                      cardBg: cardBg,
                    ),

                    buildRow(
                      icon: Icons.refresh,
                      iconColor: Colors.red,
                      title: "Reset App",
                      subtitle: "Delete all data and reset",

                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Colors.red,
                      ),

                      onTap: () {
                        showDialog(
                          context: context,

                          builder: (_) => buildConfirmDialog(
                            context,
                            title: "Reset App?",
                            desc:
                                "All transactions and settings will be deleted permanently.",

                            confirmText: "Reset",

                            onConfirm: () async {
                              await provider.resetApp();

                              Navigator.pop(context);
                            },

                            isDark: isDark,
                          ),
                        );
                      },

                      mainText: Colors.red,
                      subText: subText,
                      borderColor: borderColor,
                      cardBg: cardBg,
                    ),
                  ],
                ),

                cardBg: cardBg,
                borderColor: borderColor,
                subText: subText,
              ),

              const SizedBox(height: 20),

              Text(
                "Personal Expense Tracker Pro\nMade with ❤️ for India 🇮🇳",

                textAlign: TextAlign.center,

                style: TextStyle(
                  color: subText,
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSection({
    required String title,
    required Widget child,
    required Color cardBg,
    required Color borderColor,
    required Color subText,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: borderColor),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            title.toUpperCase(),

            style: TextStyle(
              color: subText,
              fontWeight: FontWeight.bold,
              fontSize: 11,
              letterSpacing: 1.2,
            ),
          ),

          const SizedBox(height: 10),

          child,
        ],
      ),
    );
  }

  Widget buildRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget trailing,
    required Color mainText,
    required Color subText,
    required Color borderColor,
    required Color cardBg,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),

        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: borderColor),
          ),
        ),

        child: Row(
          children: [

            Container(
              width: 40,
              height: 40,

              decoration: BoxDecoration(
                color: iconColor.withOpacity(.12),
                borderRadius: BorderRadius.circular(14),
              ),

              child: Icon(
                icon,
                color: iconColor,
                size: 20,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,

                    style: TextStyle(
                      color: mainText,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    subtitle,

                    style: TextStyle(
                      color: subText,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            trailing,
          ],
        ),
      ),
    );
  }

  Widget buildSwitchRow({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
    required Color iconColor,
    required Color mainText,
    required Color subText,
    required Color borderColor,
  }) {
    return buildRow(
      icon: icon,
      iconColor: iconColor,
      title: title,
      subtitle: subtitle,

      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),

      mainText: mainText,
      subText: subText,
      borderColor: borderColor,
      cardBg: Colors.transparent,
    );
  }

  Widget buildDropdownRow({
    required String title,
    required String subtitle,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData icon,
    required Color iconColor,
    required Color mainText,
    required Color subText,
    required Color borderColor,
  }) {
    return buildRow(
      icon: icon,
      iconColor: iconColor,
      title: title,
      subtitle: subtitle,

      trailing: DropdownButton<String>(
        value: value,
        underline: const SizedBox(),

        items: items.map((e) {
          return DropdownMenuItem(
            value: e,
            child: Text(e),
          );
        }).toList(),

        onChanged: onChanged,
      ),

      mainText: mainText,
      subText: subText,
      borderColor: borderColor,
      cardBg: Colors.transparent,
    );
  }

  Widget buildConfirmDialog(
    BuildContext context, {
    required String title,
    required String desc,
    required String confirmText,
    required VoidCallback onConfirm,
    required bool isDark,
  }) {
    return AlertDialog(
      backgroundColor:
          isDark ? const Color(0xFF1E293B) : Colors.white,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),

      title: Text(
        title,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black,
        ),
      ),

      content: Text(
        desc,
        style: TextStyle(
          color: isDark ? Colors.white70 : Colors.black54,
        ),
      ),

      actions: [

        TextButton(
          onPressed: () => Navigator.pop(context),

          child: const Text("Cancel"),
        ),

        ElevatedButton(
          onPressed: onConfirm,

          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),

          child: Text(confirmText),
        ),
      ],
    );
  }
}