import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../domain/entities/schedule_entity.dart';
// removed unused: attendance_entity
import '../../../../domain/services/location_permission_service.dart';
import '../../../../domain/services/location_service.dart';
// removed unused: attendance_service
import '../providers/map_provider.dart';
// removed unused: attendance_provider
import '../widgets/attendance_bottom_sheet.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(37.5665, 126.9780), // Seoul City Hall
    zoom: 12,
  );

  GoogleMapController? _mapController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  /// 앱 시작 시 현재 위치 가져오기
  Future<void> _initializeLocation() async {
    final currentLocation = await LocationPermissionService.getCurrentLocation();
    if (currentLocation != null && mounted) {
      // 현재 위치를 provider에 업데이트
      ref.read(currentLocationProvider.notifier).state = currentLocation;
      
      // 지도 카메라를 현재 위치로 이동
      await _moveToLocation(currentLocation);
    }
  }

  /// 지도 카메라를 특정 위치로 이동
  Future<void> _moveToLocation(LatLng location) async {
    final controller = _mapController;
    if (controller != null) {
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: location,
            zoom: 14,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }  @override
  Widget build(BuildContext context) {
    final markers = ref.watch(mapMarkersProvider);
    final nearestSchedule = ref.watch(nearestScheduleProvider);
    
    return Scaffold(
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            markers: markers,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            onMapCreated: (controller) {
              _mapController = controller;
              if (!_isInitialized) {
                _isInitialized = true;
                _initializeLocation();
              }
            },
            onTap: (LatLng position) {
              // 지도를 탭하면 해당 위치를 현재 위치로 설정 (테스트용)
              ref.read(currentLocationProvider.notifier).state = position;
            },
          ),
          
          // 상단 정보 카드
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: nearestSchedule.when(
              data: (schedule) {
                if (schedule == null) {
                  return _buildInfoCard(
                    title: '근처 일정 없음',
                    subtitle: '현재 위치 근처에 예정된 일정이 없습니다.',
                    icon: Icons.location_off,
                    color: Colors.grey.shade600,
                  );
                }
                
                final currentLocation = ref.watch(currentLocationProvider);
                final distance = schedule.latitude != null && schedule.longitude != null
                    ? LocationService.calculateDistance(
                        currentLocation.latitude,
                        currentLocation.longitude,
                        schedule.latitude!,
                        schedule.longitude!,
                      )
                    : 0.0;
                
                return _buildInfoCard(
                  title: schedule.title,
                  subtitle: '${LocationService.formatDistance(distance)} • ${schedule.placeName ?? '위치 미정'}',
                  icon: Icons.event,
                  color: _getScheduleColor(schedule.color),
                  onTap: () => _onScheduleCardTap(schedule),
                );
              },
              loading: () => _buildInfoCard(
                title: '일정 로딩 중...',
                subtitle: '',
                icon: Icons.refresh,
                color: Colors.blue,
              ),
              error: (error, _) => _buildInfoCard(
                title: '오류',
                subtitle: '일정을 불러올 수 없습니다.',
                icon: Icons.error,
                color: Colors.red,
              ),
            ),
          ),
          
          // 하단 액션 버튼들
          Positioned(
            bottom: 30,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 내 위치로 이동 버튼
                FloatingActionButton(
                  heroTag: "my_location",
                  onPressed: _goToMyLocation,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  child: const Icon(Icons.my_location),
                ),
                const SizedBox(height: 12),
                
                // 가장 가까운 일정으로 이동 버튼
                FloatingActionButton(
                  heroTag: "nearest_schedule",
                  onPressed: _goToNearestSchedule,
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  child: const Icon(Icons.event_available),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  /// 정보 카드 위젯 빌더
  Widget _buildInfoCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (onTap != null) 
                Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
  /// 내 위치로 이동
  Future<void> _goToMyLocation() async {
    final currentLocation = await LocationPermissionService.getCurrentLocation();
    if (currentLocation != null && mounted) {
      ref.read(currentLocationProvider.notifier).state = currentLocation;
      await _moveToLocation(currentLocation);
    }
  }

  /// 가장 가까운 일정으로 이동
  Future<void> _goToNearestSchedule() async {
    final nearestSchedule = ref.read(nearestScheduleProvider);
    nearestSchedule.whenData((schedule) {
      if (schedule != null && 
          schedule.latitude != null && 
          schedule.longitude != null) {
        final scheduleLocation = LatLng(schedule.latitude!, schedule.longitude!);
        _moveToLocation(scheduleLocation);
      }
    });
  }

  /// 스케줄 카드 탭 이벤트
  void _onScheduleCardTap(schedule) {
    // 스케줄 상세 화면으로 이동하거나 바텀시트 표시
    _showScheduleBottomSheet(schedule);
  }

  /// 스케줄 상세 바텀시트 표시
  void _showScheduleBottomSheet(schedule) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final bottomInset = MediaQuery.of(context).viewInsets.bottom;
        return SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset + MediaQuery.of(context).viewPadding.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                  // 핸들 바
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // 타이틀
                  Text(
                    schedule.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // 위치 정보
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.grey.shade600, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        schedule.placeName ?? '위치 미정',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // 날짜 정보
                  Row(
                    children: [
                      Icon(Icons.schedule, color: Colors.grey.shade600, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        _formatDateTime(schedule.dateTime),
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // 벌금 정보
                  if (schedule.lateFine != null || schedule.lateFineAmount > 0) ...[
                    Row(
                      children: [
                        Icon(Icons.account_balance_wallet, color: Colors.grey.shade600, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          schedule.lateFine?.getDisplayText() ?? 
                          '지각 시 ${schedule.lateFineAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                  
                  // 설명
                  if (schedule.description.isNotEmpty) ...[
                    Text(
                      '설명',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(schedule.description),
                    const SizedBox(height: 12),
                  ],
                  
                  // 참가자
                  if (schedule.participants.isNotEmpty) ...[
                    Text(
                      '참가자 (${schedule.participants.length}명)',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: schedule.participants.map<Widget>((participant) => 
                        Chip(
                          avatar: participant.isHost 
                            ? const Icon(Icons.star, size: 16)
                            : null,
                          label: Text(participant.name),
                          backgroundColor: participant.isHost 
                            ? Colors.orange.shade100
                            : null,
                        )
                      ).toList(),
                    ),
                  ],
                  
                  const SizedBox(height: 20),
                  
                // 출석하기 버튼
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _showAttendanceBottomSheet(schedule, context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '출석하기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  /// 스케줄 색상을 Flutter Color로 변환
  Color _getScheduleColor(ScheduleColor color) {
    switch (color) {
      case ScheduleColor.red:
        return Colors.red;
      case ScheduleColor.green:
        return Colors.green;
      case ScheduleColor.yellow:
        return Colors.amber;
      case ScheduleColor.purple:
        return Colors.purple;
      case ScheduleColor.teal:
        return Colors.teal;
      case ScheduleColor.blue:
        return Colors.blue;
    }
  }

  /// 날짜를 사용자 친화적 문자열로 변환
  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);
    
    if (difference.inDays == 0) {
      // 오늘
      return '오늘 ${_formatTime(dateTime)}';
    } else if (difference.inDays == 1) {
      // 내일
      return '내일 ${_formatTime(dateTime)}';
    } else if (difference.inDays > 0 && difference.inDays < 7) {
      // 이번 주
      return '${_getWeekday(dateTime)} ${_formatTime(dateTime)}';
    } else {
      // 그 외
      return '${dateTime.month}/${dateTime.day} ${_formatTime(dateTime)}';
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _getWeekday(DateTime dateTime) {
    const weekdays = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
    return weekdays[dateTime.weekday - 1];
  }
}
  /// 출석 바텀시트 표시
  void _showAttendanceBottomSheet(ScheduleEntity schedule, BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AttendanceBottomSheet(schedule: schedule),
    );
  }