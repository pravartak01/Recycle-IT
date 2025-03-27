import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/flutter_map.dart' as flutter_maps;
import 'package:latlong2/latlong.dart' as latlong;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lottie/lottie.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../Community Screen/community_screen.dart';
import '../learnscreen/learn_screen.dart';

class RecyclersScreen extends StatefulWidget {
  const RecyclersScreen({Key? key}) : super(key: key);

  @override
  _RecyclersScreenState createState() => _RecyclersScreenState();
}

class _RecyclersScreenState extends State<RecyclersScreen> with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  List<Recycler> _filteredRecyclers = [];
  latlong.LatLng? _currentLocation;
  bool _isLoadingLocation = false;
  late AnimationController _animationController;
  bool _isControllerInitialized = false;
  int _currentIndex = 1; // Highlight Location tab (index 1)

  // Chhatrapati Sambhajinagar e-waste recyclers data
  final List<Recycler> recyclers = [
    Recycler(
      name: 'Aurangabad E-Waste Solutions',
      address: 'Jalna Road, CIDCO, Chhatrapati Sambhajinagar',
      latitude: 19.9010,
      longitude: 75.3525,
      phoneNumber: '+919876543210',
      whatsappNumber: '+919876543210',
      rating: 4.7,
      services: ['Computers', 'Mobile Phones', 'Printers'],
      workingHours: 'Mon-Sat: 9AM-7PM',
      description: 'Certified e-waste recycler with data destruction services.',
      image: 'assets/recycler1.png',
    ),
    Recycler(
      name: 'Green Earth Recycling',
      address: 'Near Seven Hills, Garkheda, Chhatrapati Sambhajinagar',
      latitude: 19.8744,
      longitude: 75.3364,
      phoneNumber: '+919765432109',
      whatsappNumber: '+919765432109',
      rating: 4.5,
      services: ['TVs', 'Monitors', 'Batteries'],
      workingHours: 'Mon-Sun: 8AM-8PM',
      description: 'Environment-friendly e-waste disposal with pickup service.',
      image: 'assets/recycler2.png',
    ),
    Recycler(
      name: 'Eco Tech Recyclers',
      address: 'Cannaught Place, Chhatrapati Sambhajinagar',
      latitude: 19.8826,
      longitude: 75.3209,
      phoneNumber: '+919654321098',
      whatsappNumber: '+919654321098',
      rating: 4.3,
      services: ['Laptops', 'Servers', 'Network Equipment'],
      workingHours: 'Mon-Fri: 10AM-6PM\nSat: 10AM-2PM',
      description: 'Specialized in corporate e-waste management solutions.',
      image: 'assets/recycler3.png',
    ),
    Recycler(
      name: 'Sambhaji Scrap Dealers',
      address: 'Gulmandi, Chhatrapati Sambhajinagar',
      latitude: 19.8943,
      longitude: 75.3417,
      phoneNumber: '+919543210987',
      whatsappNumber: '+919543210987',
      rating: 4.0,
      services: ['Home Appliances', 'Wires', 'Electronic Scrap'],
      workingHours: 'Mon-Sat: 8AM-7PM',
      description: 'Buying all types of electronic scrap at best prices.',
      image: 'assets/recycler4.png',
    ),
    Recycler(
      name: 'Tech Disposal Center',
      address: 'Satara Parisar, Chhatrapati Sambhajinagar',
      latitude: 19.8678,
      longitude: 75.3542,
      phoneNumber: '+919432109876',
      whatsappNumber: '+919432109876',
      rating: 4.2,
      services: ['Office Equipment', 'UPS', 'Inverters'],
      workingHours: 'Mon-Sun: 9AM-9PM',
      description: 'Safe disposal of electronic equipment with certificate.',
      image: 'assets/recycler5.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _filteredRecyclers = recyclers;
    _determinePosition();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _isControllerInitialized = true;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _determinePosition() async {
    setState(() {
      _isLoadingLocation = true;
    });

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await openAppSettings();
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentLocation = latlong.LatLng(position.latitude, position.longitude);
      _isLoadingLocation = false;
      _mapController.move(_currentLocation!, 14.0);
    });
  }

  void _filterRecyclers(String query) {
    setState(() {
      _filteredRecyclers = recyclers.where((recycler) {
        return recycler.name.toLowerCase().contains(query.toLowerCase()) ||
            recycler.address.toLowerCase().contains(query.toLowerCase()) ||
            recycler.services.any((service) => service.toLowerCase().contains(query.toLowerCase()));
      }).toList();
    });
  }

  void _findNearbyRecyclers() {
    if (_currentLocation == null) return;

    setState(() {
      _filteredRecyclers = recyclers
          .map((recycler) {
        final distance = Geolocator.distanceBetween(
          _currentLocation!.latitude,
          _currentLocation!.longitude,
          recycler.latitude,
          recycler.longitude,
        ) / 1000; // Convert to km
        return recycler.copyWith(distance: distance);
      })
          .where((recycler) => recycler.distance! <= 10) // Within 10km
          .toList()
        ..sort((a, b) => a.distance!.compareTo(b.distance!));
    });

    // Animate to show all nearby markers
    final bounds = LatLngBounds.fromPoints(
      _filteredRecyclers.map((r) => latlong.LatLng(r.latitude, r.longitude)).toList(),
    );

    // Use this for newer versions of flutter_map:
    final center = bounds.center;
    final zoom = _mapController.camera.zoomFitBounds(bounds, padding: EdgeInsets.all(50));
    _mapController.move(center, zoom);
  }

  void _launchMaps(double latitude, double longitude) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Could not launch maps'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _showCallDialog(String phoneNumber) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.phone, size: 50, color: Colors.green),
                const SizedBox(height: 16),
                Text(
                  'Call $phoneNumber?',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.grey[200],
                      ),
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Call'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        launchUrl(Uri.parse('tel:$phoneNumber'));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _launchWhatsApp(String phoneNumber) async {
    final url = 'https://wa.me/$phoneNumber?text=Hello%20I%20would%20like%20to%20know%20more%20about%20your%20e-waste%20recycling%20services';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Could not launch WhatsApp'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _showRecyclerDetails(Recycler recycler) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          builder: (BuildContext context, ScrollController scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 60,
                        height: 5,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.green[100],
                          backgroundImage: AssetImage(recycler.image),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recycler.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 18),
                                  Text(
                                    ' ${recycler.rating}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  if (recycler.distance != null) ...[
                                    const SizedBox(width: 16),
                                    const Icon(Icons.location_pin, color: Colors.blue, size: 16),
                                    Text(
                                      ' ${recycler.distance!.toStringAsFixed(1)} km',
                                      style: const TextStyle(fontSize: 14, color: Colors.blue),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'About',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      recycler.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Services',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: recycler.services
                          .map((service) => Chip(
                        label: Text(service),
                        backgroundColor: Colors.green[50],
                        labelStyle: const TextStyle(color: Colors.green),
                      ))
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Working Hours',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      recycler.workingHours,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Contact',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.location_on),
                            label: const Text('Directions'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () => _launchMaps(recycler.latitude, recycler.longitude),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.phone),
                            label: const Text('Call'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () => _showCallDialog(recycler.phoneNumber),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 20),
                            label: const Text('WhatsApp'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () => _launchWhatsApp(recycler.whatsappNumber),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'E-Waste Recyclers',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.green[700],
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back)
          , color: Colors.white,
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('About E-Waste Recycling'),
                  content: const Text(
                      'Proper e-waste recycling helps prevent environmental pollution and recovers valuable materials. Always choose certified recyclers for your electronic waste.'),
                  actions: [
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Location Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterRecyclers,
                    decoration: InputDecoration(
                      hintText: 'Search recyclers...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  heroTag: 'locationButton',
                  onPressed: () {
                    if (_currentLocation == null) {
                      _determinePosition();
                    } else {
                      _findNearbyRecyclers();
                    }
                  },
                  backgroundColor: Colors.green[700],
                  mini: true,
                  child: _isLoadingLocation
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Icon(Icons.my_location),
                ),
              ],
            ).animate().fadeIn(delay: 100.ms).slide(begin: const Offset(0, -0.2)),
          ),

          // Map Section
          Container(
            height: 250,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: latlong.LatLng(19.8762, 75.3433), // Chhatrapati Sambhajinagar coordinates
                      initialZoom: 12.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.app',
                      ),
                      if (_currentLocation != null)
                        MarkerLayer(
                          markers: [
                            flutter_maps.Marker(
                              width: 40.0,
                              height: 40.0,
                              point: _currentLocation!,
                              child: const Icon(
                                Icons.person_pin_circle,
                                color: Colors.blue,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      MarkerLayer(
                        markers: _filteredRecyclers.map((recycler) {
                          return  flutter_maps.Marker(
                            width: 40.0,
                            height: 40.0,
                            point: latlong.LatLng(recycler.latitude, recycler.longitude),
                            child: GestureDetector(
                              onTap: () => _showRecyclerDetails(recycler),
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: FloatingActionButton(
                      heroTag: 'nearbyButton',
                      onPressed: _findNearbyRecyclers,
                      backgroundColor: Colors.green[700],
                      mini: true,
                      child: const Icon(Icons.near_me),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.9, 0.9)),
          ),

          // Title and Filter
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Row(
              children: [
                const Text(
                  'Nearby Recyclers',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (_filteredRecyclers.isNotEmpty)
                  Text(
                    '${_filteredRecyclers.length} found',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                IconButton(
                  icon: const Icon(Icons.filter_alt),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Filter Recyclers',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Add filter options here
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _findNearbyRecyclers();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green[700],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.near_me),
                                    SizedBox(width: 8),
                                    Text('Show Nearest First'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),

          // Recyclers List
          Expanded(
            child: _filteredRecyclers.isEmpty
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/animations/empty.json',
                  width: 200,
                  height: 200,
                ),
                const Text(
                  'No recyclers found',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _findNearbyRecyclers,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Find Recyclers Near Me'),
                ),
              ],
            )
                : ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: _filteredRecyclers.length,
              itemBuilder: (context, index) {
                final recycler = _filteredRecyclers[index];
                return RecyclerCard(
                  recycler: recycler,
                  onAddressTap: () => _launchMaps(recycler.latitude, recycler.longitude),
                  onCallTap: () => _showCallDialog(recycler.phoneNumber),
                  onWhatsAppTap: () => _launchWhatsApp(recycler.whatsappNumber),
                  onTap: () => _showRecyclerDetails(recycler),
                ).animate().fadeIn(delay: (300 + index * 100).ms).slide(
                  begin: const Offset(0, 0.2),
                );
              },
            ),
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
              itemPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });

                if (_isControllerInitialized) {
                  _animationController.reset();
                  _animationController.forward();
                }

                switch (index) {
                  case 0:
                    Navigator.pushReplacementNamed(context, '/home');
                    break;
                  case 1:
                  // Already on this screen
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
                      MaterialPageRoute(builder: (context) => CommunityScreen()),
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

class Recycler {
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String phoneNumber;
  final String whatsappNumber;
  final double rating;
  final List<String> services;
  final String workingHours;
  final String description;
  final String image;
  final double? distance;

  Recycler({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phoneNumber,
    required this.whatsappNumber,
    required this.rating,
    required this.services,
    required this.workingHours,
    required this.description,
    required this.image,
    this.distance,
  });

  Recycler copyWith({
    double? distance,
  }) {
    return Recycler(
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
      phoneNumber: phoneNumber,
      whatsappNumber: whatsappNumber,
      rating: rating,
      services: services,
      workingHours: workingHours,
      description: description,
      image: image,
      distance: distance ?? this.distance,
    );
  }
}

class RecyclerCard extends StatelessWidget {
  final Recycler recycler;
  final VoidCallback onAddressTap;
  final VoidCallback onCallTap;
  final VoidCallback onWhatsAppTap;
  final VoidCallback onTap;

  const RecyclerCard({
    Key? key,
    required this.recycler,
    required this.onAddressTap,
    required this.onCallTap,
    required this.onWhatsAppTap,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.green[50]!,
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Hero(
                    tag: recycler.name,
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.green[100],
                      backgroundImage: AssetImage(recycler.image),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recycler.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            Text(
                              ' ${recycler.rating}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            if (recycler.distance != null) ...[
                              const SizedBox(width: 16),
                              const Icon(Icons.location_pin, color: Colors.blue, size: 16),
                              Text(
                                ' ${recycler.distance!.toStringAsFixed(1)} km',
                                style: const TextStyle(fontSize: 14, color: Colors.blue),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey[400],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: onAddressTap,
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.green[700], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        recycler.address,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: recycler.services
                    .take(3)
                    .map((service) => Chip(
                  label: Text(service),
                  backgroundColor: Colors.green[50],
                  labelStyle: const TextStyle(color: Colors.green),
                  visualDensity: VisualDensity.compact,
                ))
                    .toList(),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: FaIcon(FontAwesomeIcons.phone, size: 18),
                    color: Colors.green[700],
                    onPressed: onCallTap,
                  ),
                  IconButton(
                    icon: FaIcon(FontAwesomeIcons.whatsapp, size: 20),
                    color: Colors.green[700],
                    onPressed: onWhatsAppTap,
                  ),
                  IconButton(
                    icon: const Icon(Icons.directions, size: 22),
                    color: Colors.green[700],
                    onPressed: onAddressTap,
                  ),
                  IconButton(
                    icon: const Icon(Icons.info_outline, size: 22),
                    color: Colors.green[700],
                    onPressed: onTap,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on MapCamera {
  zoomFitBounds(LatLngBounds bounds, {required EdgeInsets padding}) {}
}

// Placeholder classes for navigation - you'll need to implement these