class ApiConfig {
  // Base URL'ler
  static const String _localBaseUrl = 'http://localhost:5278/api';
  static const String _productionBaseUrl = 'https://api.yourserver.com/api'; // Sunucu URL'nizi buraya yazın
  
  // Aktif ortam
  static const bool _isProduction = false; // Production'a geçerken true yapın
  
  // Base URL getter
  static String get baseUrl => _isProduction ? _productionBaseUrl : _localBaseUrl;
  
  // API Endpoint'leri
  static String get createCustomer => '$baseUrl/Customer/CreateCustomer';
  static String getPrompt(String text, String language) => '$baseUrl/Promt/$text,$language';
} 