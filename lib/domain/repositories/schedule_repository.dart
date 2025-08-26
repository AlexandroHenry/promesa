import '../entities/schedule_entity.dart';

abstract class ScheduleRepository {
  Future<ScheduleEntity> createSchedule({
    required String title,
    required DateTime dateTime,
  });
}


