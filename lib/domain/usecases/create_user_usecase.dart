import '../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';
import '../../core/utils/logger.dart';

class CreateUserUseCase {
  final UserRepository _repository;

  CreateUserUseCase(this._repository);

  Future<({Failure? failure, UserEntity? user})> call(CreateUserParams params) async {
    Logger.d('CreateUserUseCase: Creating user ${params.name}', 'CreateUserUseCase');
    
    // 입력값 검증
    final validationResult = _validateParams(params);
    if (validationResult != null) {
      return (failure: validationResult, user: null);
    }

    try {
      final result = await _repository.createUser(
        name: params.name,
        email: params.email,
        phone: params.phone,
        address: params.address,
      );

      if (result.failure != null) {
        Logger.e('CreateUserUseCase: Failed to create user', 'CreateUserUseCase', result.failure);
        return result;
      }

      Logger.d('CreateUserUseCase: Successfully created user ${result.user?.name}', 'CreateUserUseCase');
      return result;
    } catch (e) {
      Logger.e('CreateUserUseCase: Unexpected error', 'CreateUserUseCase', e);
      return (
        failure: Failure.unknown(message: '사용자를 생성하는 중 오류가 발생했습니다'),
        user: null,
      );
    }
  }

  // 입력값 검증 메서드
  Failure? _validateParams(CreateUserParams params) {
    // 이름 검증
    if (params.name.trim().isEmpty) {
      return const Failure.validation(message: '이름을 입력해주세요');
    }
    if (params.name.trim().length < 2) {
      return const Failure.validation(message: '이름은 2글자 이상이어야 합니다');
    }
    if (params.name.trim().length > 50) {
      return const Failure.validation(message: '이름은 50글자 이하여야 합니다');
    }

    // 이메일 검증
    if (params.email.trim().isEmpty) {
      return const Failure.validation(message: '이메일을 입력해주세요');
    }
    if (!_isValidEmail(params.email)) {
      return const Failure.validation(message: '올바른 이메일 형식이 아닙니다');
    }

    // 전화번호 검증 (선택적)
    if (params.phone != null && params.phone!.isNotEmpty) {
      if (!_isValidPhoneNumber(params.phone!)) {
        return const Failure.validation(message: '올바른 전화번호 형식이 아닙니다');
      }
    }

    // 주소 검증 (선택적)
    if (params.address != null && params.address!.length > 200) {
      return const Failure.validation(message: '주소는 200글자 이하여야 합니다');
    }

    return null;
  }

  // 이메일 유효성 검사
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email.trim());
  }

  // 전화번호 유효성 검사 (한국 형식)
  bool _isValidPhoneNumber(String phone) {
    final phoneRegex = RegExp(
      r'^01[016789]-?\d{3,4}-?\d{4}$',
    );
    return phoneRegex.hasMatch(phone.replaceAll('-', '').replaceAll(' ', ''));
  }
}

// CreateUser 파라미터 클래스
class CreateUserParams {
  final String name;
  final String email;
  final String? phone;
  final String? address;

  const CreateUserParams({
    required this.name,
    required this.email,
    this.phone,
    this.address,
  });

  // copyWith 메서드
  CreateUserParams copyWith({
    String? name,
    String? email,
    String? phone,
    String? address,
  }) {
    return CreateUserParams(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
    );
  }

  @override
  String toString() {
    return 'CreateUserParams(name: $name, email: $email, phone: $phone, address: $address)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CreateUserParams &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.address == address;
  }

  @override
  int get hashCode {
    return name.hashCode ^ email.hashCode ^ phone.hashCode ^ address.hashCode;
  }
}
