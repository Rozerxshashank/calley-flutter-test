import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class AgentIllustration extends StatelessWidget {
  final double height;

  const AgentIllustration({super.key, this.height = 140});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background soft circles
          Positioned(
            left: 20,
            bottom: 10,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            right: 30,
            top: 10,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFB800).withValues(alpha: 0.12),
              ),
            ),
          ),

          // Smartphone Graphic
          Positioned(
            left: 35,
            bottom: 15,
            child: Container(
              width: 70,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(6),
              child: Column(
                children: [
                  Container(
                    width: 20,
                    height: 3,
                    decoration: BoxDecoration(
                      color: AppColors.textMuted,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 14,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.called,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Container(
                          height: 8,
                          color: AppColors.border,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    height: 8,
                    color: AppColors.border,
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.phone_in_talk,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),

          // Caller Agent Avatar Graphic
          Positioned(
            right: 40,
            bottom: 10,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Headset band
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF1E293B),
                          width: 3.5,
                        ),
                      ),
                    ),
                    // Agent face
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: const Color(0xFFFFD1B3),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Hair
                          Positioned(
                            top: 2,
                            child: Container(
                              width: 32,
                              height: 16,
                              decoration: const BoxDecoration(
                                color: Color(0xFF1E293B),
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                              ),
                            ),
                          ),
                          // Eyes
                          const Positioned(
                            top: 20,
                            child: Row(
                              children: [
                                CircleAvatar(radius: 2, backgroundColor: Colors.black87),
                                SizedBox(width: 10),
                                CircleAvatar(radius: 2, backgroundColor: Colors.black87),
                              ],
                            ),
                          ),
                          // Smile
                          Positioned(
                            bottom: 14,
                            child: Container(
                              width: 8,
                              height: 4,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.black87, width: 1.5),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Headset ear cup
                    const Positioned(
                      left: 0,
                      child: CircleAvatar(
                        radius: 6,
                        backgroundColor: Color(0xFF2563EB),
                      ),
                    ),
                    // Headset microphone
                    Positioned(
                      right: 12,
                      bottom: 8,
                      child: Container(
                        width: 14,
                        height: 3,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                // Shirt / Shoulders
                Container(
                  width: 64,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
