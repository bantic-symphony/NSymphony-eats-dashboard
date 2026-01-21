import 'package:equatable/equatable.dart';
import 'package:nsymphony_eats_dashboard/domain/model/week_menu.dart';

/// Base class for all menu states
sealed class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class MenuInitial extends MenuState {
  const MenuInitial();
}

/// Loading state
class MenuLoading extends MenuState {
  const MenuLoading();
}

/// State when menu is successfully loaded
class MenuLoaded extends MenuState {
  final WeekMenu menu;

  const MenuLoaded(this.menu);

  @override
  List<Object?> get props => [menu];
}

/// State when no menu exists for current week
class MenuEmpty extends MenuState {
  final String message;

  const MenuEmpty(this.message);

  @override
  List<Object?> get props => [message];
}

/// Error state
class MenuError extends MenuState {
  final String message;

  const MenuError(this.message);

  @override
  List<Object?> get props => [message];
}
