class Customer {
  final String idToken;
  final String email;
  final String name;
  final String profilePhotoUrl;

  Customer({
    required this.idToken,
    required this.email,
    required this.name,
    required this.profilePhotoUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'IdToken': idToken,
      'Email': email,
      'Name': name,
      'ProfilePhotoUrl': profilePhotoUrl,
    };
  }
} 