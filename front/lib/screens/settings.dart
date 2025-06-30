import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('en');
  static const String _localeKey = 'locale';

  Locale get locale => _locale;

  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString(_localeKey);
    if (localeCode != null) {
      _locale = Locale(localeCode);
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (!AppLocalizations.supportedLocales.contains(locale)) return;
    
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
    notifyListeners();
  }

  Future<void> toggleLanguage() async {
    _locale = _locale.languageCode == 'en' 
        ? const Locale('fa') 
        : const Locale('en');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, _locale.languageCode);
    notifyListeners();
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: true);
    final localizations = AppLocalizations.of(context)!;
    final isEnglish = localeProvider.locale.languageCode == 'en';

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(localizations.settings),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red.shade900, Colors.red.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingItem(
            icon: Icons.share,
            title: localizations.shareApp,
            onTap: () => _shareApp(context),
          ),
          _buildDivider(),
          _buildSettingItem(
            icon: Icons.brightness_6,
            title: localizations.darkMode,
            trailing: Switch(
              value: _isDarkMode,
              onChanged: (value) => setState(() => _isDarkMode = value),
              activeColor: Colors.red,
            ),
          ),
          _buildDivider(),
          _buildSettingItem(
            icon: Icons.language,
            title: localizations.language,
            trailing: Switch(
              value: isEnglish,
              onChanged: (value) async {
                await localeProvider.toggleLanguage();
                _showLanguageChangedSnackbar(context, value);
              },
              activeColor: Colors.red,
            ),
            subtitle: Text(
              isEnglish ? 'English' : 'فارسی',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ),
          _buildDivider(),
          _buildSettingItem(
            icon: Icons.exit_to_app,
            title: localizations.exitApp,
            onTap: () => _exitApp(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
    Widget? subtitle,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.red.shade700),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade800,
        ),
      ),
      subtitle: subtitle,
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.shade300,
      indent: 16,
      endIndent: 16,
    );
  }

  void _showLanguageChangedSnackbar(BuildContext context, bool toEnglish) {
    final localizations = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(toEnglish
            ? localizations.languageChangedToEnglish
            : localizations.languageChangedToPersian),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _shareApp(BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;
    try {
      await Share.share(localizations.shareAppMessage);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.shareError)),
      );
    }
  }

  void _exitApp(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.exitApp),
        content: Text(localizations.exitConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.cancel),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: Text(
              localizations.exitApp,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}