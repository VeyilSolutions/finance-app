import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String mode = 'login';

  bool showPassword = false;
  bool loading = false;

  final emailController =
      TextEditingController(text: 'arjun.sharma@gmail.com');

  final passwordController = TextEditingController();

  final nameController = TextEditingController();

  Future<void> handleSubmit() async {
    setState(() => loading = true);

    await Future.delayed(const Duration(seconds: 1));

    setState(() => loading = false);

    if (!mounted) return;

    context.go('/app/home');
  }

  void handleGuest() {
    context.go('/app/home');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = true;

    const bgColor = Color(0xFF0F172A);
    const cardColor = Color(0xFF1E293B);
    const borderColor = Color.fromRGBO(255, 255, 255, 0.08);
    const textColor = Color(0xFFF8FAFC);
    const subText = Color(0xFF64748B);

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          /// Background Glow
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color.fromRGBO(41, 121, 255, 0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  /// Logo
                  Container(
                    width: 58,
                    height: 58,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF00C853),
                          Color(0xFF2979FF),
                        ],
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        '₹',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  )
                      .animate()
                      .fade(duration: 500.ms)
                      .slideY(begin: -0.2),

                  const SizedBox(height: 28),

                  /// Title
                  Text(
                    mode == 'login'
                        ? 'Welcome Back!'
                        : mode == 'signup'
                            ? 'Create Account'
                            : 'Reset Password',
                    style: const TextStyle(
                      color: textColor,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    mode == 'login'
                        ? 'Sign in to continue tracking'
                        : mode == 'signup'
                            ? 'Start your finance journey'
                            : "We'll send a reset link",
                    style: const TextStyle(
                      color: subText,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 28),

                  /// Tabs
                  if (mode != 'forgot')
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          buildTab('login', 'Sign In'),
                          buildTab('signup', 'Sign Up'),
                        ],
                      ),
                    ),

                  const SizedBox(height: 24),

                  /// Form
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Column(
                      key: ValueKey(mode),
                      children: [
                        if (mode == 'signup') ...[
                          buildInput(
                            controller: nameController,
                            hint: 'Full Name',
                            icon: LucideIcons.user,
                          ),
                          const SizedBox(height: 16),
                        ],

                        buildInput(
                          controller: emailController,
                          hint: 'Email Address',
                          icon: LucideIcons.mail,
                          keyboard: TextInputType.emailAddress,
                        ),

                        const SizedBox(height: 16),

                        if (mode != 'forgot') ...[
                          buildPasswordField(),

                          const SizedBox(height: 10),

                          if (mode == 'login')
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    mode = 'forgot';
                                  });
                                },
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: Color(0xFF2979FF),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                        ],

                        const SizedBox(height: 24),

                        /// Main Button
                        GestureDetector(
                          onTap: loading ? null : handleSubmit,
                          child: Container(
                            height: 58,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF00C853),
                                  Color(0xFF2979FF),
                                ],
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(41, 121, 255, 0.30),
                                  blurRadius: 30,
                                  offset: Offset(0, 12),
                                ),
                              ],
                            ),
                            child: Center(
                              child: loading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          mode == 'login'
                                              ? 'Sign In'
                                              : mode == 'signup'
                                                  ? 'Create Account'
                                                  : 'Send Reset Link',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
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
                        ),

                        const SizedBox(height: 28),

                        /// Divider
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                color: borderColor,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'or continue with',
                                style: TextStyle(
                                  color: Color(0xFF475569),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: borderColor,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 22),

                        /// Social Buttons
                        Row(
                          children: [
                            Expanded(
                              child: socialButton(
                                icon: '🌐',
                                label: 'Google',
                                onTap: handleSubmit,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: socialButton(
                                iconWidget: const Icon(
                                  LucideIcons.fingerprint,
                                  color: Color(0xFF2979FF),
                                  size: 20,
                                ),
                                label: 'Biometric',
                                onTap: handleSubmit,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        /// Guest Button
                        GestureDetector(
                          onTap: handleGuest,
                          child: Container(
                            height: 54,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: borderColor),
                            ),
                            child: const Center(
                              child: Text(
                                'Continue as Guest 👤',
                                style: TextStyle(
                                  color: subText,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),

                        if (mode == 'forgot') ...[
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                mode = 'login';
                              });
                            },
                            child: const Text(
                              '← Back to Sign In',
                              style: TextStyle(
                                color: subText,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTab(String value, String title) {
    final active = mode == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();

          setState(() {
            mode = value;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: active
                ? const LinearGradient(
                    colors: [
                      Color(0xFF00C853),
                      Color(0xFF2979FF),
                    ],
                  )
                : null,
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: active ? Colors.white : const Color(0xFF64748B),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(30, 41, 59, 0.80),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color.fromRGBO(255, 255, 255, 0.08),
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        style: const TextStyle(
          color: Color(0xFFF8FAFC),
          fontSize: 14,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 14,
          ),
          prefixIcon: Icon(
            icon,
            color: const Color(0xFF64748B),
            size: 18,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  Widget buildPasswordField() {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(30, 41, 59, 0.80),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color.fromRGBO(255, 255, 255, 0.08),
        ),
      ),
      child: TextField(
        controller: passwordController,
        obscureText: !showPassword,
        style: const TextStyle(
          color: Color(0xFFF8FAFC),
          fontSize: 14,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Password',
          hintStyle: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 14,
          ),
          prefixIcon: const Icon(
            LucideIcons.lock,
            color: Color(0xFF64748B),
            size: 18,
          ),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                showPassword = !showPassword;
              });
            },
            icon: Icon(
              showPassword ? LucideIcons.eyeOff : LucideIcons.eye,
              color: const Color(0xFF64748B),
              size: 18,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  Widget socialButton({
    required String label,
    required VoidCallback onTap,
    String? icon,
    Widget? iconWidget,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(30, 41, 59, 0.80),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color.fromRGBO(255, 255, 255, 0.08),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Text(
                icon,
                style: const TextStyle(fontSize: 18),
              ),

            if (iconWidget != null) iconWidget,

            const SizedBox(width: 8),

            Text(
              label,
              style: const TextStyle(
                color: Color(0xFFF8FAFC),
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}