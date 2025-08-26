import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:promesa/presentation/providers/auth_provider.dart';
import '../../../../core/router/app_router.dart';
import '../../../schedule/list/schedule_list_provider.dart';
import '../../../../domain/entities/schedule_entity.dart';

/// 홈 화면
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 스케줄 섹션
              Expanded(
                child: Consumer(
                  builder: (context, ref, _) {
                    final state = ref.watch(scheduleListNotifierProvider);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'My schedules',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const Spacer(),
                            DropdownButton<ScheduleFilter>(
                              value: state.filter,
                              onChanged: (v) => ref
                                  .read(scheduleListNotifierProvider.notifier)
                                  .setFilter(v ?? ScheduleFilter.all),
                              items: const [
                                DropdownMenuItem(value: ScheduleFilter.all, child: Text('All')),
                                DropdownMenuItem(value: ScheduleFilter.active, child: Text('Active')),
                                DropdownMenuItem(value: ScheduleFilter.expired, child: Text('Expired')),
                              ],
                            ),
                            const SizedBox(width: 8),
                            DropdownButton<ScheduleView>(
                              value: state.view,
                              onChanged: (v) => ref
                                  .read(scheduleListNotifierProvider.notifier)
                                  .setView(v ?? ScheduleView.week),
                              items: const [
                                DropdownMenuItem(value: ScheduleView.day, child: Text('Day')),
                                DropdownMenuItem(value: ScheduleView.week, child: Text('Week')),
                                DropdownMenuItem(value: ScheduleView.month, child: Text('Month')),
                                DropdownMenuItem(value: ScheduleView.year, child: Text('Year')),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: state.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : _ScheduleViewSwitcher(
                                  view: state.view,
                                  items: ref
                                      .read(scheduleListNotifierProvider.notifier)
                                      .filteredItems(state),
                                ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await context.router.push(const AddScheduleRoute());
          if (result != null && context.mounted) {
            ref.read(scheduleListNotifierProvider.notifier).refresh();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('일정이 저장되었습니다.')),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Removed old card-based view. Views are implemented below.

class _ScheduleViewSwitcher extends StatelessWidget {
  final ScheduleView view;
  final List<ScheduleEntity> items;

  const _ScheduleViewSwitcher({
    required this.view,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    switch (view) {
      case ScheduleView.day:
        return _DayView(items: items);
      case ScheduleView.week:
        return _WeekView(items: items);
      case ScheduleView.month:
        return _MonthView(items: items);
      case ScheduleView.year:
        return _YearView(items: items);
    }
  }
}

Color _colorFor(ScheduleColor color, BuildContext context) {
  switch (color) {
    case ScheduleColor.blue:
      return Colors.blue.shade400;
    case ScheduleColor.green:
      return Colors.green.shade400;
    case ScheduleColor.yellow:
      return Colors.amber.shade500;
    case ScheduleColor.red:
      return Colors.red.shade400;
    case ScheduleColor.purple:
      return Colors.purple.shade400;
    case ScheduleColor.teal:
      return Colors.teal.shade400;
  }
}

class _DayView extends StatelessWidget {
  final List<ScheduleEntity> items;
  const _DayView({required this.items});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final todayItems = items
        .where((e) => e.dateTime.year == now.year && e.dateTime.month == now.month && e.dateTime.day == now.day)
        .toList();
    return ListView.builder(
      itemCount: 24,
      itemBuilder: (context, hour) {
        final hourItems = todayItems.where((e) => e.dateTime.hour == hour).toList();
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 40, child: Text('${hour.toString().padLeft(2, '0')}:00')),
              const SizedBox(width: 12),
              if (hourItems.isEmpty)
                const Expanded(child: SizedBox())
              else
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final s in hourItems)
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                          decoration: BoxDecoration(
                            color: _colorFor(s.color, context).withOpacity(0.15),
                            border: Border.all(color: _colorFor(s.color, context)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(s.title),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _WeekView extends StatelessWidget {
  final List<ScheduleEntity> items;
  const _WeekView({required this.items});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday % 7));
    final days = [for (int i = 0; i < 7; i++) startOfWeek.add(Duration(days: i))];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final day in days)
            Container(
              width: 160,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${day.month}/${day.day}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView(
                      children: [
                        for (final s in items.where((e) => e.dateTime.year == day.year && e.dateTime.month == day.month && e.dateTime.day == day.day))
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Container(width: 8, height: 8, decoration: BoxDecoration(color: _colorFor(s.color, context), shape: BoxShape.circle)),
                                const SizedBox(width: 8),
                                Expanded(child: Text(s.title, maxLines: 1, overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _MonthView extends StatelessWidget {
  final List<ScheduleEntity> items;
  const _MonthView({required this.items});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final first = DateTime(now.year, now.month, 1);
    final firstWeekday = (first.weekday % 7); // Sunday=0
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final totalCells = firstWeekday + daysInMonth;
    final rows = (totalCells / 7).ceil();
    return Column(
      children: [
        Row(
          children: const [
            Expanded(child: Center(child: Text('Sun'))),
            Expanded(child: Center(child: Text('Mon'))),
            Expanded(child: Center(child: Text('Tue'))),
            Expanded(child: Center(child: Text('Wed'))),
            Expanded(child: Center(child: Text('Thu'))),
            Expanded(child: Center(child: Text('Fri'))),
            Expanded(child: Center(child: Text('Sat'))),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, childAspectRatio: 0.9),
            itemCount: rows * 7,
            itemBuilder: (context, index) {
              final dayNum = index - firstWeekday + 1;
              if (dayNum < 1 || dayNum > daysInMonth) {
                return const SizedBox.shrink();
              }
              final day = DateTime(now.year, now.month, dayNum);
              final dayItems = items.where((e) => e.dateTime.year == day.year && e.dateTime.month == day.month && e.dateTime.day == day.day).toList();
              return Container(
                margin: const EdgeInsets.all(2),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$dayNum', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    for (final s in dayItems.take(3))
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Row(
                          children: [
                            Container(width: 6, height: 6, decoration: BoxDecoration(color: _colorFor(s.color, context), shape: BoxShape.circle)),
                            const SizedBox(width: 4),
                            Expanded(child: Text(s.title, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11))),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _YearView extends StatelessWidget {
  final List<ScheduleEntity> items;
  const _YearView({required this.items});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 1.2),
      itemCount: 12,
      itemBuilder: (context, index) {
        final month = index + 1;
        final monthItems = items.where((e) => e.dateTime.year == now.year && e.dateTime.month == month).length;
        return Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${now.year} - $month', style: const TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              Text('Events: $monthItems'),
            ],
          ),
        );
      },
    );
  }
}
