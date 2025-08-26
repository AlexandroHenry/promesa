import 'package:flutter/material.dart';

/// 색상 선택 뷰
class ColorPickerView extends StatelessWidget {
  final String colorHex;
  final VoidCallback onColorPick;

  const ColorPickerView({
    super.key,
    required this.colorHex,
    required this.onColorPick,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '색상',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: onColorPick,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: _hexToColor(colorHex),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(colorHex)),
                const Icon(Icons.colorize, size: 18, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _hexToColor(String input) {
    var hex = input.trim();
    if (hex.startsWith('#')) hex = hex.substring(1);
    if (hex.length == 6) {
      return Color(int.parse('FF$hex', radix: 16));
    }
    return Colors.blue;
  }
}

/// 색상 선택 다이얼로그
class ColorPickerDialog extends StatelessWidget {
  final Color initialColor;

  const ColorPickerDialog({
    super.key,
    required this.initialColor,
  });

  static Future<Color?> show(BuildContext context, Color initialColor) {
    return showDialog<Color>(
      context: context,
      builder: (context) => ColorPickerDialog(initialColor: initialColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('색상 선택'),
      content: SizedBox(
        width: 320,
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final color in [
              Colors.red,
              Colors.pink,
              Colors.orange,
              Colors.amber,
              Colors.yellow,
              Colors.lime,
              Colors.green,
              Colors.teal,
              Colors.cyan,
              Colors.lightBlue,
              Colors.blue,
              Colors.indigo,
              Colors.purple,
              Colors.brown,
              Colors.grey,
              Colors.black,
            ])
              GestureDetector(
                onTap: () => Navigator.of(context).pop(color),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                    boxShadow: color == initialColor
                        ? [
                            BoxShadow(
                              color: color.withOpacity(0.5),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
