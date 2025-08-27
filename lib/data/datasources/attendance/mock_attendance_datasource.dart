import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../../domain/entities/attendance_entity.dart';

class MockAttendanceDataSource {
  final List<AttendanceEntity> _attendances = [];
  bool _seeded = false;

  Future<void> _ensureSeeded() async {
    if (_seeded) return;
    try {
      final jsonStr = await rootBundle.loadString('assets/mock_data/attendances.json');
      final Map<String, dynamic> data = json.decode(jsonStr) as Map<String, dynamic>;
      final List<dynamic> attendanceList = data['attendances'] as List<dynamic>;
      
      for (final item in attendanceList) {
        _attendances.add(AttendanceEntity.fromJson(item as Map<String, dynamic>));
      }
    } catch (_) {
      // ignore when asset missing
    }
    _seeded = true;
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
}
