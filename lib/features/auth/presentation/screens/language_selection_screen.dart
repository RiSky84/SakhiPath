import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/providers/language_provider.dart';

class LanguageSelectionScreen extends ConsumerStatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  ConsumerState<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends ConsumerState<LanguageSelectionScreen> {
  String? _selectedLanguage;

  final List<LanguageOption> _languages = [
    LanguageOption(code: 'en', name: 'English', nativeName: 'English'),
    LanguageOption(code: 'hi', name: 'Hindi', nativeName: 'हिन्दी'),
    LanguageOption(code: 'bn', name: 'Bengali', nativeName: 'বাংলা'),
    LanguageOption(code: 'te', name: 'Telugu', nativeName: 'తెలుగు'),
    LanguageOption(code: 'mr', name: 'Marathi', nativeName: 'मराठी'),
    LanguageOption(code: 'ta', name: 'Tamil', nativeName: 'தமிழ்'),
    LanguageOption(code: 'gu', name: 'Gujarati', nativeName: 'ગુજરાતી'),
    LanguageOption(code: 'kn', name: 'Kannada', nativeName: 'ಕನ್ನಡ'),
    LanguageOption(code: 'as', name: 'Assamese', nativeName: 'অসমীয়া'),
    LanguageOption(code: 'pa', name: 'Punjabi', nativeName: 'ਪੰਜਾਬੀ'),
    LanguageOption(code: 'or', name: 'Odia', nativeName: 'ଓଡ଼ିଆ'),
    LanguageOption(code: 'ml', name: 'Malayalam', nativeName: 'മലയാളം'),
    LanguageOption(code: 'ur', name: 'Urdu', nativeName: 'اردو'),
  ];

  void _continue() {
    if (_selectedLanguage != null) {

      ref.read(languageProvider.notifier).setLanguage(_selectedLanguage!);
      Navigator.of(context).pushReplacementNamed(AppRouter.phoneAuth);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a language')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Language'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Icon(
                    Icons.language,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Choose Your Preferred Language',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You can change this later in settings',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _languages.length,
                itemBuilder: (context, index) {
                  final language = _languages[index];
                  final isSelected = _selectedLanguage == language.code;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          _selectedLanguage = language.code;
                        });
                      },
                      leading: Radio<String>(
                        value: language.code,
                        groupValue: _selectedLanguage,
                        onChanged: (value) {
                          setState(() {
                            _selectedLanguage = value;
                          });
                        },
                      ),
                      title: Text(
                        language.name,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      subtitle: Text(language.nativeName),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_circle,
                              color: Theme.of(context).colorScheme.primary,
                            )
                          : null,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _continue,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Continue'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LanguageOption {
  final String code;
  final String name;
  final String nativeName;

  LanguageOption({
    required this.code,
    required this.name,
    required this.nativeName,
  });
}
