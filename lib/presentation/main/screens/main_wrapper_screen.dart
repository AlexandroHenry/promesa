import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../home/screens/home_screen.dart';
import '../map/screens/map_screen.dart';
import '../search/screens/search_screen.dart';
import '../settings/screens/settings_screen.dart';
import '../../../core/router/app_router.dart';

/// 메인 화면 - Bottom Navigation Bar를 포함
/// 가장 단순한 방식으로 구현
class MainWrapperScreen extends StatefulWidget {
  const MainWrapperScreen({super.key});

  @override
  MainWrapperScreenState createState() => MainWrapperScreenState();
}

class MainWrapperScreenState extends State<MainWrapperScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const MapScreen(),
    const SearchScreen(),
    const _ProfileScreen(),
    const SettingsScreen(),
  ];

  /// 외부에서 탭 변경할 수 있는 메서드
  void changeTab(int index) {
    if (index >= 0 && index < _screens.length) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: changeTab,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: '장소',
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

// 임시 검색 화면
// (삭제됨) 검색 임시 화면

// 임시 프로필 화면
class _ProfileScreen extends StatelessWidget {
  const _ProfileScreen();

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
            CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 50),
            ),
            SizedBox(height: 16),
            Text(
              '사용자 이름',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
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
