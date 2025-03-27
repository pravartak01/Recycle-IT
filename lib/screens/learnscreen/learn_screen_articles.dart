import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:share_plus/share_plus.dart';

class ArticlesScreen extends StatefulWidget {
  @override
  _ArticlesScreenState createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  List<Map<String, dynamic>> articles = [
    {
      'id': '1',
      'title': 'India\'s E-Waste Crisis: Challenges & Solutions',
      'summary': 'How India is tackling its growing e-waste problem with innovative recycling methods',
      'readTime': '8 min read',
      'category': 'Policy',
      'likes': 1200,
      'isLiked': false,
      'isSaved': false,
      'icon': Iconsax.building_3,
      'color': Colors.blue,
      'content': 'Detailed content about India\'s e-waste policy...',
    },
    {
      'id': '2',
      'title': 'Bengaluru Startups Turning E-Waste into Gold',
      'summary': 'Meet the entrepreneurs extracting precious metals from discarded electronics',
      'readTime': '6 min read',
      'category': 'Innovation',
      'likes': 856,
      'isLiked': false,
      'isSaved': false,
      'icon': Iconsax.activity,
      'color': Colors.green,
      'content': 'Detailed content about Bengaluru startups...',
    },
    {
      'id': '3',
      'title': 'The Dark Side of Delhi\'s E-Waste Market',
      'summary': 'Investigative report on the informal sector handling 90% of India\'s e-waste',
      'readTime': '12 min read',
      'category': 'Expose',
      'likes': 2300,
      'isLiked': false,
      'isSaved': false,
      'icon': Iconsax.warning_2,
      'color': Colors.orange,
      'content': 'Detailed content about Delhi\'s e-waste market...',
    },
  ];

  bool _showSavedOnly = false;

