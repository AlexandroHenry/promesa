import '../../entities/schedule_entity.dart';
import '../../repositories/schedule_repository.dart';

class UpdateScheduleUseCase {
  final ScheduleRepository repository;

  UpdateScheduleUseCase(this.repository);

  Future<ScheduleEntity> call({
    required String scheduleId,
    String? title,
    DateTime? dateTime,
    ScheduleColor? color,
    String? colorHex,
    int? lateFineAmount,
    String? description,
    List<String>? participantUserIds,
    List<String>? preparations,
    double? latitude,
    double? longitude,
    String? placeName,
  }) {
    return repository.updateSchedule(
      scheduleId: scheduleId,
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


