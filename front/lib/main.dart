import 'package:flutter/material.dart';
import 'screens/donor_list.dart';

void main() {
  runApp(BloodTrackApp());
}

class BloodTrackApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BloodTrack',
      theme: ThemeData(
        primarySwatch: Colors.red,
        cardTheme: CardTheme(elevation: 2, margin: EdgeInsets.all(8)),
      ),
      home: DonorListScreen(),
    );
  }
}
