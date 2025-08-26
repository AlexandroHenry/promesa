// Repository 인터페이스 (추상 클래스)
//
// 주의사항:
// - Data 레이어에서 구현됨
// - UseCase에서 사용됨
// - Either<Failure, T> 패턴 사용 권장
//
// 예시:

/* 
import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/example_entity.dart';

abstract class ExampleRepository {
  Future<Either<Failure, ExampleEntity>> getExample(int id);
  Future<Either<Failure, List<ExampleEntity>>> getExamples();
  Future<Either<Failure, ExampleEntity>> createExample(ExampleEntity entity);
  Future<Either<Failure, ExampleEntity>> updateExample(ExampleEntity entity);
  Future<Either<Failure, void>> deleteExample(int id);
}
*/
