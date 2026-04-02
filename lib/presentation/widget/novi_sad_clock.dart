import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nsymphony_eats_dashboard/core/constants/app_constants.dart';
import 'package:nsymphony_eats_dashboard/presentation/resources/app_colors.dart';

/// A clock widget displaying Novi Sad time (Europe/Belgrade timezone) in 24h format.
class NoviSadClock extends StatefulWidget {
  const NoviSadClock({super.key});

  @override
  State<NoviSadClock> createState() => _NoviSadClockState();
}

class _NoviSadClockState extends State<NoviSadClock> {
  late Timer _timer;
  late DateTime _noviSadTime;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: AppConstants.clockUpdateIntervalSeconds), (_) => _updateTime());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    // Novi Sad is UTC+1 (CET) or UTC+2 (CEST during daylight saving)
    final now = DateTime.now().toUtc();
    final noviSadOffset = _getNoviSadOffset(now);
    setState(() {
      _noviSadTime = now.add(Duration(hours: noviSadOffset));
    });
  }

  /// Returns the Novi Sad timezone offset from UTC.
  /// Novi Sad observes CET (UTC+1) in winter and CEST (UTC+2) in summer.
  int _getNoviSadOffset(DateTime utcTime) {
    // DST in Europe: last Sunday of March to last Sunday of October
    final year = utcTime.year;

    // Find last Sunday of March
    final marchEnd = DateTime.utc(year, 3, 31);
    final dstStart = marchEnd.subtract(Duration(days: marchEnd.weekday % 7));

    // Find last Sunday of October
    final octoberEnd = DateTime.utc(year, 10, 31);
    final dstEnd = octoberEnd.subtract(Duration(days: octoberEnd.weekday % 7));

    // DST transition happens at 1:00 UTC
    final dstStartUtc = DateTime.utc(year, dstStart.month, dstStart.day, AppConstants.dstTransitionHourUtc);
    final dstEndUtc = DateTime.utc(year, dstEnd.month, dstEnd.day, AppConstants.dstTransitionHourUtc);

    if (utcTime.isAfter(dstStartUtc) && utcTime.isBefore(dstEndUtc)) {
      return AppConstants.noviSadSummerOffset; // CEST (summer time)
    }
    return AppConstants.noviSadWinterOffset; // CET (winter time)
  }

  @override
  Widget build(BuildContext context) {
    final hours = _noviSadTime.hour.toString().padLeft(2, '0');
    final minutes = _noviSadTime.minute.toString().padLeft(2, '0');

    return Text(
      '$hours:$minutes',
      style: const TextStyle(
        fontSize: AppConstants.clockFontSize,
        fontWeight: FontWeight.w600,
        color: AppColors.textOnPrimary,
        letterSpacing: AppConstants.clockLetterSpacing,
      ),
    );
  }
}