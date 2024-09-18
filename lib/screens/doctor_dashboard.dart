import 'package:flutter/material.dart';

import '../widgets/doctor_widget.dart';

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({super.key});

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DoctorWidget(),
    );
  }
}
