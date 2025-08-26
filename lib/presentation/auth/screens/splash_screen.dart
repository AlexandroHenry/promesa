import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import '../../providers/auth_provider.dart';
import '../../../core/router/app_router.dart';
import '../../../core/services/token_service.dart';

/// 앱 시작 시 보여지는 스플래시 화면
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeApp();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
  }

  /// 앱 초기화 로직
  Future<void> _initializeApp() async {
    try {
      // 토큰 서비스 초기화
      await TokenService.instance.init();
      
      // 최소 스플래시 시간 보장
      await Future.delayed(const Duration(seconds: 2));
      
      if (!mounted) return;

      // 첫 실행 여부 확인
      final isFirstLaunch = TokenService.instance.isFirstLaunch();
      
      if (isFirstLaunch) {
        // 첫 실행이면 온보딩 화면으로
        context.router.replaceAll([const OnboardingRoute()]);
        return;
      }

      // 토큰이 있으면 자동 로그인 시도
      final hasTokens = TokenService.instance.hasValidTokens();
      
      if (hasTokens) {
        final loginSuccess = await ref.read(authNotifierProvider.notifier).tryAutoLogin();
        
        if (mounted) {
          if (loginSuccess) {
            // 자동 로그인 성공 → 메인 화면
            context.router.replaceAll([const MainWrapperRoute()]);
          } else {
            // 자동 로그인 실패 → 로그인 화면
            context.router.replaceAll([const LoginRoute()]);
          }
        }
      } else {
        // 토큰 없음 → 로그인 화면
        if (mounted) {
          context.router.replaceAll([const LoginRoute()]);
        }
      }
    } catch (e) {
      // 초기화 실패 시 로그인 화면으로
      if (mounted) {
        context.router.replaceAll([const LoginRoute()]);
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 앱 로고
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.flutter_dash,
                        size: 60,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // 앱 이름
                    Text(
                      'Your App Name',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // 부제목
                    Text(
                      '새로운 경험을 시작하세요',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    
                    const SizedBox(height: 60),
                    
                    // 로딩 인디케이터
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 3,
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // 로딩 텍스트
                    Text(
                      '초기화 중...',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
