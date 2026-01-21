import 'package:equatable/equatable.dart';

/// Represents aggregated meal preference counts for a specific date.
class AttendanceCount extends Equatable {
  final DateTime date;
  final int regularCount;
  final int vegetarianCount;
  final int glutenFreeCount;
  final int nonPorkCount;
  final int totalAttendees;

  const AttendanceCount({
    required this.date,
    required this.regularCount,
    required this.vegetarianCount,
    required this.glutenFreeCount,
    required this.nonPorkCount,
    required this.totalAttendees,
  });

  int get totalWithPreference =>
      regularCount + vegetarianCount + glutenFreeCount + nonPorkCount;

  int get noPreferenceCount => totalAttendees - totalWithPreference;

  double get regularPercentage =>
      totalWithPreference > 0 ? regularCount / totalWithPreference : 0.0;

  double get vegetarianPercentage =>
      totalWithPreference > 0 ? vegetarianCount / totalWithPreference : 0.0;

  double get glutenFreePercentage =>
      totalWithPreference > 0 ? glutenFreeCount / totalWithPreference : 0.0;

  double get nonPorkPercentage =>
      totalWithPreference > 0 ? nonPorkCount / totalWithPreference : 0.0;

  @override
  List<Object?> get props => [
        date,
        regularCount,
        vegetarianCount,
        glutenFreeCount,
        nonPorkCount,
        totalAttendees,
      ];
}
