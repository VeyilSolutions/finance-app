import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MobileLayout extends StatelessWidget {
  final Widget child;

  const MobileLayout({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final String currentPath =
        GoRouterState.of(context).uri.toString();

    final bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final navItems = [
      {
        'icon': Icons.home,
        'label': 'Home',
        'path': '/app/home',
      },
      {
        'icon': Icons.calendar_month,
        'label': 'Calendar',
        'path': '/app/calendar',
      },
      {
        'icon': Icons.add,
        'label': 'Add',
        'path': '/app/add-transaction',
      },
      {
        'icon': Icons.bar_chart,
        'label': 'Reports',
        'path': '/app/reports',
      },
      {
        'icon': Icons.settings,
        'label': 'Settings',
        'path': '/app/settings',
      },
    ];

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF050A1A)
          : const Color(0xFFF0F4FF),

      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 430,
          ),

          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF0F172A)
                : const Color(0xFFF8FAFC),

            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.blue.withOpacity(0.15)
                    : Colors.black.withOpacity(0.12),

                blurRadius: 40,
                spreadRadius: 2,
              ),
            ],
          ),

          child: Stack(
            children: [
              /// PAGE CONTENT
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 80,
                ),

                child: child,
              ),

              /// BOTTOM NAVIGATION
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,

                child: Container(
                  height: 72,

                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),

                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color.fromRGBO(
                            15,
                            23,
                            42,
                            0.95,
                          )
                        : const Color.fromRGBO(
                            255,
                            255,
                            255,
                            0.95,
                          ),

                    border: Border(
                      top: BorderSide(
                        color: isDark
                            ? Colors.white12
                            : Colors.black12,
                      ),
                    ),
                  ),

                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceAround,

                    children: navItems.map((item) {
                      final path =
                          item['path'] as String;

                      final label =
                          item['label'] as String;

                      final icon =
                          item['icon'] as IconData;

                      final bool isActive =
                          currentPath == path;

                      final bool isAdd =
                          label == 'Add';

                      return GestureDetector(
                        onTap: () {
                          context.go(path);
                        },

                        child: SizedBox(
                          width: 60,

                          child: Column(
                            mainAxisSize:
                                MainAxisSize.min,

                            children: [
                              if (isAdd)
                                Container(
                                  width: 52,
                                  height: 52,

                                  margin:
                                      const EdgeInsets.only(
                                    top: -20,
                                  ),

                                  decoration:
                                      BoxDecoration(
                                    shape:
                                        BoxShape.circle,

                                    gradient:
                                        const LinearGradient(
                                      colors: [
                                        Color(
                                          0xFF00C853,
                                        ),
                                        Color(
                                          0xFF2979FF,
                                        ),
                                      ],
                                    ),

                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors
                                            .blue
                                            .withOpacity(
                                          0.4,
                                        ),

                                        blurRadius:
                                            20,
                                      ),
                                    ],
                                  ),

                                  child: const Icon(
                                    Icons.add,
                                    color:
                                        Colors.white,
                                    size: 28,
                                  ),
                                )
                              else ...[
                                Container(
                                  width: 40,
                                  height: 32,

                                  decoration:
                                      BoxDecoration(
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      12,
                                    ),

                                    color: isActive
                                        ? isDark
                                            ? const Color
                                                .fromRGBO(
                                                41,
                                                121,
                                                255,
                                                0.2,
                                              )
                                            : const Color
                                                .fromRGBO(
                                                41,
                                                121,
                                                255,
                                                0.1,
                                              )
                                        : Colors
                                            .transparent,
                                  ),

                                  child: Icon(
                                    icon,

                                    size: 20,

                                    color:
                                        isActive
                                            ? const Color(
                                                0xFF2979FF,
                                              )
                                            : isDark
                                                ? const Color(
                                                    0xFF4A5568,
                                                  )
                                                : const Color(
                                                    0xFF9CA3AF,
                                                  ),
                                  ),
                                ),

                                const SizedBox(
                                  height: 4,
                                ),

                                Text(
                                  label,

                                  style: TextStyle(
                                    fontSize: 10,

                                    fontWeight:
                                        isActive
                                            ? FontWeight
                                                .w600
                                            : FontWeight
                                                .w400,

                                    color:
                                        isActive
                                            ? const Color(
                                                0xFF2979FF,
                                              )
                                            : isDark
                                                ? const Color(
                                                    0xFF4A5568,
                                                  )
                                                : const Color(
                                                    0xFF9CA3AF,
                                                  ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    }).toList(),
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