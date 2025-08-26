import 'dart:async';

import '../../../domain/entities/schedule_entity.dart';

class MockScheduleDataSource {
  Future<ScheduleEntity> createSchedule({
    required String title,
    required DateTime dateTime,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ScheduleEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      dateTime: dateTime,
    );
  }
}


