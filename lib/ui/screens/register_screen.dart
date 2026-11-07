import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/auth_provider.dart';
import '../widgets/calley_logo.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'otp_verification_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Dhrubo');
  final _emailController = TextEditingController(text: 'testing@yopmail.com');
  final _passwordController = TextEditingController(text: '123');
  final _phoneController = TextEditingController(text: '7678286227');
  bool _agreeTerms = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the Terms and Conditions'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final auth = context.read<AuthProvider>();
    final success = await auth.register(
      username: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (success && mounted) {
      // Trigger send OTP
      await auth.sendOtp(_emailController.text.trim());

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OtpVerificationScreen(
              email: _emailController.text.trim(),
              phone: '+91 ${_phoneController.text.trim()}',
              username: _nameController.text.trim(),
            ),
          ),
        );
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage ?? 'Registration failed'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    context.watch<AppStateProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Center(
                  child: CalleyLogo(size: 40),
                ),
                const SizedBox(height: 32),
                Text(
                  AppStrings.welcomeRegister,
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppStrings.pleaseRegister,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 28),

                // Name Field
                CustomTextField(
                  controller: _nameController,
                  hintText: AppStrings.name,
                  suffixIcon: const Icon(
                    Icons.person_outline,
                    color: AppColors.textMuted,
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Please enter your name' : null,
                ),
                const SizedBox(height: 16),

                // Email Field
                CustomTextField(
                  controller: _emailController,
                  hintText: AppStrings.emailAddress,
                  keyboardType: TextInputType.emailAddress,
                  suffixIcon: const Icon(
                    Icons.mail_outline,
                    color: AppColors.textMuted,
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!v.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password Field
                CustomTextField(
                  controller: _passwordController,
                  hintText: AppStrings.password,
                  isPassword: true,
                  validator: (v) => v == null || v.length < 3
                      ? 'Password must be at least 3 characters'
                      : null,
                ),
                const SizedBox(height: 16),

                // Country Code & WhatsApp row matching Figma Image 2
                Container(
                  width: double.infinity,
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.inputBorder, width: 1.2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ClipOval(
                            child: Image.asset(
                              AppAssets.indiaFlag,
                              width: 24,
                              height: 24,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '+91',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      Image.asset(
                        AppAssets.whatsapp,
                        width: 22,
                        height: 22,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Mobile Number Field
                CustomTextField(
                  controller: _phoneController,
                  hintText: AppStrings.mobileNumber,
                  keyboardType: TextInputType.phone,
                  suffixIcon: const Icon(
                    Icons.phone_android_outlined,
                    color: AppColors.textMuted,
                  ),
                  validator: (v) => v == null || v.length < 10
                      ? 'Please enter a 10-digit phone number'
                      : null,
                ),
                const SizedBox(height: 16),

                // Terms & Conditions Checkbox
                Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _agreeTerms,
                        activeColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        onChanged: (val) {
                          setState(() {
                            _agreeTerms = val ?? false;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _agreeTerms = !_agreeTerms;
                          });
                        },
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                            children: const [
                              TextSpan(text: 'I agree to the '),
                              TextSpan(
                                text: 'Terms and Conditions',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Sign Up Button
                CustomButton(
                  text: AppStrings.signUp,
                  isLoading: auth.isLoading,
                  onPressed: _handleRegister,
                ),
                const SizedBox(height: 20),

                // Sign In Link
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                        children: const [
                          TextSpan(text: 'Already have an account? '),
                          TextSpan(
                            text: 'Sign In',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
