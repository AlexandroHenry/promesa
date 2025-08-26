import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/main/screens/main_wrapper_screen.dart';
import 'package:flutter_app/presentation/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/localization/localization.dart';

/// 홈 화면
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;
    final isAuthenticated = authState.status == AuthStatus.authenticated;

    return Scaffold(
      appBar: AppBar(
        actionsPadding: const EdgeInsets.only(right: 16),
        title: Text(tr(AppTranslations.home)),
        actions: [
          // 로그인 상태에 따른 액션 버튼
          if (isAuthenticated)
            PopupMenuButton<String>(
              onSelected: (value) async {
                switch (value) {
                  case 'profile':
                    // 프로필 화면으로 이동
                    final mainWrapper = context.findAncestorStateOfType<MainWrapperScreenState>();
                    mainWrapper?.changeTab(2);
                    break;
                  case 'logout':
                    await ref.read(authNotifierProvider.notifier).logout();
                    if (context.mounted) {
                      context.router.replaceAll([const LoginRoute()]);
                    }
                    break;
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'profile',
                  child: Row(
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 8),
                      Text(tr(AppTranslations.profile)),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout),
                      SizedBox(width: 8),
                      Text(tr(AppTranslations.logout)),
                    ],
                  ),
                ),
              ],
              child: CircleAvatar(
                backgroundImage: user?.profileImageUrl != null
                    ? NetworkImage(user!.profileImageUrl!)
                    : null,
                child: user?.profileImageUrl == null
                    ? Text(
                        user?.name.substring(0, 1).toUpperCase() ?? 'G',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    : null,
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.login),
              onPressed: () {
                context.router.push(const LoginRoute());
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 환영 메시지
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 인사말
                    if (isAuthenticated && user != null) ...[
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: user.profileImageUrl != null
                                ? NetworkImage(user.profileImageUrl!)
                                : null,
                            child: user.profileImageUrl == null
                                ? Text(
                                    user.name.substring(0, 1).toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tr(AppTranslations.welcome, namedArgs: {'name': user.name}),
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  user.email,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        tr(AppTranslations.haveNiceDay),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ] else ...[
                      Text(
                        tr(AppTranslations.welcomeGuest),
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tr(AppTranslations.loginPrompt),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context.router.push(const LoginRoute());
                          },
                          icon: const Icon(Icons.login),
                          label: Text(tr(AppTranslations.loginButton)),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // 퀵 액션 버튼들
            Text(
              tr(AppTranslations.quickActions),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  // 홈 상세 화면으로 이동
                  _QuickActionCard(
                    icon: Icons.info,
                    title: tr(AppTranslations.detailInfo),
                    subtitle: tr(AppTranslations.detailInfoSubtitle),
                    onTap: () {
                      context.router.push(const HomeDetailRoute());
                    },
                  ),
                  
                  // 웹뷰 화면으로 이동 (공유 화면 예시)
                  _QuickActionCard(
                    icon: Icons.web,
                    title: tr(AppTranslations.webPage),
                    subtitle: tr(AppTranslations.webPageSubtitle),
                    onTap: () {
                      context.router.push(WebViewRoute(
                        url: 'https://flutter.dev',
                        title: 'Flutter',
                      ));
                    },
                  ),
                  
                  // 프로필로 이동 (로그인 상태에 따라 다르게)
                  _QuickActionCard(
                    icon: Icons.person,
                    title: isAuthenticated 
                        ? tr(AppTranslations.profileAction) 
                        : tr(AppTranslations.loginAction),
                    subtitle: isAuthenticated 
                        ? tr(AppTranslations.profileActionSubtitle) 
                        : tr(AppTranslations.loginActionSubtitle),
                    onTap: () {
                      if (isAuthenticated) {
                        // MainWrapper의 탭 변경
                        final mainWrapper = context.findAncestorStateOfType<MainWrapperScreenState>();
                        mainWrapper?.changeTab(2);
                      } else {
                        context.router.push(const LoginRoute());
                      }
                    },
                  ),
                  
                  // 설정으로 이동
                  _QuickActionCard(
                    icon: Icons.settings,
                    title: tr(AppTranslations.settingsAction),
                    subtitle: tr(AppTranslations.settingsActionSubtitle),
                    onTap: () {
                      // MainWrapper의 탭 변경
                      final mainWrapper = context.findAncestorStateOfType<MainWrapperScreenState>();
                      mainWrapper?.changeTab(3);
                    },
                  ),
                  
                  // 이미지 뷰어
                  _QuickActionCard(
                    icon: Icons.image,
                    title: tr(AppTranslations.imageViewer),
                    subtitle: tr(AppTranslations.imageViewerSubtitle),
                    onTap: () {
                      context.router.push(ImageViewerRoute(
                        imageUrl: 'https://picsum.photos/800/600',
                      ));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 퀵 액션 카드 위젯
class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
