import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  double progress = 0;

  late Timer progressTimer;

  late AnimationController fadeController;
  late AnimationController logoController;

  late Animation<double> fadeAnimation;
  late Animation<double> logoScaleAnimation;
  late Animation<Offset> slideAnimation;

  @override
  void initState() {
    super.initState();

    fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    fadeAnimation = CurvedAnimation(
      parent: fadeController,
      curve: Curves.easeOut,
    );

    logoScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: logoController,
        curve: Curves.elasticOut,
      ),
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: fadeController,
        curve: Curves.easeOut,
      ),
    );

    fadeController.forward();
    logoController.forward();

    startLoading();
  }

  Future<void> startLoading() async {

    progressTimer = Timer.periodic(
      const Duration(milliseconds: 100),
      (timer) {

        setState(() {
          progress += 4;

          if (progress >= 100) {
            progress = 100;
            timer.cancel();
          }
        });
      },
    );

    await Future.delayed(
      const Duration(milliseconds: 2800),
    );

    final prefs = await SharedPreferences.getInstance();

    final onboarded = prefs.getBool('petpro_onboarded') ?? false;

    if (!mounted) return;

    if (onboarded) {
      Navigator.pushReplacementNamed(context, '/app/home');
    } else {
      Navigator.pushReplacementNamed(context, '/onboarding');
    }
  }

  @override
  void dispose() {
    progressTimer.cancel();
    fadeController.dispose();
    logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,

            colors: [
              Color(0xFF0F172A),
              Color(0xFF0D1F3C),
              Color(0xFF0A1628),
            ],
          ),
        ),

        child: Stack(
          children: [

            /// TOP BLUE GLOW
            Positioned(
              top: -180,
              right: -180,

              child: Container(
                width: 400,
                height: 400,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  gradient: RadialGradient(
                    colors: [
                      Colors.blue.withOpacity(.18),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            /// BOTTOM GREEN GLOW
            Positioned(
              bottom: -120,
              left: -180,

              child: Container(
                width: 350,
                height: 350,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  gradient: RadialGradient(
                    colors: [
                      Colors.green.withOpacity(.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            /// CENTER CONTENT
            Center(
              child: FadeTransition(
                opacity: fadeAnimation,

                child: SlideTransition(
                  position: slideAnimation,

                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [

                      /// LOGO
                      ScaleTransition(
                        scale: logoScaleAnimation,

                        child: Container(
                          width: 96,
                          height: 96,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),

                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF00C853),
                                Color(0xFF2979FF),
                              ],
                            ),

                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(.35),
                                blurRadius: 40,
                                offset: const Offset(0, 16),
                              ),
                            ],
                          ),

                          child: const Center(
                            child: Text(
                              '₹',

                              style: TextStyle(
                                fontSize: 48,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// TITLE
                      const Text(
                        "Personal Expense",

                        style: TextStyle(
                          color: Color(0xFFF8FAFC),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),

                      ShaderMask(
                        shaderCallback: (bounds) {
                          return const LinearGradient(
                            colors: [
                              Color(0xFF00C853),
                              Color(0xFF2979FF),
                            ],
                          ).createShader(bounds);
                        },

                        child: const Text(
                          "Tracker Pro",

                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      /// TAGLINE
                      const Text(
                        "Track Smart. Save Better.",

                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 14,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// LOADING SECTION
            Positioned(
              left: 40,
              right: 40,
              bottom: 70,

              child: Column(
                children: [

                  /// PROGRESS BAR
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),

                    child: Container(
                      height: 4,
                      width: double.infinity,
                      color: Colors.white10,

                      child: Align(
                        alignment: Alignment.centerLeft,

                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 100),

                          width:
                              MediaQuery.of(context).size.width *
                                  (progress / 100),

                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF00C853),
                                Color(0xFF2979FF),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// LOADING TEXT
                  const Text(
                    "Loading your finances...",

                    style: TextStyle(
                      color: Color(0xFF475569),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            /// VERSION
            const Positioned(
              bottom: 20,
              left: 0,
              right: 0,

              child: Center(
                child: Text(
                  "v2.4.1 • Made for India 🇮🇳",

                  style: TextStyle(
                    color: Color(0xFF334155),
                    fontSize: 11,
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