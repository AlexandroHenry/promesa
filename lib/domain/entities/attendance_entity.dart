enum AttendanceStatus {
  notStarted,    // 출석 시작 전
  inProgress,    // 출석 진행 중
  success,       // 출석 성공
  failed,        // 출석 실패
}

class AttendanceEntity {
  final String scheduleId;
  final String userId;
  final AttendanceStatus status;
  final DateTime? checkInTime;
  final int lateMinutes;
  final int fineAmount;
  final double? checkInLatitude;
  final double? checkInLongitude;
  final double? distanceFromVenue; // 출석 시 회장과의 거리

  const AttendanceEntity({
    required this.scheduleId,
    required this.userId,
    required this.status,
    this.checkInTime,
    this.lateMinutes = 0,
    this.fineAmount = 0,
    this.checkInLatitude,
    this.checkInLongitude,
    this.distanceFromVenue,
  });

  AttendanceEntity copyWith({
    String? scheduleId,
    String? userId,
    AttendanceStatus? status,
    DateTime? checkInTime,
    int? lateMinutes,
    int? fineAmount,
    double? checkInLatitude,
    double? checkInLongitude,
    double? distanceFromVenue,
  }) {
    return AttendanceEntity(
      scheduleId: scheduleId ?? this.scheduleId,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      checkInTime: checkInTime ?? this.checkInTime,
      lateMinutes: lateMinutes ?? this.lateMinutes,
      fineAmount: fineAmount ?? this.fineAmount,
      checkInLatitude: checkInLatitude ?? this.checkInLatitude,
      checkInLongitude: checkInLongitude ?? this.checkInLongitude,
      distanceFromVenue: distanceFromVenue ?? this.distanceFromVenue,
    );
  }

  /// 지각 여부 확인
  bool get isLate => lateMinutes > 0;

  /// 출석 완료 여부
  bool get isCompleted => status == AttendanceStatus.success || status == AttendanceStatus.failed;

  Map<String, dynamic> toJson() {
    return {
      'scheduleId': scheduleId,
      'userId': userId,
      'status': status.index,
      'checkInTime': checkInTime?.toIso8601String(),
      'lateMinutes': lateMinutes,
      'fineAmount': fineAmount,
      'checkInLatitude': checkInLatitude,
      'checkInLongitude': checkInLongitude,
      'distanceFromVenue': distanceFromVenue,
    };
  }

  factory AttendanceEntity.fromJson(Map<String, dynamic> json) {
    return AttendanceEntity(
      scheduleId: json['scheduleId'] as String,
      userId: json['userId'] as String,
      status: AttendanceStatus.values[json['status'] as int? ?? 0],
      checkInTime: json['checkInTime'] != null 
          ? DateTime.parse(json['checkInTime'] as String) 
          : null,
      lateMinutes: json['lateMinutes'] as int? ?? 0,
      fineAmount: json['fineAmount'] as int? ?? 0,
      checkInLatitude: json['checkInLatitude'] as double?,
      checkInLongitude: json['checkInLongitude'] as double?,
      distanceFromVenue: json['distanceFromVenue'] as double?,
    );
  }
}