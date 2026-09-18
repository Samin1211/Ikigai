import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'tasks_page.dart';
import 'pomodoro.dart';
import 'analytics_page.dart';
import 'profile_screen.dart';

const _primary  = Color(0xFF645887);
const _darkText = Color(0xFF362E4B);

class BlogArticle {
  final String title;
  final String category;
  final String subtitle;
  final String webUrl;
  final String imagePath;

  const BlogArticle({
    required this.title,
    required this.category,
    required this.subtitle,
    required this.webUrl,
    required this.imagePath,
  });
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    TasksPage(),
    PomodoroPage(),
    InsightsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF7FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4EAFF),
        elevation: 0,
        titleSpacing: 24,
        title: const Text(
          'Ikigai',
          style: TextStyle(
            fontFamily: 'Epilogue',
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: _primary,
          ),
        ),
        actions: const [
          ProfileMenuButton(),
          SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: const Color(0xFFEADDFF),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                color: _primary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              );
            }
            return const TextStyle(
              color: Color(0xFF645A7A),
              fontWeight: FontWeight.normal,
              fontSize: 12,
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: _primary);
            }
            return const IconThemeData(color: Color(0xFF645A7A));
          }),
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          backgroundColor: const Color(0xFFF4EAFF),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.check_circle_outline),
              selectedIcon: Icon(Icons.check_circle),
              label: 'Tasks',
            ),
            NavigationDestination(
              icon: Icon(Icons.timer_outlined),
              selectedIcon: Icon(Icons.timer),
              label: 'Focus',
            ),
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
          ],
        ),
      ),
    );
  }
}

// Alias for backwards compatibility
typedef HomePage = MainScreen;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<BlogArticle> articles = [
    BlogArticle(
      category: 'BOOK',
      title: 'Ikigai: The Japanese Secret to a Long and Happy Life',
      subtitle: 'Hector Garcia & Francesc Miralles',
      webUrl: 'https://dn760000.eu.archive.org/0/items/ikigai-the-japanese-secret-to-a-long-and-happy-life-pdfdrive.com/Ikigai%20_%20the%20Japanese%20secret%20to%20a%20long%20and%20happy%20life%20(%20PDFDrive.com%20).pdf',
      imagePath: 'assets/ikigai.jpg',
    ),
    BlogArticle(
      category: 'BOOK',
      title: 'Atomic Habits: Building Good Habits & Breaking Bad Ones',
      subtitle: 'James Clear',
      webUrl: 'https://ia600409.us.archive.org/26/items/atomic-habits-pdfdrive/Atomic%20habits%20(%20PDFDrive%20).pdf',
      imagePath: 'assets/atomic_habits.jpg',
    ),
    BlogArticle(
      category: 'BOOK',
      title: 'The Let Them Theory: Stop Wasting Energy on What You Cant Control',
      subtitle: 'Mel Robbins',
      webUrl: 'https://www.melrobbins.com/wp-content/uploads/2025/03/LetThem_Guide_Leading_Teams.pdf',
      imagePath: 'assets/let_them_theory.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text(
            'Welcome.',
            style: TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.bold,
              height: 1,
              color: _primary,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'For You',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: _primary,
            ),
          ),
          const SizedBox(height: 20),

          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: articles.length,
              separatorBuilder: (context, index) => const SizedBox(height: 24),
              itemBuilder: (context, index) {
                final article = articles[index];
                return GestureDetector(
                  onTap: () async {
                    final Uri uri = Uri.parse(article.webUrl);
                    try {
                      final launched = await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                      if (!launched) {
                        await launchUrl(
                          uri,
                          mode: LaunchMode.platformDefault,
                        );
                      }
                    } catch (_) {
                      try {
                        await launchUrl(
                          uri,
                          mode: LaunchMode.inAppBrowserView,
                        );
                      } catch (_) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Could not open the link.'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      }
                    }
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        article.imagePath,
                        width: 80,
                        height: 120,
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 80,
                          height: 120,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.book, color: _primary),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              article.category,
                              style: const TextStyle(
                                color: _primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              article.title,
                              style: const TextStyle(
                                color: _darkText,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              article.subtitle,
                              style: const TextStyle(
                                color: _darkText,
                                fontSize: 12,
                              ),
                            ),
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
      ),
    );
  }
}