import '../../entities/schedule_entity.dart';
import '../../repositories/schedule_repository.dart';

class CreateScheduleUseCase {
  final ScheduleRepository repository;

  CreateScheduleUseCase(this.repository);

  Future<ScheduleEntity> call({
    required String title,
    required DateTime dateTime,
  }) {
    return repository.createSchedule(title: title, dateTime: dateTime);
  }
}


