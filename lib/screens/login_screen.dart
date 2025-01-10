import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/customer.dart';
import '../services/language_service.dart';
import 'search_screen.dart';
import '../config/api_config.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '653686178359-6f10kga79kt1d1is4evcllu4bhjnc5cg.apps.googleusercontent.com',
    scopes: ['email', 'profile'],
  );

  Future<void> _createCustomer(Customer customer) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.createCustomer),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(customer.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to create customer: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create customer: $e');
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        
        // Customer nesnesini oluştur
        final customer = Customer(
          idToken: googleAuth.idToken ?? '',
          email: googleUser.email,
          name: googleUser.displayName ?? '',
          profilePhotoUrl: googleUser.photoUrl ?? '',
        );

        // Backend'e customer bilgilerini gönderme işlemini şimdilik yoruma alıyoruz
        // await _createCustomer(customer);
        
        // Debug için customer bilgilerini yazdıralım
        print('Customer Info: ${jsonEncode(customer.toJson())}');

        if (mounted) {
          // Başarılı giriş sonrası SearchScreen'e yönlendir
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const SearchScreen(),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Giriş yapılırken bir hata oluştu: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      print('Google Sign In Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    LanguageService.getQuestionText(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: _signInWithGoogle,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.abc, color: Colors.white),
                          const SizedBox(width: 10),
                          Text(
                            LanguageService.getGoogleButtonText(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // E-posta ile giriş işlemleri
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.email, color: Colors.white),
                          const SizedBox(width: 10),
                          Text(
                            LanguageService.getEmailButtonText(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 