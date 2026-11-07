import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/auth_provider.dart';
import '../widgets/custom_button.dart';
import 'main_navigation_screen.dart';

class GettingStartedScreen extends StatelessWidget {
  const GettingStartedScreen({super.key});

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

  void _playChallengeVideo(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => const _VideoPlayerDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AppStateProvider>();
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;
    final displayName = user?.username ?? 'Swati';
    final subscription = user?.subscription ?? 'Calley Personal';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top User Header Banner
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 8,
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
                        displayName.isNotEmpty
                            ? displayName[0].toUpperCase()
                            : 'S',
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
                        subscription,
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

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Web Panel Instruction Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E3A8A), // Navy Blue Card
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.webPanelNotice,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.white,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: _openWebPanel,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  AppStrings.visitWebPanel,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF60A5FA),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.open_in_new,
                                  size: 14,
                                  color: Color(0xFF60A5FA),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 2 MINUTE CHALLENGE Card matching Figma Screen 05
                    InkWell(
                      onTap: () => _playChallengeVideo(context),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: double.infinity,
                        height: 220,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Background Banner Graphic
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE0F2FE),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    AppStrings.twoMinuteChallenge,
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.5,
                                      color: const Color(0xFF0369A1),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  AppStrings.watchChallengeVideo,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),

                            // Play Button Overlay
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFDC2626), // Red YouTube style play
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.red.withValues(alpha: 0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 36,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Bottom Actions: WhatsApp button + Start Calling Now
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  // WhatsApp Icon Button
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.whatsApp.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.whatsApp.withValues(alpha: 0.3),
                      ),
                    ),
                    child: IconButton(
                      icon: Image.asset(
                        AppAssets.whatsapp,
                        width: 28,
                        height: 28,
                        fit: BoxFit.contain,
                      ),
                      onPressed: _openWhatsApp,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Start Calling Button
                  Expanded(
                    child: CustomButton(
                      text: AppStrings.startCallingNow,
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MainNavigationScreen(),
                          ),
                        );
                      },
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
}

class _VideoPlayerDialog extends StatefulWidget {
  const _VideoPlayerDialog();

  @override
  State<_VideoPlayerDialog> createState() => _VideoPlayerDialogState();
}

class _VideoPlayerDialogState extends State<_VideoPlayerDialog> {
  final bool _isPlaying = true;
  double _currentSeconds = 12.0;
  static const double _totalDuration = 120.0; // 2 minutes (120 seconds)

  @override
  void initState() {
    super.initState();
    _startPlayback();
  }

  void _startPlayback() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return false;
      if (_isPlaying) {
        setState(() {
          _currentSeconds += 0.5;
          if (_currentSeconds >= _totalDuration) {
            _currentSeconds = 0.0;
          }
        });
      }
      return mounted;
    });
  }

  Future<void> _launchYouTubeVideo() async {
    final uri = Uri.parse(AppAssets.challengeVideoUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String _formatTime(double sec) {
    final s = sec.toInt();
    final m = (s ~/ 60).toString().padLeft(2, '0');
    final remainder = (s % 60).toString().padLeft(2, '0');
    return '$m:$remainder';
  }

  @override
  Widget build(BuildContext context) {

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A), // Dark slate cinema style
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Video Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDC2626),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'YOUTUBE',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '2 Minute Challenge for GetCalley',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Video Screen Display Frame with YouTube Thumbnail
            InkWell(
              onTap: _launchYouTubeVideo,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                height: 200,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white12),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://img.youtube.com/vi/bP4U-L4EHcg/hqdefault.jpg',
                    ),
                    fit: BoxFit.cover,
                    opacity: 0.88,
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDC2626),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withValues(alpha: 0.5),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),

            // Progress Bar & Time
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Column(
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 3,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                      activeTrackColor: const Color(0xFFDC2626),
                      inactiveTrackColor: Colors.white24,
                      thumbColor: const Color(0xFFDC2626),
                      overlayColor: Colors.red.withValues(alpha: 0.2),
                    ),
                    child: Slider(
                      value: _currentSeconds.clamp(0.0, _totalDuration),
                      max: _totalDuration,
                      onChanged: (val) {
                        setState(() {
                          _currentSeconds = val;
                        });
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_formatTime(_currentSeconds)} / ${_formatTime(_totalDuration)}',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        'Calley Official Setup Guide',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.white38,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Bottom Actions (Watch on YouTube Button)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: ElevatedButton.icon(
                onPressed: _launchYouTubeVideo,
                icon: const Icon(Icons.open_in_new, size: 16),
                label: const Text('Watch on YouTube (Official Video)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC2626), // YouTube Red
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
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
