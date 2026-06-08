import 'package:flutter/material.dart';
import 'translation_provider.dart';
import 'translation_service.dart';

/// A floating action button that opens a language-picker bottom sheet.
/// Place this inside a [Stack] or use it as the [Scaffold.floatingActionButton].
class LanguageFab extends StatelessWidget {
  const LanguageFab({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = TranslationProvider.of(context);

    return FloatingActionButton(
      onPressed: () => _showLanguagePicker(context, notifier),
      backgroundColor: const Color(0xFFD4A017),
      elevation: 4,
      tooltip: '選擇語言',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.translate, color: Colors.white, size: 20),
          Text(
            notifier.current.flag,
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  void _showLanguagePicker(
      BuildContext context, TranslationNotifier notifier) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return _LanguagePickerSheet(notifier: notifier);
      },
    );
  }
}

class _LanguagePickerSheet extends StatelessWidget {
  final TranslationNotifier notifier;
  const _LanguagePickerSheet({required this.notifier});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '選擇顯示語言',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: supportedLanguages.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, indent: 16),
              itemBuilder: (_, i) {
                final lang = supportedLanguages[i];
                final isSelected = notifier.current.code == lang.code;
                return ListTile(
                  leading: Text(lang.flag,
                      style: const TextStyle(fontSize: 24)),
                  title: Text(lang.label),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle,
                          color: Color(0xFFD4A017))
                      : null,
                  onTap: () {
                    notifier.setLanguage(lang);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}