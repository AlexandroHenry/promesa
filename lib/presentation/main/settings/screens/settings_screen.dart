import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../core/router/app_router.dart';

/// 설정 화면
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: ListView(
        children: [
          // 계정 설정 섹션
          _buildSectionHeader(context, '계정'),
          _buildSettingsItem(
            context,
            icon: Icons.account_circle,
            title: '계정 설정',
            subtitle: '프로필, 비밀번호 변경',
            onTap: () {
              context.router.push(const AccountSettingsRoute());
            },
          ),
          _buildSettingsItem(
            context,
            icon: Icons.privacy_tip,
            title: '개인정보 설정',
            subtitle: '개인정보 보호 및 데이터 관리',
            onTap: () {
              context.router.push(const PrivacySettingsRoute());
            },
          ),

          const Divider(),

          // 알림 설정 섹션
          _buildSectionHeader(context, '알림'),
          _buildSettingsItem(
            context,
            icon: Icons.notifications,
            title: '알림 설정',
            subtitle: '푸시 알림, 이메일 알림 관리',
            onTap: () {
              context.router.push(const NotificationSettingsRoute());
            },
          ),

          const Divider(),

          // 앱 정보 섹션
          _buildSectionHeader(context, '앱 정보'),
          _buildSettingsItem(
            context,
            icon: Icons.info,
            title: '앱 정보',
            subtitle: '버전 1.0.0',
            onTap: () {
              _showAppInfoDialog(context);
            },
          ),
          _buildSettingsItem(
            context,
            icon: Icons.help,
            title: '도움말',
            subtitle: '자주 묻는 질문',
            onTap: () {
              // 웹뷰로 도움말 페이지 열기 (공유 화면 사용 예시)
              context.router.push(WebViewRoute(url: 'https://flutter.dev/docs', title: '도움말'));
            },
          ),

          const Divider(),

          // 기타
          _buildSettingsItem(
            context,
            icon: Icons.logout,
            title: '로그아웃',
            subtitle: '계정에서 로그아웃',
            onTap: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  /// 섹션 헤더 빌드
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// 설정 아이템 빌드
  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  /// 앱 정보 다이얼로그
  void _showAppInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('앱 정보'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('앱 이름: Your App Name'),
            Text('버전: 1.0.0'),
            Text('빌드: 1'),
            SizedBox(height: 8),
            Text('개발자: Your Company'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('확인')),
        ],
      ),
    );
  }

  /// 로그아웃 확인 다이얼로그
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('정말 로그아웃하시겠습니까?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('취소')),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: 로그아웃 로직 실행
              // 로그인 화면으로 이동하고 스택 완전 클리어
              context.router.replaceAll([const LoginRoute()]);
            },
            child: const Text('로그아웃'),
          ),
        ],
      ),
    );
  }
}
