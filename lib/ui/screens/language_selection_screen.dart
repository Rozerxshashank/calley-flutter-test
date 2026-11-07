import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/app_state_provider.dart';
import '../widgets/custom_button.dart';
import 'register_screen.dart';

class LanguageSelectionScreen extends StatefulWidget {
  final bool isFromSettings;

  const LanguageSelectionScreen({super.key, this.isFromSettings = false});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  late String _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = context.read<AppStateProvider>().selectedLanguage;
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AppStateProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.isFromSettings
          ? AppBar(
              title: Text(
                AppStrings.chooseLanguage,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: const IconThemeData(color: AppColors.textPrimary),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            )
          : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Text(
                AppStrings.chooseLanguage,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: kAppLanguages.length,
                    separatorBuilder: (_, _) => const Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                      color: AppColors.divider,
                    ),
                    itemBuilder: (context, index) {
                      final item = kAppLanguages[index];
                      final isSelected = item.id == _selectedId;

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 2,
                        ),
                        title: Text(
                          item.name,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        subtitle: Text(
                          item.nativeName,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        trailing: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? Colors.black87
                                  : AppColors.inputBorder,
                              width: 2,
                            ),
                          ),
                          child: isSelected
                              ? Center(
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black87,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        onTap: () {
                          setState(() {
                            _selectedId = item.id;
                          });
                          context.read<AppStateProvider>().setLanguage(item.id);
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
              const SizedBox(height: 20),
              CustomButton(
                text: AppStrings.select,
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  await context
                      .read<AppStateProvider>()
                      .setLanguage(_selectedId);
                  if (!mounted) return;

                  if (widget.isFromSettings) {
                    navigator.pop();
                  } else {
                    navigator.pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const RegisterScreen(),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
