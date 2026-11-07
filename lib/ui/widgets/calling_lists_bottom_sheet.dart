import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/calling_list_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/list_provider.dart';

class CallingListsBottomSheet extends StatelessWidget {
  final ValueChanged<CallingListModel>? onListSelected;

  const CallingListsBottomSheet({
    super.key,
    this.onListSelected,
  });

  static Future<void> show(
    BuildContext context, {
    ValueChanged<CallingListModel>? onListSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CallingListsBottomSheet(
        onListSelected: onListSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final listProvider = context.watch<ListProvider>();
    final auth = context.read<AuthProvider>();
    final user = auth.currentUser;

    // Use fetched lists from API or fallback to mock Test List
    final lists = listProvider.lists.isNotEmpty
        ? listProvider.lists
        : [
            CallingListModel(
              id: '68626fb3e070e6118dcf9e1d',
              name: 'Test List',
              clientId: user?.id ?? '68626f9ce070e6118dcf9e1c',
            ),
          ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Dark Navy Header matching Figma Screen 07 & Video
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: const BoxDecoration(
                color: Color(0xFF1E3A8A), // Calley Navy Header
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Center(
                child: Text(
                  AppStrings.callingLists,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // White Inner Card
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Row: Select Calling List + Refresh Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.selectCallingList,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          if (user != null) {
                            await listProvider.fetchLists(user.id);
                          }
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Calling lists refreshed'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.refresh, size: 14),
                        label: Text(
                          AppStrings.refresh,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          minimumSize: Size.zero,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // List of Calling Lists from API
                  ...lists.map((list) {
                    final isSelected =
                        listProvider.selectedList?.id == list.id;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.border,
                          width: isSelected ? 1.5 : 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () async {
                          await listProvider.selectList(list);
                          await listProvider.fetchListDetails(list.id);
                          if (context.mounted) {
                            Navigator.pop(context);
                            onListSelected?.call(list);
                          }
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                list.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
