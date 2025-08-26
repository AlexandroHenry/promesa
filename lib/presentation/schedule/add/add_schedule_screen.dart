import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '00_state/add_schedule_provider.dart';
import '../../../domain/entities/schedule_entity.dart';
import '../../../domain/entities/preparation_entity.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:characters/characters.dart';

@RoutePage()
class AddScheduleScreen extends ConsumerStatefulWidget {
  const AddScheduleScreen({super.key});

  @override
  ConsumerState<AddScheduleScreen> createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends ConsumerState<AddScheduleScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _fineController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _colorHexController = TextEditingController(text: '#4285F4');
  final TextEditingController _prepInputController = TextEditingController();
  DateTime? _selectedDateTime;
  ScheduleColor _color = ScheduleColor.blue;
  LatLng? _selectedLatLng;
  final List<Map<String, String>> _selectedFriends = [];
  final List<PreparationEntity> _preparations = [];
  
  String _colorToHex(Color color) {
    return '#'
        '${color.red.toRadixString(16).padLeft(2, '0')}'
        '${color.green.toRadixString(16).padLeft(2, '0')}'
        '${color.blue.toRadixString(16).padLeft(2, '0')}'.toUpperCase();
  }

  Color _hexToColor(String input) {
    var hex = input.trim();
    if (hex.startsWith('#')) hex = hex.substring(1);
    if (hex.length == 6) {
      return Color(int.parse('FF$hex', radix: 16));
    }
    return Colors.blue;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _fineController.dispose();
    _descController.dispose();
    _placeController.dispose();
    _colorHexController.dispose();
    _prepInputController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
    );
    if (time == null) return;
    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _openFriendPicker() async {
    final users = await _loadMockUsers();
    final selectedIds = _selectedFriends.map((e) => e['id']).toSet();
    if (!mounted) return;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          builder: (_, controller) {
            return Column(
              children: [
                const SizedBox(height: 12),
                Container(height: 4, width: 36, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
                const SizedBox(height: 12),
                const Text('친구 선택', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    controller: controller,
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final u = users[index];
                      final id = u['id'].toString();
                      final name = u['name'] as String? ?? 'Unknown';
                      final checked = selectedIds.contains(id);
                      return CheckboxListTile(
                        value: checked,
                        onChanged: (v) {
                          setState(() {
                            if (v == true) {
                              if (_selectedFriends.indexWhere((e) => e['id'] == id) == -1) {
                                _selectedFriends.add({'id': id, 'name': name});
                              }
                            } else {
                              _selectedFriends.removeWhere((e) => e['id'] == id);
                            }
                          });
                        },
                        title: Text(name),
                        secondary: CircleAvatar(child: Text(name.characters.first)),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
              ],
            );
          },
        );
      },
    );
  }

