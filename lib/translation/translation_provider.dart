import 'package:flutter/material.dart';
import 'translation_service.dart';

// ── Global translation state ──────────────────────────────
class TranslationProvider extends InheritedNotifier<TranslationNotifier> {
  const TranslationProvider({
    super.key,
    required TranslationNotifier notifier,
    required super.child,
  }) : super(notifier: notifier);

  static TranslationNotifier of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TranslationProvider>()!
        .notifier!;
  }
}

class TranslationNotifier extends ChangeNotifier {
  AppLanguage _current = supportedLanguages.first; // default: 繁體中文

  AppLanguage get current => _current;
  String get langCode => _current.code;

  void setLanguage(AppLanguage lang) {
    if (_current.code == lang.code) return;
    _current = lang;
    notifyListeners();
  }
}