# Localization Setup Guide

이 프로젝트는 `easy_localization` 패키지를 사용하여 다국어 지원을 구현합니다.

## 📁 파일 구조

```
lib/
├── core/
│   └── localization/
│       ├── app_locales.dart          # 지원하는 언어 상수
│       ├── localization_service.dart # 언어 변경 서비스  
│       ├── translation_keys.dart     # 번역 키 상수
│       └── localization.dart         # 인덱스 파일
├── data/
│   └── services/
│       └── remote_language_service.dart # API/IP 기반 언어 변경
├── presentation/
│   ├── widgets/common/
│   │   └── language_selector.dart    # 언어 선택 위젯
│   └── shared/
│       └── localization_example_page.dart # 사용 예제
└── assets/
    └── translations/
        ├── en.json                   # 영어 번역
        └── ko.json                   # 한국어 번역
```

## 🚀 설정 방법

### 1. Dependencies 설치

```bash
flutter pub get
```

### 2. 번역 파일 경로 확인

`assets/translations/` 폴더에 다음 파일들이 있는지 확인:
- `en.json` (영어)
- `ko.json` (한국어)

### 3. 기본 사용법

#### 앱에서 번역 사용하기

```dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app/core/localization/localization.dart';

// 방법 1: easy_localization 기본 방식
Text('common.ok'.tr())

// 방법 2: 타입 안전한 키 사용 (권장)
Text(AppTranslations.ok.tr())

// 매개변수가 있는 번역
Text('welcome_message'.tr(namedArgs: {'name': 'John'}))

// 복수형 번역  
Text('items_count'.plural(5))
```

#### 언어 변경

```dart
// 수동 언어 변경
await LocalizationService.changeLocale(
  context, 
  AppLocales.ko,
  source: LocalizationService.LocaleSource.manual,
);

// API에서 받은 언어로 변경
await LocalizationService.setLocaleFromAPI(context, 'ko');

// IP 기반 언어 변경
await LocalizationService.setLocaleFromIP(context, 'KR');

// 시스템 언어로 재설정
await LocalizationService.resetToSystemLocale(context);
```

## 🛠️ 고급 사용법

### API를 통한 언어 변경

```dart
import 'package:flutter_app/data/services/remote_language_service.dart';

// API에서 사용자 언어 설정 가져오기
await remoteLanguageService.fetchAndSetUserLanguage(context, userId);

// API에 언어 설정 업데이트
await remoteLanguageService.updateUserLanguage(userId, 'ko');

// IP 주소로 언어 감지
await remoteLanguageService.detectAndSetLanguageFromIP(context);
```

### 위젯에서 언어 변경

```dart
// 간단한 토글 버튼
const LanguageToggle()

// 드롭다운 선택기
const LanguageSelector() 

// 바텀시트
LanguageSelectionBottomSheet.show(context)
```

## 🌍 새 언어 추가하기

### 1. 번역 파일 추가

`assets/translations/` 폴더에 새 언어 파일 생성:
```
assets/translations/ja.json  # 일본어 예시
```

### 2. AppLocales 업데이트

```dart
// lib/core/localization/app_locales.dart
class AppLocales {
  static const Locale ja = Locale('ja');  // 일본어 추가
  
  static const List<Locale> supportedLocales = [
    en,
    ko,
    ja,  // 새 언어 추가
  ];

  static String getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'en': return 'English';
      case 'ko': return '한국어';
      case 'ja': return '日本語';  // 새 언어 이름 추가
      default:
        return locale.languageCode;
    }
  }

  static Locale? fromLanguageCode(String languageCode) {
    switch (languageCode.toLowerCase()) {
      case 'en': return en;
      case 'ko': return ko;
      case 'ja': return ja;  // 새 언어 추가
      default: return null;
    }
  }
}
```

### 3. pubspec.yaml에서 번역 경로 확인

```yaml
flutter:
  assets:
    - assets/translations/
```

## 🔧 언어 변경 소스 추적

앱은 언어가 어떤 방식으로 설정되었는지 추적합니다:

