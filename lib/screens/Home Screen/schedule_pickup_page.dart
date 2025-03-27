import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

import 'home_screen.dart';

class SchedulePickupPage extends StatefulWidget {
  @override
  _SchedulePickupPageState createState() => _SchedulePickupPageState();
}

class _SchedulePickupPageState extends State<SchedulePickupPage> with SingleTickerProviderStateMixin {

  final TextEditingController _addressController = TextEditingController(); // Initialize immediately
  final TextEditingController _mobileController = TextEditingController();
  String? mobileNumber;

  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  String? selectedDeviceType;
  String? selectedBrand;
  String? selectedCondition;
  String? timeSincePurchased;
  String? userAddress;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  List<XFile>? images = [];
  final ImagePicker _picker = ImagePicker();
  late AnimationController _animationController;
  int _currentStep = 0;
  bool _isLocationLoading = false;
  bool _isSubmitting = false;

  List<String> deviceTypes = ["Smartphone", "Laptop", "Tablet", "Monitor", "Printer", "Others"];
  Map<String, List<String>> deviceBrands = {
    "Smartphone": ["Apple", "Samsung", "OnePlus", "Xiaomi", "Google"],
    "Laptop": ["HP", "Dell", "Asus", "Lenovo", "Apple"],
    "Tablet": ["Samsung", "Apple", "Lenovo", "Microsoft"],
    "Monitor": ["LG", "Samsung", "Dell", "HP"],
    "Printer": ["HP", "Canon", "Epson", "Brother"],
    "Others": ["Miscellaneous"]
  };
  List<String> conditions = ["New", "Working", "Not Working", "Damaged"];
  List<String> purchaseTimes = ["Less than 1 year", "1-2 years", "2-3 years", "More than 3 years"];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _mobileController.dispose(); // Add this line

    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> getCurrentLocation() async {
    setState(() {
      _isLocationLoading = true;
    });

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Location permission denied'))
          );
          setState(() {
            _isLocationLoading = false;
          });
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude
      );

      String address;
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        address = "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
      } else {
        address = "Lat: ${position.latitude}, Lng: ${position.longitude}";
      }

      setState(() {
        userAddress = address;
        _addressController.text = address; // Update the controller text
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location updated successfully!'),
            backgroundColor: Colors.green,
          )
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to get location: $e'),
            backgroundColor: Colors.red,
          )
      );
    } finally {
      setState(() {
        _isLocationLoading = false;
      });
    }
  }

  Future<void> pickImages() async {
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if (selectedImages != null && selectedImages.isNotEmpty) {
      setState(() {
        images = selectedImages;
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${selectedImages.length} images selected'),
            backgroundColor: Colors.green,
          )
      );
    }
  }

  Future<void> takePicture() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        images = [...(images ?? []), photo];
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Photo taken successfully'),
            backgroundColor: Colors.green,
          )
      );
    }
  }

  Future<void> pickDate(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: Colors.teal,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> pickTime(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: Colors.teal,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void nextStep() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep += 1;
      });

      // Scroll to top after step change
      Future.delayed(Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            0,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });

      // Scroll to top after step change
      Future.delayed(Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            0,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  bool validateCurrentStep() {
    switch (_currentStep) {
      case 0: // Device details
        return selectedDeviceType != null && selectedBrand != null;
      case 1: // Condition details
        return selectedCondition != null && timeSincePurchased != null;
      case 2: // Address and pictures
        return userAddress != null &&
            userAddress!.isNotEmpty &&
            mobileNumber != null &&
            mobileNumber!.length == 10;
      case 3: // Date and time
        return selectedDate != null && selectedTime != null;
      default:
        return false;
    }
  }

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      // Create the device data map
      final Map<String, dynamic> deviceData = {
        'deviceType': selectedDeviceType!,
        'brand': selectedBrand!,
        'condition': selectedCondition!,
        'age': timeSincePurchased!,
        'address': userAddress!,
        'mobile': mobileNumber!,
        'date': DateFormat('yyyy-MM-dd').format(selectedDate!),
        'time': selectedTime!.format(context),
        'status': 'Scheduled',
        'dateAdded': DateTime.now().toString(),
      };

      // Simulate network delay
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              newDevice: deviceData, // Pass the device data
            ),
          ),
              (route) => false, // Remove all previous routes
        );
      });
    }
  }  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Schedule E-Waste Pickup",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
        centerTitle: true,
        leading: _currentStep > 0
            ? IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: previousStep,
        )
            : null,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal.shade50, Colors.white],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: StepProgressIndicator(
                currentStep: _currentStep,
                totalSteps: 4,
                stepTitles: ["Device", "Condition", "Location", "Schedule"],
              ),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: AnimationLimiter(
                  child: ListView(
                    controller: _scrollController,
                    padding: EdgeInsets.all(16),
                    children: AnimationConfiguration.toStaggeredList(
                      duration: Duration(milliseconds: 600),
                      childAnimationBuilder: (widget) => SlideAnimation(
                        horizontalOffset: 50.0,
                        child: FadeInAnimation(child: widget),
                      ),
                      children: _buildCurrentStepWidgets(),
                    ),
                  ),
                ),
              ),
            ),
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCurrentStepWidgets() {
    switch (_currentStep) {
      case 0:
        return _buildDeviceSelectionStep();
      case 1:
        return _buildConditionStep();
      case 2:
        return _buildLocationStep();
      case 3:
        return _buildScheduleStep();
      default:
        return [];
    }
  }

  List<Widget> _buildDeviceSelectionStep() {
    return [
      Center(
        // child: Lottie.network(
        //   'https://assets1.lottiefiles.com/packages/lf20_qp5bmihb.json',
        //   height: 150,
        // ),
      ),
      SizedBox(height: 16),
      Text(
        "What device would you like to recycle?",
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 24),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: DropdownButtonFormField(
          decoration: InputDecoration(
            labelText: "Device Type",
            prefixIcon: Icon(Icons.devices, color: Colors.teal),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          isExpanded: true,
          items: deviceTypes.map((type) {
            IconData icon = _getDeviceIcon(type);
            return DropdownMenuItem(
              value: type,
              child: Row(
                children: [
                  Icon(icon, size: 20, color: Colors.teal),
                  SizedBox(width: 12),
                  Text(type),
                ],
              ),
            );
          }).toList(),
          onChanged: (val) {
            setState(() {
              selectedDeviceType = val as String;
              selectedBrand = null;  // Reset brand when device type changes
            });
          },
          validator: (val) => val == null ? "Please select a device type" : null,
          value: selectedDeviceType,
        ),
      ),
      SizedBox(height: 16),
      if (selectedDeviceType != null)
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: "Brand",
              prefixIcon: Icon(Icons.business, color: Colors.teal),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            isExpanded: true,
            items: deviceBrands[selectedDeviceType]!.map((brand) {
              return DropdownMenuItem(
                value: brand,
                child: Row(
                  children: [
                    _getBrandIcon(brand),
                    SizedBox(width: 12),
                    Text(brand),
                  ],
                ),
              );
            }).toList(),
            onChanged: (val) => setState(() => selectedBrand = val as String),
            validator: (val) => val == null ? "Please select a brand" : null,
            value: selectedBrand,
          ),
        ).animate().slideX(
          begin: 0.3,
          end: 0,
          curve: Curves.easeOutQuad,
          duration: Duration(milliseconds: 400),
        ).fade(duration: Duration(milliseconds: 400)),
    ];
  }

  List<Widget> _buildConditionStep() {
    return [
      Center(
        // child: Lottie.network(
        //   'https://assets9.lottiefiles.com/packages/lf20_lkp6yr2d.json',
        //   height: 150,
        // ),
      ),
      SizedBox(height: 16),
      Text(
        "Tell us about your ${selectedDeviceType?.toLowerCase() ?? 'device'}",
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 24),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: DropdownButtonFormField(
          decoration: InputDecoration(
            labelText: "Condition",
            prefixIcon: Icon(Icons.security_update_good, color: Colors.teal),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          isExpanded: true,
          items: conditions.map((cond) {
            IconData icon = _getConditionIcon(cond);
            return DropdownMenuItem(
              value: cond,
              child: Row(
                children: [
                  Icon(icon, size: 20, color: _getConditionColor(cond)),
                  SizedBox(width: 12),
                  Text(cond),
                ],
              ),
            );
          }).toList(),
          onChanged: (val) => setState(() => selectedCondition = val as String),
          validator: (val) => val == null ? "Please select condition" : null,
          value: selectedCondition,
        ),
      ),
      SizedBox(height: 16),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: DropdownButtonFormField(
          decoration: InputDecoration(
            labelText: "Time Since Purchased",
            prefixIcon: Icon(Icons.access_time, color: Colors.teal),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          isExpanded: true,
          items: purchaseTimes.map((time) => DropdownMenuItem(
              value: time,
              child: Text(time)
          )).toList(),
          onChanged: (val) => setState(() => timeSincePurchased = val as String),
          validator: (val) => val == null ? "Please select time since purchased" : null,
          value: timeSincePurchased,
        ),
      ),
    ];
  }

  List<Widget> _buildLocationStep() {
    return [
      Center(
        child: Lottie.network(
          'https://assets3.lottiefiles.com/packages/lf20_UgZWvP.json',
          height: 150,
        ),
      ),
      SizedBox(height: 16),
      Text(
        "Where should we pick up your device?",
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 24),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: TextFormField(
          controller: _addressController,
          decoration: InputDecoration(
            labelText: "Address",
            prefixIcon: Icon(Icons.location_on, color: Colors.teal),
            border: InputBorder.none,
          ),
          maxLines: 3,
          onChanged: (val) => userAddress = val,
          validator: (val) => val == null || val.isEmpty ? "Please enter an address" : null,
        ),
      ),
      SizedBox(height: 16),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: TextFormField(
          controller: _mobileController,
          decoration: InputDecoration(
            labelText: "Mobile Number",
            prefixIcon: Icon(Icons.phone, color: Colors.teal),
            border: InputBorder.none,
            hintText: "Enter 10-digit mobile number",
            counterText: "", // Hide character counter
          ),
          keyboardType: TextInputType.phone,
          maxLength: 10,
          onChanged: (val) => mobileNumber = val,
          validator: (val) {
            if (val == null || val.isEmpty) {
              return "Please enter mobile number";
            }
            if (val.length != 10) {
              return "Enter valid 10-digit number";
            }
            if (!RegExp(r'^[0-9]+$').hasMatch(val)) {
              return "Only numbers allowed";
            }
            return null;
          },
        ),
      ),
      SizedBox(height: 16),
      ElevatedButton.icon(
        onPressed: _isLocationLoading ? null : getCurrentLocation,
        icon: _isLocationLoading
            ? Container(
          width: 24,
          height: 24,
          padding: EdgeInsets.all(2),
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 3,
          ),
        )
            : Icon(Icons.my_location),
        label: Text(_isLocationLoading ? "Getting location..." : "Use Current Location"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
        ),
      ),
      SizedBox(height: 24),
      Text(
        "Take pictures of your device",
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: takePicture,
            icon: Icon(Icons.camera_alt),
            label: Text("Camera"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: pickImages,
            icon: Icon(Icons.photo_library),
            label: Text("Gallery"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
      SizedBox(height: 16),
      if (images != null && images!.isNotEmpty) ...[
        Text(
          "${images!.length} image${images!.length > 1 ? 's' : ''} selected",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.teal.shade700,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
        Container(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: images!.length,
            itemBuilder: (context, index) {
              return Container(
                width: 120,
                margin: EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.teal.shade200),
                  image: DecorationImage(
                    image: FileImage(
                      File(images![index].path),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ];
  }
  List<Widget> _buildScheduleStep() {
    return [
      Center(
        child: Lottie.network(
          'https://assets10.lottiefiles.com/packages/lf20_yetxuujw.json',
          height: 150,
        ),
      ),
      SizedBox(height: 16),
      Text(
        "When should we pick up your device?",
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 24),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            InkWell(
              onTap: () => pickDate(context),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.teal),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pickup Date",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            selectedDate == null
                                ? "Select a date"
                                : DateFormat('EEEE, MMM d, yyyy').format(selectedDate!),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () => pickTime(context),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.teal),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pickup Time",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            selectedTime == null
                                ? "Select a time"
                                : selectedTime!.format(context),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      SizedBox(height: 24),
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.teal.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.teal.shade200),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.teal),
                SizedBox(width: 12),
                Text(
                  "Pickup Summary",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.teal.shade800,
                  ),
                ),
              ],
            ),
            Divider(color: Colors.teal.shade200),
            SummaryRow(
              title: "Device",
              value: "$selectedDeviceType, $selectedBrand",
            ),
            SummaryRow(
              title: "Condition",
              value: "$selectedCondition",
            ),
            SummaryRow(
              title: "Age",
              value: "$timeSincePurchased",
            ),
            SummaryRow(
              title: "Images",
              value: "${images?.length ?? 0} uploaded",
            ),
            SummaryRow(
              title: "Mobile",
              value: mobileNumber ?? "Not provided",
            ),
          ],
        ),
      ),
    ];
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: _currentStep == 3
          ? ElevatedButton(
        onPressed: validateCurrentStep() && !_isSubmitting ? submitForm : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: _isSubmitting
            ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            ),
            SizedBox(width: 12),
            Text("Processing..."),
          ],
        )
            : Text(
          "Schedule Pickup",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      )
          : Row(
          children: [
          if (_currentStep > 0)
      Expanded(
      flex: 1,
      child: OutlinedButton(
        onPressed: previousStep,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16),
          side: BorderSide(color: Colors.teal),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text("Previous"),
      ),
    ),
    if (_currentStep > 0) SizedBox(width: 16),
    Expanded(
    flex: 2,
    child: ElevatedButton(
    onPressed: validateCurrentStep() ? nextStep : null,
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.teal,
    padding: EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    ),
    elevation: 0,
    ),
    child: Text(
    "Next",
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
    ),
    ),
          ],
      ),
    );
  }

  IconData _getDeviceIcon(String deviceType) {
    switch (deviceType) {
      case "Smartphone":
        return Icons.phone_android;
      case "Laptop":
        return Icons.laptop;
      case "Tablet":
        return Icons.tablet;
      case "Monitor":
        return Icons.monitor;
      case "Printer":
        return Icons.print;
      default:
        return Icons.devices_other;
    }
  }

  Widget _getBrandIcon(String brand) {
    switch (brand) {
      case "Apple":
        return Icon(FontAwesomeIcons.apple, size: 20, color: Colors.black);
      case "Samsung":
        return Icon(FontAwesomeIcons.solidStar, size: 20, color: Colors.blue);
      case "OnePlus":
        return Icon(FontAwesomeIcons.plus, size: 20, color: Colors.red);
      case "Xiaomi":
        return Icon(FontAwesomeIcons.bold, size: 20, color: Colors.orange);
      case "Google":
        return Icon(FontAwesomeIcons.google, size: 20, color: Colors.blue);
      case "HP":
        return Icon(FontAwesomeIcons.h, size: 20, color: Colors.blue);
      case "Dell":
        return Icon(FontAwesomeIcons.d, size: 20, color: Colors.blue);
      case "Asus":
        return Icon(FontAwesomeIcons.a, size: 20, color: Colors.red);
      case "Lenovo":
        return Icon(FontAwesomeIcons.l, size: 20, color: Colors.red);
      case "Microsoft":
        return Icon(FontAwesomeIcons.microsoft, size: 20, color: Colors.blue);
      case "LG":
        return Icon(FontAwesomeIcons.l, size: 20, color: Colors.red);
      case "Canon":
        return Icon(FontAwesomeIcons.c, size: 20, color: Colors.blue);
      case "Epson":
        return Icon(FontAwesomeIcons.e, size: 20, color: Colors.blue);
      case "Brother":
        return Icon(FontAwesomeIcons.b, size: 20, color: Colors.blue);
      default:
        return Icon(Icons.business, size: 20, color: Colors.teal);
    }
  }

  IconData _getConditionIcon(String condition) {
    switch (condition) {
      case "New":
        return Icons.new_releases;
      case "Working":
        return Icons.check_circle;
      case "Not Working":
        return Icons.cancel;
      case "Damaged":
        return Icons.warning;
      default:
        return Icons.help_outline;
    }
  }

  Color _getConditionColor(String condition) {
    switch (condition) {
      case "New":
        return Colors.green;
      case "Working":
        return Colors.blue;
      case "Not Working":
        return Colors.orange;
      case "Damaged":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class StepProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> stepTitles;

  const StepProgressIndicator({
    required this.currentStep,
    required this.totalSteps,
    required this.stepTitles,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(totalSteps, (index) {
            return Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 2),
                height: 4,
                decoration: BoxDecoration(
                  color: index <= currentStep ? Colors.teal : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        SizedBox(height: 8),
        Row(
          children: List.generate(totalSteps, (index) {
            return Expanded(
              child: Center(
                child: Text(
                  stepTitles[index],
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: index <= currentStep ? FontWeight.w600 : FontWeight.normal,
                    color: index <= currentStep ? Colors.teal : Colors.grey,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class SummaryRow extends StatelessWidget {
  final String title;
  final String value;

  const SummaryRow({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.teal.shade800,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class ReceiptPage extends StatelessWidget {
  final String deviceType;
  final String brand;
  final String condition;
  final String timeSincePurchased;
  final String address;
  final String date;
  final String time;
  final List<XFile> images;

  final dynamic mobileNumber;

  const ReceiptPage({
    required this.deviceType,
    required this.brand,
    required this.condition,
    required this.timeSincePurchased,
    required this.address,
    required this.date,
    required this.time,
    required this.images,
    required this.mobileNumber, // Add this

  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pickup Scheduled"),
        backgroundColor: Colors.teal,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Lottie.network(
                'https://assets10.lottiefiles.com/packages/lf20_1pxqjqps.json',
                height: 200,
              ),
            ),
            SizedBox(height: 24),
            Text(
              "Your pickup has been scheduled!",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.teal.shade800,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal.shade200),
              ),
              child: Column(
                children: [
                  SummaryRow(
                    title: "Device",
                    value: "$deviceType, $brand",
                  ),
                  SummaryRow(
                    title: "Condition",
                    value: condition,
                  ),
                  SummaryRow(
                    title: "Age",
                    value: timeSincePurchased,
                  ),
                  SummaryRow(
                    title: "Address",
                    value: address,
                  ),
                  SummaryRow(
                    title: "Date",
                    value: date,
                  ),
                  SummaryRow(
                    title: "Time",
                    value: time,
                  ),
                  SummaryRow(
                    title: "Images",
                    value: "${images.length} uploaded",
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Done",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}