import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/Home Screen/home_screen.dart';  // Fixed import issue (no spaces in folder names)

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recycle\'IT\'',

      // Set SplashScreen as the initial route
      initialRoute: '/',

      routes: {
        '/': (context) => SplashScreen(), // Splash screen will load first
        '/home': (context) => HomeScreen(),
        '/signup': (context) => SignupScreen(),
        '/login': (context) => LoginScreen(),
      },
    );
  }
}