- `LocaleSource.system`: 시스템/기기 언어
- `LocaleSource.api`: API 응답에서
- `LocaleSource.ip`: IP 기반 감지
- `LocaleSource.manual`: 사용자가 수동으로 변경

## 📱 실제 사용 예시

### 앱 시작 시 언어 초기화

```dart
// main.dart에서 자동으로 처리됨
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  
  // 저장된 언어 설정이나 시스템 언어 사용
  final initialLocale = await LocalizationService.initializeLocale();
  
  runApp(
    EasyLocalization(
      supportedLocales: AppLocales.supportedLocales,
      path: 'assets/translations',
      fallbackLocale: AppLocales.fallbackLocale,
      startLocale: initialLocale,
      child: MyApp(),
    ),
  );
}
```

### 사용자 로그인 후 API에서 언어 가져오기

```dart
class AuthService {
  Future<void> loginUser(String email, String password) async {
    // 로그인 로직...
    
    // 로그인 성공 후 사용자의 언어 설정 적용
    await remoteLanguageService.fetchAndSetUserLanguage(context, userId);
  }
}
```

### 설정 페이지에서 언어 변경

```dart
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppTranslations.settings.tr()),
        actions: const [LanguageSelector()],
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(AppTranslations.settings.tr()),
            subtitle: Text(LocalizationService.getCurrentLocaleDisplayName(context)),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => LanguageSelectionBottomSheet.show(context),
          ),
        ],
      ),
    );
  }
}
```

## 🎯 번역 키 관리 베스트 프랙티스

### 1. 구조화된 키 사용

```json
{
  "auth": {
    "login": "로그인",
    "register": "회원가입"
  },
  "common": {
    "ok": "확인",
    "cancel": "취소"
  }
}
```

### 2. 타입 안전한 키 상수 사용

```dart
// ❌ 피해야 할 방식 (오타 가능성)
Text('auth.login'.tr())

// ✅ 권장 방식 (IDE 자동완성 + 오타 방지)
Text(AppTranslations.login.tr())
```

### 3. 매개변수가 있는 번역

```json
{
  "welcome": "안녕하세요, {name}님!",
  "items_found": "{count}개의 항목을 찾았습니다"
}
```

```dart
Text('welcome'.tr(namedArgs: {'name': userName}))
Text('items_found'.tr(namedArgs: {'count': itemCount.toString()}))
```

## 🐛 문제 해결

### 1. 번역이 나타나지 않는 경우

- `pubspec.yaml`에서 `assets/translations/` 경로 확인
- `flutter clean && flutter pub get` 실행
- 번역 파일의 JSON 형식이 올바른지 확인

### 2. 언어가 변경되지 않는 경우

- `context.setLocale()` 대신 `LocalizationService.changeLocale()` 사용
- 위젯이 `EasyLocalization`으로 래핑되어 있는지 확인
- 앱을 완전히 재시작해보기

### 3. 빌드 에러가 발생하는 경우

```bash
# 캐시 정리
flutter clean
flutter pub get

# 코드 생성 (필요한 경우)
flutter packages pub run build_runner build
```

## 📋 체크리스트

프로젝트에 다국어 지원을 완전히 설정했는지 확인:

- [x] `easy_localization` 패키지 추가
- [x] 번역 파일 (`en.json`, `ko.json`) 생성
- [x] `AppLocales` 클래스 설정
- [x] `LocalizationService` 설정
- [x] `main.dart`에서 `EasyLocalization` 래핑
- [ ] 앱에서 `.tr()` 사용하여 번역 적용
- [x] 언어 변경 위젯 추가
- [x] API/IP 기반 언어 변경 서비스 (선택사항)

## 🚀 다음 단계

1. **번역 자동화**: Crowdin, Lokalise 등의 번역 관리 도구 연동
2. **더 많은 언어 지원**: 필요에 따라 추가 언어 지원
3. **복수형 처리**: 복잡한 복수형 규칙이 있는 언어 지원
4. **RTL 지원**: 아랍어, 히브리어 등 우-좌 쓰기 언어 지원
5. **번역 검증**: 번역 누락이나 오타 감지 자동화

---

이제 프로젝트에서 완전한 다국어 지원을 사용할 수 있습니다! 🎉