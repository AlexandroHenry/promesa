import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/localization/localization.dart';

/// Language selector widget for changing app language
class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Locale>(
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.language),
          const SizedBox(width: 4),
          Text(
            LocalizationService.getCurrentLocaleDisplayName(context),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      onSelected: (Locale locale) {
        LocalizationService.changeLocale(
          context,
          locale,
          source: LocaleSource.manual,
        );
      },
      itemBuilder: (BuildContext context) {
        return AppLocales.supportedLocales.map((Locale locale) {
          final isSelected = context.locale == locale;
          return PopupMenuItem<Locale>(
            value: locale,
            child: Row(
              children: [
                Icon(
                  isSelected ? Icons.check : Icons.language,
                  size: 18,
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : null,
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocales.getLanguageName(locale),
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : null,
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : null,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}

/// Simple language toggle button (for two languages)
class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;
    final isKorean = currentLocale == AppLocales.ko;
    
    return IconButton(
      onPressed: () {
        final newLocale = isKorean ? AppLocales.en : AppLocales.ko;
        LocalizationService.changeLocale(
          context,
          newLocale,
          source: LocaleSource.manual,
        );
      },
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isKorean ? 'EN' : 'KO',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.swap_horiz, size: 16),
        ],
      ),
      tooltip: isKorean ? 'Switch to English' : '한국어로 변경',
    );
  }
}

/// Language selection bottom sheet
class LanguageSelectionBottomSheet extends StatelessWidget {
  const LanguageSelectionBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => const LanguageSelectionBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppTranslations.settings.tr(),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          ...AppLocales.supportedLocales.map((locale) {
            final isSelected = context.locale == locale;
            return ListTile(
              leading: Icon(
                isSelected ? Icons.check_circle : Icons.language,
                color: isSelected ? Theme.of(context).primaryColor : null,
              ),
              title: Text(
                AppLocales.getLanguageName(locale),
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : null,
                  color: isSelected ? Theme.of(context).primaryColor : null,
                ),
              ),
              onTap: () {
                LocalizationService.changeLocale(
                  context,
                  locale,
                  source: LocaleSource.manual,
                );
                Navigator.of(context).pop();
              },
            );
          }),
        ],
      ),
    );
  }
}