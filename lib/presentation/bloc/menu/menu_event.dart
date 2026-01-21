import 'package:equatable/equatable.dart';

/// Base class for all menu events
sealed class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load the current week's menu
class LoadCurrentWeekMenu extends MenuEvent {
  const LoadCurrentWeekMenu();
}

/// Event to subscribe to real-time menu updates
class SubscribeToCurrentWeekMenu extends MenuEvent {
  const SubscribeToCurrentWeekMenu();
}
