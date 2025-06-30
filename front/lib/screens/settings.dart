import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        title: Text(_isEnglish ? 'Settings' : 'تنظیمات'),
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
            title: _isEnglish ? 'Share App' : 'اپلیکیشن شریک کړئ',
            onTap: _shareApp,
          ),
          _buildDivider(),
          _buildSettingItem(
            icon: Icons.brightness_6,
            title: _isEnglish ? 'Dark Mode' : 'تاریخ حالت',
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
            title: _isEnglish ? 'Language (English/پښتو)' : 'ژبه (English/پښتو)',
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
            title: _isEnglish ? 'Exit App' : 'اپلیکیشن بند کړئ',
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
      await Share.share(
        _isEnglish 
          ? 'Check out this awesome LifeBlood app!'
          : 'د ژوند وینه ښه اپلیکیشن وګورئ!',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEnglish ? 'Failed to share' : 'شریکولو کې ناکام')),
      );
    }
  }

  void _exitApp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_isEnglish ? 'Exit App' : 'اپلیکیشن بند کړئ'),
        content: Text(
          _isEnglish 
            ? 'Are you sure you want to exit?'
            : 'ایا تاسو ډاډه یاست چې وتل غواړئ؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_isEnglish ? 'Cancel' : 'لغوه کړئ'),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: Text(
              _isEnglish ? 'Exit' : 'وتل',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}