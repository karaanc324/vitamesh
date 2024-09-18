import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vitamesh/screens/doctor_profile_screen.dart';
import 'package:vitamesh/screens/patient_dashboard.dart';
import 'package:vitamesh/screens/register_screen.dart';
import 'package:vitamesh/services/auth_service.dart';
import 'package:toastification/toastification.dart';

import '../constant/style.dart';
import '../screens/doctor_dashboard.dart';
import '../services/firestore_service.dart';

TextEditingController nameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController contactController = TextEditingController();
TextEditingController passwordController = TextEditingController();
String selectedRole = 'patient'; // Default role

Scaffold loginWidget(context) {
  return Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: Image.asset('assets/images/VITAmesh-2.png'),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  labelText: 'Email *',
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: passwordController,
                obscureText: true, // Hide password text
                decoration: const InputDecoration(
                  icon: Icon(Icons.lock),
                  labelText: 'Password *',
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                style: AppStyles.elevatedButtonStyle,
                onPressed: () async {
                  print("Attempting sign-in");

                  AuthService authService = AuthService();
                  try {
                    UserCredential? userCredential = await authService.signInWithEmailAndPassword(
                      emailController.text,
                      passwordController.text,
                    );
                    if (userCredential != null) {
                      print("===================");
                      print(userCredential.user?.displayName);
                      print(userCredential.user?.uid);
                      // Navigate based on role
                      var exists = await FirestoreService().documentExists('doctor', userCredential.user!.uid);
                      print(exists);
                      if (exists) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const DoctorDashboard()));
                      }
                      else {
                        exists = await FirestoreService().documentExists('patient', userCredential.user!.uid);
                        print(exists);
                        if (exists) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PatientDashboard()));
                        }
                      }
                    } else {
                      print('Sign-in failed');
                    }
                  } catch (e) {
                    print('Error during sign-in: $e');
                  }
                },
                child: const Text(
                  'Login',
                  style: AppStyles.buttonText
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                // Handle sign-up or other actions
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterScreen()));
              },
              child: const Text(
                  "New user? Sign up.",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
              ),
            ),
          )
        ],
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () async {
        print("Google sign-in not available");
        toastification.show(
          context: context,
          title: Text('Google sign-in not yet available. Try with email and password.'),
          autoCloseDuration: const Duration(seconds: 5),
        );
      },
      tooltip: 'Google Sign-In',
      child: const Image(image: AssetImage('assets/images/ios_light_rd_na@3x.png')),
    ),
  );
}