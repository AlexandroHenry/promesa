import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../../core/errors/failures.dart';
import '../datasources/mock/mock_data_source.dart';
import '../models/user_model.dart';
import '../../core/utils/logger.dart';

class MockUserRepository implements UserRepository {
  @override
  Future<({Failure? failure, List<UserEntity>? users})> getUsers({
    int page = 1,
    int limit = 10,
    String? search,
  }) async {
    try {
      Logger.d('MockUserRepository: Getting users', 'MockUserRepository');
      
      final response = await MockDataSource.getUsers(
        page: page,
        limit: limit,
        search: search,
      );

      if (response['success'] == true) {
        final usersData = response['data']['users'] as List<dynamic>;
        final users = usersData
            .map((userData) => UserModel.fromJson(userData).toEntity())
            .toList();
        
        Logger.d('MockUserRepository: Got ${users.length} users', 'MockUserRepository');
        return (failure: null, users: users);
      } else {
        final error = response['error'];
        final failure = Failure.server(
          message: error['message'] ?? 'Unknown error',
          statusCode: 400,
        );
        return (failure: failure, users: null);
      }
    } catch (e) {
      Logger.e('MockUserRepository: Error getting users', 'MockUserRepository', e);
      return (
        failure: Failure.unknown(message: e.toString()),
        users: null,
      );
    }
  }

  @override
  Future<({Failure? failure, UserEntity? user})> getUser(int id) async {
    try {
      Logger.d('MockUserRepository: Getting user $id', 'MockUserRepository');
      
      final response = await MockDataSource.getUser(id);

      if (response['success'] == true) {
        final userData = response['data'];
        final user = UserModel.fromJson(userData).toEntity();
        
        Logger.d('MockUserRepository: Got user ${user.name}', 'MockUserRepository');
        return (failure: null, user: user);
      } else {
        final error = response['error'];
        final failure = error['code'] == 'NOT_FOUND'
            ? Failure.server(message: error['message'], statusCode: 404)
            : Failure.server(message: error['message'], statusCode: 400);
        return (failure: failure, user: null);
      }
    } catch (e) {
      Logger.e('MockUserRepository: Error getting user', 'MockUserRepository', e);
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
      Logger.d('MockUserRepository: Creating user $name', 'MockUserRepository');
      
      final userData = {
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
      };
      
      final response = await MockDataSource.createUser(userData);

      if (response['success'] == true) {
        final createdUserData = response['data'];
        final user = UserModel.fromJson(createdUserData).toEntity();
        
        Logger.d('MockUserRepository: Created user ${user.name}', 'MockUserRepository');
        return (failure: null, user: user);
      } else {
        final error = response['error'];
        final failure = Failure.server(
          message: error['message'] ?? 'Creation failed',
          statusCode: 400,
        );
        return (failure: failure, user: null);
      }
    } catch (e) {
      Logger.e('MockUserRepository: Error creating user', 'MockUserRepository', e);
      return (
        failure: Failure.unknown(message: e.toString()),
        user: null,
      );
    }
  }
}
