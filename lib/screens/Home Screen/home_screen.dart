import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_waste_app/UiHelper/snackbar_message.dart';
import 'package:e_waste_app/screens/Home%20Screen/profile_screen.dart';
import 'package:e_waste_app/screens/Home%20Screen/schedule_pickup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Community Screen/community_screen.dart';
import '../LocationScreen/recycle_screen.dart';
import '../learnscreen/learn_screen.dart';
import 'app_bar.dart';
import 'notification_screen.dart';
import 'your_impact.dart';
import '../../widgets/pickup_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'previous_recycle_section.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic>? newDevice;

  const HomeScreen({Key? key, this.newDevice}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final User? user = FirebaseAuth.instance.currentUser;

  late final String displayName;
  late final String email;
  late final String photoURL;

  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;
  int _currentIndex = 0;
  late AnimationController _animationController;
  bool _isControllerInitialized = false;

String getFirstTwoLetters(String name) {
  return name.length >= 2 ? name.substring(0, 2) : name; 
}


  Widget _buildProfileAvatar() {
    return GestureDetector(
      onTap: _onProfileTap,
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.blue, // Background color
        child: Text(
          getFirstTwoLetters(displayName), // User initials
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Sample data for the impact section
  final double _totalEWasteRecycled = 75.6; // kg
  final int _treesSaved = 12;
  final double _waterSaved = 4550.0; // liters
  final double _energySaved = 341.5; // kWh
  final double _co2Reduced = 125.8; // kg

  // Sample data for previous recycles
  final List<RecycleOrder> _previousOrders = [
    RecycleOrder(
      orderId: '8742',
      dateTime: DateTime.now().subtract(const Duration(days: 5)),
      status: 'Completed',
      recycledItems: [
        RecycledItem(name: 'iPhone 11', type: 'phone'),
        RecycledItem(name: 'Samsung TV', type: 'tv'),
      ],
      amountEarned: 1250.00,
      review: OrderReview(
        rating: 4.5,
        comment:
            'Great service! The pickup agent was very professional and on time.',
      ),
    ),
  ];

  Future<void> fetchDevices(String userId) async {
  try {
    CollectionReference recyclingHistory = FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('RecyclingHistory');

    QuerySnapshot querySnapshot = await recyclingHistory.get();

    List<Map<String, dynamic>> fetchedDevices = querySnapshot.docs.map((doc) {
      return doc.data() as Map<String, dynamic>; 
    }).toList();

    // ✅ Update state
    setState(() {
      _devices.clear();
      _devices.addAll(fetchedDevices);
    });

    print("Devices loaded successfully!");
  } catch (e) {
    showSnackBar(context,"Error fetching devices: $e",false);
  }
}

  // List to store all devices
  List<Map<String, dynamic>> _devices = [];

  @override
  void initState() {
    super.initState();
    displayName = user?.displayName ?? 'User';
    email = user?.email ?? 'No email';
    photoURL = user?.photoURL ?? '';
    _scrollController.addListener(_onScroll);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
      setState(() {});
    });
    _isControllerInitialized = true;

    // Add the new device if it exists
    if (widget.newDevice != null) {
      _devices.add(widget.newDevice!);
    }

      if (user != null) {
    fetchDevices(user!.uid);
  }
    // Add sample data
    // _devices.addAll([
    //   {
    //     'deviceType': 'iPhone 11',
    //     'brand': 'Apple',
    //     'condition': 'Working',
    //     'age': 'Less than 1 year',
    //     'address': '123 Main St, City',
    //     'mobile': '9876543210',
    //     'date': DateFormat(
    //       'yyyy-MM-dd',
    //     ).format(DateTime.now().add(Duration(days: 2))),
    //     'time': '10:00 AM',
    //     'status': 'Scheduled',
    //     'dateAdded': DateTime.now().subtract(Duration(days: 1)).toString(),
    //   },
    // ]);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  void _onNotificationTap() {
    print('Notification tapped');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotificationScreen()),
    );
  }

  void _onProfileTap() {
    print('Profile tapped');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileScreen()),
    );
  }

  void _navigateToPickupForm() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SchedulePickupPage()),
    );
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (_isControllerInitialized) {
      if (_animationController.status == AnimationStatus.completed) {
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
    }
  }

  Widget _buildRecentPickups() {
    if (_devices.isEmpty) return Container();

    // Sort by date added (newest first)
    _devices.sort(
      (a, b) => DateTime.parse(
        b['dateAdded'],
      ).compareTo(DateTime.parse(a['dateAdded'])),
    );

    return AnimationLimiter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Text(
              'Recent Pickups',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _devices.length,
            itemBuilder: (context, index) {
              final device = _devices[index];
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 500),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(child: _buildDeviceCard(device)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceCard(Map<String, dynamic> device) {
    return Card(
      margin: EdgeInsets.fromLTRB(16, 8, 16, 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  device['deviceType'],
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color:
                        device['status'] == 'Scheduled'
                            ? Colors.blue.withOpacity(0.1)
                            : Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    device['status'],
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color:
                          device['status'] == 'Scheduled'
                              ? Colors.blue
                              : Colors.green,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              '${device['brand']} • ${device['condition']} • ${device['age']}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 12),
            Divider(height: 1, color: Colors.grey.shade200),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  'Pickup: ${device['date']} at ${device['time']}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    device['address'],
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone, size: 16, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  device['mobile'],
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                expandedHeight: 150.0,
                collapsedHeight: 60.0,
                pinned: true,
                flexibleSpace: CollapsibleAppBar(
                  userName: displayName,
                  appName: 'Recycle\'IT\'',
                  userPoints: 1200,
                  userStreak: 7,
                  isCollapsed: _scrollOffset > 60,
                  scrollController: _scrollController,
                  onNotificationTap: _onNotificationTap,
                  onProfileTap: _onProfileTap,
                  scrollOffset: _scrollOffset,
                  profileWidget: _buildProfileAvatar(),
                ),
              ),
              SliverToBoxAdapter(
                child: YourImpactSection(
                  totalEWasteRecycled: _totalEWasteRecycled,
                  treesSaved: _treesSaved,
                  waterSaved: _waterSaved,
                  energySaved: _energySaved,
                  co2Reduced: _co2Reduced,
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 32, 10, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.recycling,
                            color: Color(0xFF10B981),
                            size: 24,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Ready to recycle your e-waste?',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        'We\'ll pick up your electronics from your doorstep',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.07),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: SchedulePickupButton(
                            onPressed: _navigateToPickupForm,
                            width: MediaQuery.of(context).size.width * 0.9,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 16),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 18,
                              color: Colors.black54,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Earn rewards with each recycling pickup',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 32, bottom: 8),
                        child: Divider(
                          color: Colors.grey.withOpacity(0.3),
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(child: _buildRecentPickups()),
              SliverToBoxAdapter(
                child: PreviousRecyclesSection(previousOrders: _previousOrders),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Container(
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
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });

                // Ensure the animation runs if initialized
                if (_isControllerInitialized) {
                  _animationController.reset();
                  _animationController.forward();
                }

                // Navigate to respective screens
                switch (index) {
                  case 1:
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecyclersScreen(),
                      ),
                    );
                    break;
                  case 2:
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LearnScreen()),
                    );
                    break;
                  case 3:
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommunityScreen(),
                      ),
                    );
                    break;
                }
              },
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
      ),
    );
  }
}
