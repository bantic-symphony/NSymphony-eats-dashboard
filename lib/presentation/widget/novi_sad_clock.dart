import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nsymphony_eats_dashboard/presentation/resources/app_colors.dart';

/// A clock widget displaying Belgrade time (Europe/Belgrade timezone) in 24h format.
class NoviSadClock extends StatefulWidget {
  const NoviSadClock({super.key});

  @override
  State<NoviSadClock> createState() => _BelgradeClockState();
}

class _BelgradeClockState extends State<NoviSadClock> {
  late Timer _timer;
  late DateTime _belgradeTime;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    // Belgrade is UTC+1 (CET) or UTC+2 (CEST during daylight saving)
    final now = DateTime.now().toUtc();
    final belgradeOffset = _getBelgradeOffset(now);
    setState(() {
      _belgradeTime = now.add(Duration(hours: belgradeOffset));
    });
  }

  /// Returns the Belgrade timezone offset from UTC.
  /// Belgrade observes CET (UTC+1) in winter and CEST (UTC+2) in summer.
  int _getBelgradeOffset(DateTime utcTime) {
    // DST in Europe: last Sunday of March to last Sunday of October
    final year = utcTime.year;

    // Find last Sunday of March
    final marchEnd = DateTime.utc(year, 3, 31);
    final dstStart = marchEnd.subtract(Duration(days: marchEnd.weekday % 7));

    // Find last Sunday of October
    final octoberEnd = DateTime.utc(year, 10, 31);
    final dstEnd = octoberEnd.subtract(Duration(days: octoberEnd.weekday % 7));

    // DST transition happens at 1:00 UTC
    final dstStartUtc = DateTime.utc(year, dstStart.month, dstStart.day, 1);
    final dstEndUtc = DateTime.utc(year, dstEnd.month, dstEnd.day, 1);

    if (utcTime.isAfter(dstStartUtc) && utcTime.isBefore(dstEndUtc)) {
      return 2; // CEST (summer time)
    }
    return 1; // CET (winter time)
  }

  @override
  Widget build(BuildContext context) {
    final hours = _belgradeTime.hour.toString().padLeft(2, '0');
    final minutes = _belgradeTime.minute.toString().padLeft(2, '0');

    return Text(
      '$hours:$minutes',
      style: const TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.w600,
        color: AppColors.textOnPrimary,
        letterSpacing: 2,
      ),
    );
  }
}