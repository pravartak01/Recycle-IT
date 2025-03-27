import 'package:e_waste_app/screens/Home%20Screen/home_screen.dart';
import 'package:e_waste_app/screens/LocationScreen/recycle_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../Community Screen/community_screen.dart';
import 'learn_screen_videos.dart';
import 'learn_screen_articles.dart';
import 'learn_screen_17goals.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({Key? key}) : super(key: key);

  @override
  _LearnScreenState createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _showTabs = false;
  late AnimationController _animationController;
  bool _isControllerInitialized = false;
  int _currentIndex = 2; // Highlight Learn tab (index 2)

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController.addListener(_handleScroll);
    _animationController = AnimationController(
      vsync: this, // Now using the correct vsync provider
      duration: const Duration(milliseconds: 500),
    );
    _isControllerInitialized = true;
  }

  void _handleScroll() {
    final shouldShow = _scrollController.offset > 50;
    if (shouldShow != _showTabs) {
      setState(() => _showTabs = shouldShow);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildHeader() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[800]!, Colors.teal[400]!],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -50,
            top: -20,
            child: Icon(Icons.recycling, size: 150, color: Colors.white.withOpacity(0.1)),
          ),
          Positioned(
            left: -30,
            bottom: -30,
            child: Icon(Iconsax.electricity, size: 150, color: Colors.white.withOpacity(0.1)),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'E-Waste Education',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2),
                const SizedBox(height: 8),
                Text(
                  'Learn how to properly dispose and recycle electronic waste',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ).animate(delay: 200.ms).fadeIn(duration: 500.ms).slideY(begin: 0.2),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicatorColor: Colors.green[700],
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: Colors.green[700],
        unselectedLabelColor: Colors.grey[600],
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        tabs: const [
          Tab(
            icon: Icon(Iconsax.video_play, size: 22),
            text: 'Video Guides',
          ),
          Tab(
            icon: Icon(Iconsax.document_text, size: 22),
            text: 'Articles',
          ),
          Tab(
            icon: Icon(Iconsax.global, size: 22),
            text: '17SDG',
          ),
        ],
      ),
    );
  }

  void _handleNavigation(int index) {
    if (index == _currentIndex) return; // Don't reload if already on this tab

    setState(() => _currentIndex = index);

    if (_isControllerInitialized) {
      _animationController.reset();
      _animationController.forward();
    }

    switch (index) {
      case 0:
    MaterialPageRoute(builder: (context) =>  HomeScreen());
    break;
      case 1:
    Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) =>  RecyclersScreen()));
    break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LearnScreen()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  CommunityScreen()),
        );

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Colors.white,
                onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
              ),
              expandedHeight: 200,
              pinned: true,
              floating: false,
              backgroundColor: Colors.green[700],
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: _buildHeader(),
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(_showTabs ? 48 : 0),
                child: AnimatedOpacity(
                  opacity: _showTabs ? 1.0 : 0.0,
                  duration: 300.ms,
                  child: _buildTabBar(),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children:  [
            VideosScreen(),
            ArticlesScreen(),
            GoalsScreen(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SalomonBottomBar(
            currentIndex: _currentIndex,
            onTap: _handleNavigation,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            items: [
              SalomonBottomBarItem(
                icon: const Icon(Icons.home_outlined, size: 26),
                activeIcon: const Icon(Icons.home, size: 26),
                title: const Text("Home"),
                selectedColor: const Color(0xFF4CAF50),
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.location_on_outlined, size: 26),
                activeIcon: const Icon(Icons.location_on, size: 26),
                title: const Text("Location"),
                selectedColor: const Color(0xFF4CAF50),
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.menu_book_outlined, size: 26),
                activeIcon: const Icon(Icons.menu_book, size: 26),
                title: const Text("Learn"),
                selectedColor: const Color(0xFF4CAF50),
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.people_outline, size: 25),
                activeIcon: const Icon(Icons.people, size: 25),
                title: const Text("Community"),
                selectedColor: const Color(0xFF4CAF50),
              ),
            ],
          ),
        ],
      ),
    );
  }
}