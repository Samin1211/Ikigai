import 'package:flutter/material.dart';

const _primary  = Color(0xFF645887);
const _darkText = Color(0xFF362E4B);

class BlogArticle {
  final String title;
  final String category;
  final String subtitle;
  final String imagePath;

  const BlogArticle({
    required this.title,
    required this.category,
    required this.subtitle,
    required this.imagePath,
  });
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<BlogArticle> articles = [
    BlogArticle(
      category: 'BOOK',
      title: 'Ikigai: The Japanese Secret to a Long and Happy Life',
      subtitle: 'Hector Garcia & Francesc Miralles',
      imagePath: 'assets/images/ikigai.jpg',
    ),
    BlogArticle(
      category: 'BOOK',
      title: 'Atomic Habits: Building Good Habits & Breaking Bad Ones',
      subtitle: 'James Clear',
      imagePath: 'assets/images/atomic_habits.jpg',
    ),
    BlogArticle(
      category: 'BOOK',
      title: 'The Let Them Theory: Stop Wasting Energy on What You Cant Control',
      subtitle: 'Mel Robbins',
      imagePath: 'assets/images/let_them_theory.jpg',
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

          for (int i = 0; i < articles.length; i++) ...[
            if (i > 0) const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  articles[i].imagePath,
                  width: 80,
                  height: 120,
                  fit: BoxFit.fill,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        articles[i].category,
                        style: const TextStyle(
                          color: _primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        articles[i].title,
                        style: const TextStyle(
                          color: _darkText,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        articles[i].subtitle,
                        style: TextStyle(
                          color: _darkText,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}