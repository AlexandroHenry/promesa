import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../domain/entities/schedule_entity.dart';

@RoutePage()
class EditScheduleScreen extends StatelessWidget {
  final ScheduleEntity schedule;
  const EditScheduleScreen({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('스케줄 수정')),
      body: Center(
        child: Text('Edit UI for: ${schedule.title} (구현 예정)'),
      ),
    );
  }
}