  @override
  Widget build(BuildContext context) {
    final displayedArticles = _showSavedOnly
        ? articles.where((article) => article['isSaved'] == true).toList()
        : articles;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('E-Waste Knowledge Hub'),
        actions: [
          IconButton(
            icon: Icon(_showSavedOnly ? Iconsax.book_saved : Iconsax.book),
            onPressed: () {
              setState(() {
                _showSavedOnly = !_showSavedOnly;
              });
            },
            tooltip: _showSavedOnly ? 'Show All Articles' : 'Show Saved Articles',
          ),
        ],
      ),
      body: displayedArticles.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmarks_sharp, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              _showSavedOnly
                  ? 'No saved articles yet'
                  : 'No articles available',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: displayedArticles.length,
        itemBuilder: (context, index) {
          final article = displayedArticles[index];
          return _buildArticleCard(article, index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement search functionality
        },
        backgroundColor: Colors.green[700],
        child: Icon(Iconsax.search_normal, color: Colors.white),
        elevation: 4,
      ).animate().scale(delay: 300.ms),
    );
  }

  Widget _buildArticleCard(Map<String, dynamic> article, int index) {
    final isLiked = article['isLiked'] ?? false;
    final isSaved = article['isSaved'] ?? false;
    final likes = article['likes'] ?? 0;

    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            _showArticleDetail(context, article);
          },
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: (article['color'] as Color).withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(article['icon'], size: 20, color: article['color']),
                        ),
                        SizedBox(width: 8),
                        Text(
                          article['category'] ?? '',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),

                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      article['title'] ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      article['summary'] ?? '',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),

                    SizedBox(height: 16),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            isLiked ? Iconsax.like_15 : Iconsax.like_1,
                            color: isLiked ? Colors.red : Colors.grey,
                          ),
                          onPressed: () {
                            _toggleLike(article['id']);
                          },
                        ),
                        Text(likes.toString()),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Read',
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Iconsax.arrow_right_3, size: 14, color: Colors.green[700]),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: IconButton(
                  icon: Icon(
                    isSaved ? Iconsax.book_saved : Iconsax.bookmark,
                    color: isSaved ? Colors.green[700] : Colors.grey[400],
                  ),
                  onPressed: () {
                    _toggleSave(article['id']);
                  },
                ),
              ),
            ],
          ),
        ),
      ).animate(delay: (100 * index).ms).fadeIn().slideY(begin: 0.2),
    );
  }

  void _toggleLike(String articleId) {
    setState(() {
      final article = articles.firstWhere((a) => a['id'] == articleId);
      final isLiked = article['isLiked'] ?? false;
      article['isLiked'] = !isLiked;
      article['likes'] = (article['likes'] ?? 0) + (isLiked ? -1 : 1);
    });
  }

  void _toggleSave(String articleId) {
    setState(() {
      final article = articles.firstWhere((a) => a['id'] == articleId);
      article['isSaved'] = !(article['isSaved'] ?? false);
    });
  }

  void _showArticleDetail(BuildContext context, Map<String, dynamic> article) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final isLiked = article['isLiked'] ?? false;
            final isSaved = article['isSaved'] ?? false;
            final likes = article['likes'] ?? 0;

            return Container(
                height: MediaQuery.of(context).size.height * 0.85,
            decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
            children: [
            Padding(
            padding: EdgeInsets.all(16),
            child: Row(
            children: [
            IconButton(
            icon: Icon(Iconsax.arrow_left),
            onPressed: () => Navigator.pop(context),
            ),
            Text(
            'Article Details',
            style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            ),
            ),
            Spacer(),
            IconButton(
            icon: Icon(Iconsax.share, color: Colors.grey[600]),
            onPressed: () {
            Share.share(
            '${article['title']}\n\n${article['summary']}\n\nRead more about e-waste solutions!',
            );
            },
            ),
            IconButton(
            icon: Icon(
            isSaved ? Iconsax.book_saved : Iconsax.bookmark,
            color: isSaved ? Colors.green[700] : Colors.grey[600],
            ),
            onPressed: () {
            setModalState(() {
            _toggleSave(article['id']);
            });
            },
            ),
            ],
            ),
            ),
            Expanded(
            child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Container(
            height: 200,
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey[200],
            image: DecorationImage(
            image: NetworkImage(
            'https://source.unsplash.com/random/600x400/?ewaste,recycling',
            ),
            fit: BoxFit.cover,
            ),
            ),
            ),
            SizedBox(height: 20),
            Text(
            article['category'] ?? '',
            style: TextStyle(
            color: article['color'],
            fontWeight: FontWeight.w500,
            ),
            ),
            SizedBox(height: 8),
            Text(
            article['title'] ?? '',
            style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            ),
            ),
            SizedBox(height: 16),
            Row(
            children: [
            CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(
            'https://ui-avatars.com/api/?name=Eco+India&background=random',
            ),
            ),
            SizedBox(width: 8),
            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(
            'Eco India News',
            style: TextStyle(
            fontWeight: FontWeight.w500,
            ),
            ),
            Text(
            'Published 2 days ago • ${article['readTime']}',
            style: TextStyle(
            color: Colors.grey[500],
            fontSize: 12,
            ),
            ),
            ],
            ),
            Spacer(),
            IconButton(
            icon: Icon(
            isLiked ? Iconsax.like_15 : Iconsax.like_1,
            color: isLiked ? Colors.red : Colors.grey,
            ),
            onPressed: () {
            setModalState(() {
            _toggleLike(article['id']);
            });
            },
            ),
            Text(likes.toString()),
            ],
            ),
            SizedBox(height: 24),
            Text(
            article['content'] ?? '',
            style: TextStyle(
            fontSize: 16,
            height: 1.6,
            ),
            ),
            SizedBox(height: 40),
            ],
            ),
            ),
            ),
            Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
            BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
            ),
            ],
            ),
            child: Row(
            children: [
            Expanded(
            child: ElevatedButton.icon(
            icon: Icon(Iconsax.bookmark),
            label: Text(isSaved ? 'Saved' : 'Save for Later'),
            style: ElevatedButton.styleFrom(
            iconColor: isSaved
            ? Colors.green[50]
                : Colors.grey[100],
              foregroundColor : isSaved
            ? Colors.green[700]
                : Colors.grey[800],
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () {
            setModalState(() {
            _toggleSave(article['id']);
            });
            },
            ),
            ),
            SizedBox(width: 12),
            Expanded(
            child: ElevatedButton.icon(
            icon: Icon(Iconsax.share),
            label: Text('Share'),
            style: ElevatedButton.styleFrom(
            iconColor: Colors.green[700],
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () {
            Share.share(
            '${article['title']}\n\n${article['summary']}\n\nRead more about e-waste solutions!',
            );
            },
            ),
            ),
            ],
            ),
            ),
            ],
            ),
            );

          },
        );
      },
    );
  }
}