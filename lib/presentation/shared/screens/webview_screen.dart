import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

/// 웹뷰 화면 - 다양한 화면에서 접근 가능한 공유 화면
/// 
/// 주의: webview_flutter 패키지가 설치되어 있지 않아 주석 처리됨
/// pubspec.yaml에 webview_flutter: ^4.4.4 추가 후 사용 가능
class WebViewScreen extends StatefulWidget {
  final String url;
  final String? title;
  
  const WebViewScreen({
    super.key,
    required this.url,
    this.title,
  });

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  // WebViewController? controller;
  bool isLoading = true;
  double loadingProgress = 0.0;

  @override
  void initState() {
    super.initState();
    // _initializeWebView();
    
    // 웹뷰가 설치되지 않았으므로 로딩 완료로 설정
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  // void _initializeWebView() {
  //   controller = WebViewController()
  //     ..setJavaScriptMode(JavaScriptMode.unrestricted)
  //     ..setNavigationDelegate(
  //       NavigationDelegate(
  //         onProgress: (int progress) {
  //           setState(() {
  //             loadingProgress = progress / 100.0;
  //           });
  //         },
  //         onPageStarted: (String url) {
  //           setState(() {
  //             isLoading = true;
  //           });
  //         },
  //         onPageFinished: (String url) {
  //           setState(() {
  //             isLoading = false;
  //           });
  //         },
  //         onWebResourceError: (WebResourceError error) {
  //           _showErrorDialog();
  //         },
  //       ),
  //     )
  //     ..loadRequest(Uri.parse(widget.url));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? '웹 페이지'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // controller?.reload();
              _showFeatureNotAvailableDialog();
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'forward':
                  // controller?.goForward();
                  _showFeatureNotAvailableDialog();
                  break;
                case 'back':
                  // controller?.goBack();
                  _showFeatureNotAvailableDialog();
                  break;
                case 'share':
                  _shareUrl();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'back',
                child: Row(
                  children: [
                    Icon(Icons.arrow_back),
                    SizedBox(width: 8),
                    Text('뒤로'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'forward',
                child: Row(
                  children: [
                    Icon(Icons.arrow_forward),
                    SizedBox(width: 8),
                    Text('앞으로'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share),
                    SizedBox(width: 8),
                    Text('공유'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // 로딩 프로그레스 바
          if (isLoading)
            LinearProgressIndicator(
              value: loadingProgress,
              backgroundColor: Colors.grey[200],
            ),
          
          // 웹뷰 대신 안내 메시지
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.web,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'WebView 기능',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'URL: ${widget.url}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'WebView 기능을 사용하려면\npubspec.yaml에 webview_flutter 패키지를 추가하세요.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      _showInstructions();
                    },
                    icon: const Icon(Icons.info),
                    label: const Text('설치 방법'),
                  ),
                ],
              ),
            ),
          ),
          // 실제 웹뷰가 설치되면 이 부분을 사용
          // Expanded(
          //   child: WebViewWidget(
          //     controller: controller!,
          //   ),
          // ),
        ],
      ),
    );
  }

  /// 기능 사용 불가 안내
  void _showFeatureNotAvailableDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('WebView 패키지가 설치되지 않았습니다.'),
      ),
    );
  }

  /// 설치 방법 안내
  void _showInstructions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('WebView 설치 방법'),
        content: const SingleChildScrollView(
          child: Text(
            '1. pubspec.yaml 파일을 엽니다.\n\n'
            '2. dependencies 섹션에 다음을 추가합니다:\n'
            'webview_flutter: ^4.4.4\n\n'
            '3. 터미널에서 다음 명령어를 실행합니다:\n'
            'flutter pub get\n\n'
            '4. 앱을 재시작합니다.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  /// 에러 다이얼로그 표시
  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('페이지 로드 오류'),
        content: const Text('페이지를 로드할 수 없습니다. 인터넷 연결을 확인해주세요.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // 웹뷰 화면도 닫기
            },
            child: const Text('닫기'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // controller?.reload();
            },
            child: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }

  /// URL 공유
  void _shareUrl() {
    // TODO: share_plus 패키지 사용하여 실제 공유 기능 구현
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('URL 공유: ${widget.url}'),
      ),
    );
  }
}
