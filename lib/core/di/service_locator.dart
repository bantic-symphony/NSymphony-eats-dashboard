import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:nsymphony_eats_dashboard/data/datasource/firestore_datasource.dart';
import 'package:nsymphony_eats_dashboard/data/datasource/firestore_datasource_impl.dart';
import 'package:nsymphony_eats_dashboard/data/repository/attendance_repository_impl.dart';
import 'package:nsymphony_eats_dashboard/data/repository/menu_repository_impl.dart';
import 'package:nsymphony_eats_dashboard/domain/repository/attendance_repository.dart';
import 'package:nsymphony_eats_dashboard/domain/repository/menu_repository.dart';
import 'package:nsymphony_eats_dashboard/domain/usecase/get_current_week_menu_usecase.dart';
import 'package:nsymphony_eats_dashboard/domain/usecase/get_today_meal_preference_counts_usecase.dart';
import 'package:nsymphony_eats_dashboard/domain/usecase/stream_current_week_menu_usecase.dart';
import 'package:nsymphony_eats_dashboard/presentation/bloc/attendance/attendance_bloc.dart';
import 'package:nsymphony_eats_dashboard/presentation/bloc/menu/menu_bloc.dart';

final getIt = GetIt.instance;

/// Initializes all dependencies
Future<void> setupDependencyInjection() async {
  // External dependencies
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  // Data sources
  getIt.registerLazySingleton<FirestoreDataSource>(
    () => FirestoreDataSourceImpl(getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<MenuRepository>(
    () => MenuRepositoryImpl(getIt()),
  );

  getIt.registerLazySingleton<AttendanceRepository>(
    () => AttendanceRepositoryImpl(getIt()),
  );

  // Use cases (Factory for fresh instances)
  getIt.registerFactory<GetCurrentWeekMenuUseCase>(
    () => GetCurrentWeekMenuUseCase(getIt()),
  );

  getIt.registerFactory<StreamCurrentWeekMenuUseCase>(
    () => StreamCurrentWeekMenuUseCase(getIt()),
  );

  getIt.registerFactory<GetTodayMealPreferenceCountsUseCase>(
    () => GetTodayMealPreferenceCountsUseCase(getIt()),
  );

  // BLoCs (Factory for fresh instances)
  getIt.registerFactory<MenuBloc>(
    () => MenuBloc(getIt(), getIt()),
  );

  getIt.registerFactory<AttendanceBloc>(
    () => AttendanceBloc(getIt()),
  );

  // Wait for all async registrations to complete
  await getIt.allReady();
}
