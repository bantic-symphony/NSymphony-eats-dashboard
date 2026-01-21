import 'package:equatable/equatable.dart';

/// Enum representing the type of meal.
enum MealType {
  regular,
  vegetarian,
  glutenFree,
  nonPork,
}

/// Domain model representing a single menu item (dish).
class MenuItem extends Equatable {
  final String id;
  final String name;
  final String? imageUrl;
  final String? imagePath;

  const MenuItem({
    required this.id,
    required this.name,
    this.imageUrl,
    this.imagePath,
  });

  bool get hasImage => imageUrl != null;

  MenuItem copyWith({
    String? id,
    String? name,
    String? imageUrl,
    String? imagePath,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  @override
  List<Object?> get props => [id, name, imageUrl, imagePath];

  @override
  String toString() => 'MenuItem(id: $id, name: $name, hasImage: $hasImage)';
}
