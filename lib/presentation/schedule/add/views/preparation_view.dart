import 'package:flutter/material.dart';
import 'package:characters/characters.dart';
import '../../../../domain/entities/preparation_entity.dart';

/// 지각비 설정 뷰
class LateFineView extends StatelessWidget {
  final TextEditingController fineController;

  const LateFineView({
    super.key,
    required this.fineController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '지각비',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: fineController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: '지각비 금액 (원)',
            hintText: '지각 시 내야할 금액을 입력하세요',
            border: OutlineInputBorder(),
            prefixText: '₩ ',
          ),
        ),
      ],
    );
  }
}

/// 준비물 관리 뷰
class PreparationView extends StatelessWidget {
  final TextEditingController prepInputController;
  final List<PreparationEntity> preparations;
  final List<Map<String, String>> selectedFriends;
  final VoidCallback onAddPreparation;
  final Function(PreparationEntity) onAssignPreparation;
  final Function(PreparationEntity) onDeletePreparation;

  const PreparationView({
    super.key,
    required this.prepInputController,
    required this.preparations,
    required this.selectedFriends,
    required this.onAddPreparation,
    required this.onAssignPreparation,
    required this.onDeletePreparation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '준비물',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: prepInputController,
                decoration: const InputDecoration(
                  labelText: '준비물 입력',
                  hintText: '준비할 물건을 입력하세요',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    onAddPreparation();
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: onAddPreparation,
              icon: const Icon(Icons.add),
              label: const Text('추가'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (preparations.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final prep in preparations)
                _PreparationChip(
                  preparation: prep,
                  selectedFriends: selectedFriends,
                  onAssign: () => onAssignPreparation(prep),
                  onDelete: () => onDeletePreparation(prep),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

/// 준비물 칩 위젯
class _PreparationChip extends StatelessWidget {
  final PreparationEntity preparation;
  final List<Map<String, String>> selectedFriends;
  final VoidCallback onAssign;
  final VoidCallback onDelete;

  const _PreparationChip({
    required this.preparation,
    required this.selectedFriends,
    required this.onAssign,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InputChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(preparation.name),
          const SizedBox(width: 6),
          if (preparation.assignedToUserIds.isEmpty)
            const Text('(전체)', style: TextStyle(fontSize: 12))
          else ...[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 아바타들 (최대 3개)
                for (final friend in selectedFriends
                    .where((f) => preparation.assignedToUserIds.contains(f['id']))
                    .take(3)) ...[
                  const SizedBox(width: 4),
                  CircleAvatar(
                    radius: 8,
                    child: Text(
                      friend['name']!.characters.first,
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                ],
                if (preparation.assignedToUserIds.length > 3) ...[
                  const SizedBox(width: 4),
                  Text(
                    '+${preparation.assignedToUserIds.length - 3}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
                const SizedBox(width: 4),
                Text(
                  '(${selectedFriends
                      .where((f) => preparation.assignedToUserIds.contains(f['id']))
                      .map((f) => f['name'])
                      .take(2)
                      .join(', ')}${preparation.assignedToUserIds.length > 2 ? '…' : ''})',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ],
      ),
      avatar: const CircleAvatar(
        radius: 10,
        child: Icon(Icons.inventory_2, size: 12),
      ),
      onPressed: onAssign,
      onDeleted: onDelete,
    );
  }
}
