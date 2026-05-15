class TranslationsHolder {
  static Map<String, String> _translations = {};

  static void update(Map<String, String> translations) {
    _translations = translations;
  }

  static String translate(String key, [String? fallback]) {
    return _translations[key] ?? fallback ?? key;
  }
}
