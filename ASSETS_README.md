# Assets Management with Spider

이 프로젝트는 Spider를 사용하여 타입 안전한 에셋 관리를 구현합니다.

## 📁 폴더 구조

```
assets/
├── icons/              # SVG/PNG 아이콘들
│   ├── menu.svg
│   ├── user.svg
│   └── warning.svg
├── images/             # 일반 이미지들
│   ├── profile_placeholder.png
│   └── background.jpg
├── illustrations/      # 일러스트레이션
│   ├── onboarding_1.svg
│   └── success.svg
├── logos/              # 로고들
│   └── app_logo.svg
└── translations/       # 번역 파일들
    ├── en.json
    └── ko.json
```

## 🚀 사용법

### 1. 에셋 파일 추가

적절한 폴더에 에셋 파일을 추가합니다:

```bash
# 아이콘 추가
assets/icons/home.svg
assets/icons/settings.png

# 이미지 추가  
assets/images/splash_bg.jpg
assets/images/avatar_default.png

# 로고 추가
assets/logos/company_logo.svg
```

### 2. Spider 코드 생성

```bash
# Mac/Linux
./scripts/generate_assets.sh

# Windows
scripts\generate_assets.bat

# 또는 직접 실행
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### 3. 생성된 코드 사용

```dart
import 'package:flutter_app/core/assets/assets_barrel.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // SVG 아이콘
        Assets.iconsHome.toSvgIcon(
          size: 24,
          color: Colors.blue,
        ),
        
        // 일반 이미지
        Assets.imagesProfile.toImage(
          width: 100,
          height: 100,
        ),
        
        // 네트워크 이미지 + 폴백
        AssetHelper.getNetworkImageWithAssetFallback(
          user.avatarUrl,
          Assets.imagesAvatarDefault,
          width: 50,
          height: 50,
        ),
        
        // 원형 이미지
        Assets.imagesProfile.toCircularImage(radius: 25),
        
        // 색상이 적용된 SVG
        Assets.iconsWarning.toTintedSvg(
          Colors.orange,
          width: 32,
          height: 32,
        ),
      ],
    );
  }
}
```

## 🔧 Spider 설정

Spider는 `build.yaml` 파일에서 설정됩니다:

```yaml
targets:
  $default:
    builders:
      spider:
        options:
          class_name: "Assets"
          file_name: "core/assets/assets.dart"
          assets_path: "assets"
          package: "flutter_app"
          use_svg: true
          use_sort: true
          groups:
            - path: "icons"
              class_name: "AppIcons"
            - path: "images"
              class_name: "AppImages"
```

## 📝 생성되는 코드 예시

Spider가 생성하는 코드:

```dart
// lib/core/assets/assets.dart
class Assets {
  // Icons
  static const String iconsHome = 'assets/icons/home.svg';
  static const String iconsMenu = 'assets/icons/menu.svg';
  static const String iconsUser = 'assets/icons/user.svg';
  
  // Images
  static const String imagesProfile = 'assets/images/profile.png';
  static const String imagesSplash = 'assets/images/splash_bg.jpg';
  
  // Logos
  static const String logosApp = 'assets/logos/app_logo.svg';
}

class AppIcons {
  static const String home = 'assets/icons/home.svg';
  static const String menu = 'assets/icons/menu.svg';
  static const String user = 'assets/icons/user.svg';
}
```

## 🎨 헬퍼 유틸리티들

### AssetHelper

```dart
// 에셋 존재 확인
bool exists = await 'assets/icons/user.svg'.assetExists();

// 문자열로 로드
String jsonContent = await 'assets/data/config.json'.loadAsString();

// 에러 처리가 포함된 이미지 위젯
Widget image = AssetHelper.getImage(
  'assets/images/profile.png',
  width: 100,
  height: 100,
  errorWidget: Icon(Icons.person), // 커스텀 에러 위젯
);
```

### SvgAssetHelper

```dart
// SVG 아이콘
Widget icon = SvgAssetHelper.getSvgIcon(
  'assets/icons/home.svg',
  size: 24,
  color: Colors.blue,
);

