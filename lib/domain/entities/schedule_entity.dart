import 'participant_entity.dart';
import 'preparation_entity.dart';

enum ScheduleColor {
  blue,
  green,
  yellow,
  red,
  purple,
  teal,
}

class ScheduleEntity {
  final String id;
  final String title;
  final DateTime dateTime;
  final ScheduleColor color;
  final String? colorHex;
  final int lateFineAmount;
  final String description;
  final List<ParticipantEntity> participants;
  final double? latitude;
  final double? longitude;
  final String? placeName;
  final List<PreparationEntity> preparations;

  const ScheduleEntity({
    required this.id,
    required this.title,
    required this.dateTime,
    this.color = ScheduleColor.blue,
    this.colorHex,
    this.lateFineAmount = 0,
    this.description = '',
    this.participants = const [],
    this.latitude,
    this.longitude,
    this.placeName,
    this.preparations = const [],
  });

  bool get isExpired => dateTime.isBefore(DateTime.now());
}


