import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<BlogArticle> articles = [
    BlogArticle(
      category: 'BOOK',
      title: 'Ikigai: The Japanese Secret to a Long and Happy Life',
      subtitle: 'Hector Garcia & Francesc Miralles',
      webUrl: 'https://dn760000.eu.archive.org/0/items/ikigai-the-japanese-secret-to-a-long-and-happy-life-pdfdrive.com/Ikigai%20_%20the%20Japanese%20secret%20to%20a%20long%20and%20happy%20life%20(%20PDFDrive.com%20).pdf',
      imagePath: 'assets/images/ikigai.jpg',
    ),
    BlogArticle(
      category: 'BOOK',
      title: 'Atomic Habits: Building Good Habits & Breaking Bad Ones',
      subtitle: 'James Clear',
      webUrl: 'https://ia600409.us.archive.org/26/items/atomic-habits-pdfdrive/Atomic%20habits%20(%20PDFDrive%20).pdf',
      imagePath: 'assets/images/atomic_habits.jpg',
    ),
    BlogArticle(
      category: 'BOOK',
      title: 'The Let Them Theory: Stop Wasting Energy on What You Cant Control',
      subtitle: 'Mel Robbins',
      webUrl: 'https://www.melrobbins.com/wp-content/uploads/2025/03/LetThem_Guide_Leading_Teams.pdf',
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
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
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