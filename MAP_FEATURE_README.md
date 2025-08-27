# 🗺️ Map Screen with Schedule Markers

지도 화면에서 현재 위치 기준으로 가장 가까운 일정을 마커로 표시하는 기능을 구현했습니다.

## 🚀 구현된 기능

### 1. 스케줄 Mock 데이터 확장
- `assets/mock_data/schedules.json`에 6개의 샘플 스케줄 데이터 추가
- 각 스케줄에는 위치 정보(latitude, longitude), 색상, 참가자, 준비물 등이 포함됨
- 서울 시내 주요 지점들을 기반으로 한 현실적인 위치 데이터

### 2. 위치 서비스
- **LocationService** (`lib/domain/services/location_service.dart`)
  - Haversine formula를 사용한 정확한 거리 계산
  - 현재 위치에서 가장 가까운 스케줄 찾기
  - 거리순으로 스케줄 정렬
  - 거리를 사용자 친화적 형태로 포맷팅 (m/km)

- **LocationPermissionService** (`lib/domain/services/location_permission_service.dart`)
  - 위치 권한 요청 및 상태 확인
  - 현재 위치 가져오기
  - 실시간 위치 업데이트 스트림

### 3. 상태 관리 (Riverpod)
- **MapProvider** (`lib/presentation/main/map/providers/map_provider.dart`)
  - 스케줄 데이터 로딩
  - 현재 위치 관리
  - 가장 가까운 스케줄 계산
  - 지도 마커 생성 및 관리
  - 스케줄 색상별 마커 색상 매핑

### 4. 향상된 Map Screen
- **현재 위치와 가장 가까운 스케줄을 마커로 표시**
- **상단 정보 카드**: 가장 가까운 스케줄 정보와 거리 표시
- **플로팅 액션 버튼들**:
  - 내 위치로 이동
  - 가장 가까운 스케줄로 이동
- **스케줄 상세 바텀시트**: 스케줄을 탭하면 상세 정보 표시

## 📱 사용자 경험

### 초기 로딩
1. 앱 시작 시 위치 권한 요청
2. 현재 위치 획득 후 지도 중심 이동
3. 가장 가까운 스케줄을 자동으로 마커와 정보 카드로 표시

### 인터랙션
- **지도 탭**: 해당 위치를 현재 위치로 설정 (테스트용)
- **정보 카드 탭**: 스케줄 상세 바텀시트 표시
- **내 위치 버튼**: 현재 위치로 지도 이동
- **일정 버튼**: 가장 가까운 스케줄 위치로 지도 이동

### 정보 표시
- **거리 표시**: 미터/킬로미터 단위로 정확한 거리 표시
- **시간 형식**: "오늘", "내일", 요일 등 직관적인 시간 표시
- **참가자 정보**: 호스트 구분, 참가자 수 표시
- **스케줄 색상**: 각 스케줄의 고유 색상으로 마커 구분

## 🛠️ 기술 스택

### 추가된 패키지
```yaml
dependencies:
  geolocator: ^10.1.0           # 위치 서비스
  permission_handler: ^11.3.1   # 권한 관리
  characters: ^1.3.0            # 텍스트 처리
```

### 아키텍처
- **Clean Architecture** 구조 유지
- **Riverpod**을 통한 반응형 상태 관리
- **Provider Pattern**으로 비즈니스 로직 분리
- **Repository Pattern**으로 데이터 레이어 추상화

## 📝 파일 구조

```
lib/
├── domain/
│   ├── services/
│   │   ├── location_service.dart              # 위치 계산 유틸리티
│   │   └── location_permission_service.dart   # 위치 권한 관리
│   └── entities/
│       └── schedule_entity.dart               # 기존 스케줄 엔티티
├── data/
│   └── datasources/
│       └── schedule/
│           └── mock_schedule_datasource.dart  # 기존 Mock 데이터소스
└── presentation/
    └── main/
        └── map/
            ├── screens/
            │   └── map_screen.dart            # 메인 지도 화면
            └── providers/
                └── map_provider.dart          # 지도 상태 관리
```

## 🔧 설정

### Android 권한 (이미 설정됨)
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

### iOS 권한 (이미 설정됨)
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>현재 위치를 지도의 중심으로 표시하기 위해 위치 권한이 필요합니다.</string>
```

## 🧪 테스트 방법

1. **시뮬레이터/에뮬레이터에서**:
   - 지도를 탭해서 현재 위치 변경
   - 다양한 위치에서 가장 가까운 스케줄 확인

2. **실제 기기에서**:
   - 위치 권한 허용
   - 실제 이동하면서 가장 가까운 스케줄 변경 확인

## 🚀 향후 개선 가능사항

1. **실시간 위치 추적**: 사용자 이동 시 자동으로 가장 가까운 스케줄 업데이트
2. **다중 마커**: 반경 내 모든 스케줄을 마커로 표시
3. **경로 안내**: Google Directions API를 통한 길찾기
4. **알림**: 스케줄 장소 근처 도착 시 푸시 알림
5. **오프라인 지도**: 네트워크가 없을 때도 기본 기능 사용 가능