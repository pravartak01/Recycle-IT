import 'package:e_waste_app/UiHelper/snackbar_message.dart';
import 'package:e_waste_app/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'phone_verification.dart';
import 'login_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Home Screen/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _obscurePassword = true;
  bool _isLoading = false;

  // Main app theme colors
  final Color primaryGreen = Color(0xFF4CAF50);
  final Color accentGreen = Color(0xFF8BC34A);
  final Color backgroundColor = Colors.white;
  final Color textDarkColor = Color(0xFF2E7D32);
  final Color textLightColor = Color(0xFF81C784);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Method to validate email format
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _signUpWithEmailPass() async {
    // Implement Google Sign-In logic here
    setState(() => _isLoading = true);
    if (_formKey.currentState!.validate()) {
      // Simulate API call delay
      try {
        final userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        await userCredential.user?.updateDisplayName(
          _nameController.text.trim(),
        );
        setState(() => _isLoading = false);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PhoneVerificationScreen()),
        );
        // print(userCredential.user?.uid);
        showSnackBar(
          context,
          "User Signed up Successfully! Please verify your Phone number",
          true,
        );
        addUser();
      } on FirebaseAuthException catch (e) {
        showSnackBar(context, e.message.toString(), false);
        setState(() {
          _isLoading = false;
        });
      }
      setState(() => _isLoading = false);
    }
  }

  void _signInWithGoogle() async {
    // Implement Google Sign-In logic here
    setState(() => _isLoading = true);

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        showSnackBar(context, "Google Sign-In cancelled.", false);

        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      showSnackBar(context, "Google Sign-In successful!", true);
      setState(() => _isLoading = false);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
      addUser();
      return;
    } catch (e) {
      showSnackBar(context, "Google Sign-In failed: $e", false);
      setState(() => _isLoading = false);
      return;
    }
  }

  void addUser() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentReference userRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid);
      await userRef.set({
        'displayName': user.displayName,
        'email': user.email,
        'phone': user.phoneNumber,
        'profilePictureURL': user.photoURL,
        'location': 'User location', // Default or user input
        'accountCreated': FieldValue.serverTimestamp(),
      });
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    showSnackBar(context, "Signed out successfully.", true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    Center(
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: accentGreen.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.eco_rounded,
                            size: 70,
                            color: primaryGreen,
                          ),
                        ),
                      ),
                    ).animate().fadeIn(duration: 600.ms).scale(delay: 200.ms),

                    SizedBox(height: 40),
                    Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: textDarkColor,
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 500.ms)
                        .moveX(begin: -20, end: 0),

                    SizedBox(height: 8),
                    Text(
                          'Join us in making the world greener',
                          style: TextStyle(fontSize: 16, color: textLightColor),
                        )
                        .animate()
                        .fadeIn(duration: 500.ms, delay: 200.ms)
                        .moveX(begin: -20, end: 0),

                    SizedBox(height: 40),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildInputField(
                            controller: _nameController,
                            label: "Full Name",
                            icon: Icons.person_outline,
                            validator:
                                (val) =>
                                    val!.isEmpty ? 'Name is required' : null,
                          ).animate().fadeIn(duration: 400.ms, delay: 300.ms),

                          SizedBox(height: 16),
                          _buildInputField(
                            controller: _emailController,
                            label: "Email Address",
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) {
                              if (val!.isEmpty) return 'Email is required';
                              if (!_isValidEmail(val))
                                return 'Enter a valid email';
                              return null;
                            },
                          ).animate().fadeIn(duration: 400.ms, delay: 400.ms),

                          SizedBox(height: 16),
                          _buildPasswordField().animate().fadeIn(
                            duration: 400.ms,
                            delay: 500.ms,
                          ),

                          SizedBox(height: 40),
                          _buildSignupButton().animate().fadeIn(
                            duration: 500.ms,
                            delay: 600.ms,
                          ),

                          SizedBox(height: 20),
                          _buildOrDivider().animate().fadeIn(
                            duration: 400.ms,
                            delay: 650.ms,
                          ),

                          SizedBox(height: 20),
                          _buildGoogleSignupButton().animate().fadeIn(
                            duration: 500.ms,
                            delay: 700.ms,
                          ),

                          SizedBox(height: 24),
                          _buildLoginLink().animate().fadeIn(
                            duration: 400.ms,
                            delay: 750.ms,
                          ),
                          SizedBox(height: 30),
                        ],
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

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(fontSize: 16, color: Colors.black87),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: textLightColor),
        prefixIcon: Icon(icon, color: primaryGreen),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: textLightColor.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      style: TextStyle(fontSize: 16, color: Colors.black87),
      validator: (val) {
        if (val!.isEmpty) return 'Password is required';
        if (val.length < 6) return 'Password must be at least 6 characters';
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        labelStyle: TextStyle(color: textLightColor),
        prefixIcon: Icon(Icons.lock_outline, color: primaryGreen),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: textLightColor,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: textLightColor.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  Widget _buildSignupButton() {
    return Container(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _signUpWithEmailPass,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: primaryGreen.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child:
            _isLoading
                ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                : Text(
                  "SIGN UP",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
      ),
    );
  }

  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade400, thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "OR",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey.shade400, thickness: 1)),
      ],
    );
  }

  Widget _buildGoogleSignupButton() {
    return Container(
      width: double.infinity,
      height: 55,
      child: OutlinedButton.icon(
        icon: Container(
          height: 24,
          width: 24,
          // child: Image.network(
          //   'https://upload.wikimedia.org/wikipedia/commons/5/53/Google_%22G%22_Logo.svg',
          //   height: 24,
          //   width: 24,
          //   errorBuilder: (context, error, stackTrace) {
          //     // Fallback to a simple G icon if image fails to load
          //     return Text(
          //       'G',
          //       style: TextStyle(
          //         color: Colors.red,
          //         fontWeight: FontWeight.bold,
          //         fontSize: 18,
          //       ),
          //     );
          //   },
          // ),
        ),
        label: Text(
          "Continue with Google",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        onPressed: _isLoading ? null : _signInWithGoogle,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey.shade300, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
          shadowColor: Colors.black12,
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
          child: Text(
            "Log In",
            style: TextStyle(
              decoration: TextDecoration.underline,
              decorationColor: Colors.green,
              color: primaryGreen,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}
