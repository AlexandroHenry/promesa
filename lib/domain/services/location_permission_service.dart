import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPermissionService {
  /// 위치 권한 상태 확인 및 요청
  static Future<bool> requestLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 위치 서비스가 활성화되어 있는지 확인
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // 위치 서비스가 비활성화되어 있으면 false 반환
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // 권한이 거부되면 false 반환
        return false;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      // 권한이 영구적으로 거부되면 false 반환
      return false;
    } 

    // 권한이 허용되면 true 반환
    return true;
  }

  /// 현재 위치 가져오기
  static Future<LatLng?> getCurrentLocation() async {
    try {
      final hasPermission = await requestLocationPermission();
      if (!hasPermission) return null;

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      // 위치 가져오기 실패
      return null;
    }
  }

  /// 위치 스트림 (실시간 위치 업데이트)
  static Stream<LatLng> getLocationStream() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // 10미터 이상 이동 시에만 업데이트
    );
    
    return Geolocator.getPositionStream(locationSettings: locationSettings)
        .map((position) => LatLng(position.latitude, position.longitude));
  }
}