import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

// Domain entities
import '../../domain/entities/schedule_entity.dart';

// Auth Screens
import '../../presentation/auth/screens/splash_screen.dart';
import '../../presentation/auth/screens/login_screen.dart';
import '../../presentation/onboarding/screens/onboarding_screen.dart';

// Main Screens
import '../../presentation/main/screens/main_wrapper_screen.dart';
import '../../presentation/main/home/screens/home_screen.dart';
import '../../presentation/main/settings/screens/settings_screen.dart';
import '../../presentation/main/map/screens/map_screen.dart';
import '../../presentation/main/settings/screens/notification_settings_screen.dart';

// Shared Screens
import '../../presentation/shared/screens/webview_screen.dart';
// Schedule Screens
import '../../presentation/schedule/add/add_schedule_screen.dart';
import '../../presentation/schedule/detail/schedule_detail_screen.dart';
import '../../presentation/schedule/edit/edit_schedule_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
    // ==================== Auth Routes ====================
    AutoRoute(page: SplashRoute.page, path: '/', initial: true),

    AutoRoute(page: OnboardingRoute.page, path: '/onboarding'),

    AutoRoute(page: LoginRoute.page, path: '/login'),

    // ==================== Main Routes ====================
    AutoRoute(page: MainWrapperRoute.page, path: '/main'),

    // ==================== Tab Routes ====================
    AutoRoute(page: HomeRoute.page, path: '/home'),

    AutoRoute(page: SearchRoute.page, path: '/search'),

    AutoRoute(page: MapRoute.page, path: '/map'),

    AutoRoute(page: ProfileRoute.page, path: '/profile'),

    AutoRoute(page: SettingsRoute.page, path: '/settings'),

    // ==================== Sub Routes ====================
    AutoRoute(page: HomeDetailRoute.page, path: '/home-detail'),

    AutoRoute(page: ProfileEditRoute.page, path: '/profile-edit'),

    AutoRoute(page: NotificationSettingsRoute.page, path: '/notification-settings'),

    AutoRoute(page: PrivacySettingsRoute.page, path: '/privacy-settings'),

    AutoRoute(page: AccountSettingsRoute.page, path: '/account-settings'),

    // ==================== Shared Routes ====================
    AutoRoute(page: WebViewRoute.page, path: '/webview'),

    AutoRoute(page: ImageViewerRoute.page, path: '/image-viewer'),

    // ==================== Schedule Routes ====================
    AutoRoute(page: AddScheduleRoute.page, path: '/add-schedule'),
    AutoRoute(page: ScheduleDetailRoute.page, path: '/schedule-detail'),
    AutoRoute(page: EditScheduleRoute.page, path: '/edit-schedule'),
  ];
}

// ==================== Route Pages ====================

// Auth Pages
@RoutePage()
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}

@RoutePage()
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingScreen();
  }
}

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginScreen();
  }
}

// Main Wrapper Page
@RoutePage()
class MainWrapperPage extends StatelessWidget {
  const MainWrapperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainWrapperScreen();
  }
}

// Tab Pages
@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}

@RoutePage()
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('검색')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.search, size: 64), SizedBox(height: 16), Text('검색 화면 (구현 예정)')],
        ),
      ),
    );
  }
}

@RoutePage()
class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MapScreen();
  }
}

@RoutePage()
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.router.push(const ProfileEditRoute());
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
            SizedBox(height: 16),
            Text('사용자 이름', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('user@example.com'),
            SizedBox(height: 16),
            Text('프로필 화면 (구현 예정)'),
          ],
        ),
      ),
    );
  }
}

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsScreen();
  }
}

// Sub Pages
@RoutePage()
class HomeDetailPage extends StatelessWidget {
  const HomeDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('홈 상세')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.info, size: 64), SizedBox(height: 16), Text('홈 상세 화면 (구현 예정)')],
        ),
      ),
    );
  }
}

@RoutePage()
class ProfileEditPage extends StatelessWidget {
  const ProfileEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필 편집'),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('저장되었습니다')));
              context.router.pop();
            },
            child: const Text('저장'),
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.edit, size: 64), SizedBox(height: 16), Text('프로필 편집 화면 (구현 예정)')],
        ),
      ),
    );
  }
}

@RoutePage()
class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const NotificationSettingsScreen();
  }
}

@RoutePage()
class PrivacySettingsPage extends StatelessWidget {
  const PrivacySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('개인정보 설정')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.privacy_tip, size: 64),
            SizedBox(height: 16),
            Text('개인정보 설정 화면 (구현 예정)'),
          ],
        ),
      ),
    );
  }
}

@RoutePage()
class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('계정 설정')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_circle, size: 64),
            SizedBox(height: 16),
            Text('계정 설정 화면 (구현 예정)'),
          ],
        ),
      ),
    );
  }
}

// Shared Pages
@RoutePage()
class WebViewPage extends StatelessWidget {
  final String? url;
  final String? title;

  const WebViewPage({super.key, this.url, this.title});

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('오류')),
        body: const Center(child: Text('잘못된 URL입니다.')),
      );
    }

    return WebViewScreen(url: url!, title: title);
  }
}

@RoutePage()
class ImageViewerPage extends StatelessWidget {
  final String? imageUrl;

  const ImageViewerPage({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('이미지 뷰어'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? Image.network(
                imageUrl!,
                errorBuilder: (context, error, stackTrace) =>
                    const Text('이미지를 불러올 수 없습니다', style: TextStyle(color: Colors.white)),
              )
            : const Text('잘못된 이미지 URL입니다', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

// Schedule Pages
@RoutePage()
class AddSchedulePage extends StatelessWidget {
  const AddSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AddScheduleScreen();
  }
}

// Schedule Pages
@RoutePage()
class AddSchedulePage extends StatelessWidget {
  const AddSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AddScheduleScreen();
  }
}

// Wrapper pages are unnecessary; the routed pages are defined in their own files.
