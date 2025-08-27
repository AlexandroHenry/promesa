enum LateFineType {
  perMinute,   // 분당
  perHour,     // 시간당
  fixed,       // 전체 고정금액
}

class LateFineEntity {
  final LateFineType type;
  final int amount;        // 벌금 금액
  final int? interval;     // 분당/시간당일 때 간격 (예: 5분당, 1시간당)

  const LateFineEntity({
    required this.type,
    required this.amount,
    this.interval,
  });

  /// 지연 시간(분)에 따른 벌금 계산
  int calculateFine(int lateMinutes) {
    switch (type) {
      case LateFineType.perMinute:
        if (interval == null || interval! <= 0) return 0;
        final units = (lateMinutes / interval!).ceil();
        return units * amount;
      
      case LateFineType.perHour:
        if (interval == null || interval! <= 0) return 0;
        final lateHours = lateMinutes / 60;
        final units = (lateHours / interval!).ceil();
        return units * amount;
      
      case LateFineType.fixed:
        return lateMinutes > 0 ? amount : 0;
    }
  }

  /// 벌금 정책을 사용자 친화적 문자열로 변환
  String getDisplayText() {
    switch (type) {
      case LateFineType.perMinute:
        return '${interval}분당 ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원';
      
      case LateFineType.perHour:
        return '${interval}시간당 ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원';
      
      case LateFineType.fixed:
        return '지각 시 ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.index,
      'amount': amount,
      'interval': interval,
    };
  }

  factory LateFineEntity.fromJson(Map<String, dynamic> json) {
    return LateFineEntity(
      type: LateFineType.values[json['type'] as int? ?? 2],
      amount: json['amount'] as int? ?? 0,
      interval: json['interval'] as int?,
    );
  }
}