// 색상이 적용된 SVG
Widget tintedSvg = SvgAssetHelper.getTintedSvg(
  'assets/icons/warning.svg',
  Colors.red,
  width: 32,
  height: 32,
);
```

## 🔄 개발 워크플로우

### 1. 에셋 추가 시

```bash
# 1. 에셋 파일 추가
cp new_icon.svg assets/icons/

# 2. Spider 재실행
./scripts/generate_assets.sh

# 3. Hot Restart (Hot Reload로는 새 에셋이 반영되지 않음)
flutter hot restart
```

### 2. 자동화된 워크플로우

VS Code에서 단축키로 실행하려면 `.vscode/tasks.json` 추가:

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Generate Assets",
      "type": "shell",
      "command": "./scripts/generate_assets.sh",
      "group": "build",
      "presentation": {
        "echo": true,
        "reveal": "always",
        "focus": false,
        "panel": "shared"
      }
    }
  ]
}
```

## 📋 베스트 프랙티스

### 1. 파일 네이밍

- **소문자 + 언더스코어**: `home_icon.svg`, `profile_image.png`
- **의미있는 이름**: `user_avatar.png` (❌ `img001.png`)
- **크기 명시**: `logo_small.svg`, `banner_large.jpg`

### 2. 폴더 구조

```
assets/
├── icons/
│   ├── navigation/    # 네비게이션 아이콘들
│   ├── actions/       # 액션 버튼 아이콘들
│   └── status/        # 상태 표시 아이콘들
├── images/
│   ├── backgrounds/   # 배경 이미지들
│   ├── placeholders/  # 플레이스홀더 이미지들
│   └── avatars/       # 아바타 이미지들
└── illustrations/
    ├── onboarding/    # 온보딩 일러스트
    └── empty_states/  # 빈 상태 일러스트
```

### 3. 이미지 최적화

```bash
# SVG 최적화
npx svgo assets/icons/*.svg

# PNG 최적화
optipng assets/images/*.png

# WebP 변환
cwebp assets/images/*.jpg -o assets/images/*.webp
```

## 🐛 문제 해결

### 1. Assets가 생성되지 않는 경우

```bash
# 캐시 정리 후 재시도
flutter clean
flutter pub get
flutter packages pub run build_runner clean
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### 2. Hot Reload에서 새 에셋이 보이지 않는 경우

- **Hot Restart** 사용 (Hot Reload로는 새 에셋 인식 안됨)
- pubspec.yaml의 assets 섹션 확인

### 3. SVG가 표시되지 않는 경우

- `flutter_svg` 패키지 설치 확인
- SVG 파일의 유효성 검사
- `use_svg: true` 설정 확인

### 4. 타입 에러가 발생하는 경우

```dart
// ❌ 잘못된 사용
Assets.iconsHome.toImage() // SVG를 Image로 사용

// ✅ 올바른 사용  
Assets.iconsHome.toSvgIcon() // SVG를 SVG로 사용
Assets.imagesProfile.toImage() // PNG/JPG를 Image로 사용
```

## 📊 성능 고려사항

### 1. 이미지 크기 최적화

- **아이콘**: 24x24, 32x32 등 표준 크기 사용
- **이미지**: 실제 표시 크기의 2배 해상도로 제한
- **WebP**: 지원 가능한 경우 WebP 형식 사용

### 2. 메모리 관리

```dart
// 큰 이미지의 경우 명시적 크기 지정
Assets.imagesLarge.toImage(
  width: 200, // 실제 표시 크기로 제한
  height: 150,
  fit: BoxFit.cover,
)
```

---

이제 완전한 타입 안전한 에셋 관리 시스템이 구축되었습니다! 🎉

Spider를 실행하려면:
```bash
./scripts/generate_assets.sh
```