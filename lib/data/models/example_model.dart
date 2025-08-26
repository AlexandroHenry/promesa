// Data Models (JSON 직렬화/역직렬화를 위한 모델)
//
// 주의사항:
// - freezed와 json_serializable을 사용하여 생성
// - API 응답 구조와 정확히 일치해야 함
// - Domain Entity와는 별도로 관리
//
// 예시 파일명:
// - user_model.dart
// - product_model.dart
// - response_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'example_model.freezed.dart';
part 'example_model.g.dart';

@freezed
class ExampleModel with _$ExampleModel {
  const factory ExampleModel({
    required int id,
    required String name,
    String? description,
  }) = _ExampleModel;

  factory ExampleModel.fromJson(Map<String, dynamic> json) =>
      _$ExampleModelFromJson(json);
}
