import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/list_provider.dart';
import '../widgets/calley_drawer.dart';
import '../widgets/calling_lists_bottom_sheet.dart';
import 'call_session_screen.dart';
import 'dashboard_empty_screen.dart';
import 'dashboard_stats_screen.dart';
import 'settings_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _hasSelectedList = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (auth.currentUser != null) {
        context.read<ListProvider>().fetchLists(auth.currentUser!.id);
      }
    });
  }

  void _openCallingListsDrawer() {
    CallingListsBottomSheet.show(
      context,
      onListSelected: (list) {
        setState(() {
          _hasSelectedList = true;
        });
      },
    );
  }

  void _startCalling() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CallSessionScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();
    final currentIndex = appState.bottomNavIndex;
    context.watch<ListProvider>();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: const CalleyDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.textPrimary, size: 26),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text(
          AppStrings.dashboard,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.headset_mic_outlined, color: AppColors.textPrimary, size: 22),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Calley Support: support@getcalley.com'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined, color: AppColors.textPrimary, size: 22),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No new notifications'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: IndexedStack(
        index: currentIndex,
        children: [
          // Index 0: Home (Screen 06 if no list selected, Screen 08 once list is picked)
          _hasSelectedList
              ? DashboardStatsScreen(
                  onStartCalling: _startCalling,
                  onSelectList: _openCallingListsDrawer,
                )
              : DashboardEmptyScreen(
                  onStartCalling: _openCallingListsDrawer,
                ),

          // Index 1: Calling Lists & Load Numbers (Screen 06 in Figma)
          DashboardEmptyScreen(
            onStartCalling: _openCallingListsDrawer,
          ),

          // Index 2: Placeholder for center action
          const SizedBox.shrink(),

          // Index 3: Phone / Call session
          const CallSessionScreen(),

          // Index 4: Profile / Settings
          const SettingsScreen(),
        ],
      ),
      // Clean icon-only Bottom Navigation Bar matching Figma Screens 06 & 08 exactly
      bottomNavigationBar: Container(
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(top: BorderSide(color: AppColors.border, width: 1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // 1. Home Icon
              _navIconButton(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                isSelected: currentIndex == 0,
                onTap: () => appState.setBottomNavIndex(0),
              ),

              // 2. Feed / List Icon (opens Calling Lists bottom drawer)
              _navIconButton(
                icon: Icons.badge_outlined,
                activeIcon: Icons.badge,
                isSelected: currentIndex == 1,
                onTap: _openCallingListsDrawer,
              ),

              // 3. Center Elevated Blue Play Button
              GestureDetector(
                onTap: _hasSelectedList ? _startCalling : _openCallingListsDrawer,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),

              // 4. Phone Dialer Icon
              _navIconButton(
                icon: Icons.phone_outlined,
                activeIcon: Icons.phone,
                isSelected: currentIndex == 3,
                onTap: _startCalling,
              ),

              // 5. Calendar / Profile Icon
              _navIconButton(
                icon: Icons.calendar_month_outlined,
                activeIcon: Icons.calendar_month,
                isSelected: currentIndex == 4,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SettingsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navIconButton({
    required IconData icon,
    required IconData activeIcon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return IconButton(
      onPressed: onTap,
      splashRadius: 24,
      icon: Icon(
        isSelected ? activeIcon : icon,
        color: isSelected ? AppColors.primary : AppColors.textMuted,
        size: 24,
      ),
    );
  }
}
