import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui' as ui;
import '../widgets/typing_text.dart';
import '../utils/app_localizations.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'login_screen.dart';
import '../enums/language_enum.dart';
import '../config/api_config.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  String _result = '';
  late String _userLanguage;
  final _scrollController = ScrollController();
  bool _isLoading = false;
  bool _isSearching = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _detectUserLanguage();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0.5, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  void _detectUserLanguage() {
    final String systemLocale = ui.window.locale.languageCode;
    setState(() {
      _userLanguage = Language.getDisplayName(systemLocale);
    });
  }

  Future<void> _searchText() async {
    if (_controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.getString('empty_input', _userLanguage)),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _isSearching = true;
      _isLoading = true;
      _result = '';
    });

    _animationController.forward();

    try {
      final url = Uri.parse(ApiConfig.getPrompt(_controller.text, _userLanguage));
      print('API Request URL: $url');

      final response = await http.get(url);
      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          final jsonResponse = json.decode(response.body);
          _result = jsonResponse['message'] as String;
          _isLoading = false;
        });
      } else {
        setState(() {
          _result = '${AppLocalizations.getString('error_occurred', _userLanguage)}: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('API Error: $e');
      setState(() {
        _result = '${AppLocalizations.getString('error_occurred', _userLanguage)}: $e';
        _isLoading = false;
      });
    }
  }

  void _resetSearch() {
    setState(() {
      _isSearching = false;
      _result = '';
      _controller.clear();
    });
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                _userLanguage == 'Turkish' 
                    ? 'Dil: Türkçe'
                    : 'Language: $_userLanguage',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.logout,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: isDark ? Colors.grey[900] : Colors.white,
                  title: Text(
                    _userLanguage == 'Turkish' ? 'Çıkış Yap' : 'Logout',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  content: Text(
                    _userLanguage == 'Turkish' 
                        ? 'Çıkış yapmak istediğinizden emin misiniz?' 
                        : 'Are you sure you want to logout?',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        _userLanguage == 'Turkish' ? 'İptal' : 'Cancel',
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Logout işlemi
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      child: Text(
                        _userLanguage == 'Turkish' ? 'Çıkış Yap' : 'Logout',
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * _animation.value,
                    left: 20,
                    right: 20,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[900] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _controller,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: AppLocalizations.getString('search_hint', _userLanguage),
                        hintStyle: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        alignLabelWithHint: true,
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_isSearching)
                              IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                                onPressed: _resetSearch,
                              ),
                            IconButton(
                              icon: Icon(
                                Icons.search,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                              onPressed: _searchText,
                            ),
                          ],
                        ),
                      ),
                      onSubmitted: (_) => _searchText(),
                    ),
                  ),
                );
              },
            ),
            if (_isSearching) 
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: _isLoading
                      ? CircularProgressIndicator(
                          color: isDark ? Colors.white : Colors.black,
                        )
                      : TypingText(
                          text: _result,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }
} 