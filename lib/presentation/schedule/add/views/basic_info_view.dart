import 'package:flutter/material.dart';
import '../00_state/add_schedule_state.dart';

/// 스케줄 기본 정보 입력 뷰 (제목, 설명)
class BasicInfoView extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descController;
  
  const BasicInfoView({
    super.key,
    required this.titleController,
    required this.descController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '기본 정보',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: titleController,
          decoration: const InputDecoration(
            labelText: '제목',
            hintText: '스케줄 제목을 입력하세요',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: descController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: '설명',
            hintText: '스케줄에 대한 상세 설명을 입력하세요',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
