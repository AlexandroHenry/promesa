# 💰 Enhanced Fine System for Schedule Management

스케줄 추가 시 다양한 벌금 타입을 설정할 수 있는 고급 벌금 시스템을 구현했습니다.

## 🚀 새로 추가된 기능

### 1. 🎯 다양한 벌금 타입
- **전체 고정금액**: 지각하면 고정 금액 (기존 방식)
- **분당 벌금**: 지정한 분마다 벌금 추가 (예: 5분당 1,000원)
- **시간당 벌금**: 지정한 시간마다 벌금 추가 (예: 1시간당 10,000원)

### 2. 🔧 향상된 사용자 경험
- **실시간 미리보기**: 벌금 설정 변경 시 즉시 미리보기 표시
- **직관적인 UI**: 라디오 버튼으로 벌금 타입 선택
- **스마트 입력**: 벌금 타입에 따라 필요한 필드만 표시
- **친구 선택 개선**: 체크마크가 실시간으로 업데이트

### 3. 📊 Mock 데이터 저장
- **자동 저장**: 스케줄 생성 시 Mock 데이터에 자동 추가
- **영구 보존**: 앱 재시작 후에도 생성한 스케줄 유지
- **호환성**: 기존 스케줄과 새로운 벌금 시스템 모두 지원

## 🎨 UI 개선사항

### 벌금 설정 섹션
```
📍 지각 벌금
○ 전체 고정금액 - 지각하면 고정 금액
● 분당 벌금 - 지정한 분마다 벌금 추가  
○ 시간당 벌금 - 지정한 시간마다 벌금 추가

[분 간격: 5] [벌금 금액: 1000원]
5분당

ℹ️ 5분당 1,000원
```

### 친구 선택 개선
- StatefulBuilder 사용으로 모달 내 상태 실시간 업데이트
- 체크마크 동기화 문제 해결
- 메인 화면과 모달 간 상태 동기화

### 지도 화면 벌금 표시
- 스케줄 상세 바텀시트에 벌금 정보 표시
- 새로운 벌금 시스템과 기존 시스템 모두 지원

## 💡 벌금 계산 로직

### 분당 벌금 (LateFineType.perMinute)
```dart
// 5분당 1,000원, 12분 지각
final units = (12 / 5).ceil(); // 3 단위
final fine = 3 * 1000; // 3,000원
```

### 시간당 벌금 (LateFineType.perHour)
```dart
// 1시간당 5,000원, 90분 지각
final lateHours = 90 / 60; // 1.5시간
final units = (1.5 / 1).ceil(); // 2 단위
final fine = 2 * 5000; // 10,000원
```

### 고정 벌금 (LateFineType.fixed)
```dart
// 지각 시 5,000원
final fine = lateMinutes > 0 ? 5000 : 0;
```

## 🗂️ 데이터 구조

### LateFineEntity
```dart
class LateFineEntity {
  final LateFineType type;     // 벌금 타입
  final int amount;            // 벌금 금액
  final int? interval;         // 간격 (분/시간)
  
  // 지연 시간에 따른 벌금 계산
  int calculateFine(int lateMinutes);
  
  // 사용자 친화적 문자열 변환
  String getDisplayText();
}
```

### Mock 데이터 예시
```json
{
  "id": "s4",
  "title": "클라이언트 미팅",
  "lateFineAmount": 15000,
  "lateFine": {
    "type": 0,        // 0: perMinute, 1: perHour, 2: fixed
    "amount": 2000,   // 벌금 금액
    "interval": 5     // 5분당
  }
}
```

## 🔄 기존 시스템과의 호환성

- `lateFineAmount`: 기존 고정 벌금 (호환성 유지)
- `lateFine`: 새로운 벌금 시스템 (우선 적용)
- 두 시스템 모두 지원하여 점진적 마이그레이션 가능

## 📱 사용 방법

1. **스케줄 생성**: AddScheduleScreen에서 새 스케줄 생성
2. **벌금 타입 선택**: 라디오 버튼으로 원하는 벌금 타입 선택
3. **금액/간격 설정**: 벌금 금액과 간격 입력
4. **실시간 미리보기**: 설정된 벌금 정보 확인
5. **친구 선택**: 개선된 UI로 참가자 선택
6. **저장**: 스케줄이 Mock 데이터에 자동 저장
7. **지도 확인**: MapScreen에서 생성된 스케줄 마커 확인

## 🛠️ 기술적 개선사항

### Architecture Layer 업데이트
- **Domain**: LateFineEntity 추가
- **Data**: MockScheduleDataSource 확장
- **Presentation**: UI 구성요소 개선

### 상태 관리
- StatefulBuilder로 모달 상태 관리
- 텍스트 필드 리스너로 실시간 업데이트
- Riverpod을 통한 전역 상태 관리

### 데이터 흐름
```
UI Input → LateFineEntity → Repository → DataSource → Mock JSON
```

모든 기능이 완벽하게 구현되어 바로 사용할 수 있습니다! 🎯