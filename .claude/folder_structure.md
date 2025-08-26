# 폴더 구조 가이드

## 📁 lib/ 구조
```
lib/
├── 📁 core/                    # 공통 기능
│   ├── 📁 constants/           # 상수 정의
│   ├── 📁 errors/             # 에러 클래스
│   ├── 📁 network/            # 네트워크 설정
│   ├── 📁 di/                 # 의존성 주입 설정
│   ├── 📁 router/             # 라우터 설정
│   └── 📁 utils/              # 유틸리티 함수
├── 📁 data/                   # 데이터 레이어
│   ├── 📁 datasources/        # 데이터 소스 (remote, local)
│   ├── 📁 models/             # 데이터 모델
│   └── 📁 repositories/       # Repository 구현체
├── 📁 domain/                 # 도메인 레이어
│   ├── 📁 entities/           # 엔티티
│   ├── 📁 repositories/       # Repository 인터페이스
│   └── 📁 usecases/          # Use Case
└── 📁 presentation/           # 프레젠테이션 레이어
    ├── 📁 screens/            # Screen 위젯들
    ├── 📁 fragments/          # Fragment 위젯들
    ├── 📁 views/              # View 위젯들
    ├── 📁 providers/          # Riverpod 프로바이더들
    └── 📁 widgets/            # 공통 위젯들
```

## 파일 명명 규칙

### Screen
- `{feature}_screen.dart`
- 예: `home_screen.dart`, `login_screen.dart`

### Fragment  
- `{feature}_fragment.dart`
- 예: `home_tab_fragment.dart`, `profile_fragment.dart`

### View
- `{feature}_view.dart`
- 예: `user_profile_view.dart`, `product_card_view.dart`

### Provider (State)
- `{feature}_provider.dart`
- 예: `home_provider.dart`, `login_provider.dart`

### UseCase
- `{action}_usecase.dart`
- 예: `get_user_usecase.dart`, `login_usecase.dart`

### Repository
- `{feature}_repository.dart` (인터페이스)
- `{feature}_repository_impl.dart` (구현체)

### Model
- `{feature}_model.dart`
- 예: `user_model.dart`, `product_model.dart`

### Entity
- `{feature}_entity.dart` 
- 예: `user_entity.dart`, `product_entity.dart`

## 코드 구조 예제

### Screen 구조
```dart
class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // Screen은 Scaffold 포함
    );
  }
}
```

### Fragment 구조
```dart
class HomeTabFragment extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fragment는 Screen 내부의 큰 단위 위젯
    return Container();
  }
}
```

### View 구조
```dart
class UserProfileView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // View는 재사용 가능한 작은 단위 위젯
    return Card();
  }
}
```

### Provider 구조
```dart
@riverpod
class HomeNotifier extends _$HomeNotifier {
  @override
  HomeState build() {
    return const HomeState.initial();
  }
  
  // BuildContext 사용 금지!
  // 순수한 dart 클래스만 사용
  // usecase를 통한 데이터 처리만
}
```
