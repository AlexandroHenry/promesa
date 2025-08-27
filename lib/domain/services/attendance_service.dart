import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../entities/attendance_entity.dart';
import '../entities/schedule_entity.dart';
import '../entities/late_fine_entity.dart';

class AttendanceService {
  static const double _attendanceRadius = 50.0; // 출석 인정 반경 (미터)
  
  /// 출석 가능 거리인지 확인
  static bool isWithinAttendanceRange(
    LatLng currentLocation, 
    LatLng venueLocation
  ) {
    final distance = calculateDistance(
      currentLocation.latitude,
      currentLocation.longitude,
      venueLocation.latitude,
      venueLocation.longitude,
    );
    
    return distance <= _attendanceRadius;
  }
  
  /// 두 지점 간의 거리 계산 (Haversine formula)
  static double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371000; // 지구 반지름 (미터)
    
    final double dLat = _toRadians(lat2 - lat1);
    final double dLon = _toRadians(lon2 - lon1);
    
    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
        sin(dLon / 2) * sin(dLon / 2);
    
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    
    return earthRadius * c;
  }
  
  static double _toRadians(double degree) {
    return degree * pi / 180;
  }
  
  /// 지각 시간 계산 (분 단위)
  static int calculateLateMinutes(DateTime scheduleTime, DateTime checkInTime) {
    if (checkInTime.isBefore(scheduleTime)) {
      return 0; // 일찍 도착
    }
    
    final difference = checkInTime.difference(scheduleTime);
    return difference.inMinutes;
  }
  
  /// 벌금 계산
  static int calculateFine(ScheduleEntity schedule, int lateMinutes) {
    if (lateMinutes <= 0) return 0;
    
    // 새로운 벌금 시스템 우선 사용
    if (schedule.lateFine != null) {
      return schedule.lateFine!.calculateFine(lateMinutes);
    }
    
    // 기존 고정 벌금 시스템
    return schedule.lateFineAmount;
  }
  
  /// 출석 엔티티 생성
  static AttendanceEntity createAttendance({
    required String scheduleId,
    required String userId,
    required ScheduleEntity schedule,
    required LatLng currentLocation,
    required DateTime checkInTime,
  }) {
    // 회장 위치가 없으면 출석 불가
    if (schedule.latitude == null || schedule.longitude == null) {
      return AttendanceEntity(
        scheduleId: scheduleId,
        userId: userId,
        status: AttendanceStatus.failed,
        checkInTime: checkInTime,
        checkInLatitude: currentLocation.latitude,
        checkInLongitude: currentLocation.longitude,
      );
    }
    
    final venueLocation = LatLng(schedule.latitude!, schedule.longitude!);
    final distance = calculateDistance(
      currentLocation.latitude,
      currentLocation.longitude,
      venueLocation.latitude,
      venueLocation.longitude,
    );
    
    // 거리 확인
    final isInRange = distance <= _attendanceRadius;
    
    // 지각 시간 계산
    final lateMinutes = calculateLateMinutes(schedule.dateTime, checkInTime);
    
    // 벌금 계산
    final fineAmount = calculateFine(schedule, lateMinutes);
    
    return AttendanceEntity(
      scheduleId: scheduleId,
      userId: userId,
      status: isInRange ? AttendanceStatus.success : AttendanceStatus.failed,
      checkInTime: checkInTime,
      lateMinutes: lateMinutes,
      fineAmount: fineAmount,
      checkInLatitude: currentLocation.latitude,
      checkInLongitude: currentLocation.longitude,
      distanceFromVenue: distance,
    );
  }
  
  /// 출석 상태 메시지 생성
  static String getStatusMessage(AttendanceEntity attendance, ScheduleEntity schedule) {
    switch (attendance.status) {
      case AttendanceStatus.success:
        if (attendance.isLate) {
          return '출석 완료 (${attendance.lateMinutes}분 지각)';
        } else {
          return '출석 완료';
        }
      case AttendanceStatus.failed:
        final distance = attendance.distanceFromVenue ?? 0;
        return '출석 실패 - 장소에서 ${distance.round()}m 떨어져 있음 (${_attendanceRadius.round()}m 이내 필요)';
      case AttendanceStatus.inProgress:
        return '출석 진행 중...';
      case AttendanceStatus.notStarted:
        return '출석 대기 중';
    }
  }
  
  /// 거리를 사용자 친화적 문자열로 변환
  static String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()}m';
    } else {
      return '${(distanceInMeters / 1000).toStringAsFixed(1)}km';
    }
  }
}