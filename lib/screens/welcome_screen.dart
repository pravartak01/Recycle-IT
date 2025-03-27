import 'package:flutter/material.dart';
import './auth/signup_screen.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _backgroundAnimation;

  // For floating recycling icons
  final List<Map<String, dynamic>> _floatingIcons = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      );
    });

    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _backgroundAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    final random = math.Random();
    for (int i = 0; i < 8; i++) {
      // Reduced number of floating icons
      _floatingIcons.add({
        'icon':
            i % 3 == 0
                ? Icons.recycling
                : (i % 3 == 1 ? Icons.eco : Icons.battery_charging_full),
        'size': random.nextDouble() * 22 + 12, // Slightly larger icons
        'x': random.nextDouble(),
        'y': random.nextDouble(),
        'speed': random.nextDouble() * 0.004 + 0.002,
        'offset': random.nextDouble() * 2 * math.pi,
        'color': Color.fromARGB(
          120 + random.nextInt(105),
          76 + random.nextInt(100),
          175 + random.nextInt(81),
          60 + random.nextInt(41),
        ),
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Animated gradient background - smoother gradient
          AnimatedBuilder(
            animation: _backgroundAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.white,
                      const Color(0xFFEDF7EE),
                      const Color(0xFFCFE8D0),
                    ],
                    stops: [
                      0.0,
                      0.4 +
                          0.15 *
                              math.sin(
                                _backgroundAnimation.value * 2 * math.pi,
                              ),
                      1.0,
                    ],
                  ),
                ),
              );
            },
          ),

          // Floating recycling icons background effect
          ...List.generate(_floatingIcons.length, (index) {
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final icon = _floatingIcons[index];
                final x = (icon['x'] + _controller.value * icon['speed']) % 1.0;
                final y =
                    (icon['y'] + _controller.value * icon['speed'] * 1.5) % 1.0;

                return Positioned(
                  left: x * screenSize.width,
                  top: y * screenSize.height,
                  child: Transform.rotate(
                    angle: icon['offset'] + _controller.value * math.pi * 2,
                    child: Icon(
                      icon['icon'],
                      size: icon['size'],
                      color: icon['color'],
                    ),
                  ),
                );
              },
            );
          }),

          // Earth outline at the bottom - larger with gradient stroke
          Positioned(
            bottom: -screenSize.width * 0.7,
            left: -screenSize.width * 0.2,
            right: -screenSize.width * 0.2,
            child: Container(
              width: screenSize.width * 1.4,
              height: screenSize.width * 1.4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF4CAF50).withOpacity(0.4),
                    const Color(0xFF2E7D32).withOpacity(0.2),
                  ],
                ),
                border: Border.all(color: Colors.transparent, width: 0),
              ),
              child: Container(
                margin: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                ),
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),

                  // Logo and App Name with enhanced animation
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 1200),
                    curve: Curves.easeOutBack,
                    builder: (context, double value, child) {
                      return Transform.scale(scale: value, child: child);
                    },
                    child: Center(
                      child: Container(
                        width: 170, // Container size
                        height: 170,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 20,
                              spreadRadius: 1,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/logo.png', // Your local logo
                            width: 210, // Increased size but still within the container
                            height: 210,
                            fit: BoxFit.contain, // Ensures it fits inside without overflowing
                          ),
                        ),
                      ),
                    ),

                  ),

                  const SizedBox(height: 40),

                  // Welcome Text with enhanced typography
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeOut,
                    builder: (context, double value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 50 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: Column(
                      children: const [
                        // Text(
                        //   "Welcome to",
                        //   textAlign: TextAlign.left,
                        //   style: TextStyle(
                        //     fontSize: 24,
                        //     color: Color(0xFF616161), // Darker gray
                        //     fontWeight: FontWeight.w700,
                        //   ),
                        // ),
                        SizedBox(height: 8),
                        Text(
                          "Recycle'IT'",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 42, // Larger font
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                            letterSpacing: 1.2,
                            shadows: [
                              Shadow(
                                offset: Offset(0, 1),
                                blurRadius: 2,
                                color: Color(0x40000000),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Tagline with better typography
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeOut,
                    builder: (context, double value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 30 * (1 - value)),
                          child: child,
                        ),
                      );
                    },

                    child: const Text(
                      "Welcomes you in the journey to transform electronic waste into a sustainable future!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17, // Slightly larger for better readability
                        color: Color(0xFF757575),
                        height: 1.4,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Statistics with improved design
                  const SizedBox(height: 40),

                  // Get Started Button with improved design
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeOut,
                    builder: (context, double value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 40 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    SignupScreen(),
                            transitionsBuilder: (
                              context,
                              animation,
                              secondaryAnimation,
                              child,
                            ) {
                              var begin = const Offset(0.0, 1.0);
                              var end = Offset.zero;
                              var curve = Curves.easeOutQuint;
                              var tween = Tween(
                                begin: begin,
                                end: end,
                              ).chain(CurveTween(curve: curve));
                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                            transitionDuration: const Duration(
                              milliseconds: 800,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 65,
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF1B5E20),
                              Color(0xFF388E3C),
                              Color(0xFF4CAF50),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4CAF50).withOpacity(0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            "GET STARTED",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.8,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label) {
    return Column(
      children: [
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 1500),
          curve: Curves.easeOut,
          builder: (context, double progress, child) {
            // Parse the numeric part of the value
            int displayValue =
                (progress * int.parse(value.replaceAll("+", ""))).toInt();
            return Text(
              "${displayValue.toString()}+",
              style: const TextStyle(
                fontSize: 22, // Larger font size
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32), // Darker green for better contrast
              ),
            );
          },
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF757575), // Consistent gray color
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1.5,
      height: 35, // Slightly taller
      color: const Color(0xFFBDBDBD), // Lighter gray
      margin: const EdgeInsets.symmetric(horizontal: 12),
    );
  }
}

// Separate class for the rotating icon animation
class RotatingIcon extends StatelessWidget {
  const RotatingIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 6.28),
      duration: const Duration(seconds: 10),
      curve: Curves.linear,
      builder: (context, double value, child) {
        return Transform.rotate(angle: value, child: child);
      },
      child: const Icon(
        Icons.autorenew,
        size: 95, // Matched with main icon size
        color: Color(0xFF4CAF50),
      ),
    );
  }
}
