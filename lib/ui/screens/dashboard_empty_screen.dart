import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/auth_provider.dart';
import '../widgets/agent_illustration.dart';
import '../widgets/custom_button.dart';

class DashboardEmptyScreen extends StatelessWidget {
  final VoidCallback onStartCalling;

  const DashboardEmptyScreen({
    super.key,
    required this.onStartCalling,
  });

  Future<void> _openWebPanel() async {
    final uri = Uri.parse(AppStrings.webPanelUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openWhatsApp() async {
    final uri = Uri.parse('https://wa.me/917678286227?text=Hello%20Calley%20Support');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AppStateProvider>();
    final auth = context.watch<AuthProvider>();
    final displayName = auth.currentUser?.username ?? 'Swati';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // Greeting Banner Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.18),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color(0xFFFFD1B3),
                    child: Text(
                      displayName.isNotEmpty ? displayName[0].toUpperCase() : 'S',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${AppStrings.hello} $displayName',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      AppStrings.welcomeToCalley,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Main Card: LOAD NUMBER TO CALL
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Top Header of card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E3A8A), // Navy Blue
                    borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  ),
                  child: Center(
                    child: Text(
                      AppStrings.loadNumberToCall,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                  child: Column(
                    children: [
                      // Subtext
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                          children: [
                            const TextSpan(text: 'Visit '),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: GestureDetector(
                                onTap: _openWebPanel,
                                child: Text(
                                  AppStrings.webPanelUrl,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                            const TextSpan(
                              text:
                                  ' to upload numbers that you wish to call using Calley Mobile App.',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Graphic Illustration matching Figma Screen 06
                      Image.asset(
                        AppAssets.loadNumberAgent,
                        height: 190,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const AgentIllustration(height: 150),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Bottom Action: WhatsApp + Start Calling
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.whatsApp.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.whatsApp.withValues(alpha: 0.3)),
                ),
                child: IconButton(
                  icon: Image.asset(
                    AppAssets.whatsapp,
                    width: 26,
                    height: 26,
                    fit: BoxFit.contain,
                  ),
                  onPressed: _openWhatsApp,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  text: AppStrings.startCallingNow,
                  onPressed: onStartCalling,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
