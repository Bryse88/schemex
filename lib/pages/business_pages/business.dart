import 'package:cloud_firestore/cloud_firestore.dart';

class Business {
  String id;
  String name;
  String adress;
  String phoneNumber;
  String logoUrl;
  String instagram;
  String website;
  String menuUrl;

  Business({
    required this.id,
    required this.name,
    required this.adress,
    required this.phoneNumber,
    required this.logoUrl,
    required this.instagram,
    required this.website,
    required this.menuUrl,
  });

  factory Business.fromFirestore(DocumentSnapshot doc) {
    try {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Business(
        id: doc.id,
        name: data['Name'] ?? '',
        adress: data['Adress'] ?? '',
        phoneNumber: data['Phone'] ?? '',
        logoUrl: data['URL'] ?? '',
        instagram: data['Instagram'] ?? '',
        website: data['Website'] ?? '',
        menuUrl: data['menuUrl'] ?? '',
      );
    } catch (e) {
      print("Error parsing business data: $e");
      // Return a default Business object or handle the error appropriately
      return Business(
        id: '',
        name: 'Error',
        adress: 'Error',
        phoneNumber: 'Error',
        logoUrl: 'Error',
        instagram: '',
        website: '',
        menuUrl: '',
      );
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'Name': name,
      'Adress': adress,
      'Phone': phoneNumber,
      'URL': logoUrl,
    };
  }
}
