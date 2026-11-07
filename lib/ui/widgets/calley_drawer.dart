import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/list_provider.dart';
import '../screens/getting_started_screen.dart';
import '../screens/login_screen.dart';
import '../screens/settings_screen.dart';

class CalleyDrawer extends StatelessWidget {
  const CalleyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    context.watch<AppStateProvider>();
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    final displayName = user?.username ?? 'Swati';
    final displayEmail = user?.email ?? 'swati@calley.in';
    final subscription = user?.subscription ?? 'Calley Personal';

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        top: false,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 52, 20, 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryDark,
                    AppColors.primary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color(0xFFFFD1B3),
                      child: Text(
                        displayName.isNotEmpty
                            ? displayName[0].toUpperCase()
                            : 'S',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$displayName • ${AppStrings.personal}',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          displayEmail,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Main Menu Items
            _DrawerItem(
              icon: Icons.play_circle_outline,
              title: AppStrings.gettingStarted,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const GettingStartedScreen(),
                  ),
                );
              },
            ),
            _DrawerItem(
              icon: Icons.sync,
              title: AppStrings.syncData,
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Calling data synced successfully'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
            ),
            _DrawerItem(
              icon: Icons.emoji_events_outlined,
              title: AppStrings.gamification,
              onTap: () {
                Navigator.pop(context);
                _showInfoDialog(
                  context,
                  AppStrings.gamification,
                  'Earn calling points and track agent leaderboards to boost daily conversion targets!',
                );
              },
            ),
            _DrawerItem(
              icon: Icons.description_outlined,
              title: AppStrings.sendLogs,
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Diagnostics logs sent to support@getcalley.com'),
                  ),
                );
              },
            ),
            _DrawerItem(
              icon: Icons.settings_outlined,
              title: AppStrings.settings,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SettingsScreen(),
                  ),
                );
              },
            ),
            _DrawerItem(
              icon: Icons.help_outline,
              title: AppStrings.help,
              onTap: () async {
                Navigator.pop(context);
                final uri = Uri.parse('https://www.getcalley.com/help');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
            ),
            _DrawerItem(
              icon: Icons.cancel_outlined,
              title: AppStrings.cancelSubscription,
              onTap: () {
                Navigator.pop(context);
                _showInfoDialog(
                  context,
                  'Subscription Details',
                  'Active plan: $subscription.\nTo manage or cancel your subscription, please visit https://app.getcalley.com',
                );
              },
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Divider(),
            ),

            // Section App Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Text(
                AppStrings.appInfo,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
            ),

            _DrawerItem(
              icon: Icons.info_outline,
              title: AppStrings.aboutUs,
              onTap: () async {
                Navigator.pop(context);
                final uri = Uri.parse('https://www.getcalley.com/about-us/');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
            ),
            _DrawerItem(
              icon: Icons.privacy_tip_outlined,
              title: AppStrings.privacyPolicy,
              onTap: () async {
                Navigator.pop(context);
                final uri = Uri.parse('https://www.getcalley.com/privacy-policy/');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
            ),
            _DrawerItem(
              icon: Icons.phone_android_outlined,
              title: '${AppStrings.version} 1.01.53',
              onTap: null,
            ),
            _DrawerItem(
              icon: Icons.share_outlined,
              title: AppStrings.shareApp,
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sharing Calley App link...'),
                  ),
                );
              },
            ),
            _DrawerItem(
              icon: Icons.logout,
              title: AppStrings.logout,
              iconColor: AppColors.error,
              textColor: AppColors.error,
              onTap: () async {
                final navigator = Navigator.of(context);
                final auth = context.read<AuthProvider>();
                final listProvider = context.read<ListProvider>();

                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(AppStrings.logout),
                    content: Text(AppStrings.logoutConfirm),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: Text(AppStrings.cancel),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(AppStrings.logout),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  listProvider.clear();
                  await auth.logout();
                  navigator.pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                }
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  static void _showInfoDialog(BuildContext context, String title, String body) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: Text(body, style: GoogleFonts.poppins(fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? textColor;

  const _DrawerItem({
    required this.icon,
    required this.title,
    this.onTap,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(
          icon,
          size: 18,
          color: iconColor ?? AppColors.textPrimary,
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textColor ?? AppColors.textPrimary,
        ),
      ),
      onTap: onTap,
      dense: true,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -1),
    );
  }
}
