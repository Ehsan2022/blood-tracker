import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:life_blood_donor/locale_provider.dart';
import 'package:life_blood_donor/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final localizations = AppLocalizations.of(context)!;
    final isEnglish = localeProvider.locale.languageCode == 'en';

    return Scaffold(
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Hero(
                tag: 'settings-icon',
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  child: Icon(
                    Icons.settings,
                    size: 60,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              localizations.settings,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildSettingItem(
                    context,
                    icon: Icons.share,
                    title: localizations.shareApp,
                    onTap: () => _shareApp(context),
                  ),
                  _buildDivider(context),
                  _buildSettingItem(
                    context,
                    icon: Icons.brightness_6,
                    title: localizations.darkMode,
                    trailing: Switch(
                      value: themeProvider.themeMode == ThemeMode.dark,
                      onChanged: (value) {
                        themeProvider.setTheme(
                          value ? ThemeMode.dark : ThemeMode.light);
                      },
                      activeColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  _buildDivider(context),
                  _buildSettingItem(
                    context,
                    icon: Icons.language,
                    title: localizations.language,
                    trailing: Switch(
                      value: isEnglish,
                      onChanged: (value) async {
                        await localeProvider.toggleLanguage();
                      },
                      activeColor: Theme.of(context).colorScheme.primary,
                    ),
                    subtitle: Text(
                      isEnglish ? 'English' : 'فارسی',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                      ),
                    ),
                  ),
                  _buildDivider(context),
                  _buildSettingItem(
                    context,
                    icon: Icons.exit_to_app,
                    title: localizations.exitApp,
                    onTap: () => _exitApp(context),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
    Widget? subtitle,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: subtitle,
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: Theme.of(context).dividerColor,
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
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}