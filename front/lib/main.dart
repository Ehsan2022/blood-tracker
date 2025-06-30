import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:life_blood_donor/screens/about.dart';
import 'package:life_blood_donor/screens/donor_form.dart';
import 'package:life_blood_donor/screens/donor_info.dart';
import 'package:life_blood_donor/screens/donor_list.dart';
import 'package:life_blood_donor/screens/settings.dart';
import 'package:life_blood_donor/screens/stats.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final localeProvider = LocaleProvider();
  await localeProvider.loadLocale();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => ChangeNotifierProvider(
        create: (context) => localeProvider,
        child: const LifeBloodApp(),
      ),
    ),
  );
}

class LifeBloodApp extends StatelessWidget {
  const LifeBloodApp({super.key});

  @override
 Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return MaterialApp(
          // locale: DevicePreview.locale(context) ?? localeProvider.locale,
          // locale: Locale('fa'),
          locale: localeProvider.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          
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
      },
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

  final List<Widget> _pages = const [
    DonorListScreen(),
    StatsScreen(),
    AboutScreen(),
    DonorInfoScreen(),
    SettingsScreen(),
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
          left: MediaQuery.of(context).size.width / 2 - 28,
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
        _currentIndex = 0;
      });
    }
  }

  Widget _buildAnimatedNavBar(int index) {
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 340,
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
              Positioned(
                left: 25,
                bottom: 10,
                child: _buildNavItem(Icons.info, 2),
              ),
              Positioned(
                left: 75,
                bottom: 55,
                child: _buildNavItem(Icons.people_alt_outlined, 0),
              ),
              Positioned(
                left: 145,
                bottom: 75,
                child: _buildNavItem(Icons.stacked_bar_chart, 1),
              ),
              Positioned(
                right: 75,
                bottom: 55,
                child: _buildNavItem(Icons.medical_information_rounded, 3),
              ),
              Positioned(
                right: 25,
                bottom: 10,
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
        padding: const EdgeInsets.all(8),
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
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}