import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nsymphony_eats_dashboard/core/constants/firebase_constants.dart';
import 'package:nsymphony_eats_dashboard/core/utils/app_logger.dart';
import 'package:nsymphony_eats_dashboard/data/datasource/firestore_datasource.dart';
import 'package:nsymphony_eats_dashboard/data/model/week_menu_dto.dart';
import 'package:intl/intl.dart';

/// Implementation of [FirestoreDataSource] using Cloud Firestore.
class FirestoreDataSourceImpl implements FirestoreDataSource {
  final FirebaseFirestore _firestore;

  FirestoreDataSourceImpl(this._firestore);

  @override
  Future<WeekMenuDto?> getWeekMenu(String weekId) async {
    try {
      AppLogger.log('Fetching menu for week: $weekId', tag: 'FIRESTORE');

      final doc = await _firestore
          .collection(FirebaseConstants.menusCollection)
          .doc(weekId)
          .get();

      if (!doc.exists || doc.data() == null) {
        AppLogger.log('Menu not found for week: $weekId', tag: 'FIRESTORE');
        return null;
      }

      AppLogger.success('Menu fetched successfully for week: $weekId', tag: 'FIRESTORE');
      return WeekMenuDto.fromJson(doc.data()!);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to fetch menu for week: $weekId',
        tag: 'FIRESTORE',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Stream<WeekMenuDto?> getWeekMenuStream(String weekId) {
    AppLogger.log('Setting up real-time stream for week: $weekId', tag: 'FIRESTORE');

    return _firestore
        .collection(FirebaseConstants.menusCollection)
        .doc(weekId)
        .snapshots()
        .map((snapshot) {
      try {
        if (!snapshot.exists || snapshot.data() == null) {
          AppLogger.log('Stream update: Menu not found for week: $weekId', tag: 'FIRESTORE');
          return null;
        }
        AppLogger.success('Stream update: Menu received for week: $weekId', tag: 'FIRESTORE');
        return WeekMenuDto.fromJson(snapshot.data()!);
      } catch (e, stackTrace) {
        AppLogger.error(
          'Stream error for week: $weekId',
          tag: 'FIRESTORE',
          error: e,
          stackTrace: stackTrace,
        );
        return null;
      }
    }).handleError((error, stackTrace) {
      AppLogger.error(
        'Stream error for week: $weekId',
        tag: 'FIRESTORE',
        error: error,
        stackTrace: stackTrace,
      );
    });
  }

  @override
  Future<Map<String, dynamic>?> getTodayAttendanceAndPreferences() async {
    try {
      final now = DateTime.now();
      final today = DateFormat('yyyy-MM-dd').format(now);
      AppLogger.log('Current DateTime: $now', tag: 'FIRESTORE');
      AppLogger.log('Formatted date: $today', tag: 'FIRESTORE');
      AppLogger.log('Fetching attendance for date: $today', tag: 'FIRESTORE');

      // Get today's attendance from daily_logs
      final attendanceDoc = await _firestore
          .collection(FirebaseConstants.dailyLogsCollection)
          .doc(today)
          .get();

      if (!attendanceDoc.exists || attendanceDoc.data() == null) {
        AppLogger.log('❌ No attendance found for today: $today', tag: 'FIRESTORE');

        // Check what dates do exist in daily_logs
        AppLogger.log('Checking recent daily_logs documents...', tag: 'FIRESTORE');
        final recentLogs = await _firestore
            .collection(FirebaseConstants.dailyLogsCollection)
            .orderBy(FieldPath.documentId, descending: true)
            .limit(10)
            .get();

        AppLogger.log('Found ${recentLogs.docs.length} recent daily_logs:', tag: 'FIRESTORE');
        for (final doc in recentLogs.docs) {
          final cardCount = (doc.data()['cardNumbers'] as List?)?.length ?? 0;
          AppLogger.log('  - ${doc.id}: $cardCount attendees', tag: 'FIRESTORE');
        }

        return {
          'cardNumbers': <String>[],
          'regular': 0,
          'vegetarian': 0,
          'glutenFree': 0,
          'nonPork': 0,
        };
      }

      final data = attendanceDoc.data()!;

      // Parse card numbers from entries array
      final entries = data['entries'] as List<dynamic>?;
      final cardNumbers = entries
              ?.map((entry) {
                if (entry is Map<String, dynamic>) {
                  return entry['cardNumber']?.toString() ?? '';
                }
                return entry.toString();
              })
              .where((cardNumber) => cardNumber.isNotEmpty)
              .toList() ??
          [];

      AppLogger.log('Found ${cardNumbers.length} attendees for today (from ${entries?.length ?? 0} entries)', tag: 'FIRESTORE');

      // Get meal preferences for attendees
      if (cardNumbers.isEmpty) {
        return {
          'cardNumbers': <String>[],
          'regular': 0,
          'vegetarian': 0,
          'glutenFree': 0,
          'nonPork': 0,
        };
      }

      AppLogger.log('Fetching meal preferences for ${cardNumbers.length} users', tag: 'FIRESTORE');

      // Fetch meal preferences in batches (Firestore whereIn limit is 10)
      final allDocs = <QueryDocumentSnapshot>[];
      for (var i = 0; i < cardNumbers.length; i += 10) {
        final batch = cardNumbers.skip(i).take(10).toList();
        AppLogger.log('Fetching batch ${(i / 10).floor() + 1}: ${batch.length} users', tag: 'FIRESTORE');

        final snapshot = await _firestore
            .collection(FirebaseConstants.userMealPreferencesCollection)
            .where(FieldPath.documentId, whereIn: batch)
            .get();

        allDocs.addAll(snapshot.docs);
      }

      AppLogger.log('Found ${allDocs.length} meal preferences total', tag: 'FIRESTORE');

      // Count meal types
      var regularCount = 0;
      var vegetarianCount = 0;
      var glutenFreeCount = 0;
      var nonPorkCount = 0;

      for (final doc in allDocs) {
        final docData = doc.data() as Map<String, dynamic>?;
        final mealType = docData?['mealType'] as String?;
        AppLogger.log('User ${doc.id}: mealType = $mealType', tag: 'FIRESTORE');
        switch (mealType) {
          case 'regular':
            regularCount++;
            break;
          case 'vegetarian':
            vegetarianCount++;
            break;
          case 'glutenFree':
            glutenFreeCount++;
            break;
          case 'nonPork':
            nonPorkCount++;
            break;
        }
      }

      AppLogger.success(
        'Attendance loaded: Total=${cardNumbers.length}, Regular=$regularCount, Veg=$vegetarianCount, GF=$glutenFreeCount, NP=$nonPorkCount',
        tag: 'FIRESTORE',
      );

      return {
        'cardNumbers': cardNumbers,
        'regular': regularCount,
        'vegetarian': vegetarianCount,
        'glutenFree': glutenFreeCount,
        'nonPork': nonPorkCount,
      };
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to fetch attendance and preferences',
        tag: 'FIRESTORE',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
