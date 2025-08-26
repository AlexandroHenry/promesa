import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../data/datasources/schedule/mock_schedule_datasource.dart';
import '../../../../data/repositories/schedule_repository_impl.dart';
import '../../../../domain/entities/schedule_entity.dart';
import '../../../../domain/repositories/schedule_repository.dart';
import '../../../../domain/usecases/schedule/create_schedule_usecase.dart';

part 'add_schedule_provider.freezed.dart';
part 'add_schedule_provider.g.dart';

@freezed
class AddScheduleState with _$AddScheduleState {
  const factory AddScheduleState({
    @Default(false) bool isSubmitting,
    ScheduleEntity? created,
    String? errorMessage,
  }) = _AddScheduleState;
}

@riverpod
MockScheduleDataSource scheduleDataSource(ScheduleDataSourceRef ref) {
  // 현재는 mock만 제공. AppConfig에 따라 real datasource로 분기 예정
  return MockScheduleDataSource();
}

@riverpod
ScheduleRepository scheduleRepository(ScheduleRepositoryRef ref) {
  return ScheduleRepositoryImpl(ref.read(scheduleDataSourceProvider));
}

@riverpod
CreateScheduleUseCase createScheduleUseCase(CreateScheduleUseCaseRef ref) {
  return CreateScheduleUseCase(ref.read(scheduleRepositoryProvider));
}

@riverpod
class AddScheduleNotifier extends _$AddScheduleNotifier {
  @override
  AddScheduleState build() {
    return const AddScheduleState();
  }

  Future<ScheduleEntity?> submit({
    required String title,
    required DateTime dateTime,
    required ScheduleColor color,
    String? colorHex,
    required int lateFineAmount,
    required String description,
    required List<String> participantUserIds,
    List<String>? preparations,
    double? latitude,
    double? longitude,
    String? placeName,
  }) async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);
    try {
      final usecase = ref.read(createScheduleUseCaseProvider);
      final created = await usecase(
        title: title,
        dateTime: dateTime,
        color: color,
        colorHex: colorHex,
        lateFineAmount: lateFineAmount,
        description: description,
        participantUserIds: participantUserIds,
        preparations: preparations,
        latitude: latitude,
        longitude: longitude,
        placeName: placeName,
      );
      state = state.copyWith(isSubmitting: false, created: created);
      return created;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: e.toString());
      return null;
    }
  }
}


