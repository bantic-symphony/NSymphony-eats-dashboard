import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nsymphony_eats_dashboard/presentation/bloc/attendance/attendance_bloc.dart';
import 'package:nsymphony_eats_dashboard/presentation/bloc/attendance/attendance_event.dart';
import 'package:nsymphony_eats_dashboard/presentation/bloc/attendance/attendance_state.dart';
import 'package:nsymphony_eats_dashboard/presentation/resources/app_colors.dart';
import 'package:nsymphony_eats_dashboard/presentation/resources/app_dimens.dart';

/// Widget displaying today's attendance and meal preferences (1/4 of the screen)
class AttendancePanel extends StatelessWidget {
  const AttendancePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceVariant,
      child: BlocBuilder<AttendanceBloc, AttendanceState>(
        builder: (context, state) {
          if (state is AttendanceLoading) {
            return Container(
              color: Colors.white.withValues(alpha: 0.5),
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
            );
          }

          if (state is AttendanceCountsLoaded) {
            return _buildContent(context, state);
          }

          if (state is AttendanceError) {
            return Container(
              color: AppColors.error.withValues(alpha: 0.1),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimens.spacing24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 40,
                        color: AppColors.error,
                      ),
                      const SizedBox(width: AppDimens.spacing16),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Error Loading Data',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.error,
                              ),
                            ),
                            const SizedBox(height: AppDimens.spacing6),
                            Text(
                              state.message,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppDimens.spacing24),
                      ElevatedButton.icon(
                        onPressed: () {
                          context
                              .read<AttendanceBloc>()
                              .add(const LoadTodayMealPreferenceCounts());
                        },
                        icon: const Icon(Icons.refresh, size: 20),
                        label: const Text('Retry', style: TextStyle(fontSize: 16)),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimens.spacing20,
                            vertical: AppDimens.spacing12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, AttendanceCountsLoaded state) {
    final counts = state.counts;

    return Container(
      color: Colors.white.withValues(alpha: 0.5),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spacing48,
        vertical: AppDimens.spacing8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: Date
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Today',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppDimens.spacing4),
              Text(
                DateFormat('MMMM d, yyyy').format(counts.date),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppDimens.spacing4),
              Text(
                DateFormat('HH:mm').format(DateTime.now()),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(width: AppDimens.spacing32),

          // Meal Stats
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _buildCompactStatCard(
                    label: 'Regular',
                    count: counts.regularCount,
                    color: AppColors.regular,
                    icon: Icons.restaurant,
                  ),
                ),
                const SizedBox(width: AppDimens.spacing12),
                Expanded(
                  child: _buildCompactStatCard(
                    label: 'Vegetarian',
                    count: counts.vegetarianCount,
                    color: AppColors.vegetarian,
                    icon: Icons.eco,
                  ),
                ),
                if (counts.noPreferenceCount > 0) ...[
                  const SizedBox(width: AppDimens.spacing12),
                  Expanded(
                    child: _buildCompactStatCard(
                      label: 'No Pref.',
                      count: counts.noPreferenceCount,
                      color: AppColors.warning,
                      icon: Icons.help_outline,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactStatCard({
    required String label,
    required int count,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spacing16,
        vertical: AppDimens.spacing8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(height: AppDimens.spacing4),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: color,
              height: 1,
            ),
          ),
          const SizedBox(height: AppDimens.spacing4),
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
              letterSpacing: 0.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
