import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslationService {
  static const _baseUrl =
      'https://translate.googleapis.com/translate_a/single';

  /// Translates [text] from [from] language to [to] language.
  /// Uses the free Google Translate endpoint (no API key required).
  static Future<String> translate({
    required String text,
    required String to,
    String from = 'auto',
  }) async {
    if (text.trim().isEmpty) return text;
    if (to == 'auto' || to == from) return text;

    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'client': 'gtx',
      'sl': from,
      'tl': to,
      'dt': 't',
      'q': text,
    });

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final buffer = StringBuffer();
        for (final part in decoded[0] as List) {
          if (part[0] != null) buffer.write(part[0]);
        }
        return buffer.toString();
      }
    } catch (_) {}
    return text; // fallback: return original
  }
}

// ── Supported language list ────────────────────────────────
class AppLanguage {
  final String code;
  final String label;
  final String flag;

  const AppLanguage({
    required this.code,
    required this.label,
    required this.flag,
  });
}

const List<AppLanguage> supportedLanguages = [
  AppLanguage(code: 'zh-TW', label: '繁體中文',        flag: '🇹🇼'),
  AppLanguage(code: 'zh-CN', label: '简体中文',        flag: '🇨🇳'),
  AppLanguage(code: 'en',    label: 'English',        flag: '🇺🇸'),
  AppLanguage(code: 'fr',    label: 'Français',       flag: '🇫🇷'),
  AppLanguage(code: 'ja',    label: '日本語',          flag: '🇯🇵'),
  AppLanguage(code: 'ko',    label: '한국어',          flag: '🇰🇷'),
  AppLanguage(code: 'th',    label: 'ภาษาไทย',        flag: '🇹🇭'),
  AppLanguage(code: 'vi',    label: 'Tiếng Việt',     flag: '🇻🇳'),
  AppLanguage(code: 'hi',    label: 'हिन्दी',           flag: '🇮🇳'),
  AppLanguage(code: 'ne',    label: 'नेपाली',          flag: '🇳🇵'),
  AppLanguage(code: 'de',    label: 'Deutsch',        flag: '🇩🇪'),
  AppLanguage(code: 'ru',    label: 'Русский',        flag: '🇷🇺'),
  AppLanguage(code: 'es',    label: 'Español',        flag: '🇪🇸'),
  AppLanguage(code: 'la',    label: 'Latina',         flag: '🏛️'),
  AppLanguage(code: 'tr',    label: 'Türkçe',         flag: '🇹🇷'),
  AppLanguage(code: 'id',    label: 'Bahasa Indonesia', flag: '🇮🇩'),
  AppLanguage(code: 'ar',    label: 'العربية',         flag: '🇸🇦'),
];