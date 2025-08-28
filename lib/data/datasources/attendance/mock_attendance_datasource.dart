import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../../domain/entities/attendance_entity.dart';
import '../../../domain/entities/attendance_ranking_entity.dart';

class MockAttendanceDataSource {
  final List<AttendanceEntity> _attendances = [];
  final Map<String, String> _userNames = {}; // 사용자 ID -> 이름 캐시
  bool _seeded = false;

  Future<void> _ensureSeeded() async {
    if (_seeded) return;
    try {
      // 출석 데이터 로드
      final jsonStr = await rootBundle.loadString('assets/mock_data/attendances.json');
      final Map<String, dynamic> data = json.decode(jsonStr) as Map<String, dynamic>;
      final List<dynamic> attendanceList = data['attendances'] as List<dynamic>;
      
      for (final item in attendanceList) {
        _attendances.add(AttendanceEntity.fromJson(item as Map<String, dynamic>));
      }
      
      // 사용자 데이터 로드
      await _loadUserNames();
    } catch (_) {
      // ignore when asset missing
    }
    _seeded = true;
  }
  
  Future<void> _loadUserNames() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/mock_data/users.json');
      final Map<String, dynamic> data = json.decode(jsonStr) as Map<String, dynamic>;
      final List<dynamic> userList = data['users'] as List<dynamic>;
      
      for (final user in userList) {
        final userId = user['id'].toString();
        final userName = user['name'] as String;
        _userNames[userId] = userName;
      }
    } catch (e) {
      print('Failed to load user names: $e');
    }
  }

  String _getUserName(String userId) {
    return _userNames[userId] ?? 'User $userId';
  }

  /// 출석 기록 생성
  Future<AttendanceEntity> createAttendance(AttendanceEntity attendance) async {
    await _ensureSeeded();
    await Future.delayed(const Duration(milliseconds: 300));
    
    // 기존 출석 기록이 있다면 업데이트, 없다면 새로 추가
    final existingIndex = _attendances.indexWhere(
      (a) => a.scheduleId == attendance.scheduleId && a.userId == attendance.userId,
    );
    
    if (existingIndex != -1) {
      _attendances[existingIndex] = attendance;
    } else {
      _attendances.add(attendance);
    }
    
    return attendance;
  }

  /// 사용자의 특정 스케줄 출석 기록 조회
  Future<AttendanceEntity?> getAttendance(String scheduleId, String userId) async {
    await _ensureSeeded();
    await Future.delayed(const Duration(milliseconds: 100));
    
    try {
      return _attendances.firstWhere(
        (a) => a.scheduleId == scheduleId && a.userId == userId,
      );
    } catch (_) {
      return null;
    }
  }
  /// 사용자의 모든 출석 기록 조회
  Future<List<AttendanceEntity>> getUserAttendances(String userId) async {
    await _ensureSeeded();
    await Future.delayed(const Duration(milliseconds: 150));
    
    return _attendances.where((a) => a.userId == userId).toList();
  }

  /// 특정 스케줄의 모든 출석 기록 조회
  Future<List<AttendanceEntity>> getScheduleAttendances(String scheduleId) async {
    await _ensureSeeded();
    await Future.delayed(const Duration(milliseconds: 150));
    
    return _attendances.where((a) => a.scheduleId == scheduleId).toList();
  }

  /// 출석 기록 업데이트
  Future<AttendanceEntity> updateAttendance(AttendanceEntity attendance) async {
    await _ensureSeeded();
    await Future.delayed(const Duration(milliseconds: 200));
    
    final index = _attendances.indexWhere(
      (a) => a.scheduleId == attendance.scheduleId && a.userId == attendance.userId,
    );
    
    if (index == -1) {
      throw StateError('Attendance record not found');
    }
    
    _attendances[index] = attendance;
    return attendance;
  }

  /// 출석 기록 삭제
  Future<void> deleteAttendance(String scheduleId, String userId) async {
    await _ensureSeeded();
    await Future.delayed(const Duration(milliseconds: 100));
    
    _attendances.removeWhere(
      (a) => a.scheduleId == scheduleId && a.userId == userId,
    );
  }

  /// 모든 출석 기록 조회 (관리자용)
  Future<List<AttendanceEntity>> getAllAttendances() async {
    await _ensureSeeded();
    await Future.delayed(const Duration(milliseconds: 200));
    
    return List.unmodifiable(_attendances);
  }
  /// 스케줄의 출석 순위 조회
  Future<List<AttendanceRankingEntity>> getAttendanceRanking(String scheduleId) async {
    await _ensureSeeded();
    await Future.delayed(const Duration(milliseconds: 200));
    
    // 해당 스케줄의 성공한 출석만 가져오기
    final scheduleAttendances = _attendances
        .where((a) => a.scheduleId == scheduleId && a.status == AttendanceStatus.success)
        .toList();
    
    // 출석 시간순으로 정렬
    scheduleAttendances.sort((a, b) => a.checkInTime!.compareTo(b.checkInTime!));
    
    // 순위 엔티티로 변환
    final rankings = <AttendanceRankingEntity>[];
    for (int i = 0; i < scheduleAttendances.length; i++) {
      final attendance = scheduleAttendances[i];
      final ranking = AttendanceRankingEntity.fromAttendance(
        attendance,
        _getUserName(attendance.userId), // 실제 사용자 이름 사용
        i + 1, // 순위
        attendance.userId == 'u1', // u1을 호스트로 설정 (임시)
      );
      rankings.add(ranking);
    }
    
    return rankings;
  }

  /// 특정 사용자의 순위 조회
  Future<int?> getUserRanking(String scheduleId, String userId) async {
    final rankings = await getAttendanceRanking(scheduleId);
    final userRanking = rankings
        .where((r) => r.userId == userId)
        .firstOrNull;
    
    return userRanking?.arrivalOrder;
  }

  /// 출석 통계 조회
  Future<Map<String, dynamic>> getAttendanceStats(String scheduleId, int totalParticipants) async {
    final rankings = await getAttendanceRanking(scheduleId);
    
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
      'attendanceRate': totalParticipants > 0 ? attendedCount / totalParticipants * 100 : 0,
      'onTimeRate': totalParticipants > 0 ? onTimeCount / totalParticipants * 100 : 0,
    };
  }
}
extension ListExtension<T> on List<T> {
  T? get firstOrNull {
    if (isEmpty) return null;
    return first;
  }
}
