import '../entities/attendance_entity.dart';
import '../entities/attendance_ranking_entity.dart';
import '../entities/schedule_entity.dart';
import '../entities/participant_entity.dart';

class AttendanceRankingService {
  /// 출석 기록들을 순위로 정렬
  static List<AttendanceRankingEntity> generateRanking(
    List<AttendanceEntity> attendances,
    ScheduleEntity schedule,
  ) {
    // 성공한 출석만 필터링
    final successfulAttendances = attendances
        .where((a) => a.status == AttendanceStatus.success)
        .toList();
    
    // 출석 시간순으로 정렬
    successfulAttendances.sort((a, b) => 
        a.checkInTime!.compareTo(b.checkInTime!));
    
    final rankings = <AttendanceRankingEntity>[];
    
    for (int i = 0; i < successfulAttendances.length; i++) {
      final attendance = successfulAttendances[i];
      final participant = _findParticipant(attendance.userId, schedule);
      
      final ranking = AttendanceRankingEntity.fromAttendance(
        attendance,
        participant?.name ?? 'Unknown User',
        i + 1, // 순위 (1부터 시작)
        participant?.isHost ?? false,
      );
      
      rankings.add(ranking);
    }
    
    return rankings;
  }
  
  /// 특정 사용자의 순위 찾기
  static int? getUserRanking(
    String userId,
    List<AttendanceRankingEntity> rankings,
  ) {
    final userRanking = rankings
        .where((r) => r.userId == userId)
        .firstOrNull;
    
    return userRanking?.arrivalOrder;
  }
  
  /// 순위 통계 생성
  static Map<String, dynamic> generateRankingStats(
    List<AttendanceRankingEntity> rankings,
    int totalParticipants,
  ) {
    final attendedCount = rankings.length;
    final lateCount = rankings.where((r) => r.isLate).length;
    final onTimeCount = attendedCount - lateCount;
    final absentCount = totalParticipants - attendedCount;
    
    return {
      'totalParticipants': totalParticipants,
      'attendedCount': attendedCount,
      'onTimeCount': onTimeCount,
      'lateCount': lateCount,
      'absentCount': absentCount,
      'attendanceRate': attendedCount / totalParticipants * 100,
      'onTimeRate': onTimeCount / totalParticipants * 100,
    };
  }
  
  /// 상위 3명 가져오기
  static List<AttendanceRankingEntity> getTopThree(
    List<AttendanceRankingEntity> rankings,
  ) {
    return rankings.take(3).toList();
  }
  
  /// 순위 메시지 생성
  static String generateRankingMessage(
    int userRanking,
    int totalAttended,
    int totalParticipants,
  ) {
    if (userRanking == 1) {
      return '🎉 1등으로 도착했습니다!';
    } else if (userRanking <= 3) {
      return '👏 ${userRanking}등으로 도착했습니다!';
    } else {
      return '${userRanking}등으로 도착했습니다 ($totalAttended/$totalParticipants명 출석)';
    }
  }
  
  /// 참가자 찾기 헬퍼
  static ParticipantEntity? _findParticipant(String userId, ScheduleEntity schedule) {
    try {
      return schedule.participants.firstWhere((p) => p.id == userId);
    } catch (e) {
      return null;
    }
  }
}

extension ListExtension<T> on List<T> {
  T? get firstOrNull {
    if (isEmpty) return null;
    return first;
  }
}