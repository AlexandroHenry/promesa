import '../../domain/entities/preparation_entity.dart';
import '../../domain/entities/schedule_entity.dart';
import '../../domain/entities/late_fine_entity.dart';
import '../../domain/repositories/schedule_repository.dart';
import '../datasources/schedule/mock_schedule_datasource.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final MockScheduleDataSource dataSource;

  ScheduleRepositoryImpl(this.dataSource);

  @override
  Future<ScheduleEntity> createSchedule({
    required String title,
    required DateTime dateTime,
    required ScheduleColor color,
    String? colorHex,
    required int lateFineAmount,
    LateFineEntity? lateFine,
    required String description,
    required List<String> participantUserIds,
    List<PreparationEntity>? preparations,
    double? latitude,
    double? longitude,
    String? placeName,
  }) {
    return dataSource.createSchedule(
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
  }

  @override
  Future<List<ScheduleEntity>> getMySchedules() {
    return dataSource.getMySchedules();
  }

  @override
  Future<ScheduleEntity> updateSchedule({
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
  }) {
    return dataSource.updateSchedule(
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
  }
}


