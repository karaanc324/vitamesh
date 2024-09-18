import 'package:appbar_animated/appbar_animated.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vitamesh/widgets/reusable_widgets.dart';

import '../screens/login_screen.dart';

// import '../screens/profile_screen.dart'; // Assuming you have a ProfileScreen
import '../screens/specialization_screen.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class DoctorWidget extends StatefulWidget {
  const DoctorWidget({super.key});

  @override
  State<DoctorWidget> createState() => _DoctorWidgetState();
}

class _DoctorWidgetState extends State<DoctorWidget> {
  final ScrollController _scrollController = ScrollController();

  // Add a variable to store the user's signed-in state
  // bool _isUserSignedIn = false;
  final AuthService _authService = AuthService();
  late final User currentUser;

  @override
  void initState() {
    super.initState();
    // Check user signed-in status on widget initialization
    // _checkUserSignedIn();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Function to check user signed-in status
  void _checkUserSignedIn() async {
    // Replace with your logic to check if a user is signed in (e.g., using Firebase Auth)
    // This is a placeholder example
    User? currentUser = await _authService.getCurrentUser();
    // setState(() {
    //   currentUser = currentUser;
    //   _isUserSignedIn = currentUser != null; // Update signed-in state
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(
        onLoginSignupTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
        },
      ),
      body: ScaffoldLayoutBuilder(
        backgroundColorAppBar:
            const ColorBuilder(Colors.transparent, Colors.blue),
        textColorAppBar: const ColorBuilder(Colors.white),
        appBarBuilder: (context, colorAnimated) => CustomAppBar(
          colorAnimated: colorAnimated.color,
          icon: const Icon(Icons.person),
          appBarLeadingTap: () => Scaffold.of(context).openDrawer(),
        ),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height * 0.49,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/VITAmesh.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.36,
                ),
                height: 900,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(40),
                  ),
                  color: Colors.white,
                ),
                child: Stack(
                  children: [
                    // ... (your existing Stack children)
                    Container(
                      // margin: EdgeInsets.only(
                      //   top: MediaQuery.of(context).size.height * 0.36,
                      // ),
                      padding: const EdgeInsets.all(20), // Add padding here
                      height: 900, // Adjust height as needed
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(40),
                        ),
                        color: Colors.white,
                      ),
                      child: GridView.count(
                        controller: _scrollController,
                          crossAxisCount: 2, // 2 columns
                          childAspectRatio:
                              2, // Adjust aspect ratio for card size
                          children: [
                            Card(
                              elevation: 10,
                              color: Colors.white,
                              child: Center(
                                child: Text(
                                  "Pending",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple[600],
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              elevation: 10,
                              color: Colors.white,
                              child: Center(
                                child: Text(
                                  "New Requests",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple[600],
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              elevation: 10,
                              color: Colors.white,
                              child: Center(
                                child: Text(
                                  "Completed",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple[600],
                                  ),
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
