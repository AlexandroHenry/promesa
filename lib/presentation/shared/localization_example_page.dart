import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/localization/localization.dart';
import '../widgets/common/language_selector.dart';

/// Example page demonstrating localization features
class LocalizationExamplePage extends StatelessWidget {
  const LocalizationExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(AppTranslations.settings)),
        actions: const [
          LanguageSelector(),
          SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr(AppTranslations.appTitle),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(tr(AppTranslations.appDescription)),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Common buttons section
            Text(
              'Common Actions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text(tr(AppTranslations.save)),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(tr(AppTranslations.edit)),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(tr(AppTranslations.delete)),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: Text(tr(AppTranslations.cancel)),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Auth section
            Text(
              'Authentication',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: tr(AppTranslations.email),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: tr(AppTranslations.password),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text(tr(AppTranslations.login)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {},
                            child: Text(tr(AppTranslations.register)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Language controls section
            Text(
              'Language Controls',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Language: ${LocalizationService.getCurrentLocaleDisplayName(context)}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const LanguageToggle(),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            LanguageSelectionBottomSheet.show(context);
                          },
                          child: const Text('More Languages'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            LocalizationService.resetToSystemLocale(context);
                          },
                          child: const Text('Reset to System'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            _simulateAPILanguageChange(context);
                          },
                          child: const Text('Simulate API Change'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            LocalizationService.reloadTranslations(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Translations reloaded!'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          child: const Text('Reload Translations'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            LocalizationService.forceTranslationRebuild(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('UI refreshed!'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                          child: const Text('Force Refresh'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const Spacer(),
            
            // Status information
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Localization Info',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 4),
                  Text('Locale: ${context.locale}'),
                  Text('Fallback: ${AppLocales.fallbackLocale}'),
                  Text('Supported: ${AppLocales.supportedLocales.join(', ')}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _simulateAPILanguageChange(BuildContext context) {
    final currentLocale = context.locale;
    final newLocale = currentLocale == AppLocales.ko ? AppLocales.en : AppLocales.ko;
    
    // Simulate API response
    LocalizationService.setLocaleFromAPI(context, newLocale.languageCode);
    
    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Language changed via API to ${AppLocales.getLanguageName(newLocale)}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}