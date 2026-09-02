// lib/home_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ─────────────────── THEME CONSTANTS ───────────────────
const _primary      = Color(0xFF645887);
const _darkText     = Color(0xFF362E4B);
const _surfaceColor = Color(0xFFF7F2FA);
const _accentTint   = Color(0xFFEADDFF);
const _pill = BorderRadius.all(Radius.circular(9999));

// ─────────────────── DATA MODEL ───────────────────
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

// ─────────────────── HOME SCREEN ───────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ── Resource Items ──
  final List<BlogArticle> articles = const [
    BlogArticle(
      category: 'BOOK',
      title: 'Ikigai: The Japanese Secret to a Long and Happy Life',
      subtitle: 'Discovering your life purpose • Hector Garcia & Francesc Miralles',
      webUrl: 'https://dn760000.eu.archive.org/0/items/ikigai-the-japanese-secret-to-a-long-and-happy-life-pdfdrive.com/Ikigai%20_%20the%20Japanese%20secret%20to%20a%20long%20and%20happy%20life%20(%20PDFDrive.com%20).pdf',
      imagePath: 'assets/images/ikigai.jpg',
    ),
    BlogArticle(
      category: 'BOOK',
      title: 'Atomic Habits: Building Good Habits & Breaking Bad Ones',
      subtitle: 'Small changes, remarkable results • James Clear',
      webUrl: 'https://ia600409.us.archive.org/26/items/atomic-habits-pdfdrive/Atomic%20habits%20(%20PDFDrive%20).pdf',
      imagePath: 'assets/images/atomic_habits.jpg',
    ),
    BlogArticle(
      category: 'BOOK',
      title: 'The Let Them Theory: Stop Wasting Energy on What You Can\'t Control',
      subtitle: 'A life-changing mindset tool • Mel Robbins',
      webUrl: 'https://www.melrobbins.com/wp-content/uploads/2025/03/LetThem_Guide_Leading_Teams.pdf',
      imagePath: 'assets/images/let_them_theory.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // Hero heading
          const Text(
            'Welcome.',
            style: TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.bold,
              height: 1.1,
              color: _primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Discover insights, resources & inspiration.',
            style: TextStyle(fontSize: 15, color: _darkText.withOpacity(0.6)),
          ),
          const SizedBox(height: 36),

          // Section title
          Text(
            'For You',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _darkText.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 16),

          // Resource cards mapping
          ...articles.map(_buildArticleCard),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // ─────────────────── ARTICLE CARD ───────────────────
  Widget _buildArticleCard(BlogArticle article) {
    return InkWell(
      onTap: () async {
        final Uri uri = Uri.parse(article.webUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _surfaceColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left thumbnail (using contain so covers never crop)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                article.imagePath,
                width: 90,
                height: 120,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 90,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0D8EB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(Icons.image_not_supported_outlined, size: 32, color: _primary),
                  ),
                ),
              ),
            ),

            // Right text content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: const BoxDecoration(
                        color: _accentTint,
                        borderRadius: _pill,
                      ),
                      child: Text(
                        article.category,
                        style: const TextStyle(
                          color: _primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Title
                    Text(
                      article.title,
                      style: const TextStyle(
                        color: _darkText,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),

                    // Subtitle
                    Text(
                      article.subtitle,
                      style: TextStyle(
                        color: _darkText.withOpacity(0.55),
                        fontSize: 12,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}