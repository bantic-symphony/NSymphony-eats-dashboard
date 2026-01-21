import 'package:nsymphony_eats_dashboard/domain/model/attendance_count.dart' as domain;

/// Data Transfer Object for AttendanceCount.
class AttendanceCountDto {
  final String date;
  final int regularCount;
  final int vegetarianCount;
  final int glutenFreeCount;
  final int nonPorkCount;
  final int totalAttendees;

  AttendanceCountDto({
    required this.date,
    required this.regularCount,
    required this.vegetarianCount,
    required this.glutenFreeCount,
    required this.nonPorkCount,
    required this.totalAttendees,
  });

  domain.AttendanceCount toDomain() {
    return domain.AttendanceCount(
      date: DateTime.parse(date),
      regularCount: regularCount,
      vegetarianCount: vegetarianCount,
      glutenFreeCount: glutenFreeCount,
      nonPorkCount: nonPorkCount,
      totalAttendees: totalAttendees,
    );
  }

  factory AttendanceCountDto.fromDomain(domain.AttendanceCount count) {
    return AttendanceCountDto(
      date: count.date.toIso8601String(),
      regularCount: count.regularCount,
      vegetarianCount: count.vegetarianCount,
      glutenFreeCount: count.glutenFreeCount,
      nonPorkCount: count.nonPorkCount,
      totalAttendees: count.totalAttendees,
    );
  }
}
