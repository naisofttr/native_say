import 'dart:ui';

class LanguageService {
  static String getQuestionText() {
    final String languageCode = window.locale.languageCode;
    
    switch (languageCode) {
      case 'tr':
        return 'Türkçesi Ne?';
      case 'en':
        return 'What is the English word for it?';
      case 'de':
        return 'Was ist das deutsche Wort dafür?';
      case 'fr':
        return 'Quel est le mot français?';
      case 'es':
        return '¿Cuál es la palabra en español?';
      default:
        return 'What is the English word for it?';
    }
  }

  static String getGoogleButtonText() {
    final String languageCode = window.locale.languageCode;
    
    switch (languageCode) {
      case 'tr':
        return 'Google ile Devam Et';
      case 'en':
        return 'Continue with Google';
      default:
        return 'Continue with Google';
    }
  }

  static String getEmailButtonText() {
    final String languageCode = window.locale.languageCode;
    
    switch (languageCode) {
      case 'tr':
        return 'E-posta ile Devam Et';
      case 'en':
        return 'Continue with Email';
      default:
        return 'Continue with Email';
    }
  }
} 