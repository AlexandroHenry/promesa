import '../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';
import '../../core/utils/logger.dart';

class GetUserUseCase {
  final UserRepository _repository;

  GetUserUseCase(this._repository);

  Future<({Failure? failure, UserEntity? user})> call(int userId) async {
    Logger.d('GetUserUseCase: Getting user $userId', 'GetUserUseCase');
    
    // 입력값 검증
    if (userId <= 0) {
      return (
        failure: const Failure.validation(message: '유효하지 않은 사용자 ID입니다'),
        user: null,
      );
    }

    try {
      final result = await _repository.getUser(userId);

      if (result.failure != null) {
        Logger.e('GetUserUseCase: Failed to get user $userId', 'GetUserUseCase', result.failure);
        return result;
      }

      Logger.d('GetUserUseCase: Successfully got user ${result.user?.name}', 'GetUserUseCase');
      return result;
    } catch (e) {
      Logger.e('GetUserUseCase: Unexpected error', 'GetUserUseCase', e);
      return (
        failure: Failure.unknown(message: '사용자 정보를 가져오는 중 오류가 발생했습니다'),
        user: null,
      );
    }
  }
}
