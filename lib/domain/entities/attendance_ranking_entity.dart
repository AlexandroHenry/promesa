import 'package:promesa/domain/entities/attendance_entity.dart';

class AttendanceRankingEntity {
  final String scheduleId;
  final String userId;
  final String userName;
  final DateTime checkInTime;
  final int arrivalOrder; // 도착 순서 (1등, 2등, ...)
  final int lateMinutes;
  final int fineAmount;
  final bool isHost;

  const AttendanceRankingEntity({
    required this.scheduleId,
    required this.userId,
    required this.userName,
    required this.checkInTime,
    required this.arrivalOrder,
    required this.lateMinutes,
    required this.fineAmount,
    this.isHost = false,
  });

  /// 지각 여부
  bool get isLate => lateMinutes > 0;

  /// 순위 표시 (1등, 2등, ...)
  String get rankingText {
    switch (arrivalOrder) {
      case 1:
        return '🥇 1등';
      case 2:
        return '🥈 2등';
      case 3:
        return '🥉 3등';
      default:
        return '${arrivalOrder}등';
    }
  }

  /// 시간 표시
  String get timeText {
    final hour = checkInTime.hour.toString().padLeft(2, '0');
    final minute = checkInTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// 지각 정보 텍스트
  String get lateText {
    if (lateMinutes <= 0) return '정시 도착';
    return '${lateMinutes}분 지각';
  }

  Map<String, dynamic> toJson() {
    return {
      'scheduleId': scheduleId,
      'userId': userId,
      'userName': userName,
      'checkInTime': checkInTime.toIso8601String(),
      'arrivalOrder': arrivalOrder,
      'lateMinutes': lateMinutes,
      'fineAmount': fineAmount,
      'isHost': isHost,
    };
  }

  factory AttendanceRankingEntity.fromJson(Map<String, dynamic> json) {
    return AttendanceRankingEntity(
      scheduleId: json['scheduleId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      checkInTime: DateTime.parse(json['checkInTime'] as String),
      arrivalOrder: json['arrivalOrder'] as int,
      lateMinutes: json['lateMinutes'] as int,
      fineAmount: json['fineAmount'] as int,
      isHost: json['isHost'] as bool? ?? false,
    );
  }

  /// AttendanceEntity에서 변환
  factory AttendanceRankingEntity.fromAttendance(
    AttendanceEntity attendance,
    String userName,
    int arrivalOrder,
    bool isHost,
  ) {
    return AttendanceRankingEntity(
      scheduleId: attendance.scheduleId,
      userId: attendance.userId,
      userName: userName,
      checkInTime: attendance.checkInTime!,
      arrivalOrder: arrivalOrder,
      lateMinutes: attendance.lateMinutes,
      fineAmount: attendance.fineAmount,
      isHost: isHost,
    );
  }
}