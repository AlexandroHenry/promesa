// Domain Entities (비즈니스 로직 엔티티)
//
// 주의사항:
// - 순수한 Dart 클래스만 사용 (Flutter 의존성 없음)
// - 불변 객체로 생성 (freezed 사용)
// - Data Model과는 별도로 관리
//
// 예시:

import 'package:freezed_annotation/freezed_annotation.dart';

part 'example_entity.freezed.dart';

@freezed
class ExampleEntity with _$ExampleEntity {
  const factory ExampleEntity({
    required int id,
    required String name,
    String? description,
  }) = _ExampleEntity;
}
