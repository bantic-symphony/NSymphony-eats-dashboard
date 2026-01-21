import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nsymphony_eats_dashboard/core/utils/app_logger.dart';
import 'package:nsymphony_eats_dashboard/domain/repository/menu_repository.dart';
import 'package:nsymphony_eats_dashboard/domain/usecase/get_current_week_menu_usecase.dart';
import 'package:nsymphony_eats_dashboard/domain/usecase/stream_current_week_menu_usecase.dart';
import 'package:nsymphony_eats_dashboard/presentation/bloc/menu/menu_event.dart';
import 'package:nsymphony_eats_dashboard/presentation/bloc/menu/menu_state.dart';

/// BLoC for managing menu state
class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final GetCurrentWeekMenuUseCase _getCurrentWeekMenuUseCase;
  final StreamCurrentWeekMenuUseCase _streamCurrentWeekMenuUseCase;
  StreamSubscription? _menuSubscription;

  MenuBloc(
    this._getCurrentWeekMenuUseCase,
    this._streamCurrentWeekMenuUseCase,
  ) : super(const MenuInitial()) {
    on<LoadCurrentWeekMenu>(_onLoadCurrentWeekMenu);
    on<SubscribeToCurrentWeekMenu>(_onSubscribeToCurrentWeekMenu);
  }

  Future<void> _onLoadCurrentWeekMenu(
    LoadCurrentWeekMenu event,
    Emitter<MenuState> emit,
  ) async {
    AppLogger.log('Event: LoadCurrentWeekMenu', tag: 'MENU_BLOC');
    emit(const MenuLoading());
    AppLogger.log('State: MenuLoading emitted', tag: 'MENU_BLOC');

    final result = await _getCurrentWeekMenuUseCase();

    switch (result) {
      case Success(:final data):
        AppLogger.success('Emitting MenuLoaded with ${data.days.length} days', tag: 'MENU_BLOC');
        emit(MenuLoaded(data));
      case Failure(:final error):
        AppLogger.error('Emitting MenuError: ${error.message}', tag: 'MENU_BLOC');
        emit(MenuError(error.message));
    }
  }

  Future<void> _onSubscribeToCurrentWeekMenu(
    SubscribeToCurrentWeekMenu event,
    Emitter<MenuState> emit,
  ) async {
    AppLogger.log('Event: SubscribeToCurrentWeekMenu', tag: 'MENU_BLOC');
    emit(const MenuLoading());
    AppLogger.log('State: MenuLoading emitted', tag: 'MENU_BLOC');

    await _menuSubscription?.cancel();

    await emit.forEach(
      _streamCurrentWeekMenuUseCase(),
      onData: (result) {
        AppLogger.log('Stream result received in emit.forEach', tag: 'MENU_BLOC');
        switch (result) {
          case Success(:final data):
            AppLogger.success('Returning MenuLoaded state with ${data.days.length} days', tag: 'MENU_BLOC');
            return MenuLoaded(data);
          case Failure(:final error):
            AppLogger.error('Returning MenuError state: ${error.message}', tag: 'MENU_BLOC');
            return MenuError(error.message);
        }
      },
      onError: (error, stackTrace) {
        AppLogger.error('Stream error in emit.forEach', tag: 'MENU_BLOC', error: error, stackTrace: stackTrace);
        return MenuError(error.toString());
      },
    );
  }

  @override
  Future<void> close() {
    _menuSubscription?.cancel();
    return super.close();
  }
}
