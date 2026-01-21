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
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AttendanceCountsLoaded) {
            return _buildContent(context, state);
          }

          if (state is AttendanceError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppDimens.spacing16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 32,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: AppDimens.spacing12),
                    Text(
                      'Error Loading Data',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppDimens.spacing8),
                    Text(
                      state.message,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimens.spacing16),
                    ElevatedButton.icon(
                      onPressed: () {
                        context
                            .read<AttendanceBloc>()
                            .add(const LoadTodayMealPreferenceCounts());
                      },
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text('Retry', style: TextStyle(fontSize: 12)),
                    ),
                  ],
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
    final dateFormat = DateFormat('d.MM.yyyy');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          const Text(
            'Attendance',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppDimens.spacing4),
          Text(
            dateFormat.format(counts.date),
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimens.spacing16),

          // Total Attendees Card
          Card(
            elevation: 4,
            color: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.spacing16),
              child: Column(
                children: [
                  const Icon(
                    Icons.people,
                    size: 32,
                    color: AppColors.textOnPrimary,
                  ),
                  const SizedBox(height: AppDimens.spacing8),
                  const Text(
                    'Total Attendees',
                    style: TextStyle(
                      color: AppColors.textOnPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: AppDimens.spacing4),
                  Text(
                    '${counts.totalAttendees}',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimens.spacing16),

          // Meal Types Title
          const Text(
            'Meal Preferences',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppDimens.spacing8),

          // Regular Meals Card
          _buildMealTypeCard(
            icon: Icons.restaurant,
            count: counts.regularCount,
            total: counts.totalWithPreference,
            label: 'Regular',
            color: AppColors.regular,
          ),
          const SizedBox(height: AppDimens.spacing8),

          // Vegetarian Meals Card
          _buildMealTypeCard(
            icon: Icons.eco,
            count: counts.vegetarianCount,
            total: counts.totalWithPreference,
            label: 'Vegetarian',
            color: AppColors.vegetarian,
          ),
          const SizedBox(height: AppDimens.spacing8),

          // Gluten-Free Meals Card
          _buildMealTypeCard(
            icon: Icons.health_and_safety,
            count: counts.glutenFreeCount,
            total: counts.totalWithPreference,
            label: 'Gluten-Free',
            color: AppColors.glutenFree,
          ),
          const SizedBox(height: AppDimens.spacing8),

          // Non-Pork Meals Card
          _buildMealTypeCard(
            icon: Icons.verified,
            count: counts.nonPorkCount,
            total: counts.totalWithPreference,
            label: 'Non-Pork',
            color: AppColors.nonPork,
          ),

          // No Preference Card (only show if > 0)
          if (counts.noPreferenceCount > 0) ...[
            const SizedBox(height: AppDimens.spacing8),
            Card(
              color: AppColors.warning.withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppDimens.spacing12),
                child: Row(
                  children: [
                    const Icon(
                      Icons.help_outline,
                      size: 24,
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: AppDimens.spacing8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${counts.noPreferenceCount}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.warning,
                            ),
                          ),
                          const SizedBox(height: AppDimens.spacing4),
                          const Text(
                            'No preference set',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          // Last updated
          const SizedBox(height: AppDimens.spacing16),
          Text(
            'Last updated: ${DateFormat('HH:mm:ss').format(DateTime.now())}',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMealTypeCard({
    required IconData icon,
    required int count,
    required int total,
    required String label,
    required Color color,
  }) {
    final percentage = total > 0 ? count / total : 0.0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spacing12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: color,
                ),
                const SizedBox(width: AppDimens.spacing8),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.spacing8),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
              child: LinearProgressIndicator(
                value: percentage,
                minHeight: 6,
                backgroundColor: color.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            const SizedBox(height: AppDimens.spacing4),
            Text(
              '${(percentage * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 13,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
