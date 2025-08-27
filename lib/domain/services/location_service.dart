import 'dart:math';
import '../entities/schedule_entity.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService {
  /// 두 지점 간의 거리를 계산 (Haversine formula)
  /// 결과는 미터 단위
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
  
  /// 현재 위치에서 가장 가까운 일정을 찾아 반환
  static ScheduleEntity? findNearestSchedule(
    LatLng currentLocation, 
    List<ScheduleEntity> schedules
  ) {
    if (schedules.isEmpty) return null;
    
    // 위치 정보가 있는 일정만 필터링
    final schedulesWithLocation = schedules.where(
      (schedule) => schedule.latitude != null && schedule.longitude != null
    ).toList();
    
    if (schedulesWithLocation.isEmpty) return null;
    
    ScheduleEntity? nearestSchedule;
    double minDistance = double.infinity;
    
    for (final schedule in schedulesWithLocation) {
      final distance = calculateDistance(
        currentLocation.latitude,
        currentLocation.longitude,
        schedule.latitude!,
        schedule.longitude!,
      );
      
      if (distance < minDistance) {
        minDistance = distance;
        nearestSchedule = schedule;
      }
    }
    
    return nearestSchedule;
  }
  
  /// 현재 위치 기준으로 일정들을 거리순으로 정렬
  static List<ScheduleEntity> sortSchedulesByDistance(
    LatLng currentLocation,
    List<ScheduleEntity> schedules
  ) {
    final schedulesWithLocation = schedules.where(
      (schedule) => schedule.latitude != null && schedule.longitude != null
    ).toList();
    
    schedulesWithLocation.sort((a, b) {
      final distanceA = calculateDistance(
        currentLocation.latitude,
        currentLocation.longitude,
        a.latitude!,
        a.longitude!,
      );
      
      final distanceB = calculateDistance(
        currentLocation.latitude,
        currentLocation.longitude,
        b.latitude!,
        b.longitude!,
      );
      
      return distanceA.compareTo(distanceB);
    });
    
    return schedulesWithLocation;
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