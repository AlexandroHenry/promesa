import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:characters/characters.dart';
import '../../../domain/entities/schedule_entity.dart';
import '../../../domain/entities/late_fine_entity.dart';
import '../../../domain/entities/preparation_entity.dart';
import '00_state/edit_schedule_provider.dart';

@RoutePage()
class EditScheduleScreen extends ConsumerStatefulWidget {
  final ScheduleEntity schedule;
  const EditScheduleScreen({super.key, required this.schedule});

  @override
  ConsumerState<EditScheduleScreen> createState() => _EditScheduleScreenState();
}

class _EditScheduleScreenState extends ConsumerState<EditScheduleScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _fineController = TextEditingController();
  final TextEditingController _fineIntervalController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _colorHexController = TextEditingController(text: '#4285F4');
  final TextEditingController _prepInputController = TextEditingController();

  DateTime? _selectedDateTime;
  ScheduleColor _color = ScheduleColor.blue;
  LatLng? _selectedLatLng;
  final List<Map<String, String>> _selectedFriends = [];
  final List<PreparationEntity> _preparations = [];

  LateFineType _fineType = LateFineType.fixed;

  @override
  void initState() {
    super.initState();
    final s = widget.schedule;
    _titleController.text = s.title;
    _descController.text = s.description;
    _placeController.text = s.placeName ?? '';
    _selectedDateTime = s.dateTime;
    _color = s.color;
    _colorHexController.text = s.colorHex ?? '#4285F4';
    if (s.latitude != null && s.longitude != null) {
      _selectedLatLng = LatLng(s.latitude!, s.longitude!);
    }
    // participants
    _selectedFriends.addAll([
      for (final p in s.participants) {'id': p.id, 'name': p.name}
    ]);
    // preparations
    _preparations.addAll(s.preparations);
    // fine
    if (s.lateFine != null) {
      _fineType = s.lateFine!.type;
      _fineController.text = s.lateFine!.amount.toString();
      if (s.lateFine!.interval != null) {
        _fineIntervalController.text = s.lateFine!.interval.toString();
      }
    } else if (s.lateFineAmount > 0) {
      _fineType = LateFineType.fixed;
      _fineController.text = s.lateFineAmount.toString();
    }

    _fineController.addListener(() => setState(() {}));
    _fineIntervalController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _fineController.removeListener(() => setState(() {}));
    _fineIntervalController.removeListener(() => setState(() {}));
    _fineController.dispose();
    _fineIntervalController.dispose();
    _descController.dispose();
    _placeController.dispose();
    _colorHexController.dispose();
    _prepInputController.dispose();
    super.dispose();
  }

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

  Future<void> _pickDateTime() async {
    final now = _selectedDateTime ?? DateTime.now();
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

  Future<List<dynamic>> _loadMockUsers() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/mock_data/users.json');
      final map = json.decode(jsonStr) as Map<String, dynamic>;
      return (map['users'] as List<dynamic>?) ?? [];
    } catch (_) {
      return [];
    }
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
        return StatefulBuilder(
          builder: (context, setModalState) {
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
                              setModalState(() {
                                if (v == true) {
                                  if (!selectedIds.contains(id)) {
                                    selectedIds.add(id);
                                    _selectedFriends.add({'id': id, 'name': name});
                                  }
                                } else {
                                  selectedIds.remove(id);
                                  _selectedFriends.removeWhere((e) => e['id'] == id);
                                }
                              });
                              setState(() {});
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
      },
    );
  }

  Future<void> _assignPreparation(PreparationEntity prep) async {
    final chosen = await showModalBottomSheet<List<String>>(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        final temp = {...prep.assignedToUserIds};
        bool isAll = temp.isEmpty;
        return SafeArea(
          child: StatefulBuilder(
            builder: (context, setInner) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),
                  Text('"${prep.name}" 할당', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const Divider(),
                  CheckboxListTile(
                    value: isAll,
                    onChanged: (v) {
                      setInner(() {
                        isAll = v ?? false;
                        if (isAll) temp.clear();
                      });
                    },
                    secondary: const Icon(Icons.groups),
                    title: const Text('전체 (모두가 준비)'),
                  ),
                  for (final f in _selectedFriends)
                    CheckboxListTile(
                      value: !isAll && temp.contains(f['id']),
                      onChanged: (v) {
                        setInner(() {
                          if (v == true) {
                            temp.add(f['id']!);
                            isAll = false;
                          } else {
                            temp.remove(f['id']);
                          }
                        });
                      },
                      secondary: const Icon(Icons.person),
                      title: Text(f['name']!),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(onPressed: () => Navigator.pop(context, null), child: const Text('취소')),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (isAll) {
                            Navigator.pop(context, <String>[]);
                          } else {
                            Navigator.pop(context, temp.toList());
                          }
                        },
                        child: const Text('적용'),
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              );
            },
          ),
        );
      },
    );
    if (chosen == null) return;
    setState(() {
      final idx = _preparations.indexOf(prep);
      if (idx != -1) {
        _preparations[idx] = PreparationEntity(
          name: prep.name,
          assignedToUserIds: chosen,
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

  String _getFinePreviewText() {
    final fine = int.tryParse(_fineController.text.trim()) ?? 0;
    if (fine <= 0) return '벌금 없음';
    switch (_fineType) {
      case LateFineType.fixed:
        return '지각 시 ${fine.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원';
      case LateFineType.perMinute:
        final interval = int.tryParse(_fineIntervalController.text.trim()) ?? 1;
        return '${interval}분당 ${fine.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원';
      case LateFineType.perHour:
        final interval = int.tryParse(_fineIntervalController.text.trim()) ?? 1;
        return '${interval}시간당 ${fine.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('스케줄 수정'),
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
              Text('지각 벌금', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Column(
                children: [
                  RadioListTile<LateFineType>(
                    title: const Text('전체 고정금액'),
                    subtitle: const Text('지각하면 고정 금액'),
                    value: LateFineType.fixed,
                    groupValue: _fineType,
                    onChanged: (value) {
                      setState(() {
                        _fineType = value!;
                      });
                    },
                  ),
                  RadioListTile<LateFineType>(
                    title: const Text('분당 벌금'),
                    subtitle: const Text('지정한 분마다 벌금 추가'),
                    value: LateFineType.perMinute,
                    groupValue: _fineType,
                    onChanged: (value) {
                      setState(() {
                        _fineType = value!;
                      });
                    },
                  ),
                  RadioListTile<LateFineType>(
                    title: const Text('시간당 벌금'),
                    subtitle: const Text('지정한 시간마다 벌금 추가'),
                    value: LateFineType.perHour,
                    groupValue: _fineType,
                    onChanged: (value) {
                      setState(() {
                        _fineType = value!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (_fineType == LateFineType.fixed) ...[
                TextField(
                  controller: _fineController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: '벌금 금액 (₩)',
                    hintText: '예: 5000',
                  ),
                ),
              ] else ...[
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _fineIntervalController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: _fineType == LateFineType.perMinute ? '분 간격' : '시간 간격',
                          hintText: _fineType == LateFineType.perMinute ? '예: 5' : '예: 1',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: _fineController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: '벌금 금액 (₩)',
                          hintText: '예: 1000',
                          helperText: _fineType == LateFineType.perMinute
                              ? '${_fineIntervalController.text.isEmpty ? 'N' : _fineIntervalController.text}분당'
                              : '${_fineIntervalController.text.isEmpty ? 'N' : _fineIntervalController.text}시간당',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade600, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _getFinePreviewText(),
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
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
                          if (p.assignedToUserIds.isEmpty)
                            const Text('(전체)', style: TextStyle(fontSize: 12))
                          else ...[
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                for (final f in _selectedFriends.where((f) => p.assignedToUserIds.contains(f['id'])).take(3)) ...[
                                  const SizedBox(width: 4),
                                  CircleAvatar(
                                    radius: 8,
                                    child: Text(f['name']!.characters.first, style: const TextStyle(fontSize: 10)),
                                  ),
                                ],
                                if (p.assignedToUserIds.length > 3) ...[
                                  const SizedBox(width: 4),
                                  Text('+${p.assignedToUserIds.length - 3}', style: const TextStyle(fontSize: 12)),
                                ],
                                const SizedBox(width: 4),
                                Text(
                                  '(${_selectedFriends.where((f) => p.assignedToUserIds.contains(f['id']))
                                      .map((f) => f['name'])
                                      .take(2)
                                      .join(', ')}${p.assignedToUserIds.length > 2 ? '…' : ''})',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ],
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
                    final state = ref.watch(editScheduleNotifierProvider);
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

                              LateFineEntity? lateFineEntity;
                              if (fine > 0) {
                                switch (_fineType) {
                                  case LateFineType.fixed:
                                    lateFineEntity = LateFineEntity(
                                      type: LateFineType.fixed,
                                      amount: fine,
                                    );
                                    break;
                                  case LateFineType.perMinute:
                                    final interval = int.tryParse(_fineIntervalController.text.trim()) ?? 1;
                                    lateFineEntity = LateFineEntity(
                                      type: LateFineType.perMinute,
                                      amount: fine,
                                      interval: interval,
                                    );
                                    break;
                                  case LateFineType.perHour:
                                    final interval = int.tryParse(_fineIntervalController.text.trim()) ?? 1;
                                    lateFineEntity = LateFineEntity(
                                      type: LateFineType.perHour,
                                      amount: fine,
                                      interval: interval,
                                    );
                                    break;
                                }
                              }

                              final updated = await ref.read(editScheduleNotifierProvider.notifier).submit(
                                scheduleId: widget.schedule.id,
                                title: title,
                                dateTime: _selectedDateTime!,
                                color: _color,
                                colorHex: _colorHexController.text.trim().isEmpty ? null : _colorHexController.text.trim(),
                                lateFineAmount: fine,
                                lateFine: lateFineEntity,
                                description: description,
                                participantUserIds: participants,
                                preparations: _preparations,
                                latitude: _selectedLatLng?.latitude,
                                longitude: _selectedLatLng?.longitude,
                                placeName: _placeController.text.trim().isEmpty ? null : _placeController.text.trim(),
                              );
                              if (!mounted) return;
                              if (updated != null) {
                                context.router.pop(updated);
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


