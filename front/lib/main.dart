import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:life_blood_donor/locale_provider.dart';
import 'package:life_blood_donor/screens/about.dart';
import 'package:life_blood_donor/screens/donor_form.dart';
import 'package:life_blood_donor/screens/donor_info.dart';
import 'package:life_blood_donor/screens/donor_list.dart';
import 'package:life_blood_donor/screens/settings.dart';
import 'package:life_blood_donor/screens/stats.dart';
import 'package:life_blood_donor/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final localeProvider = LocaleProvider();
  final themeProvider = ThemeProvider();
  await Future.wait([
    localeProvider.loadLocale(),
    themeProvider.loadTheme(),
  ]);

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => localeProvider),
          ChangeNotifierProvider(create: (_) => themeProvider),
        ],
        child: const LifeBloodApp(),
      ),
    ),
  );
}

class LifeBloodApp extends StatelessWidget {
  const LifeBloodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<LocaleProvider, ThemeProvider>(
      builder: (context, localeProvider, themeProvider, child) {
        return MaterialApp(
          locale: localeProvider.locale,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeProvider.themeMode,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          title: 'LifeBlood',
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
      final isDarkMode = Theme.of(context).brightness == Brightness.dark;
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
            backgroundColor: isDarkMode ? const Color.fromARGB(255, 40, 39, 39).withOpacity(0.2) : Colors.white,
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            child:  Icon(Icons.add, color:isDarkMode ? Colors.white:Colors.red , size: 32),
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
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  
  return GestureDetector(
    onTap: () => setState(() => _currentIndex = index),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected 
          ? (isDarkMode ? const Color.fromARGB(255, 40, 39, 39).withOpacity(0.2) : Colors.white.withOpacity(0.5))
          : (isDarkMode ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected 
              ? Colors.white // Keep white for selected state in both modes
              : (isDarkMode ? Colors.white.withOpacity(0.7) : Colors.white.withOpacity(0.8)),
            size: isSelected ? 36 : 30,
          ),
        ],
      ),
    ),
  );
}
}