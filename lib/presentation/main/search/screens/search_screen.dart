import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('검색')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: '검색어를 입력하세요',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                FocusScope.of(context).unfocus();
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: Text(
                  _controller.text.isEmpty
                      ? '검색 결과가 여기에 표시됩니다'
                      : '"${_controller.text}" 검색 결과 (구현 예정)',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


