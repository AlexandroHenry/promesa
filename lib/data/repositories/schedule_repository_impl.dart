import '../../domain/entities/schedule_entity.dart';
import '../../domain/repositories/schedule_repository.dart';
import '../datasources/schedule/mock_schedule_datasource.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final MockScheduleDataSource dataSource;

  ScheduleRepositoryImpl(this.dataSource);

  @override
  Future<ScheduleEntity> createSchedule({
    required String title,
    required DateTime dateTime,
  }) {
    return dataSource.createSchedule(title: title, dateTime: dateTime);
  }
}


