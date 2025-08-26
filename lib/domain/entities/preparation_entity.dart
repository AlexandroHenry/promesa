class PreparationEntity {
  final String name;
  // 비어있으면 전체(ALL) 의미. 하나 이상이면 해당 유저들이 준비.
  final List<String> assignedToUserIds;

  const PreparationEntity({
    required this.name,
    this.assignedToUserIds = const [],
  });
}