  Future<List<dynamic>> _loadMockUsers() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/mock_data/users.json');
      final map = json.decode(jsonStr) as Map<String, dynamic>;
      return (map['users'] as List<dynamic>?) ?? [];
    } catch (_) {
      return [];
    }
  }

  Future<void> _assignPreparation(PreparationEntity prep) async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Text('"${prep.name}" 할당', style: const TextStyle(fontWeight: FontWeight.bold)),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.groups),
                title: const Text('전체 (모두가 준비)'),
                onTap: () => Navigator.pop(context, 'ALL'),
              ),
              for (final f in _selectedFriends)
                ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(f['name']!),
                  onTap: () => Navigator.pop(context, f['id']!),
                ),
              ListTile(
                leading: const Icon(Icons.clear),
                title: const Text('할당 해제'),
                onTap: () => Navigator.pop(context, ''),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
    if (choice == null) return;
    setState(() {
      final idx = _preparations.indexOf(prep);
      if (idx != -1) {
        _preparations[idx] = PreparationEntity(
          name: prep.name,
          assignedToUserId: choice.isEmpty ? null : choice,
        );
      }
    });
  }

  Future<void> _openColorPickerDialog() async {
    Color temp = _hexToColor(_colorHexController.text);
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('색상 선택'),
          content: SizedBox(
            width: 320,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final c in [
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
                    onTap: () {
                      temp = c;
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: c,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
    setState(() {
      _colorHexController.text = _colorToHex(temp);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Schedule'),
        actions: [
          IconButton(
            icon: const Icon(Icons.group_add),
            onPressed: _openFriendPicker,
            tooltip: '친구 추가',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _placeController,
                      decoration: const InputDecoration(labelText: 'Place name'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      final picked = await Navigator.of(context).push<LatLng>(
                        MaterialPageRoute(
                          builder: (_) => _MapPickerPage(
                            initial: _selectedLatLng ?? const LatLng(37.5665, 126.9780),
                          ),
                          fullscreenDialog: true,
                        ),
                      );
                      if (picked != null) {
                        setState(() {
                          _selectedLatLng = picked;
                        });
                      }
                    },
                    child: const Text('지도 선택'),
                  )
                ],
              ),
              const SizedBox(height: 12),

              if (_selectedLatLng != null)
                SizedBox(
                  height: 140,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _selectedLatLng!,
                        zoom: 12,
                      ),
                      onTap: (pos) => setState(() => _selectedLatLng = pos),
                      markers: {
                        Marker(markerId: const MarkerId('picked'), position: _selectedLatLng!),
                      },
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                    ),
                  ),
                ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: _pickDateTime,
                      child: InputDecorator(
                        decoration: const InputDecoration(labelText: '날짜/시간'),
                        child: Text(
                          _selectedDateTime == null
                              ? '탭해서 선택'
                              : _selectedDateTime.toString(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              InkWell(
                onTap: _openColorPickerDialog,
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Color'),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: _hexToColor(_colorHexController.text),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(_colorHexController.text),
                      const Spacer(),
                      const Icon(Icons.colorize, size: 18),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _fineController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Late fine amount (₩)'),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _prepInputController,
                      decoration: const InputDecoration(labelText: '준비물 입력'),
                      onSubmitted: (v) {
                        if (v.trim().isEmpty) return;
                        setState(() {
                          _preparations.add(PreparationEntity(name: v.trim()));
                          _prepInputController.clear();
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      final v = _prepInputController.text.trim();
                      if (v.isEmpty) return;
                      setState(() {
                        _preparations.add(PreparationEntity(name: v));
                        _prepInputController.clear();
                      });
                    },
                    child: const Text('추가'),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final p in _preparations)
                    InputChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(p.name),
                          const SizedBox(width: 6),
                          if (p.assignedToUserId == 'ALL')
                            const Text('(전체)', style: TextStyle(fontSize: 12))
                          else if (p.assignedToUserId != null)
                            Text('(${_selectedFriends.firstWhere((f) => f['id'] == p.assignedToUserId, orElse: () => {'name': '지정됨'})['name']})', style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                      avatar: const CircleAvatar(radius: 10, child: Icon(Icons.inventory_2, size: 12)),
                      onPressed: () => _assignPreparation(p),
                      onDeleted: () {
                        setState(() {
                          _preparations.remove(p);
                        });
                      },
                    ),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Text('초대된 인원', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(width: 8),
                  const Icon(Icons.info, size: 16),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedFriends.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final f = _selectedFriends[index];
                    return Chip(
                      avatar: CircleAvatar(child: Text(f['name']!.characters.first)),
                      label: Text(f['name']!),
                      onDeleted: () {
                        setState(() {
                          _selectedFriends.removeAt(index);
                        });
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: Consumer(
                  builder: (context, ref, _) {
                    final state = ref.watch(addScheduleNotifierProvider);
                    return ElevatedButton(
                      onPressed: state.isSubmitting
                          ? null
                          : () async {
                              final title = _titleController.text.trim();
                              if (title.isEmpty || _selectedDateTime == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('입력값을 확인해주세요.')),
                                );
                                return;
                              }
                              final fine = int.tryParse(_fineController.text.trim()) ?? 0;
                              final description = _descController.text.trim();
                              final participants = _selectedFriends.map((e) => e['id']!).toList();
                              final created = await ref.read(addScheduleNotifierProvider.notifier).submit(
                                title: title,
                                dateTime: _selectedDateTime!,
                                color: _color,
                                colorHex: _colorHexController.text.trim().isEmpty ? null : _colorHexController.text.trim(),
                                lateFineAmount: fine,
                                description: description,
                                participantUserIds: participants,
                                preparations: _preparations,
                                latitude: _selectedLatLng?.latitude,
                                longitude: _selectedLatLng?.longitude,
                                placeName: _placeController.text.trim().isEmpty ? null : _placeController.text.trim(),
                              );
                              if (!mounted) return;
                              if (created != null) {
                                context.router.pop(created);
                              } else if (state.errorMessage != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.errorMessage!)),
                                );
                              }
                            },
                      child: state.isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('저장'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapPickerPage extends StatefulWidget {
  final LatLng initial;
  const _MapPickerPage({required this.initial});

  @override
  State<_MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<_MapPickerPage> {
  LatLng? _picked;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('위치 선택'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(_picked ?? widget.initial);
            },
            child: const Text('완료'),
          )
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: widget.initial, zoom: 14),
        onTap: (pos) => setState(() => _picked = pos),
        markers: {
          Marker(markerId: const MarkerId('m'), position: _picked ?? widget.initial),
        },
        myLocationButtonEnabled: true,
      ),
    );
  }
}