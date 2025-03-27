import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:confetti/confetti.dart';
import 'package:lottie/lottie.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Color scheme
  final Color primaryGreen = const Color(0xFF4CAF50);
  final Color accentGreen = const Color(0xFF8BC34A);
  final Color backgroundColor = Colors.white;
  final Color textDarkColor = const Color(0xFF2E7D32);
  final Color textLightColor = const Color(0xFF81C784);

  // Confetti controller
  late final ConfettiController _confettiController;
  bool _isControllerInitialized = false;

  // Mock notification data with Indian context
  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'Recycling Milestone!',
      'message': 'You recycled 5kg paper in Mumbai - equivalent to saving 17 trees! 🌳',
      'details': 'Your recent recycling at Andheri collection center earned you 50 points. '
          'This helps reduce landfill waste and supports local recycling initiatives.',
      'time': DateTime.now().subtract(const Duration(minutes: 15)),
      'icon': Icons.recycling,
      'read': false,
      'reward': true,
    },
    {
      'title': 'Clean Delhi Challenge',
      'message': 'Join 500+ Delhiites in the monthly cleanliness drive',
      'details': 'Starts tomorrow at 7 AM in Connaught Place. Earn double points and '
          'special badges for participation. Refreshments provided to all volunteers.',
      'time': DateTime.now().subtract(const Duration(hours: 2)),
      'icon': Icons.emoji_events,
      'read': false,
      'reward': false,
    },
    {
      'title': 'E-Waste Special',
      'message': '10% extra points for e-waste recycling in Bangalore',
      'details': 'Special offer valid at all Bangalore centers till month-end. '
          'Proper e-waste recycling prevents toxic chemicals from polluting our soil and water.',
      'time': DateTime.now().subtract(const Duration(days: 1)),
      'icon': Icons.local_offer,
      'read': true,
      'reward': false,
    },
    {
      'title': 'Community Impact',
      'message': 'Your recycling planted 10 trees in Chennai!',
      'details': 'Thanks to your efforts, we\'ve partnered with Green Chennai '
          'to plant native saplings in Adyar Eco Park. Track their growth in the app.',
      'time': DateTime.now().subtract(const Duration(days: 3)),
      'icon': Icons.people,
      'read': true,
      'reward': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: 3.seconds);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => _isControllerInitialized = true);
      }
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _showNotificationDetails(BuildContext context, Map<String, dynamic> notification) {
    if (notification['reward'] == true && !notification['read']) {
      _confettiController.play();
    }

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      ),
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            Container(
                width: 60,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                 ),
                 SizedBox(height: 20),

                if (notification['reward'] == true)

            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: primaryGreen.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(notification['icon'], color: primaryGreen),
            ),
            const SizedBox(height: 16),
            Text(
              notification['title'],
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textDarkColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              DateFormat('MMM dd, hh:mm a').format(notification['time']),
              style: TextStyle(color: textLightColor),
            ),
            const SizedBox(height: 20),
            Text(
              notification['details'],
              style: const TextStyle(fontSize: 16, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text('Got it!'),
            ),
          ],
        ),
      ),
    ).then((_) => _confettiController.stop());
  }

  void _markAsRead(int index) {
    setState(() => notifications[index]['read'] = true);
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in notifications) {
        notification['read'] = true;
      }
    });
  }

  Widget _buildStatItem(IconData icon, String text, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ).animate().scale(delay: 200.ms);
  }

  Widget _buildNotificationCard(BuildContext context, int index) {
    final notification = notifications[index];
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: notification['read'] ? 1 : 3,
      color: notification['read'] ? Colors.grey[50] : backgroundColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          _markAsRead(index);
          _showNotificationDetails(context, notification);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: notification['reward']
                      ? Colors.amber.withOpacity(0.2)
                      : primaryGreen.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  notification['icon'],
                  color: notification['reward'] ? Colors.amber : primaryGreen,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification['title'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: textDarkColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        if (!notification['read'])
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: accentGreen,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification['message'],
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: textLightColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('MMM dd, hh:mm a').format(notification['time']),
                          style: TextStyle(
                            fontSize: 12,
                            color: textLightColor,
                          ),
                        ),
                        if (notification['reward'])
                          const Spacer(),
                        if (notification['reward'])
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 14,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Reward',
                                  style: TextStyle(
                                    color: Colors.amber[800],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate()
        .fadeIn(delay: (100 * index).ms)
        .slideX(begin: 0.2, curve: Curves.easeOutQuart);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 100,
                floating: false,
                pinned: true,
                backgroundColor: primaryGreen,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.white),
                    onPressed: _markAllAsRead,
                    tooltip: 'Mark all as read',
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'Notifications',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  centerTitle: true,
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryGreen, accentGreen],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),

                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem(Icons.markunread, '3 Unread', Colors.white),
                      _buildStatItem(Icons.celebration, '2 Rewards', Colors.amber),
                      _buildStatItem(Icons.calendar_month, '12 This Month', Colors.white),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildNotificationCard(context, index),
                  childCount: notifications.length,
                ),
              ),
            ],
          ),
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors:  [primaryGreen, accentGreen, Colors.white],
            numberOfParticles: 20,
            gravity: 0.1,
          ),
        ],
      ),
    );
  }
}