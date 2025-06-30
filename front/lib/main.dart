import 'package:class_project/screens/donor_info.dart';
import 'package:class_project/screens/settings.dart';
import 'package:class_project/screens/stats.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:class_project/screens/about.dart';
import 'package:class_project/screens/donor_form.dart';
import 'package:class_project/screens/donor_list.dart';
import 'app_theme.dart';

void main() => runApp(
  DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => LifeBloodApp(),
  ),
);

class LifeBloodApp extends StatelessWidget {
  const LifeBloodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'LifeBlood',
      theme: appTheme.copyWith(
        cardTheme: appTheme.cardTheme.copyWith(
          elevation: 4,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
      
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const MainNavigationWrapper(),
    );
  }
}

class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({super.key});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _pages = [
  const DonorListScreen(),
  const StatsScreen(),
  const AboutScreen(),
  const DonorInfoScreen(),
  const SettingsScreen(), 
];

@override
Widget build(BuildContext context) {
  return Stack(
    children: [
      Scaffold(
        key: _scaffoldKey,
        extendBody: true,
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: _buildAnimatedNavBar(_currentIndex),
      ),
      Positioned(
        left: MediaQuery.of(context).size.width / 2 - 28, // Center horizontally
        bottom: 5, 
        child: FloatingActionButton(
          onPressed: () => _navigateToDonorForm(context),
          backgroundColor: Colors.white,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Icon(Icons.add, color: Colors.red, size: 32),
        ),
      ),
    ],
  );
}

  Future<void> _navigateToDonorForm(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DonorFormScreen()),
    );
    
    if (result != null && mounted) {
      setState(() {
        _currentIndex = 0; // Switch to donor list
      });
    }
  }

 Widget _buildAnimatedNavBar(int index) {
  return Stack(
    alignment: Alignment.bottomCenter,
    clipBehavior: Clip.none,
    children: [
      // The red bottom navigation bar
      Container(
        width: MediaQuery.of(context).size.width * 0.85, // Slightly wider to accommodate 5 icons
        height: 130,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(150),
            topRight: Radius.circular(150),
          ),
          color: Colors.red,
        ),
        child: Stack(
          children: [
            // About Screen (leftmost)
            Positioned(
              left: 20,
              bottom: 16,
              child: _buildNavItem(Icons.info, 2),
            ),
             // Donor List (center)
            Positioned(
              left: MediaQuery.of(context).size.width * 0.20,
              bottom: 55,
              child: _buildNavItem(Icons.people_alt_outlined, 0),
            ),
                 // Stats Screen (right-center)
            Positioned(
              left: MediaQuery.of(context).size.width * 0.37,
              bottom: 75,
              child: _buildNavItem(Icons.stacked_bar_chart, 1),
            ),
            // Donor Info (rightmost)
            Positioned(
              left: MediaQuery.of(context).size.width * 0.55,
              bottom: 55,
              child: _buildNavItem(Icons.medical_information_rounded, 3),
            ),
            // Settings (left-center)
            Positioned(
              right: 20,
              bottom: 16,
              child: _buildNavItem(Icons.settings, 4), 
            ),
          ],
        ),
      ),
    ],
  );
}
  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all( 8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.white.withOpacity(0.8) : Colors.white.withOpacity(0.1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.red : Colors.white.withOpacity(0.8),
              size:30, 
            ),
            
          ],
        ),
      ),
    );
  }
}