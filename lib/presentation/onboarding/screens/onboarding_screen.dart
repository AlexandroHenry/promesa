import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../../core/router/app_router.dart';
import '../../../core/services/token_service.dart';

/// 온보딩 화면
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: '환영합니다!',
      description: '새로운 경험을 시작해보세요.\n간편하고 직관적인 인터페이스로\n모든 것을 관리할 수 있습니다.',
      imageUrl: 'https://picsum.photos/300/300?random=1',
      backgroundColor: Colors.blue.shade50,
    ),
    OnboardingPage(
      title: '쉽고 빠른 관리',
      description: '복잡한 작업들을\n몇 번의 터치만으로\n간단하게 처리하세요.',
      imageUrl: 'https://picsum.photos/300/300?random=2',
      backgroundColor: Colors.green.shade50,
    ),
    OnboardingPage(
      title: '안전한 보안',
      description: '최신 보안 기술로\n소중한 정보를 안전하게\n보호합니다.',
      imageUrl: 'https://picsum.photos/300/300?random=3',
      backgroundColor: Colors.purple.shade50,
    ),
    OnboardingPage(
      title: '지금 시작하세요!',
      description: '모든 준비가 완료되었습니다.\n지금 바로 시작해서\n새로운 경험을 만나보세요.',
      imageUrl: 'https://picsum.photos/300/300?random=4',
      backgroundColor: Colors.orange.shade50,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    // 온보딩 완료 표시
    await TokenService.instance.setFirstLaunchCompleted();
    
    if (mounted) {
      // 로그인 화면으로 이동
      context.router.replaceAll([const LoginRoute()]);
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 상단 Skip 버튼
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 뒤로가기 버튼 (첫 페이지가 아닐 때)
                  if (_currentPage > 0)
                    TextButton(
                      onPressed: _previousPage,
                      child: const Text('이전'),
                    )
                  else
                    const SizedBox(width: 60),
                  
                  // 페이지 인디케이터
                  Row(
                    children: List.generate(
                      _pages.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? Theme.of(context).primaryColor
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),
                  
                  // Skip 버튼 (마지막 페이지가 아닐 때)
                  if (_currentPage < _pages.length - 1)
                    TextButton(
                      onPressed: _skipOnboarding,
                      child: const Text('건너뛰기'),
                    )
                  else
                    const SizedBox(width: 60),
                ],
              ),
            ),
            
            // 페이지 뷰
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Container(
                    color: page.backgroundColor,
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 이미지
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            page.imageUrl,
                            width: 300,
                            height: 300,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 300,
                              height: 300,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                Icons.image,
                                size: 100,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 48),
                        
                        // 제목
                        Text(
                          page.title,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // 설명
                        Text(
                          page.description,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey.shade600,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            
            // 하단 버튼 영역
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: SizedBox(
                width: double.infinity,
                child: _currentPage == _pages.length - 1
                    ? ElevatedButton(
                        onPressed: _completeOnboarding,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          '시작하기',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          '다음',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 온보딩 페이지 데이터 모델
class OnboardingPage {
  final String title;
  final String description;
  final String imageUrl;
  final Color backgroundColor;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.backgroundColor,
  });
}
