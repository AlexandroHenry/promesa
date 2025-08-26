import '../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';
import '../../core/utils/logger.dart';

class GetUsersUseCase {
  final UserRepository _repository;

  GetUsersUseCase(this._repository);

  Future<({Failure? failure, List<UserEntity>? users})> call({
    int page = 1,
    int limit = 10,
    String? search,
  }) async {
    Logger.d('GetUsersUseCase: Getting users (page: $page, limit: $limit)', 'GetUsersUseCase');
    
    // 입력값 검증
    if (page < 1) {
      return (
        failure: const Failure.validation(message: '페이지 번호는 1 이상이어야 합니다'),
        users: null,
      );
    }
    
    if (limit < 1 || limit > 100) {
      return (
        failure: const Failure.validation(message: '한 페이지당 항목 수는 1-100 사이여야 합니다'),
        users: null,
      );
    }

    try {
      final result = await _repository.getUsers(
        page: page,
        limit: limit,
        search: search,
      );

      if (result.failure != null) {
        Logger.e('GetUsersUseCase: Failed to get users', 'GetUsersUseCase', result.failure);
        return result;
      }

      Logger.d('GetUsersUseCase: Successfully got ${result.users?.length ?? 0} users', 'GetUsersUseCase');
      return result;
    } catch (e) {
      Logger.e('GetUsersUseCase: Unexpected error', 'GetUsersUseCase', e);
      return (
        failure: Failure.unknown(message: '사용자 목록을 가져오는 중 오류가 발생했습니다'),
        users: null,
      );
    }
  }
}
