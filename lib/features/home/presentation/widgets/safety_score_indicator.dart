import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class SafetyScoreIndicator extends StatelessWidget {
  final double score;

  const SafetyScoreIndicator({
    super.key,
    required this.score,
  });

  String _getSafetyText(double score) {
    if (score >= 9.0) return 'Very Safe';
    if (score >= 7.0) return 'Safe';
    if (score >= 5.0) return 'Moderate';
    if (score >= 3.0) return 'Unsafe';
    return 'Dangerous';
  }

  IconData _getSafetyIcon(double score) {
    if (score >= 7.0) return Icons.shield;
    if (score >= 5.0) return Icons.shield_outlined;
    return Icons.warning;
  }

  @override
  Widget build(BuildContext context) {
    final color = AppColors.getSafetyColor(score);
    final safetyText = _getSafetyText(score);
    final icon = _getSafetyIcon(score);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Safety Score',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    ),
              ),
              Row(
                children: [
                  Text(
                    score.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    '/10',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    safetyText,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
