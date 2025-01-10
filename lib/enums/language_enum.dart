enum Language {
  turkish('tr', 'Turkish'),
  english('en', 'English'),
  chinese('zh', 'Chinese'),
  spanish('es', 'Spanish'),
  french('fr', 'French'),
  german('de', 'German'),
  italian('it', 'Italian'),
  japanese('ja', 'Japanese'),
  korean('ko', 'Korean'),
  russian('ru', 'Russian'),
  arabic('ar', 'Arabic'),
  hindi('hi', 'Hindi'),
  portuguese('pt', 'Portuguese'),
  dutch('nl', 'Dutch'),
  polish('pl', 'Polish'),
  vietnamese('vi', 'Vietnamese'),
  thai('th', 'Thai'),
  swedish('sv', 'Swedish'),
  danish('da', 'Danish'),
  finnish('fi', 'Finnish'),
  norwegian('no', 'Norwegian'),
  czech('cs', 'Czech'),
  greek('el', 'Greek'),
  hebrew('he', 'Hebrew'),
  indonesian('id', 'Indonesian'),
  malay('ms', 'Malay'),
  romanian('ro', 'Romanian'),
  hungarian('hu', 'Hungarian'),
  ukrainian('uk', 'Ukrainian'),
  bulgarian('bg', 'Bulgarian'),
  croatian('hr', 'Croatian'),
  slovak('sk', 'Slovak'),
  lithuanian('lt', 'Lithuanian'),
  slovenian('sl', 'Slovenian'),
  estonian('et', 'Estonian'),
  latvian('lv', 'Latvian'),
  persian('fa', 'Persian'),
  bengali('bn', 'Bengali'),
  urdu('ur', 'Urdu'),
  tamil('ta', 'Tamil'),
  telugu('te', 'Telugu');

  final String code;
  final String name;
  const Language(this.code, this.name);

  static Language fromCode(String code) {
    return Language.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => Language.english,
    );
  }

  static String getDisplayName(String code) {
    return fromCode(code).name;
  }
} 