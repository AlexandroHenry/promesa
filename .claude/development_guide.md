# 개발 가이드

## 코드 생성 (Build Runner)

프로젝트에서 사용하는 코드 생성 라이브러리들을 위한 명령어입니다.

### 전체 코드 생성
```bash
flutter packages pub run build_runner build
```

### 기존 생성 파일 삭제 후 재생성
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Watch 모드 (파일 변경시 자동 생성)
```bash
flutter packages pub run build_runner watch
```

### 생성되는 파일들
- `*.g.dart` - JSON 직렬화 (json_serializable)
- `*.freezed.dart` - 불변 클래스 (freezed)
- `*.gr.dart` - 라우터 (auto_route)

## 의존성 설치

새로운 의존성을 추가한 후:
```bash
flutter pub get
```

## Firebase 설정 (향후 사용시)

### 1. Firebase 프로젝트 생성
- Firebase Console에서 새 프로젝트 생성
- Android/iOS 앱 추가

### 2. Firebase CLI 설치 및 설정
```bash
npm install -g firebase-tools
firebase login
dart pub global activate flutterfire_cli
```

### 3. FlutterFire 설정
```bash
flutterfire configure
```

### 4. pubspec.yaml에서 Firebase 의존성 주석 해제
```yaml
# Firebase (for future use) 부분의 주석 제거
firebase_core: ^2.32.0
firebase_auth: ^4.20.0
cloud_firestore: ^4.17.5
```

## 프로젝트 구조 확인

현재 생성된 폴더 구조:
```
lib/
├── core/
│   ├── constants/
│   ├── errors/
│   ├── network/
│   ├── di/
│   ├── router/
│   └── utils/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── screens/
    ├── fragments/
    ├── views/
    ├── providers/
    └── widgets/
```

## 새로운 기능 추가시 순서

1. **Domain 레이어**
   - `entities/` - 엔티티 생성
   - `repositories/` - 리포지토리 인터페이스 생성  
   - `usecases/` - 유스케이스 생성

2. **Data 레이어**
   - `models/` - 데이터 모델 생성
   - `datasources/` - 데이터 소스 생성
   - `repositories/` - 리포지토리 구현체 생성

3. **Presentation 레이어**
   - `providers/` - 상태 관리 프로바이더 생성
   - `screens/` - 화면 위젯 생성
   - `fragments/` - 프래그먼트 위젯 생성 (필요시)
   - `views/` - 뷰 위젯 생성 (필요시)

4. **의존성 주입**
   - `core/di/injection.dart`에 새로운 의존성 등록

5. **라우팅**
   - `core/router/app_router.dart`에 새로운 라우트 추가

## 코딩 규칙 체크리스트

### Provider (State)
- [ ] BuildContext 사용 안함
- [ ] 순수한 Dart 클래스만 사용
- [ ] UseCase를 통한 데이터 처리
- [ ] State 변경만 수행 (직접 데이터 수정 금지)

### Screen
- [ ] Scaffold 포함
- [ ] Provider에서 상태 구독
- [ ] Fragment나 View 조합으로 구성

### Fragment
- [ ] Screen보다 작고 View보다 큰 단위
- [ ] 재사용 가능한 구조

### View  
- [ ] 작은 단위의 재사용 가능한 위젯
- [ ] 데이터를 파라미터로 받음
- [ ] 가능한 Stateless로 구성

## 테스트

### 단위 테스트
```bash
flutter test
```

### 위젯 테스트
```bash
flutter test test/widget_test
```

### 통합 테스트
```bash
flutter test integration_test
```
