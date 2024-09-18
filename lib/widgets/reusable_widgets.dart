import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vitamesh/services/auth_service.dart';

import '../screens/specialization_screen.dart';
import '../services/firestore_service.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color colorAnimated;
  final Icon icon;
  final Function appBarLeadingTap;

  const CustomAppBar({super.key, required this.colorAnimated, required this.icon, required this.appBarLeadingTap});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.3), // Change this for blending effect
              Colors.transparent,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton(
          icon: icon ,
          onPressed: () => appBarLeadingTap(),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => print("jjjj"),
          icon: const Icon(
            Icons.notifications,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class CustomDrawer extends StatefulWidget {
  final Function onLoginSignupTap;

  CustomDrawer({super.key, required this.onLoginSignupTap});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool _isUserSignedIn = false;
  final AuthService _authService = AuthService();
  late final User currentUser;
  late var userMap = null;
  // Function to check user signed-in status
  void _checkUserSignedIn() {
    // Replace with your logic to check if a user is signed in (e.g., using Firebase Auth)
    // This is a placeholder example
    User? user = _authService.getCurrentUser();
    setState(() {
      if (user != null) {
        currentUser = user;
        _isUserSignedIn = true;
      }
      // currentUser = user!;
      // _isUserSignedIn = currentUser != null; // Update signed-in state
    });
  }
  void _getUserDetails() async {
    // Replace with your logic to check if a user is signed in (e.g., using Firebase Auth)
    // This is a placeholder example
    final documentSnapshot = await FirestoreService().getDocumentById('patient', currentUser.uid);
    if (documentSnapshot.exists) {
      setState(() {
        userMap = documentSnapshot.data();
      });
    } else {
      print('No user document found');
    }
  }
    @override
    void initState() {
      super.initState();
      // Check user signed-in status on widget initialization
      _checkUserSignedIn();
      if (_isUserSignedIn) {
        _getUserDetails();
      }
    }
    @override
    Widget build(BuildContext context) {
      return Drawer(
        backgroundColor: Colors.white,
        child: Opacity(
          opacity: 0.8,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Column(
                  children: [
                    // Image.asset('assets/images/VITAmesh.png'),
                    if (_isUserSignedIn) Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: userMap != null && userMap['imageUrl'] != null
                              ? NetworkImage(userMap['imageUrl'])
                              : const AssetImage('assets/images/default_user_profile.jpg'),
                        ),
                        // const SizedBox(height: 10),
                        Text(
                          userMap != null && userMap['name'] != null?
                          'Welcome, ${userMap['name'] ?? userMap['name']}!': 'Welcome',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: Colors.purple[600],
                          ),
                        ),
                      ],
                    ) else InkWell(
                      onTap: () => widget.onLoginSignupTap(),
                      child: Text(
                        'Login/Signup',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w300,
                          color: Colors.purple[500],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () => Navigator.pop(context), // Close the drawer
              ),
              ListTile(
                leading: Icon(Icons.local_hospital),
                title: Text('Clinics'),
                onTap: () => Navigator.pop(context), // Close the drawer
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () => Navigator.pop(context), // Close the drawer
              ),
              if (_isUserSignedIn)
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    AuthService().signOut();
                    Navigator.pop(context);
                  }, // Close the drawer
                ),
            ],
          ),
        ),
      );
    }
  }



// class CustomDrawer extends StatelessWidget {
//
// }
class SpecializationCard extends StatelessWidget {
  final String itemName;
  final Function onTap;

  const SpecializationCard({Key? key, required this.itemName, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Card(
        elevation: 10,
        color: Colors.white,
        child: Center(
          child: Text(
            itemName,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.purple[600],
            ),
          ),
        ),
      ),
    );
  }
}

class ReusableGridView extends StatelessWidget {
  final Stream<QuerySnapshot<Map<String, dynamic>>> stream;
  final Function(BuildContext context, Map<String, dynamic> data) onTapItem;
  final ScrollController scrollController;

  const ReusableGridView({super.key, required this.onTapItem, required this.stream, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final docs = snapshot.data!.docs;

        return GridView.builder(
          controller: scrollController,
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1, // Aspect ratio for tiles
          ),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final itemName = data['name']; // Replace with your field name

            return SpecializationCard(
              itemName: itemName,
              onTap: () => onTapItem(context, data),
            );
          },
        );
      },
    );
  }
}

