import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../../../domain/entities/participant_entity.dart';
import '../../../domain/entities/preparation_entity.dart';
import '../../../domain/entities/schedule_entity.dart';

class MockScheduleDataSource {
  final List<ScheduleEntity> _schedules = [];
  bool _seeded = false;

  Future<void> _ensureSeeded() async {
    if (_seeded) return;
    try {
      final jsonStr = await rootBundle.loadString('assets/mock_data/schedules.json');
      final List<dynamic> data = json.decode(jsonStr) as List<dynamic>;
      for (final item in data) {
        _schedules.add(_fromJson(item as Map<String, dynamic>));
      }
    } catch (_) {
      // ignore when asset missing
    }
    _seeded = true;
  }

  ScheduleEntity _fromJson(Map<String, dynamic> map) {
    return ScheduleEntity(
      id: map['id'] as String,
      title: map['title'] as String,
      dateTime: DateTime.parse(map['dateTime'] as String),
      color: ScheduleColor.values[(map['color'] as int?) ?? 0],
      colorHex: map['colorHex'] as String?,
      lateFineAmount: map['lateFineAmount'] as int? ?? 0,
      description: map['description'] as String? ?? '',
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      placeName: map['placeName'] as String?,
      preparations: ((map['preparations'] as List<dynamic>?) ?? [])
          .map((e) {
            if (e is String) {
              // string만 오면 전체
              return PreparationEntity(name: e, assignedToUserIds: const []);
            }
            final m = e as Map<String, dynamic>;
            final ids = (m['assignedToUserIds'] as List<dynamic>?)?.map((x) => x.toString()).toList() ?? const [];
            return PreparationEntity(
              name: m['name'] as String? ?? '',
              assignedToUserIds: ids,
            );
          })
          .toList(),
      participants: ((map['participants'] as List<dynamic>?) ?? [])
          .map((p) => ParticipantEntity(
                id: p['id'] as String,
                name: p['name'] as String,
                isHost: p['isHost'] as bool? ?? false,
                accepted: p['accepted'] as bool? ?? true,
                lateMinutes: p['lateMinutes'] as int? ?? 0,
                finePaid: p['finePaid'] as int? ?? 0,
              ))
          .toList(),
    );
  }

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
  }) async {
    await _ensureSeeded();
    await Future.delayed(const Duration(milliseconds: 400));
    final created = ScheduleEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      dateTime: dateTime,
      color: color,
      colorHex: colorHex,
      lateFineAmount: lateFineAmount,
      description: description,
      preparations: preparations ?? const [],
      latitude: latitude,
      longitude: longitude,
      placeName: placeName,
      participants: [
        for (final id in participantUserIds)
          ParticipantEntity(id: id, name: 'User $id')
      ],
    );
    _schedules.add(created);
    return created;
  }

  Future<List<ScheduleEntity>> getMySchedules() async {
    await _ensureSeeded();
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_schedules);
  }

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
  }) async {
    await _ensureSeeded();
    await Future.delayed(const Duration(milliseconds: 250));
    final index = _schedules.indexWhere((s) => s.id == scheduleId);
    if (index == -1) {
      throw StateError('Schedule not found');
    }
    final prev = _schedules[index];
    final updated = ScheduleEntity(
      id: prev.id,
      title: title ?? prev.title,
      dateTime: dateTime ?? prev.dateTime,
      color: color ?? prev.color,
      colorHex: colorHex ?? prev.colorHex,
      lateFineAmount: lateFineAmount ?? prev.lateFineAmount,
      description: description ?? prev.description,
      preparations: preparations ?? prev.preparations,
      latitude: latitude ?? prev.latitude,
      longitude: longitude ?? prev.longitude,
      placeName: placeName ?? prev.placeName,
      participants: participantUserIds != null
          ? [for (final id in participantUserIds) ParticipantEntity(id: id, name: 'User $id')]
          : prev.participants,
    );
    _schedules[index] = updated;
    return updated;
  }
}


