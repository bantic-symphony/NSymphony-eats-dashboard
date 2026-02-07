import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nsymphony_eats_dashboard/core/di/service_locator.dart';
import 'package:nsymphony_eats_dashboard/presentation/bloc/attendance/attendance_bloc.dart';
import 'package:nsymphony_eats_dashboard/presentation/bloc/attendance/attendance_event.dart';
import 'package:nsymphony_eats_dashboard/presentation/bloc/menu/menu_bloc.dart';
import 'package:nsymphony_eats_dashboard/presentation/bloc/menu/menu_event.dart';
import 'package:nsymphony_eats_dashboard/presentation/resources/app_colors.dart';
import 'package:nsymphony_eats_dashboard/presentation/widget/attendance_panel.dart';
import 'package:nsymphony_eats_dashboard/presentation/widget/menu_panel.dart';

/// Dashboard page displaying weekly menu and attendance side by side.
/// Layout: 3/4 menu + 1/4 attendance
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              getIt<MenuBloc>()..add(const SubscribeToCurrentWeekMenu()),
        ),
        BlocProvider(
          create: (_) =>
              getIt<AttendanceBloc>()..add(const SubscribeToTodayMealPreferenceCounts()),
        ),
      ],
      child: const _DashboardPageContent(),
    );
  }
}

class _DashboardPageContent extends StatelessWidget {
  const _DashboardPageContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 4,
        toolbarHeight: 80,
        title: const Row(
          children: [
            Icon(
              Icons.restaurant_menu,
              size: 36,
              color: AppColors.textOnPrimary,
            ),
            SizedBox(width: 16),
            Text(
              'NSymphony Eats - Weekly Menu',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppColors.textOnPrimary,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Menu Panel (takes most of the height)
          Expanded(
            flex: 7,
            child: MenuPanel(),
          ),

          // Attendance Panel (bottom strip)
          const Expanded(
            flex: 3,
            child: AttendancePanel(),
          ),
        ],
      ),
    );
  }
}
