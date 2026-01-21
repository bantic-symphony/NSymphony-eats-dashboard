import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nsymphony_eats_dashboard/core/di/service_locator.dart';
import 'package:nsymphony_eats_dashboard/core/utils/app_logger.dart';
import 'package:nsymphony_eats_dashboard/firebase_options.dart';
import 'package:nsymphony_eats_dashboard/presentation/page/dashboard_page.dart';
import 'package:nsymphony_eats_dashboard/presentation/resources/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    AppLogger.log('Initializing Firebase...', tag: 'INIT');

    // Initialize Firebase with generated options
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    AppLogger.success('Firebase initialized successfully', tag: 'INIT');
    AppLogger.log('Project ID: ${DefaultFirebaseOptions.web.projectId}', tag: 'INIT');

    // Setup dependency injection
    AppLogger.log('Setting up dependency injection...', tag: 'INIT');
    await setupDependencyInjection();
    AppLogger.success('Dependency injection setup complete', tag: 'INIT');

    runApp(const MyApp());
  } catch (e, stackTrace) {
    AppLogger.error(
      'Failed to initialize app',
      tag: 'INIT',
      error: e,
      stackTrace: stackTrace,
    );
    rethrow;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Symphony Eats Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.accent,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        cardTheme: const CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      home: const DashboardPage(),
    );
  }
}
