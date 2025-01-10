import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'providers/theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Native Say',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
            scaffoldBackgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const LoginScreen(),
        );
      },
    );
  }
}
