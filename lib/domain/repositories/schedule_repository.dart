import '../entities/schedule_entity.dart';
import '../entities/preparation_entity.dart';

abstract class ScheduleRepository {
  Future<ScheduleEntity> createSchedule({
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
  });

  Future<List<ScheduleEntity>> getMySchedules();

  Future<ScheduleEntity> updateSchedule({
    required String scheduleId,
    String? title,
    DateTime? dateTime,
    ScheduleColor? color,
    String? colorHex,
    int? lateFineAmount,
    String? description,
    List<String>? participantUserIds,
    List<PreparationEntity>? preparations,
    double? latitude,
    double? longitude,
    String? placeName,
  });
}


