import 'package:nsymphony_eats_dashboard/data/model/day_menu_dto.dart';
import 'package:nsymphony_eats_dashboard/domain/model/week_menu.dart' as domain;

/// Data Transfer Object for WeekMenu.
class WeekMenuDto {
  final String id;
  final String weekStart;
  final List<DayMenuDto> days;
  final bool isPublished;
  final String createdAt;
  final String? publishedAt;
  final String createdBy;

  WeekMenuDto({
    required this.id,
    required this.weekStart,
    required this.days,
    required this.isPublished,
    required this.createdAt,
    this.publishedAt,
    required this.createdBy,
  });

  domain.WeekMenu toDomain() {
    return domain.WeekMenu(
      id: id,
      weekStart: DateTime.parse(weekStart),
      days: days.map((day) => day.toDomain()).toList(),
      isPublished: isPublished,
      createdAt: DateTime.parse(createdAt),
      publishedAt: publishedAt != null ? DateTime.parse(publishedAt!) : null,
      createdBy: createdBy,
    );
  }

  factory WeekMenuDto.fromDomain(domain.WeekMenu menu) {
    return WeekMenuDto(
      id: menu.id,
      weekStart: menu.weekStart.toIso8601String(),
      days: menu.days.map((day) => DayMenuDto.fromDomain(day)).toList(),
      isPublished: menu.isPublished,
      createdAt: menu.createdAt.toIso8601String(),
      publishedAt: menu.publishedAt?.toIso8601String(),
      createdBy: menu.createdBy,
    );
  }

  factory WeekMenuDto.fromJson(Map<String, dynamic> json) {
    return WeekMenuDto(
      id: json['id'] as String,
      weekStart: json['weekStart'] as String,
      days: (json['days'] as List<dynamic>)
          .map((day) => DayMenuDto.fromJson(day as Map<String, dynamic>))
          .toList(),
      isPublished: json['isPublished'] as bool,
      createdAt: json['createdAt'] as String,
      publishedAt: json['publishedAt'] as String?,
      createdBy: json['createdBy'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'weekStart': weekStart,
      'days': days.map((day) => day.toJson()).toList(),
      'isPublished': isPublished,
      'createdAt': createdAt,
      'publishedAt': publishedAt,
      'createdBy': createdBy,
    };
  }
}
