import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';

class VideosScreen extends StatefulWidget {
  @override
  _VideosScreenState createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  YoutubePlayerController? _controller;

  final List<Map<String, dynamic>> videos = [
    {
      'id': 'x8_pNQZstvE',
      'title': 'E-Waste Management in India',
      'channel': 'YouTube Channel Name',
      'views': '1.2M views',
      'duration': '10:15',
      'icon': Iconsax.buildings,
    },
    {
      'id': '_P0CGYiDICw',
      'title': 'E-waste Management in India: Regulatory Measures and Initiatives',
      'channel': 'YouTube Channel Name',
      'views': '850K views',
      'duration': '12:30',
      'icon': Iconsax.document,
    },
    {
      'id': 'KxGbqRF3-_0',
      'title': 'How India wants to (literally) fix e-waste',
      'channel': 'DW Planet A',
      'views': '1.1M views',
      'duration': '12:34',
      'icon': Iconsax.recovery_convert,
    },
    {
      'id': 'Y-VZ-7ZiOyk',
      'title': 'The Biggest Opportunity in India: E-Waste Recycling | Huladek',
      'channel': 'YouTube Channel Name',
      'views': '900K views',
      'duration': '15:45',
      'icon': Iconsax.activity,
    },
    {
      'id': 'zKqtVUZ1y6A',
      'title': 'E-Waste Management in India and related laws',
      'channel': 'YouTube Channel Name',
      'views': '300K views',
      'duration': '18:45',
      'icon': Iconsax.document,
    },
    {
      'id': 'V3o1wWUi5Bw',
      'title': 'E-Waste Management Business | Training & Technology',
      'channel': 'YouTube Channel Name',
      'views': '1.5M views',
      'duration': '20:10',
      'icon': Iconsax.chart,
    },
    {
      'id': 'xd2GVSfi1ps',
      'title': 'E-waste: Sources, Composition and Characteristics',
      'channel': 'YouTube Channel Name',
      'views': '700K views',
      'duration': '9:50',
      'icon': Iconsax.info_circle,
    },
    {
      'id': 'pvPI6PK8k7o',
      'title': 'Waste Experts on solving India\'s Garbage Problem, Health Risks of Waste',
      'channel': 'YouTube Channel Name',
      'views': '600K views',
      'duration': '14:20',
      'icon': Iconsax.profile_2user,
    },
    {
      'id': 'ntLP4QNG-Ow',
      'title': 'E-Waste Management Rules, 2022 (as amended)',
      'channel': 'YouTube Channel Name',
      'views': '400K views',
      'duration': '11:30',
      'icon': Iconsax.document,
    },
    {
      'id': '4IPFprhIOws',
      'title': 'FAQ on E-waste license',
      'channel': 'YouTube Channel Name',
      'views': '500K views',
      'duration': '8:45',
      'icon': Icons.question_mark,
    },
  ];

  @override
  void dispose() {
    _controller?.dispose(); // Dispose the controller when not needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Learn Through Videos',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2),
                  SizedBox(height: 8),
                  Text(
                    'Watch educational content about e-waste management in India',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildSearchBar(),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final video = videos[index];
                return _buildVideoCard(video);
              },
              childCount: videos.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search e-waste videos...',
          prefixIcon: Icon(Iconsax.search_normal, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        ),
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2);
  }

  Widget _buildVideoCard(Map<String, dynamic> video) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showVideoDialog(video),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    child: Container(
                      color: Colors.grey[200],
                      height: 180,
                      child: Image.network(
                        'https://img.youtube.com/vi/${video['id']}/hqdefault.jpg',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        video['duration'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.green[700],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(video['icon'], size: 20, color: Colors.white),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${video['channel']} • ${video['views']}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showVideoDialog(Map<String, dynamic> video) {
    _controller = YoutubePlayerController(
      initialVideoId: video['id'],
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        hideControls: false,
      ),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: AspectRatio(
            aspectRatio: 16 / 9,
            child: YoutubePlayer(
              controller: _controller!,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.green[700],
            ),
          ),
        );
      },
    ).then((_) {
      _controller?.pause();
    });
  }
}
