import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../domain/entities/schedule_entity.dart';
import '../../../../domain/entities/late_fine_entity.dart';
import '../../../../domain/entities/preparation_entity.dart';
import '../../../../domain/usecases/schedule/update_schedule_usecase.dart';
import '../../add/00_state/add_schedule_provider.dart' show scheduleRepositoryProvider; // reuse repo provider

part 'edit_schedule_provider.freezed.dart';
part 'edit_schedule_provider.g.dart';

@freezed
class EditScheduleState with _$EditScheduleState {
  const factory EditScheduleState({
    @Default(false) bool isSubmitting,
    ScheduleEntity? updated,
    String? errorMessage,
  }) = _EditScheduleState;
}

@riverpod
UpdateScheduleUseCase updateScheduleUseCase(UpdateScheduleUseCaseRef ref) {
  return UpdateScheduleUseCase(ref.read(scheduleRepositoryProvider));
}

@riverpod
class EditScheduleNotifier extends _$EditScheduleNotifier {
  @override
  EditScheduleState build() {
    return const EditScheduleState();
  }

  Future<ScheduleEntity?> submit({
    required String scheduleId,
    String? title,
    DateTime? dateTime,
    ScheduleColor? color,
    String? colorHex,
    int? lateFineAmount,
    LateFineEntity? lateFine,
    String? description,
    List<String>? participantUserIds,
    List<PreparationEntity>? preparations,
    double? latitude,
    double? longitude,
    String? placeName,
  }) async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);
    try {
      final usecase = ref.read(updateScheduleUseCaseProvider);
      final updated = await usecase(
        scheduleId: scheduleId,
        title: title,
        dateTime: dateTime,
        color: color,
        colorHex: colorHex,
        lateFineAmount: lateFineAmount,
        lateFine: lateFine,
        description: description,
        participantUserIds: participantUserIds,
        preparations: preparations,
        latitude: latitude,
        longitude: longitude,
        placeName: placeName,
      );
      state = state.copyWith(isSubmitting: false, updated: updated);
      return updated;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: e.toString());
      return null;
    }
  }
}


