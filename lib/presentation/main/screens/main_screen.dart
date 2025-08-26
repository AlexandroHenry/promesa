import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../../core/router/app_router.dart';

/// 메인 화면 - Bottom Navigation Bar를 포함
/// 
/// 주의: 현재는 MainWrapperScreen에서 AutoTabsRouter를 사용하고 있으므로
/// 이 파일은 실제로는 사용되지 않을 수 있습니다.
class MainScreen extends StatelessWidget {
  final Widget child;
  
  const MainScreen({super.key, required this.child});

  /// 현재 선택된 탭 인덱스 계산
  int _calculateSelectedIndex(BuildContext context) {
    try {
      final routeData = context.routeData;
      final routeName = routeData.name;
      
      if (routeName.contains('Home')) return 0;
      if (routeName.contains('Search')) return 1;
      if (routeName.contains('Profile')) return 2;
      if (routeName.contains('Settings')) return 3;
      
      return 0; // 기본값은 Home
    } catch (e) {
      // 에러 발생 시 기본값 반환
      return 0;
    }
  }

  /// 탭 선택 시 처리
  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.router.navigate(const HomeRoute());
        break;
      case 1:
        context.router.navigate(const SearchRoute());
        break;
      case 2:
        context.router.navigate(const ProfileRoute());
        break;
      case 3:
        context.router.navigate(const SettingsRoute());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '검색',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '프로필',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
      ),
    );
  }
}
