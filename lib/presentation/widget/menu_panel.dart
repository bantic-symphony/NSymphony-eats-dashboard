import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nsymphony_eats_dashboard/core/constants/app_constants.dart';
import 'package:nsymphony_eats_dashboard/domain/model/day_menu.dart';
import 'package:nsymphony_eats_dashboard/domain/model/menu_item.dart';
import 'package:nsymphony_eats_dashboard/presentation/bloc/attendance/attendance_bloc.dart';
import 'package:nsymphony_eats_dashboard/presentation/bloc/attendance/attendance_state.dart';
import 'package:nsymphony_eats_dashboard/presentation/bloc/menu/menu_bloc.dart';
import 'package:nsymphony_eats_dashboard/presentation/bloc/menu/menu_state.dart';
import 'package:nsymphony_eats_dashboard/presentation/resources/app_colors.dart';
import 'package:nsymphony_eats_dashboard/presentation/resources/app_dimens.dart';
import 'package:nsymphony_eats_dashboard/presentation/widget/decorative_background.dart';

/// Widget displaying the weekly menu (3/4 of the screen)
class MenuPanel extends StatefulWidget {
  const MenuPanel({super.key});

  @override
  State<MenuPanel> createState() => _MenuPanelState();
}

class _MenuPanelState extends State<MenuPanel> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _slideAnimations;
  late List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      AppConstants.weekdayCount,
      (index) => AnimationController(
        duration: Duration(milliseconds: AppConstants.animationBaseDuration + (index * AppConstants.animationStaggerDelay)),
        vsync: this,
      ),
    );

    _slideAnimations = _controllers.map((controller) {
      return Tween<double>(begin: AppConstants.animationSlideOffset, end: 0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutCubic),
      );
    }).toList();

    _fadeAnimations = _controllers.map((controller) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeIn),
      );
    }).toList();

    // Start animations with delay
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * AppConstants.animationStaggerDelay), () {
        if (mounted) _controllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Decorative background
        Positioned.fill(
          child: DecorativeBackground(key: ValueKey('decorative_background')),
        ),

        // Menu content
        BlocBuilder<MenuBloc, MenuState>(
          builder: (context, state) {
            if (state is MenuLoading) {
              return const Center(
                child: CircularProgressIndicator(strokeWidth: AppConstants.loadingStrokeWidth),
              );
            }

            if (state is MenuLoaded) {
              return _buildMenuContent(context, state.menu.days);
            }

        if (state is MenuEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.restaurant_menu_outlined,
                  size: AppConstants.iconSizeEmptyState,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: AppDimens.spacing24),
                Text(
                  state.message,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: AppConstants.fontSizeEmptyStateMessage,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        if (state is MenuError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: AppConstants.iconSizeEmptyState,
                  color: AppColors.error,
                ),
                const SizedBox(height: AppDimens.spacing24),
                Text(
                  state.message,
                  style: const TextStyle(
                    color: AppColors.error,
                    fontSize: AppConstants.fontSizeEmptyStateMessage,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildMenuContent(BuildContext context, List<DayMenu> days) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacing16, vertical: AppDimens.spacing24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: days.map((day) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacing6),
              child: _buildDayCard(context, day),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDayCard(BuildContext context, DayMenu day) {
    final dateFormat = DateFormat(AppConstants.dateFormatMonthDay);
    final isToday = DateUtils.isSameDay(day.date, DateTime.now());

    final card = Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: isToday ? AppConstants.opacityCardToday : AppConstants.opacityCardNormal),
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        boxShadow: isToday
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: AppConstants.opacityTodayShadow),
                  blurRadius: AppConstants.cardTodayShadowBlur,
                  spreadRadius: AppConstants.cardTodayShadowSpread,
                  offset: const Offset(0, AppConstants.cardTodayShadowOffsetY),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: AppConstants.opacityBlackShadow),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: AppConstants.opacityBlackShadowLight),
                  blurRadius: AppConstants.cardNormalShadowBlur,
                  offset: const Offset(0, AppConstants.cardNormalShadowOffsetY),
                ),
              ],
        border: isToday
            ? Border.all(color: AppColors.primary.withValues(alpha: AppConstants.opacityTodayBorder), width: AppConstants.cardBorderWidthToday)
            : Border.all(color: Colors.black.withValues(alpha: AppConstants.opacityBlackShadow), width: AppConstants.cardBorderWidthNormal),
      ),
      child: _buildDayCardContent(day, dateFormat, isToday),
    );

    return card;
  }

  Widget _buildDayCardContent(DayMenu day, DateFormat dateFormat, bool isToday) {
    return Stack(
      children: [
        // Card content fills the card, with bottom space reserved for chips
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppDimens.spacing24,
              AppDimens.spacing24,
              AppDimens.spacing24,
              isToday ? AppConstants.chipsAreaHeight : AppDimens.spacing24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Column(
                  children: [
                    Text(
                      day.weekday.displayName.toUpperCase(),
                      style: TextStyle(
                        fontSize: isToday ? AppConstants.fontSizeWeekdayToday : AppConstants.fontSizeWeekdayNormal,
                        fontWeight: FontWeight.w800,
                        color: isToday ? AppColors.primary : AppColors.textPrimary,
                        letterSpacing: AppConstants.letterSpacingWeekday,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimens.spacing6),
                    Text(
                      dateFormat.format(day.date),
                      style: TextStyle(
                        fontSize: isToday ? AppConstants.fontSizeDateToday : AppConstants.fontSizeDateNormal,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: AppDimens.spacing16),
                Container(height: AppConstants.dividerHeight, color: AppColors.divider.withValues(alpha: AppConstants.opacityDivider)),
                const SizedBox(height: AppDimens.spacing16),

                // Menu content
                if (day.isClosed && day.note != null) ...[
                  _buildClosedNote(context, day.note!),
                ] else if (day.hasMenu) ...[
                  if (day.regular.isNotEmpty) ...[
                    _buildMealSection(
                      context,
                      mealType: MealType.regular,
                      icon: Icons.restaurant,
                      iconColor: AppColors.primary,
                      label: AppConstants.labelRegular,
                      items: day.regular,
                      isToday: isToday,
                    ),
                    if (day.vege.isNotEmpty)
                      const SizedBox(height: AppDimens.spacing20),
                  ],
                  if (day.vege.isNotEmpty) ...[
                    _buildMealSection(
                      context,
                      mealType: MealType.vegetarian,
                      icon: Icons.eco,
                      iconColor: AppColors.success,
                      label: AppConstants.labelVegetarian,
                      items: day.vege,
                      isToday: isToday,
                    ),
                  ],
                ] else ...[
                  _buildNoMenuNote(context, day.note),
                ],
              ],
            ),
          ),
        ),

        // Attendance counts — absolutely positioned at the bottom
        if (isToday)
          Positioned(
            bottom: AppDimens.spacing16,
            left: AppDimens.spacing16,
            right: AppDimens.spacing16,
            child: BlocBuilder<AttendanceBloc, AttendanceState>(
              builder: (context, state) {
                if (state is! AttendanceCountsLoaded) return const SizedBox.shrink();
                final counts = state.counts;
                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: _buildCountChip(
                          count: counts.regularCount,
                          color: AppColors.regular,
                          label: AppConstants.labelRegular,
                        ),
                      ),
                      const SizedBox(width: AppDimens.spacing8),
                      Expanded(
                        child: _buildCountChip(
                          count: counts.vegetarianCount,
                          color: AppColors.vegetarian,
                          label: AppConstants.labelVegetarian,
                        ),
                      ),
                      if (counts.noPreferenceCount > 0) ...[
                        const SizedBox(width: AppDimens.spacing8),
                        Expanded(
                          child: _buildCountChip(
                            count: counts.noPreferenceCount,
                            color: AppColors.warning,
                            label: AppConstants.labelNoPreference,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildClosedNote(BuildContext context, String note) {
    return Column(
      children: [
        const Icon(
          Icons.event_busy,
          size: AppConstants.iconSizeClosedNote,
          color: AppColors.textSecondary,
        ),
        const SizedBox(height: AppDimens.spacing12),
        Text(
          note,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontStyle: FontStyle.italic,
            fontSize: AppConstants.fontSizeNote,
            height: AppConstants.lineHeightNote,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildNoMenuNote(BuildContext context, String? note) {
    return Column(
      children: [
        const Icon(
          Icons.info_outline,
          size: AppConstants.iconSizeClosedNote,
          color: AppColors.textSecondary,
        ),
        const SizedBox(height: AppDimens.spacing12),
        Text(
          note ?? AppConstants.noMenuAvailable,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontStyle: FontStyle.italic,
            fontSize: AppConstants.fontSizeNote,
            height: AppConstants.lineHeightNote,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCountChip({
    required int count,
    required Color color,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spacing12,
        vertical: AppDimens.spacing12,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$count',
            style: const TextStyle(
              fontSize: AppConstants.fontSizeChipCount,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1,
            ),
          ),
          const SizedBox(height: AppDimens.spacing4),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: AppConstants.fontSizeChipLabel,
              fontWeight: FontWeight.w700,
              color: Colors.white.withValues(alpha: AppConstants.opacityChipLabel),
              letterSpacing: AppConstants.letterSpacingChipLabel,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealSection(
    BuildContext context, {
    required MealType mealType,
    required IconData icon,
    required Color iconColor,
    required String label,
    required List<MenuItem> items,
    bool isToday = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Label with icon
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: isToday ? AppConstants.iconSizeMealToday : AppConstants.iconSizeMealNormal, color: iconColor),
            const SizedBox(width: AppDimens.spacing8),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: isToday ? AppConstants.fontSizeMealLabelToday : AppConstants.fontSizeMealLabelNormal,
                  fontWeight: FontWeight.w700,
                  color: iconColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spacing8),
        // Menu items
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: AppDimens.spacing6),
            child: Text(
              '• ${item.name}',
              style: TextStyle(
                fontSize: isToday ? AppConstants.fontSizeMealItemToday : AppConstants.fontSizeMealItemNormal,
                color: AppColors.textPrimary,
                height: AppConstants.lineHeightMealItem,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
