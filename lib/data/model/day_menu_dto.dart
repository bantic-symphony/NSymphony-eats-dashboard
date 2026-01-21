import 'package:nsymphony_eats_dashboard/data/model/menu_item_dto.dart';
import 'package:nsymphony_eats_dashboard/domain/model/day_menu.dart' as domain;

/// Data Transfer Object for DayMenu.
class DayMenuDto {
  final String date;
  final String weekday;
  final String status;
  final List<MenuItemDto> regular;
  final List<MenuItemDto> vege;
  final String? note;

  DayMenuDto({
    required this.date,
    required this.weekday,
    required this.status,
    required this.regular,
    required this.vege,
    this.note,
  });

  domain.DayMenu toDomain() {
    return domain.DayMenu(
      date: DateTime.parse(date),
      weekday: _weekdayFromString(weekday),
      status: _statusFromString(status),
      regular: regular.map((item) => item.toDomain()).toList(),
      vege: vege.map((item) => item.toDomain()).toList(),
      note: note,
    );
  }

  factory DayMenuDto.fromDomain(domain.DayMenu menu) {
    return DayMenuDto(
      date: menu.date.toIso8601String(),
      weekday: menu.weekday.name,
      status: menu.status.name,
      regular: menu.regular.map((item) => MenuItemDto.fromDomain(item)).toList(),
      vege: menu.vege.map((item) => MenuItemDto.fromDomain(item)).toList(),
      note: menu.note,
    );
  }

  factory DayMenuDto.fromJson(Map<String, dynamic> json) {
    return DayMenuDto(
      date: json['date'] as String,
      weekday: json['weekday'] as String,
      status: json['status'] as String,
      regular: (json['regular'] as List<dynamic>)
          .map((item) => MenuItemDto.fromJson(item as Map<String, dynamic>))
          .toList(),
      vege: (json['vege'] as List<dynamic>)
          .map((item) => MenuItemDto.fromJson(item as Map<String, dynamic>))
          .toList(),
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'weekday': weekday,
      'status': status,
      'regular': regular.map((item) => item.toJson()).toList(),
      'vege': vege.map((item) => item.toJson()).toList(),
      'note': note,
    };
  }

  domain.Weekday _weekdayFromString(String weekday) {
    return domain.Weekday.values.firstWhere(
      (e) => e.name == weekday,
      orElse: () => domain.Weekday.monday,
    );
  }

  domain.DayStatus _statusFromString(String status) {
    return domain.DayStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => domain.DayStatus.working,
    );
  }
}
