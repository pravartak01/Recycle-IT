import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:confetti/confetti.dart';

class ProfileScreen extends StatefulWidget {




  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Color scheme
  final Color primaryGreen = const Color(0xFF4CAF50);
  final Color accentGreen = const Color(0xFF8BC34A);
  final Color backgroundColor = Colors.white;
  final Color textDarkColor = const Color(0xFF2E7D32);
  final Color textLightColor = const Color(0xFF81C784);

  // Profile data
  File? _profileImage;
  final TextEditingController _nameController = TextEditingController(text: 'Shantanu Kulkarni');
  final TextEditingController _emailController = TextEditingController(text: 'shantanukulkarni1229@gmail.com');
  final TextEditingController _phoneController = TextEditingController(text: '+91 8482813688');
  final TextEditingController _locationController = TextEditingController(text: 'Chhatrapati Sambhajinagar, India');

  // Confetti
  late final ConfettiController _confettiController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: 3.seconds);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      final newImage = File(pickedFile.path);
      setState(() {
        _profileImage = newImage;
      });
    }
  }

  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Profile Picture'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    setState(() => _isSaving = true);
    await Future.delayed(1.seconds); // Simulate API call
    _confettiController.play();
    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Profile updated successfully!'),
        backgroundColor: primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('Log Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: _showImagePickerDialog,
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: primaryGreen, width: 3),
            ),
          ),
          CircleAvatar(
            radius: 56,
            backgroundColor: accentGreen.withOpacity(0.2),
            backgroundImage: _profileImage != null
                ? FileImage(_profileImage!)
                : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
            child: _profileImage == null
                ? Icon(Icons.person, size: 60, color: primaryGreen)
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primaryGreen,
                shape: BoxShape.circle,
                border: Border.all(color: backgroundColor, width: 2),
              ),
              child: const Icon(Icons.edit, size: 20, color: Colors.white),
            ),
          ),
        ],
      ).animate().scale(delay: 200.ms),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: textLightColor),
        prefixIcon: Icon(icon, color: primaryGreen),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: textLightColor.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryGreen, width: 2),
        ),
      ),
    ).animate().fadeIn().slideX(begin: 0.1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                floating: false,
                pinned: true,
                backgroundColor: primaryGreen,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text('My Profile',
                      style: TextStyle(color: Colors.white)),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryGreen, accentGreen],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildProfileImage(),
                      const SizedBox(height: 30),
                      _buildTextField(_nameController, 'Full Name', Icons.person),
                      const SizedBox(height: 20),
                      _buildTextField(_emailController, 'Email', Icons.email),
                      const SizedBox(height: 20),
                      _buildTextField(_phoneController, 'Phone', Icons.phone),
                      const SizedBox(height: 20),
                      _buildTextField(_locationController, 'Location', Icons.location_on),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 3,
                          ),
                          child: _isSaving
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('SAVE CHANGES',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: _showLogoutDialog,
                        child: const Text('LOG OUT',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors:  [primaryGreen, accentGreen, Colors.white],
          ),
        ],
      ),
    );
  }
}