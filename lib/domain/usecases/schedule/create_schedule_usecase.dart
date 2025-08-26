import '../../entities/schedule_entity.dart';
import '../../repositories/schedule_repository.dart';
import '../../entities/preparation_entity.dart';

class CreateScheduleUseCase {
  final ScheduleRepository repository;

  CreateScheduleUseCase(this.repository);

  Future<ScheduleEntity> call({
    required String title,
    required DateTime dateTime,
    required ScheduleColor color,
    String? colorHex,
    required int lateFineAmount,
    required String description,
    required List<String> participantUserIds,
    List<PreparationEntity>? preparations,
    double? latitude,
    double? longitude,
    String? placeName,
  }) {
    return repository.createSchedule(
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
  }
}


