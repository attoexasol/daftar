import 'package:flutter/material.dart';

/// StatCard Widget
/// Matches React StatCard component design exactly
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final String? trend; // 'up' or 'down'
  final String? trendValue;
  final String color; // 'blue', 'green', 'red', 'purple', 'orange', 'teal'

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    this.trend,
    this.trendValue,
    this.color = 'blue',
  });

  LinearGradient _getGradient() {
    switch (color) {
      case 'green':
        return const LinearGradient(
          colors: [Color(0xFF10B981), Color(0xFF059669)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'red':
        return const LinearGradient(
          colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'purple':
        return const LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'orange':
        return const LinearGradient(
          colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'teal':
        return const LinearGradient(
          colors: [Color(0xFF14B8A6), Color(0xFF0D9488)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default: // blue
        return const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  Color _getIconBackgroundColor() {
    switch (color) {
      case 'green':
        return const Color(0xFFDCFCE7); // green-100
      case 'red':
        return const Color(0xFFFEE2E2); // red-100
      case 'purple':
        return const Color(0xFFF3E8FF); // purple-100
      case 'orange':
        return const Color(0xFFFFEDD5); // orange-100
      case 'teal':
        return const Color(0xFFCCFBF1); // teal-100
      default:
        return const Color(0xFFDBEAFE); // blue-100
    }
  }

  Color _getIconColor() {
    switch (color) {
      case 'green':
        return const Color(0xFF10B981);
      case 'red':
        return const Color(0xFFEF4444);
      case 'purple':
        return const Color(0xFF8B5CF6);
      case 'orange':
        return const Color(0xFFF59E0B);
      case 'teal':
        return const Color(0xFF14B8A6);
      default:
        return const Color(0xFF3B82F6);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Colors.white,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top gradient line
              Container(
                height: 4,
                decoration: BoxDecoration(
                  gradient: _getGradient(),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Icon Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF6B7280), // gray-500
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                value,
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF111827), // gray-900
                                  height: 1.2,
                                ),
                              ),
                              if (subtitle != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  subtitle!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF9CA3AF), // gray-400
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _getIconBackgroundColor(),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            icon,
                            size: 24,
                            color: _getIconColor(),
                          ),
                        ),
                      ],
                    ),
                    
                    // Trend indicator
                    if (trend != null && trendValue != null) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(
                            trend == 'up'
                                ? Icons.trending_up
                                : Icons.trending_down,
                            size: 16,
                            color: trend == 'up'
                                ? const Color(0xFF10B981) // green-500
                                : const Color(0xFFEF4444), // red-500
                          ),
                          const SizedBox(width: 8),
                          Text(
                            trendValue!,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: trend == 'up'
                                  ? const Color(0xFF10B981) // green-600
                                  : const Color(0xFFEF4444), // red-600
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}