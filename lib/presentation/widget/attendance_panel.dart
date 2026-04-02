import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nsymphony_eats_dashboard/core/constants/app_constants.dart';
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
              color: Colors.white.withValues(alpha: AppConstants.opacityWhiteOverlay),
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: AppConstants.loadingStrokeWidthThin),
              ),
            );
          }

          if (state is AttendanceCountsLoaded) {
            return _buildContent(context, state);
          }

          if (state is AttendanceError) {
            return Container(
              color: AppColors.error.withValues(alpha: AppConstants.opacityErrorBg),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimens.spacing24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: AppConstants.iconSizeError,
                        color: AppColors.error,
                      ),
                      const SizedBox(width: AppDimens.spacing16),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              AppConstants.errorLoadingData,
                              style: TextStyle(
                                fontSize: AppConstants.fontSizeErrorTitle,
                                fontWeight: FontWeight.bold,
                                color: AppColors.error,
                              ),
                            ),
                            const SizedBox(height: AppDimens.spacing6),
                            Text(
                              state.message,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: AppConstants.fontSizeErrorMessage,
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
                        icon: const Icon(Icons.refresh, size: AppConstants.iconSizeRefresh),
                        label: const Text(AppConstants.labelRetry, style: TextStyle(fontSize: AppConstants.fontSizeRetryButton)),
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
      color: Colors.white.withValues(alpha: AppConstants.opacityWhiteOverlay),
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
                AppConstants.labelToday,
                style: TextStyle(
                  fontSize: AppConstants.fontSizeToday,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppDimens.spacing4),
              Text(
                DateFormat(AppConstants.dateFormatFull).format(counts.date),
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeDateLabel,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppDimens.spacing4),
              Text(
                DateFormat(AppConstants.timeFormat24h).format(DateTime.now()),
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeTime,
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
                    label: AppConstants.labelRegular,
                    count: counts.regularCount,
                    color: AppColors.regular,
                    icon: Icons.restaurant,
                  ),
                ),
                const SizedBox(width: AppDimens.spacing12),
                Expanded(
                  child: _buildCompactStatCard(
                    label: AppConstants.labelVegetarian,
                    count: counts.vegetarianCount,
                    color: AppColors.vegetarian,
                    icon: Icons.eco,
                  ),
                ),
                if (counts.noPreferenceCount > 0) ...[
                  const SizedBox(width: AppDimens.spacing12),
                  Expanded(
                    child: _buildCompactStatCard(
                      label: AppConstants.labelNoPreference,
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
        color: Colors.white.withValues(alpha: AppConstants.opacityWhiteOverlayStrong),
        borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
        border: Border.all(
          color: color.withValues(alpha: AppConstants.opacityStatBorder),
          width: AppConstants.statCardBorderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: AppConstants.opacityStatShadow),
            blurRadius: AppConstants.statCardShadowBlur,
            offset: const Offset(0, AppConstants.statCardShadowOffsetY),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: AppConstants.iconSizeStat, color: color),
          const SizedBox(height: AppDimens.spacing4),
          Text(
            '$count',
            style: TextStyle(
              fontSize: AppConstants.fontSizeStatCount,
              fontWeight: FontWeight.w900,
              color: color,
              height: 1,
            ),
          ),
          const SizedBox(height: AppDimens.spacing4),
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: AppConstants.fontSizeChipLabel,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
              letterSpacing: AppConstants.letterSpacingStatLabel,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
