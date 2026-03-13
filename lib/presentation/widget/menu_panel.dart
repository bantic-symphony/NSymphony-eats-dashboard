import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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
      5,
      (index) => AnimationController(
        duration: Duration(milliseconds: 600 + (index * 100)),
        vsync: this,
      ),
    );

    _slideAnimations = _controllers.map((controller) {
      return Tween<double>(begin: 50, end: 0).animate(
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
      Future.delayed(Duration(milliseconds: i * 100), () {
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
                child: CircularProgressIndicator(strokeWidth: 4),
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
                  size: 96,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: AppDimens.spacing24),
                Text(
                  state.message,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 24,
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
                  size: 96,
                  color: AppColors.error,
                ),
                const SizedBox(height: AppDimens.spacing24),
                Text(
                  state.message,
                  style: const TextStyle(
                    color: AppColors.error,
                    fontSize: 24,
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
      padding: const EdgeInsets.all(AppDimens.spacing48),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: days.map((day) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacing12),
              child: _buildDayCard(context, day),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDayCard(BuildContext context, DayMenu day) {
    final dateFormat = DateFormat('MMM d');
    final isToday = DateUtils.isSameDay(day.date, DateTime.now());

    final card = Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: isToday ? 1.0 : 0.75),
        borderRadius: BorderRadius.circular(20),
        boxShadow: isToday
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.30),
                  blurRadius: 28,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
        border: isToday
            ? Border.all(color: AppColors.primary.withValues(alpha: 0.45), width: 2.5)
            : Border.all(color: Colors.black.withValues(alpha: 0.08), width: 1.5),
      ),
      child: _buildDayCardContent(day, dateFormat, isToday),
    );

    if (!isToday) return card;

    return Transform.scale(
      scale: 1.05,
      child: card,
    );
  }

  Widget _buildDayCardContent(DayMenu day, DateFormat dateFormat, bool isToday) {
    // Reserve space at the bottom for the attendance chip bar when showing today
    const double chipsAreaHeight = 130.0;

    return Stack(
      children: [
        // Card content fills the card, with bottom space reserved for chips
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppDimens.spacing24,
              AppDimens.spacing24,
              AppDimens.spacing24,
              isToday ? chipsAreaHeight : AppDimens.spacing24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Column(
                  children: [
                    if (isToday) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.spacing12,
                          vertical: AppDimens.spacing6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'TODAY',
                          style: TextStyle(
                            color: AppColors.textOnPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimens.spacing12),
                    ],
                    Text(
                      day.weekday.displayName.toUpperCase(),
                      style: TextStyle(
                        fontSize: isToday ? 52 : 34,
                        fontWeight: FontWeight.w800,
                        color: isToday ? AppColors.primary : AppColors.textPrimary,
                        letterSpacing: 0.8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimens.spacing6),
                    Text(
                      dateFormat.format(day.date),
                      style: TextStyle(
                        fontSize: isToday ? 34 : 26,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: AppDimens.spacing16),
                Container(height: 2, color: AppColors.divider.withValues(alpha: 0.2)),
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
                      label: 'Regular',
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
                      label: 'Vegetarian',
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
                          icon: Icons.restaurant,
                          count: counts.regularCount,
                          color: AppColors.regular,
                          label: 'Regular',
                        ),
                      ),
                      const SizedBox(width: AppDimens.spacing8),
                      Expanded(
                        child: _buildCountChip(
                          icon: Icons.eco,
                          count: counts.vegetarianCount,
                          color: AppColors.vegetarian,
                          label: 'Vegetarian',
                        ),
                      ),
                      if (counts.noPreferenceCount > 0) ...[
                        const SizedBox(width: AppDimens.spacing8),
                        Expanded(
                          child: _buildCountChip(
                            icon: Icons.help_outline,
                            count: counts.noPreferenceCount,
                            color: AppColors.warning,
                            label: 'No Pref.',
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
          size: 48,
          color: AppColors.textSecondary,
        ),
        const SizedBox(height: AppDimens.spacing12),
        Text(
          note,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontStyle: FontStyle.italic,
            fontSize: 20,
            height: 1.4,
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
          size: 48,
          color: AppColors.textSecondary,
        ),
        const SizedBox(height: AppDimens.spacing12),
        Text(
          note ?? 'No menu available',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontStyle: FontStyle.italic,
            fontSize: 20,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCountChip({
    required IconData icon,
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
          Icon(icon, size: 20, color: Colors.white.withValues(alpha: 0.85)),
          const SizedBox(height: AppDimens.spacing4),
          Text(
            '$count',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1,
            ),
          ),
          const SizedBox(height: AppDimens.spacing4),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.white.withValues(alpha: 0.8),
              letterSpacing: 0.8,
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
            Icon(icon, size: isToday ? 34 : 28, color: iconColor),
            const SizedBox(width: AppDimens.spacing8),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: isToday ? 30 : 24,
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
                fontSize: isToday ? 28 : 22,
                color: AppColors.textPrimary,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
