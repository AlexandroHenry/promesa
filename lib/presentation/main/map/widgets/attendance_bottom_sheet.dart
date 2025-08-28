import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../domain/entities/schedule_entity.dart';
import '../../../../domain/entities/attendance_entity.dart';
import '../../../../domain/entities/attendance_ranking_entity.dart';
import '../../../../domain/services/attendance_service.dart';
import '../providers/attendance_provider.dart';
import '../providers/map_provider.dart';

class AttendanceBottomSheet extends ConsumerStatefulWidget {
  final ScheduleEntity schedule;

  const AttendanceBottomSheet({
    super.key,
    required this.schedule,
  });

  @override
  ConsumerState<AttendanceBottomSheet> createState() => _AttendanceBottomSheetState();
}

class _AttendanceBottomSheetState extends ConsumerState<AttendanceBottomSheet>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final attendanceState = ref.watch(attendanceStateProvider(widget.schedule.id));
    final currentLocation = ref.watch(currentLocationProvider);

    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      top: false,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // 핸들 바
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // 타이틀
          Text(
            widget.schedule.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // 장소 정보
          Text(
            widget.schedule.placeName ?? '위치 미정',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // 메인 콘텐츠 (오버플로 방지 위한 스크롤 래핑)
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  clipBehavior: Clip.none,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: _buildMainContent(attendanceState, currentLocation),
                  ),
                );
              },
            ),
          ),

          // 하단 버튼들
          _buildBottomButtons(attendanceState),
        ],
      ),
    ),
      ),
    );
  }
  Widget _buildMainContent(AttendanceState? attendanceState, LatLng currentLocation) {
    if (attendanceState?.attendance?.isCompleted == true) {
      return _buildCompletedContent(attendanceState!.attendance!);
    }

    if (attendanceState?.isTracking == true) {
      return _buildTrackingContent(attendanceState!, currentLocation);
    }

    return _buildInitialContent(currentLocation);
  }

  Widget _buildInitialContent(LatLng currentLocation) {
    double? distance;
    bool canAttend = false;
    
    // 출석 시간 체크
    final canStartAttendance = AttendanceService.canStartAttendance(widget.schedule.dateTime);
    final timeMessage = AttendanceService.getAttendanceTimeMessage(widget.schedule.dateTime);

    if (widget.schedule.latitude != null && widget.schedule.longitude != null) {
      final venueLocation = LatLng(widget.schedule.latitude!, widget.schedule.longitude!);
      distance = AttendanceService.calculateDistance(
        currentLocation.latitude,
        currentLocation.longitude,
        venueLocation.latitude,
        venueLocation.longitude,
      );
      canAttend = AttendanceService.isWithinAttendanceRange(currentLocation, venueLocation);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 출석 시간 상태
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
            color: canStartAttendance ? Colors.green[50] : Colors.orange[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: canStartAttendance ? Colors.green[200]! : Colors.orange[200]!,
            ),
          ),
          child: Row(
            children: [
              Icon(
                canStartAttendance ? Icons.check_circle : Icons.access_time,
                color: canStartAttendance ? Colors.green[600] : Colors.orange[600],
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  timeMessage,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: canStartAttendance ? Colors.green[700] : Colors.orange[700],
                  ),
                ),
              ),
            ],
          ),
        ),
        
        if (distance != null) ...[
          Icon(
            canAttend ? Icons.location_on : Icons.location_off,
            size: 64,
            color: canAttend ? Colors.green : Colors.orange,
          ),
          const SizedBox(height: 16),
          Text(
            '회장까지 거리',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AttendanceService.formatDistance(distance),
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: canAttend ? Colors.green : Colors.orange,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            canAttend 
                ? '출석 가능 범위 내에 있습니다!'
                : '50m 이내로 접근해주세요',
            style: TextStyle(
              fontSize: 14,
              color: canAttend ? Colors.green : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ] else ...[
          Icon(
            Icons.location_disabled,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '회장 위치가 설정되지 않았습니다',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
  Widget _buildTrackingContent(AttendanceState attendanceState, LatLng currentLocation) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 펄스 애니메이션 원
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red[400],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.location_searching,
                  size: 48,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 32),

        const Text(
          '위치 추적 중...',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        if (attendanceState.currentDistance != null) ...[
          Text(
            '회장까지: ${AttendanceService.formatDistance(attendanceState.currentDistance!)}',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          
          LinearProgressIndicator(
            value: attendanceState.currentDistance! > 50 
                ? 0.0 
                : (50 - attendanceState.currentDistance!) / 50,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              attendanceState.currentDistance! <= 50 ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            attendanceState.currentDistance! <= 50 
                ? '출석 범위 내에 있습니다!'
                : '50m 이내로 접근해주세요',
            style: TextStyle(
              fontSize: 14,
              color: attendanceState.currentDistance! <= 50 
                  ? Colors.green 
                  : Colors.grey[600],
            ),
          ),
        ],

        const SizedBox(height: 32),

        // 수동 출석 버튼
        TextButton(
          onPressed: attendanceState.isLoading 
              ? null
              : () {
                  ref.read(attendanceStateProvider(widget.schedule.id).notifier)
                      .attemptManualCheckIn(widget.schedule);
                },
          child: Text(
            attendanceState.isLoading ? '처리 중...' : '수동 출석하기',
            style: TextStyle(
              color: Colors.blue[600],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildCompletedContent(AttendanceEntity attendance) {
    final isSuccess = attendance.status == AttendanceStatus.success;
    final attendanceState = ref.watch(attendanceStateProvider(widget.schedule.id));
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 결과 아이콘
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSuccess ? Colors.green[400] : Colors.red[400],
          ),
          child: Icon(
            isSuccess ? Icons.check_circle : Icons.error,
            size: 64,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),

        // 결과 제목
        Text(
          isSuccess ? '출석 완료!' : '출석 실패',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: isSuccess ? Colors.green[600] : Colors.red[600],
          ),
        ),
        const SizedBox(height: 16),

        // 순위 정보 (성공시에만)
        if (isSuccess && attendanceState?.userRanking != null) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Column(
              children: [
                Text(
                  '🎯 도착 순위',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _getRankingText(attendanceState!.userRanking!),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                if (attendanceState.stats != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    '${attendanceState.stats!['attendedCount']}/${attendanceState.stats!['totalParticipants']}명 출석',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // 상태 메시지
        Text(
          AttendanceService.getStatusMessage(attendance, widget.schedule),
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
        
        if (attendance.isLate && isSuccess) ...[
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange[200]!),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.warning_amber, color: Colors.orange[600]),
                    const SizedBox(width: 8),
                    Text(
                      '지각 벌금',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${attendance.fineAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${attendance.lateMinutes}분 지각으로 인한 벌금',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 24),

        // 출석 시간
        if (attendance.checkInTime != null) ...[
          Text(
            '출석 시간: ${_formatTime(attendance.checkInTime!)}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
        
        // 순위 목록 보기 버튼 (성공시에만)
        if (isSuccess && attendanceState?.rankings != null && attendanceState!.rankings!.isNotEmpty) ...[
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () => _showRankingBottomSheet(context, attendanceState.rankings!),
            icon: const Icon(Icons.leaderboard),
            label: const Text('전체 순위 보기'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue[600],
            ),
          ),
        ],
      ],
    );
  }
  Widget _buildBottomButtons(AttendanceState? attendanceState) {
    if (attendanceState?.attendance?.isCompleted == true) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[600],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            '확인',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    if (attendanceState?.isTracking == true) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                ref.read(attendanceStateProvider(widget.schedule.id).notifier)
                    .cancelAttendance();
                Navigator.of(context).pop();
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('취소'),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('취소'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: (attendanceState?.isLoading == true || !AttendanceService.canStartAttendance(widget.schedule.dateTime))
                ? null
                : () {
                    ref.read(attendanceStateProvider(widget.schedule.id).notifier)
                        .startAttendanceTracking(widget.schedule);
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              attendanceState?.isLoading == true ? '시작 중...' : 
              !AttendanceService.canStartAttendance(widget.schedule.dateTime) ? '시간 대기 중' :
              '출석 시작',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

  /// 순위 텍스트 생성
  String _getRankingText(int ranking) {
    switch (ranking) {
      case 1:
        return '🥇 1등으로 도착!';
      case 2:
        return '🥈 2등으로 도착!';
      case 3:
        return '🥉 3등으로 도착!';
      default:
        return '${ranking}등으로 도착';
    }
  }

  /// 순위 바텀시트 표시
  void _showRankingBottomSheet(BuildContext context, List<AttendanceRankingEntity> rankings) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          builder: (context, controller) {
            return SafeArea(
              top: false,
              child: SingleChildScrollView(
                controller: controller,
                padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + MediaQuery.of(context).viewPadding.bottom),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  // 핸들 바
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // 타이틀
                  Text(
                    '📊 출석 순위',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  Text(
                    '${rankings.length}명이 출석했습니다',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // 순위 목록
                  ListView.builder(
                    controller: controller,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: rankings.length,
                    itemBuilder: (context, index) {
                      final ranking = rankings[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getRankingColor(ranking.arrivalOrder),
                            child: Text(
                              ranking.arrivalOrder.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Row(
                            children: [
                              Text(
                                ranking.userName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (ranking.isHost) ...[
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.star,
                                  size: 16,
                                  color: Colors.orange[600],
                                ),
                              ],
                            ],
                          ),
                          subtitle: Text(ranking.lateText),
                          trailing: Text(
                            ranking.timeText,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              ),
            );
          },
        );
      },
    );
  }

  /// 순위별 색상 반환
  Color _getRankingColor(int ranking) {
    switch (ranking) {
      case 1:
        return Colors.amber; // 금색
      case 2:
        return Colors.grey; // 은색
      case 3:
        return Colors.brown; // 동색
      default:
        return Colors.blue;
    }
  }