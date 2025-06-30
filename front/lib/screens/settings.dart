import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final localizations = AppLocalizations.of(context)!;
    final isEnglish = localeProvider.locale?.languageCode == 'en';

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
              onChanged: (value) {
                setState(() {
                  _isDarkMode = value;
                  // TODO: Implement theme change
                });
              },
              activeColor: Colors.red,
            ),
          ),
          _buildDivider(),
          _buildSettingItem(
            icon: Icons.language,
            title: localizations.language,
            trailing: Switch(
              value: isEnglish,
              onChanged: (value) {
                _changeLanguage(context, value ? 'en' : 'fa');
              },
              activeColor: Colors.red,
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

  void _changeLanguage(BuildContext context, String languageCode) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final localizations = AppLocalizations.of(context)!;

    localeProvider.setLocale(Locale(languageCode));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(languageCode == 'en'
            ? localizations.languageChangedToEnglish
            : localizations.languageChangedToPersian),
        duration: const Duration(seconds: 2),
      ),
    );
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