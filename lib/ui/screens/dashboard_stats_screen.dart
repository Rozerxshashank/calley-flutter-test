import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/call_record_model.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/list_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/donut_chart_widget.dart';
import '../widgets/stat_badge.dart';
import 'call_session_screen.dart';

class DashboardStatsScreen extends StatefulWidget {
  final VoidCallback onStartCalling;
  final VoidCallback? onSelectList;

  const DashboardStatsScreen({
    super.key,
    required this.onStartCalling,
    this.onSelectList,
  });

  @override
  State<DashboardStatsScreen> createState() => _DashboardStatsScreenState();
}

class _DashboardStatsScreenState extends State<DashboardStatsScreen> {
  void _openCallDetails(CallRecordModel call) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _CallDetailSheet(call: call),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AppStateProvider>();
    final listProvider = context.watch<ListProvider>();
    final listName = listProvider.selectedList?.name ?? 'Test List';
    final totalCalls = listProvider.totalCalls > 0 ? listProvider.totalCalls : 50;

    final pending = listProvider.pendingCount > 0 ? listProvider.pendingCount : 28;
    final called = listProvider.doneCount > 0 ? listProvider.doneCount : 22;
    final scheduled = listProvider.scheduleCount > 0 ? listProvider.scheduleCount : 9;

    final filter = listProvider.filterStatus;

    return RefreshIndicator(
      onRefresh: () async {
        if (listProvider.selectedList != null) {
          await listProvider.fetchListDetails(listProvider.selectedList!.id);
        }
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            // List Header Card (Test List - 50 CALLS)
            InkWell(
              onTap: widget.onSelectList,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        listName,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '$totalCalls',
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            AppStrings.callsUpper,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // 'S' Blue Badge
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'S',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
            const SizedBox(height: 20),

            // Donut Chart
            DonutChartWidget(
              pending: pending,
              called: called,
              scheduled: scheduled,
              size: 200,
            ),
            const SizedBox(height: 24),

            // 3 Stat Badges: Pending, Done, Schedule
            Row(
              children: [
                StatBadge(
                  label: AppStrings.pending,
                  count: pending,
                  backgroundColor: AppColors.pendingBg,
                  textColor: AppColors.pendingText,
                  borderColor: AppColors.pending.withValues(alpha: 0.3),
                  isSelected: filter == 'pending',
                  onTap: () {
                    listProvider.setFilterStatus(
                      filter == 'pending' ? 'all' : 'pending',
                    );
                  },
                ),
                const SizedBox(width: 8),
                StatBadge(
                  label: AppStrings.done,
                  count: called,
                  backgroundColor: AppColors.doneBg,
                  textColor: AppColors.doneText,
                  borderColor: AppColors.called.withValues(alpha: 0.3),
                  isSelected: filter == 'called',
                  onTap: () {
                    listProvider.setFilterStatus(
                      filter == 'called' ? 'all' : 'called',
                    );
                  },
                ),
                const SizedBox(width: 8),
                StatBadge(
                  label: AppStrings.schedule,
                  count: scheduled,
                  backgroundColor: AppColors.scheduleBg,
                  textColor: AppColors.scheduleText,
                  borderColor: AppColors.scheduled.withValues(alpha: 0.3),
                  isSelected: filter == 'rescheduled',
                  onTap: () {
                    listProvider.setFilterStatus(
                      filter == 'rescheduled' ? 'all' : 'rescheduled',
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Start Calling Button
            CustomButton(
              text: AppStrings.startCallingNow,
              onPressed: widget.onStartCalling,
            ),
            const SizedBox(height: 24),

            // Calls List Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  filter == 'all'
                      ? '${AppStrings.callRecords} (${listProvider.filteredCalls.length})'
                      : '${filter.toUpperCase()} ${AppStrings.callRecords} (${listProvider.filteredCalls.length})',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (filter != 'all')
                  GestureDetector(
                    onTap: () => listProvider.setFilterStatus('all'),
                    child: Text(
                      AppStrings.clearFilter,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // List of Call Records
            if (listProvider.isLoading)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (listProvider.filteredCalls.isEmpty)
              Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  '${AppStrings.noRecordsMatching} "$filter"',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: listProvider.filteredCalls.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final call = listProvider.filteredCalls[index];
                  return _CallRecordCard(
                    call: call,
                    onTap: () => _openCallDetails(call),
                  );
                },
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _CallRecordCard extends StatelessWidget {
  final CallRecordModel call;
  final VoidCallback onTap;

  const _CallRecordCard({
    required this.call,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    Color badgeText;
    if (call.status == 'called') {
      badgeColor = AppColors.doneBg;
      badgeText = AppColors.doneText;
    } else if (call.status == 'rescheduled') {
      badgeColor = AppColors.scheduleBg;
      badgeText = AppColors.scheduleText;
    } else {
      badgeColor = AppColors.pendingBg;
      badgeText = AppColors.pendingText;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: Text(
                call.firstName.isNotEmpty ? call.firstName[0].toUpperCase() : 'C',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    call.fullName,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${call.phone} • ${call.company}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                call.status.toUpperCase(),
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: badgeText,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CallDetailSheet extends StatelessWidget {
  final CallRecordModel call;

  const _CallDetailSheet({required this.call});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        call.fullName,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        call.company,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      call.status.toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 12),

              _detailRow('Phone Number', call.phone, isPhone: true),
              if (call.otherPhone1 != null && call.otherPhone1!.isNotEmpty)
                _detailRow('Alt Phone 1', call.otherPhone1!, isPhone: true),
              _detailRow('Email', call.email),
              _detailRow('Address', call.address),
              _detailRow('Age & Marital Status', '${call.age} years • ${call.maritalStatus}'),
              _detailRow('Notes', call.notes),
              if (call.feedback != null)
                _detailRow('Feedback', call.feedback!),
              if (call.duration != null)
                _detailRow('Call Duration', '${call.duration} seconds'),

              const SizedBox(height: 24),
              CustomButton(
                text: 'Call ${call.fullName}',
                icon: const Icon(Icons.phone, color: Colors.white, size: 20),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CallSessionScreen(initialCall: call),
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

  Widget _detailRow(String label, String value, {bool isPhone = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: isPhone ? FontWeight.w600 : FontWeight.w400,
              color: isPhone ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
