import 'package:flutter/material.dart';
import 'package:characters/characters.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

/// 친구 선택 바텀시트 Fragment
class FriendPickerFragment extends StatefulWidget {
  final List<Map<String, String>> selectedFriends;

  const FriendPickerFragment({
    super.key,
    required this.selectedFriends,
  });

  static Future<List<Map<String, String>>?> show({
    required BuildContext context,
    required List<Map<String, String>> selectedFriends,
  }) async {
    return await showModalBottomSheet<List<Map<String, String>>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => FriendPickerFragment(selectedFriends: selectedFriends),
    );
  }

  @override
  State<FriendPickerFragment> createState() => _FriendPickerFragmentState();
}

class _FriendPickerFragmentState extends State<FriendPickerFragment> {
  List<dynamic> _users = [];
  final List<Map<String, String>> _tempSelected = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tempSelected.addAll(widget.selectedFriends);
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    try {
      final jsonStr = await rootBundle.loadString('assets/mock_data/users.json');
      final map = json.decode(jsonStr) as Map<String, dynamic>;
      final users = (map['users'] as List<dynamic>?) ?? [];
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _users = [];
        _isLoading = false;
      });
    }
  }

  void _toggleUser(String id, String name) {
    setState(() {
      final index = _tempSelected.indexWhere((f) => f['id'] == id);
      if (index != -1) {
        _tempSelected.removeAt(index);
      } else {
        _tempSelected.add({'id': id, 'name': name});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Column(
          children: [
            const SizedBox(height: 12),
            Container(
              height: 4,
              width: 36,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '친구 선택',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${_tempSelected.length}명 선택됨',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      controller: scrollController,
                      itemCount: _users.length,
                      itemBuilder: (context, index) {
                        final user = _users[index];
                        final id = user['id'].toString();
                        final name = user['name'] as String? ?? 'Unknown';
                        final isSelected = _tempSelected.any((f) => f['id'] == id);
                        
                        return CheckboxListTile(
                          value: isSelected,
                          onChanged: (value) => _toggleUser(id, name),
                          title: Text(name),
                          secondary: CircleAvatar(
                            child: Text(name.characters.first),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(null),
                      child: const Text('취소'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(_tempSelected),
                      child: const Text('완료'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }
}
