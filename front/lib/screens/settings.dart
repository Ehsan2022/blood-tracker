import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  bool _isEnglish = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
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
            title: AppLocalizations.of(context)!.shareApp,
            onTap: _shareApp,
          ),
          _buildDivider(),
          _buildSettingItem(
            icon: Icons.brightness_6,
            title: AppLocalizations.of(context)!.darkMode,
            trailing: Switch(
              value: _isDarkMode,
              onChanged: (value) {
                setState(() {
                  _isDarkMode = value;
                  // Implement theme change logic here
                });
              },
              activeColor: Colors.red,
            ),
          ),
          _buildDivider(),
          _buildSettingItem(
            icon: Icons.language,
            title: AppLocalizations.of(context)!.language,
            trailing: Switch(
              value: _isEnglish,
              onChanged: (value) {
                setState(() {
                  _isEnglish = value;
                  // Implement language change logic here
                });
              },
              activeColor: Colors.red,
            ),
          ),
          _buildDivider(),
          _buildSettingItem(
            icon: Icons.exit_to_app,
            title: AppLocalizations.of(context)!.exitApp,
            onTap: _exitApp,
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

  Future<void> _shareApp() async {
    try {
      await Share.share('Check out this awesome LifeBlood app!');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to share')),
      );
    }
  }

  void _exitApp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.exitApp),
        content: Text(AppLocalizations.of(context)!.exitConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: Text(
              AppLocalizations.of(context)!.exitApp,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}