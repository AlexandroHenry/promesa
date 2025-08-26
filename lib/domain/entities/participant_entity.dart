class ParticipantEntity {
  final String id;
  final String name;
  final bool isHost;
  final bool accepted;
  final int lateMinutes;
  final int finePaid;

  const ParticipantEntity({
    required this.id,
    required this.name,
    this.isHost = false,
    this.accepted = true,
    this.lateMinutes = 0,
    this.finePaid = 0,
  });
}


