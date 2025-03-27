import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:ui';

class CollapsibleAppBar extends StatelessWidget {
  final String userName;
  final String appName;
  final int userPoints;
  final int userStreak;
  final bool isCollapsed;
  final ScrollController scrollController;
  final VoidCallback onNotificationTap;
  final VoidCallback onProfileTap;
  final String userAvatarUrl;
  final double scrollOffset;
  final Widget? profileWidget;

  const CollapsibleAppBar({
    Key? key,
    required this.userName,
    required this.appName,
    required this.userPoints,
    required this.userStreak,
    required this.isCollapsed,
    required this.scrollController,
    required this.onNotificationTap,
    required this.onProfileTap,
    this.userAvatarUrl = '',
    this.profileWidget,
    required this.scrollOffset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const ecoGreen = Color(0xFF2E7D32);
    const ecoGreenLight = Color(0xFF4CAF50);
    final expandedHeight = 140.0;
    final collapsedHeight = 60.0;

    final animationProgress = (scrollOffset / 70).clamp(0.0, 1.0);
    final currentHeight = lerpDouble(expandedHeight, collapsedHeight, animationProgress) ?? expandedHeight;

    return SizedBox(
      height: currentHeight + MediaQuery.of(context).padding.top,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 8 * animationProgress,
            sigmaY: 8 * animationProgress,
          ),
          child: PhysicalModel(
            color: Colors.transparent,
            elevation: 10.0 * animationProgress,
            shadowColor: Colors.black.withOpacity(0.4),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOutCubic,
              height: currentHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.lerp(ecoGreen, ecoGreenLight, 0.2 * (1 - animationProgress)) ?? ecoGreen,
                    Color.lerp(ecoGreen, ecoGreenLight, 0.6 * (1 - animationProgress)) ?? ecoGreenLight,
                  ],
                  stops: const [0.3, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2 * animationProgress),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: SafeArea(
                bottom: false,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: 0.08 * (1 - animationProgress),
                        child: const RecyclingIconBackground(),
                      ),
                    ),
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.08 * (1 - animationProgress * 0.7),
                        child: CustomPaint(
                          painter: EcoPatternPainter(),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: AnimatedCrossFade(
                        duration: const Duration(milliseconds: 300),
                        reverseDuration: const Duration(milliseconds: 200),
                        firstChild: _buildExpandedAppBar(context, animationProgress),
                        secondChild: _buildCollapsedAppBar(context, animationProgress),
                        crossFadeState: animationProgress < 0.5
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        firstCurve: Curves.easeOutCubic,
                        secondCurve: Curves.easeInCubic,
                        sizeCurve: Curves.easeInOutCubic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsedAppBar(BuildContext context, double animationProgress) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            tween: Tween<double>(begin: 1.0, end: 1.2),
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: Center(
                  child: Text(
                    appName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.6,
                      shadows: [
                        Shadow(
                          blurRadius: 4.0,
                          color: Colors.black26,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Row(
            children: [
              NotificationButton(
                onPressed: onNotificationTap,
                small: true,
              ),
              const SizedBox(width: 8),
              profileWidget ?? AvatarButton(
                onPressed: onProfileTap,
                userAvatarUrl: userAvatarUrl,
                small: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedAppBar(BuildContext context, double animationProgress) {
    final fadeOpacity = 1.0 - (animationProgress * 2.5).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.waving_hand_rounded,
                        color: Colors.amber,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Hello, $userName',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          shadows: [
                            Shadow(
                              blurRadius: 2.0,
                              color: Colors.black26,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.eco_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        appName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.7,
                          shadows: [
                            Shadow(
                              blurRadius: 4.0,
                              color: Colors.black26,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  NotificationButton(
                    onPressed: onNotificationTap,
                  ),
                  const SizedBox(width: 8),
                  profileWidget ?? AvatarButton(
                    onPressed: onProfileTap,
                    userAvatarUrl: userAvatarUrl,
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutBack,
            tween: Tween<double>(begin: 30.0, end: 0.0),
            builder: (context, translateY, _) {
              return Transform.translate(
                offset: Offset(0, translateY * (1 - animationProgress)),
                child: Opacity(
                  opacity: fadeOpacity,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        InfoChip(
                          icon: Icons.eco,
                          text: '$userPoints pts',
                          textColor: Colors.white.withOpacity(0.95),
                          bgColor: Colors.white.withOpacity(0.2),
                        ),
                        const SizedBox(width: 10),
                        InfoChip(
                          icon: Icons.local_fire_department,
                          text: '$userStreak day streak',
                          textColor: Colors.white.withOpacity(0.95),
                          bgColor: Colors.white.withOpacity(0.2),
                        ),
                        const SizedBox(width: 10),
                        InfoChip(
                          icon: Icons.emoji_events,
                          text: 'Lvl 4 Recycler',
                          textColor: Colors.white.withOpacity(0.95),
                          bgColor: Colors.white.withOpacity(0.2),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class NotificationButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool small;

  const NotificationButton({Key? key, required this.onPressed, this.small = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(
            Icons.notifications_outlined,
            color: Colors.white,
            size: small ? 24 : 26,
          ),
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              constraints: BoxConstraints(
                minWidth: small ? 12 : 14,
                minHeight: small ? 12 : 14,
              ),
              child: Text(
                '2',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: small ? 8 : 9,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
      onPressed: onPressed,
    );
  }
}

class AvatarButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String userAvatarUrl;
  final bool small;
  final File? profileImage;

  const AvatarButton({
    Key? key,
    required this.onPressed,
    this.userAvatarUrl = '',
    this.small = false,
    this.profileImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.8), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Hero(
          tag: 'user_avatar',
          child: CircleAvatar(
            radius: small ? 16 : 20,
            backgroundColor: Colors.white,
            child: profileImage != null
                ? ClipOval(
              child: Image.file(
                profileImage!,
                width: small ? 32 : 40,
                height: small ? 32 : 40,
                fit: BoxFit.cover,
              ),
            )
                : userAvatarUrl.isNotEmpty
                ? ClipOval(
              child: Image.network(
                userAvatarUrl,
                width: small ? 32 : 40,
                height: small ? 32 : 40,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(small),
              ),
            )
                : _buildDefaultAvatar(small),
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar(bool small) {
    return Icon(
      Icons.person,
      color: Colors.grey,
      size: small ? 20 : 24,
    );
  }
}

class InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color textColor;
  final Color bgColor;

  const InfoChip({
    Key? key,
    required this.icon,
    required this.text,
    required this.textColor,
    required this.bgColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: textColor, size: 16),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class EcoPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final leafSize = size.width * 0.1;

    void drawLeaf(double x, double y, double scale, double rotation) {
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);

      final path = Path();
      path.moveTo(0, 0);
      path.quadraticBezierTo(leafSize * scale, 0, leafSize * scale, -leafSize * scale);
      path.quadraticBezierTo(leafSize * 0.5 * scale, -leafSize * 0.5 * scale, 0, 0);

      path.moveTo(0, 0);
      path.lineTo(leafSize * 0.7 * scale, -leafSize * 0.7 * scale);

      for (int i = 1; i <= 3; i++) {
        double t = i / 4;
        path.moveTo(leafSize * 0.7 * scale * t, -leafSize * 0.7 * scale * t);
        path.lineTo(leafSize * 0.7 * scale * t + leafSize * 0.2 * scale, -leafSize * 0.7 * scale * t - leafSize * 0.1 * scale);
      }

      canvas.drawPath(path, paint);
      canvas.restore();
    }

    drawLeaf(size.width * 0.1, size.height * 0.4, 0.7, 0.3);
    drawLeaf(size.width * 0.3, size.height * 0.7, 0.5, 0.8);
    drawLeaf(size.width * 0.7, size.height * 0.3, 0.8, -0.4);
    drawLeaf(size.width * 0.8, size.height * 0.7, 0.6, 0.1);
    drawLeaf(size.width * 0.5, size.height * 0.2, 0.4, 0.5);
    drawLeaf(size.width * 0.9, size.height * 0.5, 0.5, -0.7);

    final center = Offset(size.width * 0.5, size.height * 0.6);
    final radius = size.width * 0.08;
    final arrowPath = Path();

    for (int i = 0; i < 3; i++) {
      final angle = i * (2 * pi / 3);
      final startX = center.dx + radius * 1.2 * cos(angle);
      final startY = center.dy + radius * 1.2 * sin(angle);
      final endAngle = angle + 2 * pi / 3;
      final endX = center.dx + radius * 1.2 * cos(endAngle);
      final endY = center.dy + radius * 1.2 * sin(endAngle);

      arrowPath.moveTo(startX, startY);
      arrowPath.arcToPoint(
        Offset(endX, endY),
        radius: Radius.circular(radius),
        clockwise: true,
      );

      final tipAngle = endAngle - 0.2;
      final tipX1 = endX - radius * 0.4 * cos(tipAngle - 0.3);
      final tipY1 = endY - radius * 0.4 * sin(tipAngle - 0.3);
      final tipX2 = endX - radius * 0.4 * cos(tipAngle + 0.3);
      final tipY2 = endY - radius * 0.4 * sin(tipAngle + 0.3);

      arrowPath.moveTo(endX, endY);
      arrowPath.lineTo(tipX1, tipY1);
      arrowPath.moveTo(endX, endY);
      arrowPath.lineTo(tipX2, tipY2);
    }

    canvas.drawPath(arrowPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class RecyclingIconBackground extends StatefulWidget {
  const RecyclingIconBackground({Key? key}) : super(key: key);

  @override
  _RecyclingIconBackgroundState createState() => _RecyclingIconBackgroundState();
}

class _RecyclingIconBackgroundState extends State<RecyclingIconBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: RecyclingIconPainter(_controller.value),
        );
      },
    );
  }
}

class RecyclingIconPainter extends CustomPainter {
  final double progress;

  RecyclingIconPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.1;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(progress * 2 * pi);
    canvas.translate(-center.dx, -center.dy);

    final path = Path();
    for (int i = 0; i < 3; i++) {
      final angle = i * (2 * pi / 3);
      final startX = center.dx + radius * 1.2 * cos(angle);
      final startY = center.dy + radius * 1.2 * sin(angle);
      final endAngle = angle + 2 * pi / 3;
      final endX = center.dx + radius * 1.2 * cos(endAngle);
      final endY = center.dy + radius * 1.2 * sin(endAngle);

      path.moveTo(startX, startY);
      path.arcToPoint(
        Offset(endX, endY),
        radius: Radius.circular(radius),
        clockwise: true,
      );

      final tipAngle = endAngle - 0.2;
      final tipX1 = endX - radius * 0.4 * cos(tipAngle - 0.3);
      final tipY1 = endY - radius * 0.4 * sin(tipAngle - 0.3);
      final tipX2 = endX - radius * 0.4 * cos(tipAngle + 0.3);
      final tipY2 = endY - radius * 0.4 * sin(tipAngle + 0.3);

      path.moveTo(endX, endY);
      path.lineTo(tipX1, tipY1);
      path.moveTo(endX, endY);
      path.lineTo(tipX2, tipY2);
    }

    canvas.drawPath(path, paint);
    canvas.restore();
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}