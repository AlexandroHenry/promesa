import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../domain/entities/attendance_entity.dart';
import '../../../../domain/entities/schedule_entity.dart';
import '../../../../domain/services/attendance_service.dart';
import '../../../../domain/services/location_permission_service.dart';
import '../../../../data/datasources/attendance/mock_attendance_datasource.dart';
import 'map_provider.dart';

// 현재 사용자 ID (실제로는 인증 시스템에서 가져와야 함)
final currentUserIdProvider = StateProvider<String>((ref) => 'u1');

// Mock Attendance DataSource
final attendanceDataSourceProvider = Provider<MockAttendanceDataSource>((ref) {
  return MockAttendanceDataSource();
});

// 출석 상태 관리
final attendanceStateProvider = StateNotifierProvider.family<AttendanceNotifier, AttendanceState?, String>(
  (ref, scheduleId) => AttendanceNotifier(scheduleId, ref),
);

class AttendanceState {
  final AttendanceEntity? attendance;
  final bool isTracking;
  final bool isLoading;
  final String? errorMessage;
  final double? currentDistance;

  const AttendanceState({
    this.attendance,
    this.isTracking = false,
    this.isLoading = false,
    this.errorMessage,
    this.currentDistance,
  });

  AttendanceState copyWith({
    AttendanceEntity? attendance,
    bool? isTracking,
    bool? isLoading,
    String? errorMessage,
    double? currentDistance,
  }) {
    return AttendanceState(
      attendance: attendance ?? this.attendance,
      isTracking: isTracking ?? this.isTracking,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      currentDistance: currentDistance ?? this.currentDistance,
    );
  }
}

class AttendanceNotifier extends StateNotifier<AttendanceState?> {
  final String scheduleId;
  final Ref ref;
  StreamSubscription<LatLng>? _locationSubscription;
  Timer? _timeoutTimer;

  AttendanceNotifier(this.scheduleId, this.ref) : super(null);

  /// 출석 추적 시작
  Future<void> startAttendanceTracking(ScheduleEntity schedule) async {
    if (state?.isTracking == true) return;

    state = AttendanceState(
      isTracking: true,
      isLoading: true,
    );

    final userId = ref.read(currentUserIdProvider);

    try {
      // 위치 권한 확인
      final hasPermission = await LocationPermissionService.requestLocationPermission();
      if (!hasPermission) {
        state = state!.copyWith(
          isLoading: false,
          isTracking: false,
          errorMessage: '위치 권한이 필요합니다.',
        );
        return;
      }

      // 초기 출석 엔티티 생성
      final initialAttendance = AttendanceEntity(
        scheduleId: scheduleId,
        userId: userId,
        status: AttendanceStatus.inProgress,
      );

      state = state!.copyWith(
        attendance: initialAttendance,
        isLoading: false,
      );

      // 위치 추적 시작
      _locationSubscription = LocationPermissionService.getLocationStream().listen(
        (location) => _onLocationUpdate(location, schedule),
        onError: (error) {
          state = state!.copyWith(
            errorMessage: '위치 추적 중 오류가 발생했습니다: $error',
            isTracking: false,
          );
        },
      );

      // 타임아웃 설정 (5분)
      _timeoutTimer = Timer(const Duration(minutes: 5), () {
        _stopTracking('출석 시간이 초과되었습니다.');
      });

    } catch (e) {
      state = state!.copyWith(
        isLoading: false,
        isTracking: false,
        errorMessage: '출석 추적 시작 중 오류가 발생했습니다: $e',
      );
    }
  }

  void _onLocationUpdate(LatLng currentLocation, ScheduleEntity schedule) {
    if (state?.attendance == null || !state!.isTracking) return;

    // 회장과의 거리 계산
    if (schedule.latitude != null && schedule.longitude != null) {
      final venueLocation = LatLng(schedule.latitude!, schedule.longitude!);
      final distance = _calculateDistance(
        currentLocation.latitude,
        currentLocation.longitude,
        venueLocation.latitude,
        venueLocation.longitude,
      );

      state = state!.copyWith(currentDistance: distance);

      // 출석 범위 내에 있는지 확인
      if (AttendanceService.isWithinAttendanceRange(currentLocation, venueLocation)) {
        _completeAttendance(currentLocation, schedule);
      }
    }
  }

  /// 거리 계산 헬퍼 메서드
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return AttendanceService.calculateDistance(lat1, lon1, lat2, lon2);
  }

  /// 출석 완료 처리
  Future<void> _completeAttendance(LatLng currentLocation, ScheduleEntity schedule) async {
    if (state?.isTracking != true) return;

    final userId = ref.read(currentUserIdProvider);
    final checkInTime = DateTime.now();

    final attendance = AttendanceService.createAttendance(
      scheduleId: scheduleId,
      userId: userId,
      schedule: schedule,
      currentLocation: currentLocation,
      checkInTime: checkInTime,
    );

    // Mock 데이터에 저장
    try {
      final dataSource = ref.read(attendanceDataSourceProvider);
      await dataSource.createAttendance(attendance);
    } catch (e) {
      // 저장 실패해도 UI는 업데이트
      print('Failed to save attendance: $e');
    }

    state = state!.copyWith(
      attendance: attendance,
      isTracking: false,
    );

    _stopTracking();
  }

  /// 수동 출석 시도
  Future<void> attemptManualCheckIn(ScheduleEntity schedule) async {
    if (state?.isTracking != true) return;

    state = state!.copyWith(isLoading: true);

    try {
      final currentLocation = await LocationPermissionService.getCurrentLocation();
      if (currentLocation == null) {
        state = state!.copyWith(
          isLoading: false,
          errorMessage: '현재 위치를 가져올 수 없습니다.',
        );
        return;
      }

      _completeAttendance(currentLocation, schedule);
    } catch (e) {
      state = state!.copyWith(
        isLoading: false,
        errorMessage: '출석 처리 중 오류가 발생했습니다: $e',
      );
    }
  }

  /// 추적 중단
  void _stopTracking([String? message]) {
    _locationSubscription?.cancel();
    _locationSubscription = null;
    _timeoutTimer?.cancel();
    _timeoutTimer = null;

    if (message != null) {
      state = state!.copyWith(
        isTracking: false,
        errorMessage: message,
      );
    }
  }

  /// 출석 취소
  void cancelAttendance() {
    _stopTracking();
    state = null;
  }

  @override
  void dispose() {
    _stopTracking();
    super.dispose();
  }
}