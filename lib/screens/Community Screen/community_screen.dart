
import 'package:e_waste_app/screens/LocationScreen/recycle_screen.dart';
import 'package:e_waste_app/screens/learnscreen/learn_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../Home Screen/home_screen.dart';

class CommunityScreen extends StatefulWidget {
  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> with TickerProviderStateMixin {
  int _currentTab = 0; // 0=Global, 1=Local, 2=You
  final _pageController = PageController();
  bool _showImpactDetails = false;
  late AnimationController _animationController;
  bool _isControllerInitialized = false;
  int _currentIndex = 3;

  final List<Map<String, dynamic>> _globalStats = [
    {
      'value': '2.4M',
      'label': 'Devices recycled',
      'icon': Iconsax.cpu,
      'impact': 'Saves 12M kg CO2 emissions',
      'comparison': 'Equivalent to 2,600 cars off the road'
    },
    {
      'value': '18K',
      'label': 'Toxics prevented',
      'icon': Iconsax.warning_2,
      'impact': 'Protected 450 acres of water',
      'comparison': 'Like 340 Olympic pools'
    },
    {
      'value': '4.2B',
      'label': 'kWh saved',
      'icon': Iconsax.flash,
      'impact': 'Powers 400,000 homes',
      'comparison': 'For an entire year'
    },
    {
      'value': '1.8M',
      'label': 'Pounds of metals',
      'icon': Iconsax.box,
      'impact': 'Gold, silver, copper recovered',
      'comparison': 'Worth \$62M in materials'
    },
  ];

  final List<Map<String, dynamic>> _localHeroes = [
    {
      'name': 'Sarah K.',
      'devices': 42,
      'distance': '0.5 mi',
      'streak': 28,
      'badges': ['gold', 'silver']
    },
    {
      'name': 'Mike T.',
      'devices': 35,
      'distance': '1.2 mi',
      'streak': 14,
      'badges': ['silver']
    },
    {
      'name': 'Green School',
      'devices': 127,
      'distance': '0.8 mi',
      'streak': 56,
      'badges': ['gold', 'platinum']
    },
  ];

  final List<Map<String, dynamic>> _recentActivities = [
    {
      'user': 'EcoCenter',
      'action': 'collected 250 devices',
      'time': '2 hours ago',
      'icon': Iconsax.buildings
    },
    {
      'user': 'Recycle Rally',
      'action': 'event happening tomorrow',
      'time': '5 hours ago',
      'icon': Iconsax.calendar
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_handlePageChange);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _isControllerInitialized = true;
  }

  void _handlePageChange() {
    final page = _pageController.page;
    if (page != null) {
      setState(() => _currentTab = page.round());
    }
  }
  @override
  void dispose() {
    _pageController.removeListener(_handlePageChange);
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }
  void _handleNavigation(int index) {
    if (index == _currentIndex) return;

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
        MaterialPageRoute(builder: (context) =>  RecyclersScreen());
        break;
      case 2:
        MaterialPageRoute(builder: (context) =>  LearnScreen());
        break;
      case 3:
      // Already on Community screen
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.teal,
          onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Community Impact',
          style: TextStyle(
            color: Colors.teal[800],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Tab Selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  Expanded(child: _buildTabButton('Global', 0)),
                  Expanded(child: _buildTabButton('Local', 1)),
                  Expanded(child: _buildTabButton('You', 2)),
                ],
              ),
            ),
          ),

          // Content Area
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                _buildGlobalView(),
                _buildLocalView(),
                _buildPersonalView(),
              ],
            ),
          ),
        ],
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
  Widget _buildTabButton(String label, int index) {
    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(
          index,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOutQuint,
        );
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: _currentTab == index ? Colors.teal : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: _currentTab == index ? Colors.white : Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlobalView() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Our Collective Impact',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[800],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'See how our community is making a difference worldwide',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Stats Cards
          Column(
            children: _globalStats.map((stat) => Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: _buildLargeStatCard(
                stat['value']?.toString() ?? 'N/A',
                stat['label']?.toString() ?? '',
                stat['icon'],
                stat['impact']?.toString() ?? '',
              ),
            )).toList(),
          ),

          // Impact Visualization
          _buildImpactVisualization(),

          // Community Updates
          Padding(
            padding: EdgeInsets.only(top: 16, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Community Updates',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[800],
                  ),
                ),
                SizedBox(height: 12),
                Column(
                  children: _recentActivities.map((activity) => Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: _buildActivityItem(
                      activity['user']?.toString() ?? 'User',
                      activity['action']?.toString() ?? 'Action',
                      activity['time']?.toString() ?? 'Recently',
                      activity['icon'],
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLargeStatCard(String value, String label, IconData? icon, String impact) {
    return Container(
      width: double.infinity,
      height: 300,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon ?? Iconsax.info_circle,
              size: 32,
              color: Colors.teal,
            ),
          ),
          SizedBox(height: 16),

          // Value
          Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Label
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),

          // Divider
          Divider(
            height: 24,
            thickness: 1,
            color: Colors.grey[200],
          ),

          // Impact
          Text(
            impact,
            style: TextStyle(
              fontSize: 15,
              color: Colors.teal[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImpactVisualization() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showImpactDetails = !_showImpactDetails;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Visualize Your Impact',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  _showImpactDetails ? Iconsax.arrow_up_2 : Iconsax.arrow_down_1,
                  size: 16,
                ),
              ],
            ),
            SizedBox(height: 8),
            AnimatedCrossFade(
              firstChild: Container(
                height: 120,
                child: Center(
                  child: Icon(
                    Icons.expand_circle_down_outlined,
                    size: 48,
                    color: Colors.teal,
                  ),
                ),
              ),
              secondChild: Column(
                children: [
                  Container(
                    height: 100,
                    child: Center(
                      child: Icon(
                        Iconsax.chart,
                        size: 48,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Your 18 devices helped save:',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildImpactItem('42 kg', 'CO2 reduced'),
                      _buildImpactItem('3.5g', 'Gold recovered'),
                      _buildImpactItem('1.2L', 'Toxics diverted'),
                    ],
                  ),
                ],
              ),
              crossFadeState: _showImpactDetails
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: Duration(milliseconds: 400),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImpactItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.teal[800],
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildLocalView() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Local Heroes',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[800],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'People making a difference near you',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Hero Cards
          Column(
            children: _localHeroes.map((hero) => Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: _buildLargeHeroCard(
                hero['name']?.toString() ?? 'User',
                hero['devices']?.toString() ?? '0',
                hero['distance']?.toString() ?? 'Nearby',
                (hero['streak'] as int?) ?? 0,
                (hero['badges'] as List<dynamic>?)?.cast<String>() ?? [],
              ),
            )).toList(),
          ),

          // Event Card
          _buildEventCard(),
        ],
      ),
    );
  }

  Widget _buildLargeHeroCard(String name, String devices, String distance, int streak, List<String> badges) {
    return Container(
      width: double.infinity,
      height: 120,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Stack(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: Colors.teal[100],
                child: Text(
                  name.isNotEmpty ? name.substring(0, 1) : 'U',
                  style: TextStyle(
                    color: Colors.teal[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (streak >= 7)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      '🔥',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 16),

          // Details
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    ...badges.map<Widget>((badge) {
                      Color color;
                      switch (badge) {
                        case 'gold':
                          color = Colors.amber;
                          break;
                        case 'silver':
                          color = Colors.grey;
                          break;
                        case 'platinum':
                          color = Colors.blue;
                          break;
                        default:
                          color = Colors.brown;
                      }
                      return Container(
                        margin: EdgeInsets.only(right: 4),
                        child: Icon(
                          Iconsax.star,
                          size: 16,
                          color: color,
                        ),
                      );
                    }).toList(),
                  ],
                ),
                SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Recycled ',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      TextSpan(
                        text: '$devices devices',
                        style: TextStyle(
                          color: Colors.teal[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (streak > 0) ...[
                        TextSpan(
                          text: ' • ',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                        TextSpan(
                          text: '$streak day streak',
                          style: TextStyle(
                            color: Colors.orange[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Distance
          Text(
            distance,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.only(bottom: 16),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.teal[100],
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Iconsax.calendar, size: 24, color: Colors.teal),
            Spacer(),
            Text(
              'Community Recycling Day',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal[800],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Sat, June 10 • 9AM-2PM',
              style: TextStyle(color: Colors.teal[800]),
            ),
            SizedBox(height: 4),
            Text(
              'Green Community Center',
              style: TextStyle(color: Colors.teal[800]),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('RSVP Now'),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalView() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Personal Impact
          Center(
            child: Column(
              children: [
                Container(
                  height: 180,
                  child: Icon(
                    Iconsax.medal,
                    size: 80,
                    color: Colors.teal,
                  ),
                ),
                SizedBox(height: 16),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '18',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[800],
                        ),
                      ),
                      TextSpan(
                        text: ' devices',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'recycled this year',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32),

          // Progress
          Text(
            'Your Progress',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.teal[800],
            ),
          ),
          SizedBox(height: 16),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Bronze Recycler',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '35% to Silver',
                        style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: 0.35,
                    backgroundColor: Colors.grey[200],
                    color: Colors.teal,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '7 more devices',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '≈ 2 months',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),

          // Milestones
          Text(
            'Milestones',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.teal[800],
            ),
          ),
          SizedBox(height: 16),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildMilestoneItem('First Device', true, Iconsax.like_1),
                  _buildMilestoneItem('5 Devices', true, Iconsax.star),
                  _buildMilestoneItem('Bronze Tier', true, Iconsax.medal),
                  _buildMilestoneItem('10 Devices', false, Iconsax.star),
                  _buildMilestoneItem('Silver Tier', false, Iconsax.medal_star),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),

          // Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: Icon(Iconsax.add),
              label: Text('Log New Recycling'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {},
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildMilestoneItem(String title, bool completed, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: completed ? Colors.teal : Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 14,
              color: completed ? Colors.white : Colors.grey,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: completed ? Colors.teal[800] : Colors.grey[600],
                fontWeight: completed ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Icon(
            completed ? Iconsax.tick_circle : Iconsax.clock,
            size: 16,
            color: completed ? Colors.teal : Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String user, String action, String time, IconData? icon) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.teal.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon ?? Iconsax.info_circle,
            color: Colors.teal,
            size: 24,
          ),
        ),
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: user,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: ' $action'),
            ],
          ),
        ),
        subtitle: Text(
          time,
          style: TextStyle(color: Colors.grey),
        ),
        trailing: Icon(
          Iconsax.arrow_right_3,
          size: 20,
          color: Colors.grey,
        ),
      ),
    );
  }
}