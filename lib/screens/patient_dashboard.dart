import 'package:flutter/material.dart';
import 'package:vitamesh/widgets/patient_widget.dart';

class PatientDashboard extends StatefulWidget {
  const PatientDashboard({super.key});

  @override
  State<PatientDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Scaffold(
      body: PatientWidget(),
    ));
  }
}
