import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:promesa/core/router/app_router.dart';
import '../../../domain/entities/schedule_entity.dart';
import '../../../domain/entities/participant_entity.dart';
import '../../providers/auth_provider.dart';

@RoutePage()
class ScheduleDetailScreen extends ConsumerWidget {
  final ScheduleEntity schedule;

  const ScheduleDetailScreen({super.key, required this.schedule});

  bool _isHost(WidgetRef ref, ScheduleEntity s) {
    final user = ref.read(authNotifierProvider).user;
    if (user == null) return false;
    final ParticipantEntity? me = s.participants.firstWhere(
      (p) => p.id == user.id,
      orElse: () => const ParticipantEntity(id: '', name: '', isHost: false),
    );
    return me != null && me.id.isNotEmpty && me.isHost;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isHost = _isHost(ref, schedule);
    return Scaffold(
      appBar: AppBar(
        title: Text(schedule.title),
        actions: [
          if (isHost)
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: '수정',
              onPressed: () {
                context.router.push(EditScheduleRoute(schedule: schedule));
              },
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              const Icon(Icons.event),
              const SizedBox(width: 8),
              Text('${schedule.dateTime}'),
            ],
          ),
          const SizedBox(height: 12),
          if (schedule.placeName != null) ...[
            Row(
              children: [
                const Icon(Icons.place),
                const SizedBox(width: 8),
                Text(schedule.placeName!),
              ],
            ),
            const SizedBox(height: 12),
          ],
          if (schedule.description.isNotEmpty) ...[
            Text(
              '설명',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(schedule.description),
            const SizedBox(height: 12),
          ],
          Text(
            '참가자 (${schedule.participants.length})',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final p in schedule.participants)
                Chip(
                  avatar: p.isHost ? const Icon(Icons.star, size: 16) : null,
                  label: Text(p.name),
                ),
            ],
          ),
        ],
      ),
    );
  }
}


