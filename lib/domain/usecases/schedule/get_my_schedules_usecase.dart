import '../../entities/schedule_entity.dart';
import '../../repositories/schedule_repository.dart';

class GetMySchedulesUseCase {
  final ScheduleRepository repository;

  GetMySchedulesUseCase(this.repository);

  Future<List<ScheduleEntity>> call() {
    return repository.getMySchedules();
  }
}


