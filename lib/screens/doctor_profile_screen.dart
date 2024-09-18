import 'package:appbar_animated/appbar_animated.dart';
import 'package:flutter/material.dart';
import 'package:vitamesh/constant/style.dart';

import '../widgets/reusable_widgets.dart';

class DoctorProfilePage extends StatefulWidget {
  final Map<String, dynamic> data;

  const DoctorProfilePage({super.key, required this.data});

  // final String doctorName = "Dr. Emily Clark";
  // final String specialization = "Dermatologist";
  // final String hospital = "Sunrise Clinic, California";
  // final String bio =
  //     "Dr. Emily Clark is a highly experienced dermatologist specializing in skin care and cosmetic procedures. With over 10 years of experience, she has treated a wide range of skin conditions.";
  //
  // // Availability toggle
  // bool isAvailable = true;
  @override
  _DoctorProfilePageState createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  // Sample data for the doctor
  String doctorName = "Dr. Emily Clark";
  String specialization = "Dermatologist";
  String hospital = "Sunrise Clinic, California";

  // Availability toggle
  bool isAvailable = true;

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    String bio =
        "Dr. ${data['name']} is a highly experienced dermatologist specializing in skin care and cosmetic procedures. With over 10 years of experience, she has treated a wide range of skin conditions.";

    return Scaffold(
      body: ScaffoldLayoutBuilder(
        backgroundColorAppBar:
            const ColorBuilder(Colors.transparent, Colors.blue),
        textColorAppBar: const ColorBuilder(Colors.white),
        appBarBuilder: (context, colorAnimated) => CustomAppBar(
          colorAnimated: colorAnimated.color,
          icon: const Icon(Icons.arrow_back),
          appBarLeadingTap: () => Navigator.pop(context),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Doctor's Image
                Center(
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: data['imageUrl'].isNotEmpty
                        ? NetworkImage(data['imageUrl'])
                        : const AssetImage(
                            'assets/images/default_user_profile.jpg'), // Replace with your default image asset path
                  ),
                ),
                const SizedBox(height: 16),

                // Doctor's Name
                Center(
                  child: Text(
                    data['name'],
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple[700],
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Specialization
                Center(
                  child: Text(
                    data['specialization'],
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                SizedBox(height: 8),

                // Hospital Information
                Center(
                  child: Text(
                    data['facility'],
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Availability Toggle Button
                // Center(
                //   child: ElevatedButton(
                //     onPressed: () {
                //       setState(() {
                //         isAvailable = !isAvailable;
                //       });
                //     },
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: isAvailable ? Colors.green : Colors.red,
                //       padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                //     ),
                //     child: Text(
                //       isAvailable ? "Available" : "Not Available",
                //       style: const TextStyle(
                //         fontSize: 18,
                //         color: Colors.white,
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(height: 20),

                // Doctor's Bio
                Text(
                  "About the Doctor",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[600],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  bio,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 20),

                // Contact Information Section
                Text(
                  "Contact Information",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[600],
                  ),
                ),
                SizedBox(height: 10),
                ListTile(
                  leading: const Icon(Icons.phone, color: Colors.purple),
                  title: Text(
                    data['contact'],
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.email, color: Colors.purple),
                  title: Text(
                    data['email'],
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: AppStyles.elevatedButtonStyle,
                    child: const Text(
                      "Book an appointment",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
