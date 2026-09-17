import 'package:flutter/material.dart';

const _primary= Color(0xFF645887);
const _darkText= Color(0xFF362E4B);
const _bgColor= Color(0xFFFEF7FF);
const _surfaceColor = Color(0xFFF7F2FA);
const _pill= BorderRadius.all(Radius.circular(9999));

class Task {
  final String title;
  bool isDone;

  Task({
    required this.title,
    this.isDone = false,
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
    setState(()=> _tasks.remove(task));
  }

  BoxDecoration get _sheetDecoration=>const BoxDecoration(
    color: _bgColor,
    borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
  );

  void _addTask(String title) {
    setState(() {
      _tasks.add(Task(title: title));
    });
  }

  void _showAddTaskSheet() {
    String name = '';

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
                      hintStyle: TextStyle(color: _primary),
                      filled: true,
                      fillColor: _surfaceColor,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(9999), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: ()=>Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          padding:const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Cancel', style:TextStyle(color:_primary, fontWeight: FontWeight.bold)),
                      ),
                    ),

                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (name.isNotEmpty) {
                            _addTask(name);
                            Navigator.pop(ctx);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: _primary,
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: const BoxDecoration(color: _primary, borderRadius: _pill),
      child: Row(children: [
        GestureDetector(
          onTap: () => _markDone(task),
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(task.title, style: const TextStyle(color: Colors.white, fontSize: 16)),
        ),
      ]),
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

            if (_tasks.isNotEmpty)
               ...[
              Text('To-Do List', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _darkText)),
              const SizedBox(height: 16),
                 // for (final task in _tasks)
                 //   _buildTaskItem(task),
                 ListView.builder(itemBuilder: (context, index) => _buildTaskItem(_tasks[index]), itemCount: _tasks.length,)
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