import 'package:flutter/material.dart';

/// Bajaj logo widget with customizable size variants
/// 
/// Displays "Bajaj" text in blue with white shadow and
/// "HR Transformation" subtitle in gray
class BajajLogo extends StatelessWidget {
  final BajajLogoSize size;

  const BajajLogo({
    super.key,
    this.size = BajajLogoSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    final dimensions = _getDimensions();
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "Bajaj" text with white shadow
        Text(
          'Bajaj',
          style: TextStyle(
            fontSize: dimensions.mainTextSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2828FF), // Blue
            shadows: [
              Shadow(
                offset: const Offset(2, 2),
                blurRadius: 4,
                color: Colors.white.withOpacity(0.8),
              ),
              Shadow(
                offset: const Offset(-1, -1),
                blurRadius: 2,
                color: Colors.white.withOpacity(0.6),
              ),
            ],
          ),
        ),
        SizedBox(height: dimensions.spacing),
        // "HR Transformation" subtitle
        Text(
          'HR Transformation',
          style: TextStyle(
            fontSize: dimensions.subtitleSize,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  _LogoDimensions _getDimensions() {
    switch (size) {
      case BajajLogoSize.small:
        return const _LogoDimensions(
          mainTextSize: 20,
          subtitleSize: 10,
          spacing: 2,
        );
      case BajajLogoSize.medium:
        return const _LogoDimensions(
          mainTextSize: 32,
          subtitleSize: 14,
          spacing: 4,
        );
      case BajajLogoSize.large:
        return const _LogoDimensions(
          mainTextSize: 48,
          subtitleSize: 18,
          spacing: 6,
        );
    }
  }
}

/// Size variants for the Bajaj logo
enum BajajLogoSize {
  small,  // For AppBar and compact spaces
  medium, // For login screen and standard usage
  large,  // For splash screens or hero sections
}

/// Internal class to hold logo dimensions
class _LogoDimensions {
  final double mainTextSize;
  final double subtitleSize;
  final double spacing;

  const _LogoDimensions({
    required this.mainTextSize,
    required this.subtitleSize,
    required this.spacing,
  });
}
