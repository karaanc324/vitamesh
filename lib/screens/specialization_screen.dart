import 'package:appbar_animated/appbar_animated.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vitamesh/screens/doctor_profile_screen.dart';
import 'package:vitamesh/services/firestore_service.dart';
import 'package:vitamesh/widgets/reusable_widgets.dart';

import 'login_screen.dart';

class SpecializationScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const SpecializationScreen({super.key, required this.data});

  @override
  State<SpecializationScreen> createState() => _SpecializationScreenState();
}

class _SpecializationScreenState extends State<SpecializationScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Access the data in the widget's state
    final data = widget.data;
    print(data); // Print the data to verify
    // Use the data to build your UI
    return Scaffold(
      // drawer: CustomDrawer(onLoginSignupTap: () {
      //   Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      // }),
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
                child: ReusableGridView(
                  onTapItem: (context, data) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DoctorProfilePage(
                                  data: data,
                                )));
                  },
                  stream: FirestoreService().getDocumentsByQuery(
                      'doctor', {'specialization': data['name']}),
                  scrollController: _scrollController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
