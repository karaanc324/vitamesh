import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:vitamesh/widgets/auth_widget.dart';
import 'package:image_picker/image_picker.dart';
import '../constant/style.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String selectedRole = 'patient';
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController specializationController = TextEditingController();
  TextEditingController facilityController = TextEditingController();

  XFile? _profileImage;

  Future<String> uploadProfileImage() async {
    if (_profileImage == null) {
      return ''; // Handle case where no image is selected
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return ''; // Handle case where user is not logged in
    }

    final storageReference =
        'user_profile_images/${user.uid}/${Uuid().v4()}.jpg'; // Generate unique filename with user ID
    final imageUrl = await FirestoreService()
        .uploadImageToFirebaseStorage(_profileImage!.path, storageReference);
    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: Image.asset('assets/images/VITAmesh-2.png'),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Radio<String>(
                      value: 'patient',
                      groupValue: selectedRole,
                      onChanged: (value) {
                        setState(() {
                          if (value != null) {
                            selectedRole = value;
                          }
                        });
                      },
                    ),
                    const Text('Patient'),
                    Radio<String>(
                      value: 'doctor',
                      groupValue: selectedRole,
                      onChanged: (value) {
                        setState(() {
                          if (value != null) {
                            selectedRole = value;
                          }
                        });
                      },
                    ),
                    const Text('Doctor'),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: Stack(
                  children: [
                    _profileImage == null
                        ? CircleAvatar(
                            radius: 50,
                            backgroundImage: const AssetImage(
                                'assets/images/default_user_profile.jpg'),
                          )
                        : CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                FileImage(File(_profileImage!.path)),
                          ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: () async {
                          final image = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          setState(() {
                            _profileImage = image;
                          });
                        },
                        icon: const Icon(Icons.camera_alt),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: 'Name *',
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: contactController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.phone),
                    labelText: 'Contact no. *',
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.email),
                    labelText: 'Email *',
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true, // Hide password text
                  decoration: const InputDecoration(
                    icon: Icon(Icons.password),
                    labelText: 'Password *',
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: specializationController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.work),
                    labelText: 'Specialization (for doctors only)',
                  ),
                  enabled: selectedRole == 'doctor', // Enable only for doctors
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: facilityController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.local_hospital),
                    labelText: 'Facility name (for doctors only)',
                  ),
                  enabled: selectedRole == 'doctor', // Enable only for doctors
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  style: AppStyles.elevatedButtonStyle,
                  onPressed: () async {
                    print("Attempting sign-in");

                    AuthService authService = AuthService();
                    try {
                      UserCredential? userCredential =
                          await authService.signUpWithEmailAndPassword(
                        emailController.text,
                        passwordController.text,
                      );
                      if (userCredential != null) {
                        // String uuid = const Uuid().v4();
                        userCredential.user
                            ?.updateDisplayName(nameController.text);
                        userCredential.user
                            ?.updatePassword(passwordController.text);
                        // Navigate based on
                        var image_url = await uploadProfileImage();
                        if (selectedRole == 'patient') {
                          Map<String, dynamic> map = {
                            'name': nameController.text,
                            'email': emailController.text,
                            'contact': contactController.text,
                            'password': passwordController.text,
                            // 'facility': facilityController.text,
                            // 'specialization': specializationController.text,
                            'imageUrl': image_url
                            // 'role': selectedRole
                          };
                          FirestoreService().setDocument(
                              'patient', userCredential.user!.uid, map);
                          // Navigator.pushNamed(context, "patientRoute");
                        } else if (selectedRole == 'doctor') {
                          Map<String, dynamic> map = {
                            'name': nameController.text,
                            'email': emailController.text,
                            'contact': contactController.text,
                            'password': passwordController.text,
                            'facility': facilityController.text,
                            'specialization': specializationController.text,
                            'imageUrl': image_url
                            // 'role': selectedRole
                          };
                          FirestoreService().setDocument(
                              'doctor', userCredential.user!.uid, map);
                          // Navigator.pushNamed(context, "doctorRoute");
                        } else {
                          print('Unknown role selected');
                        }
                      } else {
                        print('Sign-in failed');
                      }
                      Navigator.pop(context);
                    } catch (e) {
                      print('Error during sign-in: $e');
                    }
                  },
                  child: Text(
                    'Register',
                    style: AppStyles.buttonText,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Handle sign-up or other actions
                  Navigator.pop(context);
                },
                child: const Text(
                  "Already a user? Sign in.",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
