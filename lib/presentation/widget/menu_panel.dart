import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nsymphony_eats_dashboard/domain/model/day_menu.dart';
import 'package:nsymphony_eats_dashboard/domain/model/menu_item.dart';
import 'package:nsymphony_eats_dashboard/presentation/bloc/menu/menu_bloc.dart';
import 'package:nsymphony_eats_dashboard/presentation/bloc/menu/menu_state.dart';
import 'package:nsymphony_eats_dashboard/presentation/resources/app_colors.dart';
import 'package:nsymphony_eats_dashboard/presentation/resources/app_dimens.dart';

/// Widget displaying the weekly menu (3/4 of the screen)
class MenuPanel extends StatelessWidget {
  const MenuPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuBloc, MenuState>(
      builder: (context, state) {
        if (state is MenuLoading) {
          return const Center(child: CircularProgressIndicator());
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
                  size: 64,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: AppDimens.spacing16),
                Text(
                  state.message,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 18,
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
                  size: 64,
                  color: AppColors.error,
                ),
                const SizedBox(height: AppDimens.spacing16),
                Text(
                  state.message,
                  style: const TextStyle(
                    color: AppColors.error,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildMenuContent(BuildContext context, List<DayMenu> days) {
    // Split days into two rows: 3 on top, 2 on bottom
    final topRowDays = days.take(3).toList();
    final bottomRowDays = days.skip(3).take(2).toList();

    return Padding(
      padding: const EdgeInsets.all(AppDimens.spacing16),
      child: Column(
        children: [
          // Top row with 3 cards - takes up half the space
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: topRowDays.map((day) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacing8),
                    child: _buildDayCard(context, day),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: AppDimens.spacing16),
          // Bottom row with 2 centered cards - takes up half the space
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: bottomRowDays.map((day) {
                return SizedBox(
                  width: (MediaQuery.of(context).size.width * 0.75 - AppDimens.spacing16 * 2) / 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacing8),
                    child: _buildDayCard(context, day),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayCard(BuildContext context, DayMenu day) {
    final dateFormat = DateFormat('d.MM');
    final isToday = DateUtils.isSameDay(day.date, DateTime.now());

    return Card(
      elevation: isToday ? 6 : 2,
      color: isToday ? AppColors.primary.withValues(alpha: 0.05) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        side: isToday
            ? const BorderSide(color: AppColors.primary, width: 3)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spacing12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
              // Header
              Column(
                children: [
                  if (isToday)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.spacing8,
                        vertical: AppDimens.spacing4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius:
                            BorderRadius.circular(AppDimens.radiusSmall),
                      ),
                      child: const Text(
                        'TODAY',
                        style: TextStyle(
                          color: AppColors.textOnPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  if (isToday) const SizedBox(height: AppDimens.spacing4),
                  Text(
                    day.weekday.displayName.toUpperCase(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isToday ? AppColors.primary : AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimens.spacing4),
                  Text(
                    dateFormat.format(day.date),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.spacing12),
              const Divider(height: 1),
              const SizedBox(height: AppDimens.spacing12),

              // Menu content
              if (day.isClosed && day.note != null) ...[
                _buildClosedNote(context, day.note!),
              ] else if (day.hasMenu) ...[
                // Regular meals
                if (day.regular.isNotEmpty) ...[
                  _buildMealSection(
                    context,
                    mealType: MealType.regular,
                    icon: Icons.restaurant,
                    iconColor: AppColors.primary,
                    label: 'Regular',
                    items: day.regular,
                  ),
                  if (day.vege.isNotEmpty)
                    const SizedBox(height: AppDimens.spacing12),
                ],

                // Vegetarian meals
                if (day.vege.isNotEmpty) ...[
                  _buildMealSection(
                    context,
                    mealType: MealType.vegetarian,
                    icon: Icons.eco,
                    iconColor: AppColors.success,
                    label: 'Vegetarian',
                    items: day.vege,
                  ),
                ],
              ] else ...[
                _buildNoMenuNote(context, day.note),
              ],
            ],
        ),
      ),
    );
  }

  Widget _buildClosedNote(BuildContext context, String note) {
    return Column(
      children: [
        const Icon(
          Icons.event_busy,
          size: 32,
          color: AppColors.textSecondary,
        ),
        const SizedBox(height: AppDimens.spacing8),
        Text(
          note,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontStyle: FontStyle.italic,
            fontSize: 12,
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
          size: 32,
          color: AppColors.textSecondary,
        ),
        const SizedBox(height: AppDimens.spacing8),
        Text(
          note ?? 'No menu available',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontStyle: FontStyle.italic,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildMealSection(
    BuildContext context, {
    required MealType mealType,
    required IconData icon,
    required Color iconColor,
    required String label,
    required List<MenuItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Label with icon
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: iconColor,
            ),
            const SizedBox(width: AppDimens.spacing4),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
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
            padding: const EdgeInsets.only(bottom: AppDimens.spacing4),
            child: Text(
              '• ${item.name}',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textPrimary,
                height: 1.3,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
