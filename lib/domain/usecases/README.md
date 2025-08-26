// Use Cases (비즈니스 로직 처리)
//
// 주의사항:
// - 하나의 UseCase는 하나의 기능만 담당
// - Repository를 통해 데이터 처리
// - Provider에서 사용됨
//
// 예시:

/*
import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/example_entity.dart';
import '../repositories/example_repository.dart';

class GetExampleUseCase {
  final ExampleRepository repository;

  GetExampleUseCase(this.repository);

  Future<Either<Failure, ExampleEntity>> call(int id) async {
    return await repository.getExample(id);
  }
}

// 또는 파라미터가 복잡한 경우
class CreateExampleUseCase {
  final ExampleRepository repository;

  CreateExampleUseCase(this.repository);

  Future<Either<Failure, ExampleEntity>> call(CreateExampleParams params) async {
    return await repository.createExample(params.toEntity());
  }
}

class CreateExampleParams {
  final String name;
  final String? description;

  CreateExampleParams({
    required this.name,
    this.description,
  });

  ExampleEntity toEntity() => ExampleEntity(
    id: 0, // 서버에서 생성
    name: name,
    description: description,
  );
}
*/
