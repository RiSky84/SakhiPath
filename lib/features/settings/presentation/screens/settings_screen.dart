import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../core/providers/language_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final Map<String, String> _languageNames = {
    'en': 'English',
    'hi': 'हिन्दी (Hindi)',
    'bn': 'বাংলা (Bengali)',
    'te': 'తెలుగు (Telugu)',
    'mr': 'मराठी (Marathi)',
    'ta': 'தமிழ் (Tamil)',
    'gu': 'ગુજરાતી (Gujarati)',
    'kn': 'ಕನ್ನಡ (Kannada)',
    'as': 'অসমীয়া (Assamese)',
    'pa': 'ਪੰਜਾਬੀ (Punjabi)',
    'or': 'ଓଡ଼ିଆ (Odia)',
    'ml': 'മലയാളം (Malayalam)',
    'ur': 'اردو (Urdu)',
  };

  Future<void> _changeLanguage() async {
    final currentLanguage = ref.read(languageProvider).languageCode;

    final selected = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _languageNames.length,
            itemBuilder: (context, index) {
              final code = _languageNames.keys.elementAt(index);
              final name = _languageNames[code]!;
              return RadioListTile<String>(
                value: code,
                groupValue: currentLanguage,
                title: Text(name),
                onChanged: (value) => Navigator.pop(context, value),
              );
            },
          ),
        ),
      ),
    );

    if (selected != null && mounted) {
      await ref.read(languageProvider.notifier).setLanguage(selected);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Language changed to ${_languageNames[selected]}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final currentLanguage = ref.watch(languageProvider).languageCode;
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _buildSection(context, 'Appearance'),
          ListTile(
            leading: Icon(
              isDark ? Icons.dark_mode : Icons.light_mode,
              color: AppColors.primary,
            ),
            title: const Text('Dark Mode'),
            subtitle: Text(isDark ? 'Enabled' : 'Disabled'),
            trailing: Switch(
              value: isDark,
              onChanged: (_) => ref.read(themeProvider.notifier).toggleTheme(),
              activeColor: AppColors.primary,
            ),
          ),

          ListTile(
            leading: const Icon(Icons.language, color: AppColors.primary),
            title: const Text('Language'),
            subtitle: Text(_languageNames[currentLanguage] ?? 'English'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _changeLanguage,
          ),

          _buildSection(context, 'Safety'),
          _buildTile(context, 'Emergency Contacts', Icons.contacts, () {}),
          _buildTile(context, 'SOS Settings', Icons.emergency, () {}),
          _buildSection(context, 'Account'),
          _buildTile(context, 'Profile', Icons.person, () {}),
          _buildTile(context, 'Privacy', Icons.lock, () {}),
          _buildSection(context, 'About'),
          _buildTile(context, 'Help & Support', Icons.help, () {}),
          _buildTile(context, 'About App', Icons.info, () {}),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.sos,
                padding: const EdgeInsets.all(16),
              ),
              child: const Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildTile(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
