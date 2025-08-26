import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../../../core/utils/logger.dart';

class MockDataSource {
  static const String _basePath = 'assets/mock_data';
  static final Random _random = Random();

  // JSON 파일 로드
  static Future<Map<String, dynamic>> _loadJsonFile(String fileName) async {
    try {
      final String jsonString = await rootBundle.loadString('$_basePath/$fileName');
      return json.decode(jsonString);
    } catch (e) {
      Logger.e('Failed to load mock data: $fileName', 'MockDataSource', e);
      return {};
    }
  }

  // 네트워크 지연 시뮬레이션
  static Future<void> _simulateNetworkDelay([int? milliseconds]) async {
    final delay = milliseconds ?? _random.nextInt(1000) + 500; // 500-1500ms
    await Future.delayed(Duration(milliseconds: delay));
  }

  // 랜덤 에러 시뮬레이션 (10% 확률)
  static void _simulateRandomError() {
    if (_random.nextInt(10) == 0) { // 10% 확률
      throw Exception('Mock network error - simulated failure');
    }
  }

  // 성공 응답 생성
  static Map<String, dynamic> _createSuccessResponse(dynamic data, [String? message]) {
    return {
      'success': true,
      'message': message ?? 'Success',
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  // 에러 응답 생성
  static Map<String, dynamic> _createErrorResponse(String code, String message) {
    return {
      'success': false,
      'error': {
        'code': code,
        'message': message,
      },
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  // 사용자 목록 조회
  static Future<Map<String, dynamic>> getUsers({
    int page = 1,
    int limit = 10,
    String? search,
  }) async {
    Logger.d('🎭 Mock API: Getting users (page: $page, limit: $limit)', 'MockDataSource');
    
    await _simulateNetworkDelay();
    _simulateRandomError();

    final data = await _loadJsonFile('users.json');
    List<dynamic> users = data['users'] ?? [];

    // 검색 필터링
    if (search != null && search.isNotEmpty) {
      users = users.where((user) => 
        user['name'].toString().toLowerCase().contains(search.toLowerCase()) ||
        user['email'].toString().toLowerCase().contains(search.toLowerCase())
      ).toList();
    }

    // 페이지네이션
    final totalUsers = users.length;
    final startIndex = (page - 1) * limit;
    final endIndex = (startIndex + limit).clamp(0, totalUsers);
    final paginatedUsers = users.sublist(startIndex, endIndex);

    return _createSuccessResponse({
      'users': paginatedUsers,
      'pagination': {
        'currentPage': page,
        'totalPages': (totalUsers / limit).ceil(),
        'totalItems': totalUsers,
        'itemsPerPage': limit,
      }
    }, '사용자 목록 조회 성공');
  }

  // 사용자 상세 조회
  static Future<Map<String, dynamic>> getUser(int id) async {
    Logger.d('🎭 Mock API: Getting user $id', 'MockDataSource');
    
    await _simulateNetworkDelay();
    _simulateRandomError();

    final data = await _loadJsonFile('users.json');
    final users = data['users'] as List<dynamic>? ?? [];
    
    final user = users.firstWhere(
      (u) => u['id'] == id,
      orElse: () => null,
    );

    if (user == null) {
      return _createErrorResponse('NOT_FOUND', '사용자를 찾을 수 없습니다');
    }

    return _createSuccessResponse(user, '사용자 정보 조회 성공');
  }

  // 사용자 생성
  static Future<Map<String, dynamic>> createUser(Map<String, dynamic> userData) async {
    Logger.d('🎭 Mock API: Creating user', 'MockDataSource');
    
    await _simulateNetworkDelay(800); // 생성은 조금 더 느리게
    _simulateRandomError();

    final newUser = {
      'id': _random.nextInt(1000) + 100,
      'name': userData['name'],
      'email': userData['email'],
      'avatar': 'https://via.placeholder.com/150',
      'phone': userData['phone'] ?? '',
      'address': userData['address'] ?? '',
      'createdAt': DateTime.now().toIso8601String(),
    };

    return _createSuccessResponse(newUser, '사용자 생성 성공');
  }

  // 상품 목록 조회
  static Future<Map<String, dynamic>> getProducts({
    int page = 1,
    int limit = 10,
    String? category,
    String? search,
  }) async {
    Logger.d('🎭 Mock API: Getting products', 'MockDataSource');
    
    await _simulateNetworkDelay();
    _simulateRandomError();

    final data = await _loadJsonFile('products.json');
    List<dynamic> products = data['products'] ?? [];

    // 카테고리 필터링
    if (category != null && category.isNotEmpty) {
      products = products.where((product) => 
        product['category'].toString().toLowerCase() == category.toLowerCase()
      ).toList();
    }

    // 검색 필터링
    if (search != null && search.isNotEmpty) {
      products = products.where((product) => 
        product['name'].toString().toLowerCase().contains(search.toLowerCase()) ||
        product['description'].toString().toLowerCase().contains(search.toLowerCase())
      ).toList();
    }

    // 페이지네이션
    final totalProducts = products.length;
    final startIndex = (page - 1) * limit;
    final endIndex = (startIndex + limit).clamp(0, totalProducts);
    final paginatedProducts = products.sublist(startIndex, endIndex);

    return _createSuccessResponse({
      'products': paginatedProducts,
      'pagination': {
        'currentPage': page,
        'totalPages': (totalProducts / limit).ceil(),
        'totalItems': totalProducts,
        'itemsPerPage': limit,
      }
    }, '상품 목록 조회 성공');
  }

  // 로그인
  static Future<Map<String, dynamic>> login(String email, String password) async {
    Logger.d('🎭 Mock API: Login attempt for $email', 'MockDataSource');
    
    await _simulateNetworkDelay(1200); // 로그인은 더 느리게
    
    // 특정 계정은 실패하도록 설정
    if (email == 'fail@example.com') {
      return _createErrorResponse('UNAUTHORIZED', '이메일 또는 비밀번호가 올바르지 않습니다');
    }

    _simulateRandomError();

    return _createSuccessResponse({
      'accessToken': 'mock_access_token_${_random.nextInt(99999)}',
      'refreshToken': 'mock_refresh_token_${_random.nextInt(99999)}',
      'user': {
        'id': 1,
        'name': '김철수',
        'email': email,
        'role': 'user',
        'avatar': 'https://via.placeholder.com/150',
      }
    }, '로그인 성공');
  }
}
