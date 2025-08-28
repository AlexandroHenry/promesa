import '../../entities/schedule_entity.dart';
import '../../repositories/schedule_repository.dart';

class GetSchedulesByMonthUseCase {
  final ScheduleRepository repository;

  GetSchedulesByMonthUseCase(this.repository);

  Future<List<ScheduleEntity>> call({
    required int year,
    required int month,
  }) {
    return repository.getSchedulesByMonth(year: year, month: month);
  }
}


