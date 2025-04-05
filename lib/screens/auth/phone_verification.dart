import 'package:e_waste_app/UiHelper/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Home Screen/home_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneVerificationScreen extends StatefulWidget {
  @override
  _PhoneVerificationScreenState createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isLoading = false;
  bool _otpSent = false;
  int _timeLeft = 60;
  bool _resendActive = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationId = "";

  final Color primaryGreen = Color(0xFF4CAF50);
  final Color accentGreen = Color(0xFF8BC34A);
  final Color backgroundColor = Colors.white;
  final Color textDarkColor = Color(0xFF2E7D32);
  final Color textLightColor = Color(0xFF81C784);

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  // Step 1: Send OTP
  Future<void> _sendOTP() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String phoneNumber = _phoneController.text.trim();
      if (phoneNumber.isEmpty) {
        showSnackBar(context, "Enter a valid phone number", false);
        return;
      }

      try {
        await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await _auth.signInWithCredential(credential);
            showSnackBar(context, "Phone number automatically verified!", true);
          },
          verificationFailed: (FirebaseAuthException e) {
            showSnackBar(context, "Verification failed: ${e.message}", false);
          },
          codeSent: (String verId, int? resendToken) {
            setState(() {
              verificationId = verId;
              _otpSent = true;
            });
            showSnackBar(context, "OTP sent to $phoneNumber", true);
          },
          codeAutoRetrievalTimeout: (String verId) {
            verificationId = verId;
          },
          timeout: Duration(seconds: 60),
        );
        setState(() {
          _isLoading = false;
          _otpSent = true;
          _startCountdown();
        });
      } on FirebaseAuthException catch (e) {
        showSnackBar(context, "Something Went Wrong!", false);
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Step 2: Verify OTP
  Future<void> _verifyOTP() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );

      String otp = _otpController.text.trim();
      if (otp.isEmpty) {
        showSnackBar(context, "Enter the OTP", false);
        return;
      }

      try {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: otp,
        );
        await _auth.signInWithCredential(credential);
        showSnackBar(context, "Phone number verified successfully!", true);
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        showSnackBar(context, "Invalid OTP. Please try again.", false);
      }
    }
  }

  void _startCountdown() {
    if (_timeLeft > 0) {
      Future.delayed(Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _timeLeft--;
            if (_timeLeft == 0) _resendActive = true;
          });
          _startCountdown();
        }
      });
    }
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Back Button
                        Padding(
                          padding: EdgeInsets.only(top: 16, left: 8),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: textDarkColor,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ).animate().fadeIn(duration: 300.ms),

                        SizedBox(height: 20),

                        // Phone Icon
                        Center(
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: accentGreen.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.phone_android,
                                    size: 50,
                                    color: primaryGreen,
                                  ),
                                ),
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 600.ms)
                            .scale(delay: 200.ms),

                        SizedBox(height: 40),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header
                              Text(
                                    'Phone Verification',
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
                                    'We\'ll send a verification code to your phone',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: textLightColor,
                                    ),
                                  )
                                  .animate()
                                  .fadeIn(duration: 500.ms, delay: 200.ms)
                                  .moveX(begin: -20, end: 0),

                              SizedBox(height: 40),

                              // Form
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    // Phone Number Field
                                    _buildPhoneField(),

                                    SizedBox(height: 20),

                                    // Send OTP Button
                                    if (!_otpSent) _buildSendOTPButton(),

                                    if (_otpSent) ...[
                                      _buildOTPFields(),
                                      SizedBox(height: 10),
                                      _buildResendOption(),
                                      SizedBox(height: 30),
                                      _buildVerifyButton(),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        Spacer(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: "Phone Number",
        hintText: "Enter your 10-digit phone number",
        prefixIcon: Icon(Icons.phone, color: primaryGreen),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Phone number is required';
        }
        if (val.length < 10) {
          return 'Please enter a valid phone number';
        }
        return null;
      },
    );
  }

  Widget _buildSendOTPButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _sendOTP,
      child:
          _isLoading
              ? CircularProgressIndicator(color: Colors.white)
              : Text("SEND VERIFICATION CODE"),
    );
  }

  Widget _buildOTPFields() {
    return TextFormField(
      controller: _otpController,
      keyboardType: TextInputType.number,
      maxLength: 6,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: "Enter OTP",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'OTP is required';
        }
        if (val.length < 6) {
          return 'Please enter complete OTP';
        }
        return null;
      },
    );
  }

  Widget _buildResendOption() {
    return TextButton(
      onPressed: _resendActive ? _sendOTP : null,
      child: Text(_resendActive ? "Resend OTP" : "Resend in $_timeLeft sec"),
    );
  }

  Widget _buildVerifyButton() {
    return ElevatedButton(onPressed: _verifyOTP, child: Text("VERIFY"));
  }
}
