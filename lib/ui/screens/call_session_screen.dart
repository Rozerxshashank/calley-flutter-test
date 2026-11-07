import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/call_record_model.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/list_provider.dart';
import '../widgets/custom_button.dart';

class CallSessionScreen extends StatefulWidget {
  final CallRecordModel? initialCall;

  const CallSessionScreen({super.key, this.initialCall});

  @override
  State<CallSessionScreen> createState() => _CallSessionScreenState();
}

class _CallSessionScreenState extends State<CallSessionScreen> {
  int _currentIndex = 0;
  List<CallRecordModel> _calls = [];
  Timer? _callTimer;
  int _callDurationSeconds = 0;
  bool _isCallActive = false;
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final listProvider = context.read<ListProvider>();
    _calls = listProvider.filteredCalls;
    if (_calls.isEmpty && listProvider.listDetails != null) {
      _calls = listProvider.listDetails!.calls;
    }

    if (widget.initialCall != null && _calls.isNotEmpty) {
      final idx = _calls.indexWhere((c) => c.phone == widget.initialCall!.phone);
      if (idx != -1) {
        _currentIndex = idx;
      }
    }
  }

  @override
  void dispose() {
    _callTimer?.cancel();
    _feedbackController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _callTimer?.cancel();
    _callDurationSeconds = 0;
    _isCallActive = true;
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _callDurationSeconds++;
      });
    });
  }

  void _stopTimer() {
    _callTimer?.cancel();
    setState(() {
      _isCallActive = false;
    });
  }

  String _formatDuration(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final uri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
    _startTimer();
  }

  Future<void> _openWhatsApp(String phoneNumber) async {
    final uri = Uri.parse('https://wa.me/$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _handleCompleteCall(CallRecordModel currentCall) {
    _stopTimer();
    context.read<ListProvider>().markCallCompleted(
          currentCall,
          feedback: _feedbackController.text.isNotEmpty
              ? _feedbackController.text
              : 'Call completed (${_formatDuration(_callDurationSeconds)})',
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Call with ${currentCall.fullName} recorded!'),
        backgroundColor: AppColors.success,
      ),
    );

    if (_currentIndex < _calls.length - 1) {
      setState(() {
        _currentIndex++;
        _callDurationSeconds = 0;
        _feedbackController.clear();
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_calls.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Call Session')),
        body: const Center(
          child: Text('No prospects found in this list.'),
        ),
      );
    }

    final currentCall = _calls[_currentIndex];
    context.watch<AppStateProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '${AppStrings.callSession} (${_currentIndex + 1}/${_calls.length})',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Active Call / Timer Bar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: _isCallActive
                  ? const Color(0xFFDCFCE7)
                  : const Color(0xFFF1F5F9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        _isCallActive ? Icons.phone_in_talk : Icons.phone_paused,
                        color: _isCallActive ? AppColors.success : AppColors.textMuted,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isCallActive ? 'Call In Progress' : 'Ready to Dial',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _isCallActive ? AppColors.success : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    _formatDuration(_callDurationSeconds),
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: _isCallActive ? AppColors.success : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Prospect Header
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                          child: Text(
                            currentCall.firstName.isNotEmpty
                                ? currentCall.firstName[0].toUpperCase()
                                : 'P',
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentCall.fullName,
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                currentCall.company,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Phone Dial Actions Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'PRIMARY PHONE',
                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                    Text(
                                      currentCall.phone,
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () => _makePhoneCall(currentCall.phone),
                                icon: const Icon(Icons.call, size: 18),
                                label: const Text('Dial'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(
                                  Icons.chat,
                                  color: AppColors.whatsApp,
                                ),
                                onPressed: () => _openWhatsApp(currentCall.phone),
                              ),
                            ],
                          ),
                          if (currentCall.otherPhone1 != null &&
                              currentCall.otherPhone1!.isNotEmpty) ...[
                            const Divider(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Alt: ${currentCall.otherPhone1}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: () =>
                                      _makePhoneCall(currentCall.otherPhone1!),
                                  icon: const Icon(Icons.call, size: 14),
                                  label: const Text('Call Alt'),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Prospect Details Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _infoItem('Email', currentCall.email),
                          _infoItem('Address', currentCall.address),
                          _infoItem('Demographics',
                              '${currentCall.age} Years • ${currentCall.maritalStatus} • Zip: ${currentCall.zip}'),
                          _infoItem('Notes', currentCall.notes),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Call Feedback input
                    Text(
                      'Call Notes / Feedback',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _feedbackController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'e.g. Interested in demo, callback scheduled...',
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Buttons
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.divider)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        if (_currentIndex < _calls.length - 1) {
                          setState(() {
                            _currentIndex++;
                            _callDurationSeconds = 0;
                            _feedbackController.clear();
                          });
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Skip',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: CustomButton(
                      text: 'Complete Call',
                      backgroundColor: AppColors.success,
                      icon: const Icon(Icons.check_circle, size: 18),
                      onPressed: () => _handleCompleteCall(currentCall),
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

  Widget _infoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
