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
        title: const Text(
          'NSymphony Eats Dashboard',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textOnPrimary,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: Row(
        children: [
          // Menu Panel (3/4)
          Expanded(
            flex: 3,
            child: MenuPanel(),
          ),

          // Divider
          Container(
            width: 1,
            color: AppColors.divider,
          ),

          // Attendance Panel (1/4)
          const Expanded(
            flex: 1,
            child: AttendancePanel(),
          ),
        ],
      ),
    );
  }
}
