import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class PreviousRecyclesSection extends StatelessWidget {
  final List<RecycleOrder> previousOrders;

  const PreviousRecyclesSection({Key? key, required this.previousOrders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Show only the first order initially
    final initialOrders = previousOrders.take(1).toList();
    final bool showSeeAllButton = previousOrders.isNotEmpty;

    // Height for one RecycleOrderCard
    final double cardHeight = 400; // Approximate height of one RecycleOrderCard

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Text(
            'Previous Recycles',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32), // Dark green color
            ),
          ),
        ),
        const SizedBox(height: 16), // Add spacing below the title
        previousOrders.isEmpty
            ? const Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Column(
              children: [
                Icon(
                  Icons.recycling,
                  size: 64,
                  color: Color(0xFFAED581), // Light green color
                ),
                SizedBox(height: 16),
                Text(
                  'No recycling history yet',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Your past recycling orders will appear here',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        )
            : Column(
          children: [
            // Display only one order
            SizedBox(
              height: cardHeight, // Height for one card
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: initialOrders.length,
                itemBuilder: (context, index) {
                  return RecycleOrderCard(order: initialOrders[index]);
                },
              ),
            ),
            // Show "See All" button if there are orders
            if (showSeeAllButton)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      // Navigate to a new screen to show all orders
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllRecyclesPage(previousOrders: previousOrders),
                        ),
                      );
                    },
                    child: Text(
                      'See All (${previousOrders.length})',
                      style: const TextStyle(
                        color: Color(0xFF2E7D32),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class RecycleOrderCard extends StatelessWidget {
  final RecycleOrder order;

  const RecycleOrderCard({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE8F5E9), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with order ID and date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.orderId}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    order.status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Date and time
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  DateFormat('MMMM dd, yyyy • hh:mm a').format(order.dateTime),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Devices recycled
            const Text(
              'Recycled Items',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: order.recycledItems.map((item) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _getDeviceIcon(item.type),
                      const SizedBox(width: 6),
                      Text(
                        item.name,
                        style: const TextStyle(
                          color: Color(0xFF2E7D32),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Earnings
            Row(
              children: [
                const Icon(
                  Icons.attach_money,
                  color: Color(0xFF66BB6A),
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'You earned: ',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                Text(
                  '₹${order.amountEarned.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF66BB6A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Timeline
            const Text(
              'Order Progress',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 8),
            _buildTimeline(order),
            const SizedBox(height: 16),

            // User review
            if (order.review != null) ...[
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                'Your Review',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  RatingBarIndicator(
                    rating: order.review!.rating,
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 20.0,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    order.review!.rating.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              if (order.review!.comment.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '"${order.review!.comment}"',
                    style: const TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ] else if (order.status == 'Completed') ...[
              const Divider(),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () {
                  // Add your review functionality here
                },
                icon: const Icon(Icons.rate_review, size: 16),
                label: const Text('Add Your Review'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF2E7D32),
                  side: const BorderSide(color: Color(0xFF2E7D32)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline(RecycleOrder order) {
    final List<String> stages = [
      'Order Placed',
      'Pickup Scheduled',
      'Pickup in Progress',
      'Items Collected',
      'Recycling in Progress',
      'Completed'
    ];

    // Find the current stage index
    int currentStageIndex = stages.indexOf(order.status);
    if (currentStageIndex == -1) currentStageIndex = 0;

    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: stages.length,
        itemBuilder: (context, index) {
          bool isActive = index <= currentStageIndex;
          bool isLast = index == stages.length - 1;

          return Container(
            width: 100,
            child: TimelineTile(
              axis: TimelineAxis.horizontal,
              alignment: TimelineAlign.center,
              isFirst: index == 0,
              isLast: isLast,
              indicatorStyle: IndicatorStyle(
                width: 20,
                height: 20,
                indicator: Container(
                  decoration: BoxDecoration(
                    color: isActive ? const Color(0xFF66BB6A) : Colors.grey.shade300,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isActive ? const Color(0xFF43A047) : Colors.grey.shade400,
                      width: 2,
                    ),
                  ),
                  child: isActive
                      ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 12,
                  )
                      : null,
                ),
              ),
              beforeLineStyle: LineStyle(
                color: isActive ? const Color(0xFF66BB6A) : Colors.grey.shade300,
                thickness: 2,
              ),
              afterLineStyle: LineStyle(
                color: index < currentStageIndex ? const Color(0xFF66BB6A) : Colors.grey.shade300,
                thickness: 2,
              ),
              endChild: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  stages[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    color: isActive ? const Color(0xFF2E7D32) : Colors.grey,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Order Placed':
        return Colors.blue;
      case 'Pickup Scheduled':
        return Colors.orange;
      case 'Pickup in Progress':
        return Colors.purple;
      case 'Items Collected':
        return Colors.teal;
      case 'Recycling in Progress':
        return Colors.indigo;
      case 'Completed':
        return const Color(0xFF43A047); // Green
      default:
        return Colors.grey;
    }
  }

  Widget _getDeviceIcon(String type) {
    IconData iconData;
    switch (type) {
      case 'phone':
        iconData = Icons.smartphone;
        break;
      case 'laptop':
        iconData = Icons.laptop;
        break;
      case 'tablet':
        iconData = Icons.tablet_android;
        break;
      case 'tv':
        iconData = Icons.tv;
        break;
      case 'battery':
        iconData = Icons.battery_full;
        break;
      case 'appliance':
        iconData = Icons.kitchen;
        break;
      default:
        iconData = Icons.devices_other;
    }

    return Icon(iconData, size: 16, color: const Color(0xFF2E7D32));
  }
}

// Models
class RecycleOrder {
  final String orderId;
  final DateTime dateTime;
  final String status;
  final List<RecycledItem> recycledItems;
  final double amountEarned;
  final OrderReview? review;

  RecycleOrder({
    required this.orderId,
    required this.dateTime,
    required this.status,
    required this.recycledItems,
    required this.amountEarned,
    this.review,
  });
}

class RecycledItem {
  final String name;
  final String type;

  RecycledItem({
    required this.name,
    required this.type,
  });
}

class OrderReview {
  final double rating;
  final String comment;

  OrderReview({
    required this.rating,
    required this.comment,
  });
}

// Page to Display All Recycles
class AllRecyclesPage extends StatelessWidget {
  final List<RecycleOrder> previousOrders;

  const AllRecyclesPage({Key? key, required this.previousOrders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Previous Recycles'),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: previousOrders.length,
        itemBuilder: (context, index) {
          return RecycleOrderCard(order: previousOrders[index]);
        },
      ),
    );
  }
}

// Example Usage
class PreviousRecyclesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Example data
    final List<RecycleOrder> previousOrders = [
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
          comment: 'Great service! The pickup agent was very professional and on time.',
        ),
      ),
      RecycleOrder(
        orderId: '7563',
        dateTime: DateTime.now().subtract(const Duration(days: 12)),
        status: 'Recycling in Progress',
        recycledItems: [
          RecycledItem(name: 'Dell Laptop', type: 'laptop'),
          RecycledItem(name: 'Old Microwave', type: 'appliance'),
          RecycledItem(name: 'Sony Headphones', type: 'devices_other'),
        ],
        amountEarned: 850.00,
      ),
      RecycleOrder(
        orderId: '6924',
        dateTime: DateTime.now().subtract(const Duration(days: 30)),
        status: 'Completed',
        recycledItems: [
          RecycledItem(name: 'iPad Pro', type: 'tablet'),
          RecycledItem(name: 'Car Batteries (3)', type: 'battery'),
        ],
        amountEarned: 720.00,
        review: OrderReview(
          rating: 5.0,
          comment: 'Excellent service and great app! Love how easy it is to recycle and earn money.',
        ),
      ),
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            PreviousRecyclesSection(previousOrders: previousOrders),
          ],
        ),
      ),
    );
  }
}