import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../../core/errors/failures.dart';
import '../datasources/remote/user_api.dart';
import '../../core/utils/logger.dart';
import 'package:dio/dio.dart';

class ApiUserRepository implements UserRepository {
  final UserApi _userApi;

  ApiUserRepository(this._userApi);

  @override
  Future<({Failure? failure, List<UserEntity>? users})> getUsers({
    int page = 1,
    int limit = 10,
    String? search,
  }) async {
    try {
      Logger.d('ApiUserRepository: Getting users from API', 'ApiUserRepository');
      
      final response = await _userApi.getUsers(page, limit, search);
      
      // UserListResponseModel을 직접 사용
      final users = response.data
          .map((userModel) => userModel.toEntity())
          .toList();
      
      Logger.d('ApiUserRepository: Got ${users.length} users', 'ApiUserRepository');
      return (failure: null, users: users);
      
    } on DioException catch (e) {
      Logger.e('ApiUserRepository: Dio error getting users', 'ApiUserRepository', e);
      return (
        failure: _handleDioError(e),
        users: null,
      );
    } catch (e) {
      Logger.e('ApiUserRepository: Unknown error getting users', 'ApiUserRepository', e);
      return (
        failure: Failure.unknown(message: e.toString()),
        users: null,
      );
    }
  }

  @override
  Future<({Failure? failure, UserEntity? user})> getUser(int id) async {
    try {
      Logger.d('ApiUserRepository: Getting user $id from API', 'ApiUserRepository');
      
      final response = await _userApi.getUser(id);
      
      // UserModel을 직접 사용
      final user = response.toEntity();
      
      Logger.d('ApiUserRepository: Got user ${user.name}', 'ApiUserRepository');
      return (failure: null, user: user);
      
    } on DioException catch (e) {
      Logger.e('ApiUserRepository: Dio error getting user', 'ApiUserRepository', e);
      return (
        failure: _handleDioError(e),
        user: null,
      );
    } catch (e) {
      Logger.e('ApiUserRepository: Unknown error getting user', 'ApiUserRepository', e);
      return (
        failure: Failure.unknown(message: e.toString()),
        user: null,
      );
    }
  }

  @override
  Future<({Failure? failure, UserEntity? user})> createUser({
    required String name,
    required String email,
    String? phone,
    String? address,
  }) async {
    try {
      Logger.d('ApiUserRepository: Creating user $name via API', 'ApiUserRepository');
      
      final userData = {
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
      };
      
      final response = await _userApi.createUser(userData);
      
      // UserModel을 직접 사용
      final user = response.toEntity();
      
      Logger.d('ApiUserRepository: Created user ${user.name}', 'ApiUserRepository');
      return (failure: null, user: user);
      
    } on DioException catch (e) {
      Logger.e('ApiUserRepository: Dio error creating user', 'ApiUserRepository', e);
      return (
        failure: _handleDioError(e),
        user: null,
      );
    } catch (e) {
      Logger.e('ApiUserRepository: Unknown error creating user', 'ApiUserRepository', e);
      return (
        failure: Failure.unknown(message: e.toString()),
        user: null,
      );
    }
  }

  // DioException 처리
  Failure _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const Failure.network(message: '네트워크 연결 시간이 초과되었습니다');
      
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode ?? 0;
        final message = e.response?.data?['error']?['message'] ?? 
                       e.response?.statusMessage ?? 
                       '서버 오류가 발생했습니다';
        return Failure.server(message: message, statusCode: statusCode);
      
      case DioExceptionType.cancel:
        return const Failure.network(message: '요청이 취소되었습니다');
      
      case DioExceptionType.connectionError:
        return const Failure.network(message: '네트워크 연결을 확인해주세요');
      
      case DioExceptionType.badCertificate:
        return const Failure.network(message: '보안 인증서 오류입니다');
      
      case DioExceptionType.unknown:
      default:
        return Failure.unknown(message: e.message ?? '알 수 없는 오류가 발생했습니다');
    }
  }
}
