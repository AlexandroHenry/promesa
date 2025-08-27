import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../domain/entities/schedule_entity.dart';
import '../../../../domain/services/location_service.dart';
import '../../../../data/datasources/schedule/mock_schedule_datasource.dart';

// Mock 스케줄 데이터소스 provider
final mockScheduleDataSourceProvider = Provider<MockScheduleDataSource>((ref) {
  return MockScheduleDataSource();
});

// 모든 스케줄 목록 provider
final schedulesProvider = FutureProvider<List<ScheduleEntity>>((ref) async {
  final dataSource = ref.read(mockScheduleDataSourceProvider);
  return await dataSource.getMySchedules();
});

// 현재 위치 provider (기본값: 서울시청)
final currentLocationProvider = StateProvider<LatLng>((ref) {
  return const LatLng(37.5665, 126.9780); // 서울시청 기본값
});

// 가장 가까운 스케줄 provider
final nearestScheduleProvider = Provider<AsyncValue<ScheduleEntity?>>((ref) {
  final schedulesAsync = ref.watch(schedulesProvider);
  final currentLocation = ref.watch(currentLocationProvider);
  
  return schedulesAsync.when(
    data: (schedules) {
      final nearest = LocationService.findNearestSchedule(currentLocation, schedules);
      return AsyncValue.data(nearest);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

// 지도 마커들을 생성하는 provider
final mapMarkersProvider = Provider<Set<Marker>>((ref) {
  final nearestScheduleAsync = ref.watch(nearestScheduleProvider);
  final currentLocation = ref.watch(currentLocationProvider);
  
  return nearestScheduleAsync.when(
    data: (nearestSchedule) {
      final markers = <Marker>{};
      
      // 현재 위치 마커
      markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: currentLocation,
          infoWindow: const InfoWindow(
            title: '내 위치',
            snippet: '현재 위치',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
      
      // 가장 가까운 스케줄 마커
      if (nearestSchedule != null && 
          nearestSchedule.latitude != null && 
          nearestSchedule.longitude != null) {
        final distance = LocationService.calculateDistance(
          currentLocation.latitude,
          currentLocation.longitude,
          nearestSchedule.latitude!,
          nearestSchedule.longitude!,
        );
        
        markers.add(
          Marker(
            markerId: MarkerId('schedule_${nearestSchedule.id}'),
            position: LatLng(nearestSchedule.latitude!, nearestSchedule.longitude!),
            infoWindow: InfoWindow(
              title: nearestSchedule.title,
              snippet: '${LocationService.formatDistance(distance)} • ${nearestSchedule.placeName ?? ''}',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(_getMarkerColor(nearestSchedule.color)),
          ),
        );
      }
      
      return markers;
    },
    loading: () => <Marker>{},
    error: (_, __) => <Marker>{},
  );
});

// 스케줄 색상에 따른 마커 색상 변환
double _getMarkerColor(ScheduleColor color) {
  switch (color) {
    case ScheduleColor.red:
      return BitmapDescriptor.hueRed;
    case ScheduleColor.green:
      return BitmapDescriptor.hueGreen;
    case ScheduleColor.yellow:
      return BitmapDescriptor.hueYellow;
    case ScheduleColor.purple:
      return BitmapDescriptor.hueViolet;
    case ScheduleColor.teal:
      return BitmapDescriptor.hueCyan;
    case ScheduleColor.blue:
    default:
      return BitmapDescriptor.hueOrange;
  }
}