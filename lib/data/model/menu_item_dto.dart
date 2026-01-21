import 'package:nsymphony_eats_dashboard/domain/model/menu_item.dart' as domain;

/// Data Transfer Object for MenuItem.
class MenuItemDto {
  final String id;
  final String name;
  final String? imageUrl;
  final String? imagePath;

  MenuItemDto({
    required this.id,
    required this.name,
    this.imageUrl,
    this.imagePath,
  });

  domain.MenuItem toDomain() {
    return domain.MenuItem(
      id: id,
      name: name,
      imageUrl: imageUrl,
      imagePath: imagePath,
    );
  }

  factory MenuItemDto.fromDomain(domain.MenuItem item) {
    return MenuItemDto(
      id: item.id,
      name: item.name,
      imageUrl: item.imageUrl,
      imagePath: item.imagePath,
    );
  }

  factory MenuItemDto.fromJson(Map<String, dynamic> json) {
    return MenuItemDto(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String?,
      imagePath: json['imagePath'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'imagePath': imagePath,
    };
  }
}
