import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/schedule_entity.dart';
import '../../../domain/usecases/schedule/get_my_schedules_usecase.dart';
import '../../schedule/add/00_state/add_schedule_provider.dart';

part 'schedule_list_provider.freezed.dart';
part 'schedule_list_provider.g.dart';

enum ScheduleFilter { active, expired, all }
enum ScheduleView { day, week, month, year }

@freezed
class ScheduleListState with _$ScheduleListState {
  const factory ScheduleListState({
    @Default(false) bool isLoading,
    @Default([]) List<ScheduleEntity> items,
    @Default(ScheduleFilter.all) ScheduleFilter filter,
    @Default(ScheduleView.day) ScheduleView view,
    String? errorMessage,
  }) = _ScheduleListState;
}

@riverpod
GetMySchedulesUseCase getMySchedulesUseCase(GetMySchedulesUseCaseRef ref) {
  final repo = ref.read(scheduleRepositoryProvider);
  return GetMySchedulesUseCase(repo);
}

@riverpod
class ScheduleListNotifier extends _$ScheduleListNotifier {
  @override
  ScheduleListState build() {
    // initial state then refresh
    Future.microtask(refresh);
    return const ScheduleListState();
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final usecase = ref.read(getMySchedulesUseCaseProvider);
      final list = await usecase();
      state = state.copyWith(isLoading: false, items: list);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void setFilter(ScheduleFilter filter) {
    state = state.copyWith(filter: filter);
  }

  void setView(ScheduleView view) {
    state = state.copyWith(view: view);
  }

  List<ScheduleEntity> filteredItems(ScheduleListState s) {
    switch (s.filter) {
      case ScheduleFilter.active:
        return s.items.where((e) => !e.isExpired).toList();
      case ScheduleFilter.expired:
        return s.items.where((e) => e.isExpired).toList();
      case ScheduleFilter.all:
        return s.items;
    }
  }
}


