import '../entities/user_entity.dart';
import '../../core/errors/failures.dart';

abstract class UserRepository {
  Future<({Failure? failure, List<UserEntity>? users})> getUsers({
    int page = 1,
    int limit = 10,
    String? search,
  });

  Future<({Failure? failure, UserEntity? user})> getUser(int id);

  Future<({Failure? failure, UserEntity? user})> createUser({
    required String name,
    required String email,
    String? phone,
    String? address,
  });
}
