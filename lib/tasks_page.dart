import 'dart:async';
import 'package:flutter/material.dart';

const _primary      = Color(0xFF645887);
const _darkText     = Color(0xFF362E4B);
const _bgColor      = Color(0xFFFEF7FF);
const _surfaceColor = Color(0xFFF7F2FA);
const _pill         = BorderRadius.all(Radius.circular(9999));

class Task {
  final String title;
  bool isDone;
  DateTime? dueDate;

  Task({
    required this.title,
    this.isDone = false,
    this.dueDate,
  });
}

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final List<Task> _tasks = [];

  void _markDone(Task task) {
    setState(() => _tasks.remove(task));
  }

  void _addTask(String title, DateTime? dueDate) {
    final task = Task(title: title, dueDate: dueDate);

    if (dueDate != null) {
      final duration = dueDate.difference(DateTime.now());

      if (!duration.isNegative) {
        Timer(duration, () {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('⏰ Reminder: ${task.title}'),
                backgroundColor: _primary,
                behavior: SnackBarBehavior.floating,
                shape: const RoundedRectangleBorder(borderRadius: _pill),
                duration: const Duration(seconds: 4),
              ),
            );
          }
        });
      }
    }

    setState(() {
      _tasks.add(task);
    });
  }

  BoxDecoration get _sheetDecoration => const BoxDecoration(
    color: _bgColor,
    borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
  );

  void _showAddTaskSheet() {
    String name = '';
    DateTime? selectedDateTime;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, set) {
          final inset = MediaQuery.of(ctx).viewInsets.bottom;
          return Container(
            padding: EdgeInsets.only(bottom: inset),
            decoration: _sheetDecoration,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Task Name', style: TextStyle(color: _darkText, fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 8),
                  TextField(
                    autofocus: true,
                    onChanged: (v) => name = v,
                    style: const TextStyle(color: _darkText),
                    decoration: InputDecoration(
                      hintText: 'i.e. STUDY',
                      hintStyle: const TextStyle(color: _primary),
                      filled: true,
                      fillColor: _surfaceColor,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(9999), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextButton.icon(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: ctx,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2030),
                      );

                      if (pickedDate != null && ctx.mounted) {
                        final pickedTime = await showTimePicker(
                          context: ctx,
                          initialTime: TimeOfDay.now(),
                        );

                        if (pickedTime != null) {
                          set(() {
                            selectedDateTime = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                          });
                        }
                      }
                    },
                    icon: Icon(
                      selectedDateTime == null ? Icons.notifications_none : Icons.notifications_active,
                      color: _primary,
                    ),
                    label: Text(
                      selectedDateTime == null
                          ? 'Set Reminder'
                          : 'Due: ${selectedDateTime!.month}/${selectedDateTime!.day} at ${TimeOfDay.fromDateTime(selectedDateTime!).format(ctx)}',
                      style: const TextStyle(color: _primary, fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 24),
                  Row(children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: _primary),
                          shape: const RoundedRectangleBorder(borderRadius: _pill),
                        ),
                        child: const Text('Cancel', style: TextStyle(color: _primary, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (name.isNotEmpty) {
                            _addTask(name, selectedDateTime);
                            Navigator.pop(ctx);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: _primary,
                          shape: const RoundedRectangleBorder(borderRadius: _pill),
                          elevation: 0,
                        ),
                        child: const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTaskItem(Task task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(color: _primary, borderRadius: _pill),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                ),
                if (task.dueDate != null)
                  Text(
                    '${task.dueDate!.month}/${task.dueDate!.day} • ${TimeOfDay.fromDateTime(task.dueDate!).format(context)}',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12),
                  ),
              ],
            ),
          ),

          GestureDetector(
            onTap: () => _markDone(task),
            child: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(Icons.delete_outline, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            const Text(
              'Guide\nYour Day.',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, height: 1.1, color: _primary),
            ),
            const SizedBox(height: 32),

            if (_tasks.isNotEmpty) ...[
              const Text('To-Do List', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _darkText)),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) => _buildTaskItem(_tasks[index]),
                ),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskSheet,
        backgroundColor: _primary,
        shape: const CircleBorder(),
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}