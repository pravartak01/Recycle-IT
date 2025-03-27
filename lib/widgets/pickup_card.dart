import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:math' as math;

class SchedulePickupButton extends StatefulWidget {
  final VoidCallback onPressed;
  final double width;
  final double height;

  const SchedulePickupButton({
    Key? key,
    required this.onPressed,
    this.width = 220,
    this.height = 90, // Increased height
  }) : super(key: key);

  @override
  State<SchedulePickupButton> createState() => _SchedulePickupButtonState();
}

class _SchedulePickupButtonState extends State<SchedulePickupButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _pulseAnimation;
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _rotateAnimation = Tween<double>(begin: 0, end: 0.015).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.05), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 1.05, end: 1.0), weight: 1),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Auto-pulse animation every few seconds to draw attention
    _startPulseAnimation();
  }

  void _startPulseAnimation() async {
    await Future.delayed(Duration(seconds: 3));
    if (mounted) {
      _controller.forward();
      Future.delayed(Duration(milliseconds: 800), () {
        if (mounted && !_isPressed) {
          _controller.reverse();
          _startPulseAnimation();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
    setState(() {
      _isPressed = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    setState(() {
      _isPressed = false;
    });
    widget.onPressed();
  }

  void _handleTapCancel() {
    _controller.reverse();
    setState(() {
      _isPressed = false;
    });
  }

  void _handleHoverChanged(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _handleHoverChanged(true),
      onExit: (_) => _handleHoverChanged(false),
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.rotate(
                angle: _rotateAnimation.value * math.pi,
                child: Container(
                  width: widget.width,
                  height: widget.height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _isPressed
                          ? [Color(0xFF28A745), Color(0xFF218838)]
                          : [Color(0xFF34D399), Color(0xFF10B981)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF10B981).withOpacity(_isPressed ? 0.3 : 0.5),
                        blurRadius: _isPressed ? 10 : 15,
                        offset: Offset(0, _isPressed ? 3 : 5),
                        spreadRadius: _isPressed ? 1 : 2,
                      ),
                      if (_isHovered)
                        BoxShadow(
                          color: Colors.white.withOpacity(0.2),
                          blurRadius: 2,
                          offset: Offset(0, 0),
                          spreadRadius: 2,
                        ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Background subtle pattern
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CustomPaint(
                          size: Size(widget.width, widget.height),
                          painter: RecyclePatternPainter(),
                        ),
                      ),

                      // Animated Ripple Effect
                      AnimatedOpacity(
                        opacity: _isHovered ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 300),
                        child: CustomPaint(
                          size: Size(widget.width, widget.height),
                          painter: RipplePainter(
                            color: Colors.white.withOpacity(0.1),
                            animationValue: _isHovered ? 1.0 : 0.0,
                          ),
                        ),
                      ),

                      // Main button content
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Left side with icon and main text
                            Row(
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Icon(Icons.add,size: 50, color: Colors.white,),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Shimmer.fromColors(
                                      baseColor: Colors.white,
                                      highlightColor: Colors.white.withOpacity(0.8),
                                      period: Duration(seconds: 3),
                                      child: Text(
                                        'Schedule Pickup',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Recycle your e-waste now',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            // Right side arrow icon with circle background
                            Container(
                              height: 36,
                              width: 36,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // "Free Pickup" badge
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'FREE',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF10B981),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Custom recycling pattern
class RecyclePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Draw recycling-like pattern
    final centerY = size.height / 2;
    final radius = size.height * 0.15;
    final spacing = size.width * 0.15;

    for (double x = radius; x < size.width; x += spacing) {
      // Draw recycling arrow-like shapes
      Path path = Path();
      path.moveTo(x - radius, centerY - radius);
      path.lineTo(x, centerY);
      path.lineTo(x - radius, centerY + radius);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Ripple effect for hover state
class RipplePainter extends CustomPainter {
  final Color color;
  final double animationValue;

  RipplePainter({required this.color, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.sqrt(size.width * size.width + size.height * size.height) / 2;

    for (int i = 1; i <= 3; i++) {
      double rippleRadius = maxRadius * (i / 3) * animationValue;
      canvas.drawCircle(center, rippleRadius, paint);
    }
  }

  @override
  bool shouldRepaint(RipplePainter oldDelegate) =>
      oldDelegate.animationValue != animationValue || oldDelegate.color != color;
}

// Usage example in home screen:
class SchedulePickupButtonImplementation extends StatelessWidget {
  const SchedulePickupButtonImplementation({Key? key}) : super(key: key);

  void _navigateToPickupForm(BuildContext context) {
    // Replace with your actual navigation code
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Placeholder(), // Replace with your pickup form page
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: SchedulePickupButton(
          onPressed: () => _navigateToPickupForm(context),
          width: MediaQuery.of(context).size.width * 0.9,
        ),
      ),
    );
  }
}