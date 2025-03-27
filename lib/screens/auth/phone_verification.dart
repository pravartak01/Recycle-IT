import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Home Screen/home_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PhoneVerificationScreen extends StatefulWidget {
  @override
  _PhoneVerificationScreenState createState() => _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (index) => FocusNode());
  bool _isLoading = false;
  bool _otpSent = false;
  int _timeLeft = 60;
  bool _resendActive = false;

  // Color scheme
  final Color primaryGreen = Color(0xFF4CAF50);
  final Color accentGreen = Color(0xFF8BC34A);
  final Color backgroundColor = Colors.white;
  final Color textDarkColor = Color(0xFF2E7D32);
  final Color textLightColor = Color(0xFF81C784);
  final Color borderColor = Color(0xFFE0E0E0);

  @override
  void dispose() {
    _phoneController.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _otpFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _sendOTP() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        _isLoading = false;
        _otpSent = true;
        _timeLeft = 60;
        _resendActive = false;
        _startCountdown();
      });
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

  void _verifyOTP() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(Duration(seconds: 1));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }
  }

  void _handleOtpChange(String value, int index) {
    if (value.length == 1 && index < 5) {
      _otpFocusNodes[index + 1].requestFocus();
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
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Back Button
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: IconButton(
                            icon: Icon(Icons.arrow_back_ios, color: textDarkColor),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ).animate().fadeIn(duration: 300.ms),

                        SizedBox(height: 20),

                        // Verification Illustration
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
                                Icons.verified_user_rounded,
                                size: 60,
                                color: primaryGreen,
                              ),
                            ),
                          ),
                        ).animate().fadeIn(duration: 600.ms).scale(delay: 200.ms),

                        SizedBox(height: 40),

                        // Header
                        Text(
                          _otpSent ? 'Enter Verification Code' : 'Phone Verification',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: textDarkColor,
                          ),
                        ).animate().fadeIn(duration: 500.ms).moveX(begin: -20, end: 0),

                        SizedBox(height: 8),

                        Text(
                          _otpSent
                              ? 'We sent a 6-digit code to ${_phoneController.text}'
                              : 'We\'ll send a verification code to your phone',
                          style: TextStyle(fontSize: 16, color: textLightColor),
                        ).animate().fadeIn(duration: 500.ms, delay: 200.ms).moveX(begin: -20, end: 0),

                        SizedBox(height: 40),

                        // Form
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              if (!_otpSent) ...[
                                _buildPhoneField(),
                                SizedBox(height: 30),
                                _buildSendOTPButton(),
                              ] else ...[
                                _buildOTPInputFields(),
                                SizedBox(height: 20),
                                _buildResendOption(),
                                SizedBox(height: 30),
                                _buildVerifyButton(),
                              ],
                            ],
                          ),
                        ),
                        SizedBox(height: 40),
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
      style: TextStyle(fontSize: 16, color: Colors.black87),
      decoration: InputDecoration(
        labelText: "Phone Number",
        labelStyle: TextStyle(color: textLightColor),
        hintText: "Enter your 10-digit phone number",
        prefixIcon: Icon(Icons.phone, color: primaryGreen),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryGreen, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      validator: (val) {
        if (val == null || val.isEmpty) return 'Phone number is required';
        if (val.length < 10) return 'Please enter a valid phone number';
        return null;
      },
    );
  }

  Widget _buildSendOTPButton() {
    return Container(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _sendOTP,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : Text(
          "SEND VERIFICATION CODE",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildOTPInputFields() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (index) {
            return SizedBox(
              width: 45,
              child: TextFormField(
                controller: _otpControllers[index],
                focusNode: _otpFocusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  counterText: "",
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: borderColor, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: primaryGreen, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
                onChanged: (value) => _handleOtpChange(value, index),
                validator: (val) => val!.isEmpty ? '' : null,
              ),
            );
          }),
        ),
        SizedBox(height: 8),
        Text(
          "Enter the 6-digit code",
          style: TextStyle(color: textLightColor, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildResendOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Didn't receive code? ",
          style: TextStyle(color: textLightColor),
        ),
        GestureDetector(
          onTap: _resendActive ? _sendOTP : null,
          child: Text(
            _resendActive ? "Resend now" : "Resend in $_timeLeft sec",
            style: TextStyle(
              color: _resendActive ? primaryGreen : textLightColor,
              fontWeight: FontWeight.bold,
              decoration: _resendActive ? TextDecoration.underline : null,
              decorationColor: primaryGreen,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerifyButton() {
    return Container(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _verifyOTP,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : Text(
          "VERIFY & CONTINUE",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
