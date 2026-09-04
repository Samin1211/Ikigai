// lib/tasks_page.dart
import 'package:flutter/material.dart';

// ─────────────────── THEME CONSTANTS ───────────────────
const _primary      = Color(0xFF645887);
const _darkText     = Color(0xFF362E4B);
const _bgColor      = Color(0xFFFEF7FF);
const _cardDark     = Color(0xFF594C73);
const _cardLight    = Color(0xFFF1EBF5);
const _dueTint      = Color(0xFFFFE0E0);
const _accentTint   = Color(0xFFEADDFF);
const _pill         = BorderRadius.all(Radius.circular(9999));

// ─────────────────── DATA MODEL ───────────────────
class Task {
  final String id;
  final String title;
  final String category;
  final bool isReminder;
  bool isDone;
  final String? timeLabel;
  final String? dueAt;

  Task({
    required this.id,
    required this.title,
    required this.category,
    this.isReminder = false,
    this.isDone = false,
    this.timeLabel,
    this.dueAt,
  });

  DateTime? get dueDateTime => dueAt != null ? DateTime.tryParse(dueAt!) : null;

  bool get isDue {
    final dt = dueDateTime;
    return dt != null && !DateTime.now().isBefore(dt);
  }

  bool get isOverdue {
    final dt = dueDateTime;
    if (dt == null) return false;
    final now = DateTime.now();
    return now.isAfter(dt.add(const Duration(hours: 1))) ||
        now.isAfter(DateTime(dt.year, dt.month, dt.day, 23, 59));
  }
}

// ─────────────────── TASKS PAGE UI ───────────────────
class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  // Start completely empty as requested
  List<Task> _tasks = [];

  // Instantly delete task without delayed animations
  void _markDone(Task task) {
    setState(() => _tasks.removeWhere((t) => t.id == task.id));
  }

  void _showAddTaskSheet() {
    // TEMPORARY STUB for Phase 4.1 so it compiles cleanly
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add Task Modal ready for Phase 4.2')),
    );
  }

  // ── Task Card UI ──
  Widget _buildTaskItem(Task task) {
    final isReminder = task.isReminder;
    final due = isReminder && task.isDue;
    final overdue = isReminder && task.isOverdue;

    final bg = overdue ? const Color(0xFFFFCDCD) : (due ? _dueTint : (isReminder ? _cardLight : _cardDark));
    final fg = (isReminder || due) ? _darkText : Colors.white;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(color: bg, borderRadius: _pill),
      child: Row(children: [
        // Instant checkmark deletion
        GestureDetector(
          onTap: () => _markDone(task),
          child: Container(
            width: 24, height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle, border: Border.all(color: fg.withOpacity(0.5), width: 2),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Row(children: [
            Expanded(child: Text(task.title, style: TextStyle(color: fg, fontSize: 16))),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: const BoxDecoration(color: _accentTint, borderRadius: _pill),
              child: Text(task.category, style: const TextStyle(color: _primary, fontWeight: FontWeight.bold, fontSize: 10)),
            ),

            if (task.timeLabel != null) ...[
              const SizedBox(width: 12),
              due ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: overdue ? Colors.red.shade700 : Colors.red, borderRadius: _pill),
                child: Text(overdue ? 'OVERDUE' : 'DUE NOW', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
              )
                  : Text(task.timeLabel!, style: TextStyle(color: fg.withOpacity(0.7), fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ]),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reminders = _tasks.where((t) => t.isReminder).toList();
    final todos     = _tasks.where((t) => !t.isReminder).toList();

    return Stack(children: [
      CustomScrollView(slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Text('Guide\nYour Day.', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, height: 1.1, color: _primary)),
                const SizedBox(height: 40),

                if (_tasks.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48),
                    child: Center(child: Column(children: [
                      Icon(Icons.task_alt, size: 64, color: _primary.withOpacity(0.25)),
                      const SizedBox(height: 16),
                      Text('No tasks yet.\nTap + to add one!', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: _darkText.withOpacity(0.45), height: 1.5)),
                    ])),
                  ),

                if (reminders.isNotEmpty) ...[
                  Text('Reminders', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _darkText.withOpacity(0.7))),
                  const SizedBox(height: 16),
                  ...reminders.map(_buildTaskItem),
                  const SizedBox(height: 24),
                ],

                if (todos.isNotEmpty) ...[
                  Text('To-Do List', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _darkText.withOpacity(0.7))),
                  const SizedBox(height: 16),
                  ...todos.map(_buildTaskItem),
                ],
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ]),

      // Elevated FAB
      Positioned(
        right: 24, bottom: 104,
        child: FloatingActionButton(
          onPressed: _showAddTaskSheet,
          backgroundColor: _primary,
          shape: const CircleBorder(),
          elevation: 4,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    ]);
  }
}