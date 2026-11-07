import 'package:flutter/material.dart';
import '../../core/constants/app_assets.dart';

class CalleyLogo extends StatelessWidget {
  final double? size;
  final double width;
  final double height;
  final bool showText;
  final bool isVertical;

  const CalleyLogo({
    super.key,
    this.size,
    this.width = 228,
    this.height = 54,
    this.showText = true,
    this.isVertical = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = size != null ? size! * 1.35 : height;

    return Image.asset(
      AppAssets.logo,
      height: effectiveHeight,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return SizedBox(
          height: effectiveHeight,
          child: const Center(
            child: Text(
              'CALLEY',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Color(0xFF1E3A8A),
              ),
            ),
          ),
        );
      },
    );
  }
}
