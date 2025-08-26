import 'package:flutter/material.dart';

/// 친구 목록 뷰 (선택된 친구들 표시)
class FriendsListView extends StatelessWidget {
  final List<Map<String, String>> selectedFriends;
  final Function(int) onRemoveFriend;

  const FriendsListView({
    super.key,
    required this.selectedFriends,
    required this.onRemoveFriend,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '초대된 인원',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.info_outline, size: 16, color: Colors.grey),
          ],
        ),
        const SizedBox(height: 12),
        if (selectedFriends.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '아직 초대된 친구가 없습니다.\n우상단의 + 버튼을 눌러 친구를 초대해보세요!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          )
        else
          SizedBox(
            height: 50,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: selectedFriends.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final friend = selectedFriends[index];
                return Chip(
                  avatar: CircleAvatar(
                    child: Text(friend['name']!.characters.first),
                  ),
                  label: Text(friend['name']!),
                  onDeleted: () => onRemoveFriend(index),
                  deleteIcon: const Icon(Icons.close, size: 18),
                );
              },
            ),
          ),
      ],
    );
  }
}
