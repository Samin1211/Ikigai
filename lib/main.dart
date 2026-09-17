import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'tasks_page.dart';

const _primary = Color(0xFF645887);
const _bgColor = Color(0xFFFEF7FF);

void main() => runApp(const IkigaiApp());

class IkigaiApp extends StatelessWidget {
  const IkigaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ikigai',
      theme: ThemeData(
        scaffoldBackgroundColor: _bgColor,
        primaryColor: _primary,
      ),
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  static const _pages = <Widget>[
    HomeScreen(),
    TasksPage(),
    Center(child: Text('Focus', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _primary))),
    Center(child: Text('Profile', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _primary))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ikigai', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: _bgColor,
        foregroundColor: _primary,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: _bgColor,
        selectedItemColor: _primary,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'HOME'),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline), label: 'TASKS'),
          BottomNavigationBarItem(icon: Icon(Icons.center_focus_strong), label: 'FOCUS'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'PROFILE'),
        ],
      ),
    );
  }
}
