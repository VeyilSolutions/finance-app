import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class OnboardingSlide {
  final IconData icon;
  final String emoji;
  final String title;
  final String subtitle;
  final Color color;

  const OnboardingSlide({
    required this.icon,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int current = 0;

  final List<OnboardingSlide> slides = [
    const OnboardingSlide(
      icon: LucideIcons.wallet,
      emoji: '💰',
      title: 'Track Daily\nExpenses',
      subtitle:
          'Monitor every rupee you spend. Categorize, tag, and stay on top of your daily finances effortlessly.',
      color: Color(0xFF00C853),
    ),
    const OnboardingSlide(
      icon: LucideIcons.shield,
      emoji: '🔒',
      title: 'Offline-First\nSecure Storage',
      subtitle:
          'Your data stays private on your device. No internet required. Your finances, your control.',
      color: Color(0xFFFFD54F),
    ),
    const OnboardingSlide(
      icon: LucideIcons.cloud,
      emoji: '☁️',
      title: 'Cloud Sync\nAcross Devices',
      subtitle:
          'Optionally sync with cloud storage. Access your finances from any device, anytime.',
      color: Color(0xFF2979FF),
    ),
    const OnboardingSlide(
      icon: LucideIcons.barChart3,
      emoji: '📊',
      title: 'Analytics &\nSmart Budgeting',
      subtitle:
          'Beautiful charts, spending insights, budget planning and savings goals to help you grow wealth.',
      color: Color(0xFFA29BFE),
    ),
  ];

  void handleNext() {
    if (current < slides.length - 1) {
      setState(() => current++);
    } else {
      context.go('/storage-mode');
    }
  }

  void handleSkip() {
    context.go('/storage-mode');
  }

  @override
  Widget build(BuildContext context) {
    final slide = slides[current];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Column(
          children: [
            /// TOP
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 60),

                  /// DOTS
                  Row(
                    children: List.generate(
                      slides.length,
                      (index) => GestureDetector(
                        onTap: () {
                          setState(() => current = index);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: index == current ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: index == current
                                ? slide.color
                                : Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),

                  /// SKIP
                  GestureDetector(
                    onTap: handleSkip,
                    child: const Text(
                      "Skip",
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// MAIN CONTENT
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.2, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: _buildSlide(slide),
              ),
            ),

            /// BOTTOM
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: handleNext,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            slide.color,
                            slide.color.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: slide.color.withOpacity(0.35),
                            blurRadius: 30,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            current < slides.length - 1
                                ? 'Next'
                                : 'Get Started',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            LucideIcons.chevronRight,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (current < slides.length - 1) ...[
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        setState(() => current = slides.length - 1);
                      },
                      child: const Text(
                        'Jump to last',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide(OnboardingSlide slide) {
    return Padding(
      key: ValueKey(slide.title),
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// ILLUSTRATION
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  slide.color.withOpacity(0.15),
                  slide.color.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: slide.color.withOpacity(0.15),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  slide.icon,
                  size: 64,
                  color: slide.color,
                ),
                const SizedBox(height: 12),
                Text(
                  slide.emoji,
                  style: const TextStyle(fontSize: 40),
                ),
              ],
            ),
          ).animate().scale(
                duration: 500.ms,
                curve: Curves.easeOutBack,
              ),

          const SizedBox(height: 50),

          /// TITLE
          Text(
            slide.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFF8FAFC),
              fontSize: 28,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 18),

          /// SUBTITLE
          Text(
            slide.subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}