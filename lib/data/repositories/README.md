// Repository 구현체들이 위치하는 폴더입니다.
//
// 주의사항:
// - Domain 레이어의 Repository 인터페이스를 구현
// - Data Source를 통해 실제 데이터 처리
// - Either<Failure, T> 패턴 사용 (dartz 패키지 사용시)
//
// 예시:
// - user_repository_impl.dart
// - product_repository_impl.dart

/* 예시 구현:

import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, UserEntity>> getUser(int id) async {
    try {
      final userModel = await remoteDataSource.getUser(id);
      return Right(userModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

*/
