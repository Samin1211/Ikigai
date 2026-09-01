import 'package:flutter/material.dart';

void main() => runApp(const IkigaiApp());


const _primary      = Color(0xFF645887);
const _bgColor      = Color(0xFFFEF7FF);
const _surfaceColor = Color(0xFFF7F2FA);


class IkigaiApp extends StatelessWidget {
  const IkigaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ikigai',
      theme: ThemeData(
        scaffoldBackgroundColor: _bgColor,
        colorScheme: ColorScheme.fromSeed(seedColor: _primary),
        primaryColor: _primary,
        useMaterial3: true,
      ),
      home: const AppShell(),
    );
  }
}

// ─────────────────── APP SHELL ───────────────────
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  // Lightweight stubs for all 4 screens.
  // We will replace these with real imports in the upcoming phases.
  static const _pages = <Widget>[
    _PlaceholderPage(title: 'Home Placeholder'),   // 0 — HOME
    _PlaceholderPage(title: 'Tasks Placeholder'),  // 1 — TASKS
    _PlaceholderPage(title: 'Focus Placeholder'),  // 2 — FOCUS
    _PlaceholderPage(title: 'Profile Placeholder'),// 3 — PROFILE
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Ikigai',
          style: TextStyle(color: _primary, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: _surfaceColor,
              child: const Icon(Icons.person_outline, color: _primary),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: _bgColor,
        selectedItemColor: _primary,
        unselectedItemColor: Colors.grey[400],
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled),        label: 'HOME'),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline), label: 'TASKS'),
          BottomNavigationBarItem(icon: Icon(Icons.center_focus_strong),  label: 'FOCUS'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline),     label: 'PROFILE'),
        ],
      ),
    );
  }
}

// ─────────────────── PLACEHOLDER PAGE ───────────────────
class _PlaceholderPage extends StatelessWidget {
  final String title;
  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: _primary.withOpacity(0.3), // Fallback if withValues() isn't supported yet
        ),
      ),
    );
  }
}