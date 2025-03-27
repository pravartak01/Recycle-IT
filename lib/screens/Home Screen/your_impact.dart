import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class YourImpactSection extends StatefulWidget {
  final double totalEWasteRecycled; // in kg
  final int treesSaved;
  final double waterSaved; // in liters
  final double energySaved; // in kWh
  final double co2Reduced; // in kg

  const YourImpactSection({
    Key? key,
    required this.totalEWasteRecycled,
    required this.treesSaved,
    required this.waterSaved,
    required this.energySaved,
    required this.co2Reduced,
  }) : super(key: key);

  @override
  State<YourImpactSection> createState() => _YourImpactSectionState();
}

class _YourImpactSectionState extends State<YourImpactSection> with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.85,
      initialPage: 0,
    );

    // Auto-scroll every 5 seconds
    Future.delayed(const Duration(seconds: 1), () {
      _startAutoScroll();
    });
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        final nextPage = (_currentPage + 1) % 5;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _startAutoScroll();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Enhanced title section with decoration
        Container(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Row(
            children: [
              // Decorative element
              Container(
                height: 30,
                width: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF43A047),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),

              // Title with enhanced styling
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Impact',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2E7D32),
                      letterSpacing: 0.5,
                    ),
                  ),
                  Container(
                    width: 60,
                    height: 2,
                    decoration: BoxDecoration(
                      color: const Color(0xFF43A047),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ).animate()
            .fadeIn(duration: 500.ms)
            .moveX(begin: -20, end: 0, duration: 500.ms, curve: Curves.easeOutQuad),

        // Enhanced subtitle with shadow and styling
        Padding(
          padding: const EdgeInsets.only(left: 32, right: 16, bottom: 12),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.grey.withOpacity(0.05),
                  Colors.transparent,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Text(
              'See how your recycling efforts are helping the planet',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.black54,
                letterSpacing: 0.2,
                height: 1.3,
                shadows: [
                  Shadow(
                    color: Colors.white.withOpacity(0.8),
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        ).animate()
            .fadeIn(delay: 200.ms, duration: 500.ms)
            .moveX(begin: -20, end: 0, delay: 200.ms, duration: 500.ms, curve: Curves.easeOutQuad),

        SizedBox(
          height: 220,
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              _buildImpactCard(
                  title: 'E-Waste Recycled',
                  value: '${widget.totalEWasteRecycled.toStringAsFixed(1)} kg',
                  icon: Icons.delete_outline,
                  gradient: const [Color(0xFF43A047), Color(0xFF2E7D32)],
                  description: 'You\'ve kept electronic waste out of landfills',
              ),
              _buildImpactCard(
                title: 'Trees Saved',
                value: widget.treesSaved.toString(),
                icon: Icons.nature,
                gradient: const [Color(0xFF00897B), Color(0xFF00695C)],
                description: 'Equivalent trees saved through your recycling',
              ),
              _buildImpactCard(
                title: 'Water Saved',
                value: '${(widget.waterSaved / 1000).toStringAsFixed(1)} m³',
                icon: Icons.water_drop_outlined,
                gradient: const [Color(0xFF1976D2), Color(0xFF0D47A1)],
                description: 'Water preserved by avoiding new manufacturing',
              ),
              _buildImpactCard(
                title: 'Energy Saved',
                value: '${widget.energySaved.toStringAsFixed(0)} kWh',
                icon: Icons.bolt_outlined,
                gradient: const [Color(0xFFFFA000), Color(0xFFF57F17)],
                description: 'Electricity saved through recycling efforts',
              ),
              _buildImpactCard(
                title: 'CO₂ Reduced',
                value: '${widget.co2Reduced.toStringAsFixed(1)} kg',
                icon: Icons.eco_outlined,
                gradient: const [Color(0xFF7B1FA2), Color(0xFF4A148C)],
                description: 'Carbon emissions prevented through recycling',
              ),
            ],
          ),
        ),

        // Updated page indicator with green color theme
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Center(
            child: PageIndicator(
              count: 5,
              currentIndex: _currentPage,
              activeColor: const Color(0xFF43A047), // Green active color
              inactiveColor: const Color(0xFFE0E0E0), // Light gray inactive color
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImpactCard({
    required String title,
    required String value,
    required IconData icon,
    required List<Color> gradient,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Card(
        elevation: 4,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradient,
            ),
          ),
          child: Stack(
            children: [
              // Background pattern
              Positioned(
                right: -20,
                bottom: -20,
                child: Icon(
                  icon,
                  size: 150,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white24,
                          child: Icon(
                            icon,
                            color: Colors.white,
                          ),
                        ).animate()
                            .scale(
                          begin: const Offset(0.8, 0.8),
                          end: const Offset(1.0, 1.0),
                          duration: 500.ms,
                          curve: Curves.elasticOut,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Value counter
                    CounterText(
                      endValue: value,
                      style: GoogleFonts.poppins(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const Spacer(),

                    // Description
                    Text(
                      description,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ).animate()
          .fadeIn(duration: 500.ms)
          .slideY(begin: 0.2, end: 0, duration: 600.ms, curve: Curves.easeOutQuint),
    );
  }
}

// Counter Text Animation
class CounterText extends StatefulWidget {
  final String endValue;
  final TextStyle style;

  const CounterText({
    Key? key,
    required this.endValue,
    required this.style,
  }) : super(key: key);

  @override
  State<CounterText> createState() => _CounterTextState();
}

class _CounterTextState extends State<CounterText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String _displayValue = '0';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuart,
    );

    _controller.forward();

    // Extract the numeric part for animation
    final RegExp regex = RegExp(r'(\d+(?:\.\d+)?)');
    final match = regex.firstMatch(widget.endValue);
    if (match != null) {
      final targetValue = double.parse(match.group(1)!);
      final unitText = widget.endValue.substring(match.end);

      _animation.addListener(() {
        final animatedValue = (targetValue * _animation.value);
        if (animatedValue < 10) {
          setState(() {
            _displayValue = animatedValue.toStringAsFixed(1) + unitText;
          });
        } else {
          setState(() {
            _displayValue = animatedValue.toStringAsFixed(0) + unitText;
          });
        }
      });
    } else {
      _displayValue = widget.endValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayValue,
      style: widget.style,
    );
  }
}

// Updated Page Indicator with customizable colors
class PageIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;
  final Color activeColor;
  final Color inactiveColor;

  const PageIndicator({
    Key? key,
    required this.count,
    required this.currentIndex,
    this.activeColor = const Color(0xFF43A047), // Default to green
    this.inactiveColor = const Color(0xFFE0E0E0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: index == currentIndex ? 24 : 8,
          decoration: BoxDecoration(
            color: index == currentIndex ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(4),
            boxShadow: index == currentIndex ? [
              BoxShadow(
                color: activeColor.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 1),
              )
            ] : null,
          ),
        );
      }),
    );
  }
}

// Usage Example
class YourImpactExample extends StatelessWidget {
  const YourImpactExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const YourImpactSection(
      totalEWasteRecycled: 75.6,
      treesSaved: 12,
      waterSaved: 4550.0,
      energySaved: 341.5,
      co2Reduced: 125.8,
    );
  }
}