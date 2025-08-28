import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/schedule_entity.dart';
import '../../../domain/usecases/schedule/get_my_schedules_usecase.dart';
import '../../../domain/usecases/schedule/get_schedules_by_month_usecase.dart';
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
    DateTime? focusedMonth,
    DateTime? focusedDay,
    @Default([]) List<String> loadedMonths,
    String? errorMessage,
  }) = _ScheduleListState;
}

@riverpod
GetMySchedulesUseCase getMySchedulesUseCase(GetMySchedulesUseCaseRef ref) {
  final repo = ref.read(scheduleRepositoryProvider);
  return GetMySchedulesUseCase(repo);
}

@riverpod
GetSchedulesByMonthUseCase getSchedulesByMonthUseCase(
    GetSchedulesByMonthUseCaseRef ref) {
  final repo = ref.read(scheduleRepositoryProvider);
  return GetSchedulesByMonthUseCase(repo);
}

@riverpod
class ScheduleListNotifier extends _$ScheduleListNotifier {
  @override
  ScheduleListState build() {
    // initial state then refresh
    final now = DateTime.now();
    final firstOfMonth = DateTime(now.year, now.month, 1);
    Future.microtask(() async {
      await ensureMonthLoaded(now.year, now.month);
    });
    return ScheduleListState(focusedMonth: firstOfMonth, focusedDay: now);
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

  String _monthKey(int year, int month) => '$year-$month';

  Future<void> ensureMonthLoaded(int year, int month) async {
    final key = _monthKey(year, month);
    if (state.loadedMonths.contains(key)) return;
    state = state.copyWith(isLoading: true);
    try {
      final usecase = ref.read(getSchedulesByMonthUseCaseProvider);
      final list = await usecase(year: year, month: month);
      // merge unique by id
      final Map<String, ScheduleEntity> byId = {
        for (final s in state.items) s.id: s,
      };
      for (final s in list) {
        byId[s.id] = s;
      }
      final updated = byId.values.toList();
      state = state.copyWith(
        isLoading: false,
        items: updated,
        loadedMonths: [...state.loadedMonths, key],
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> setFocusedMonth(int year, int month) async {
    state = state.copyWith(focusedMonth: DateTime(year, month, 1));
    await ensureMonthLoaded(year, month);
  }

  Future<void> setFocusedDay(DateTime date) async {
    await ensureMonthLoaded(date.year, date.month);
    state = state.copyWith(focusedDay: date);
  }

  Future<void> goToDay(DateTime date) async {
    await setFocusedDay(date);
    setView(ScheduleView.day);
  }
}


