import 'package:cloud_firestore/cloud_firestore.dart';
import 'business.dart';

class BusinessService {
  final CollectionReference _businessCollection =
      FirebaseFirestore.instance.collection('Businesses');

  // Fetch a single business by ID
  Future<Business?> fetchBusinessById(String businessId) async {
    try {
      DocumentSnapshot doc = await _businessCollection.doc(businessId).get();
      //print(businessId);
      //print("Fetched document: ${doc.data()}"); // Log the document
      if (doc.exists) {
        return Business.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      //("Error fetching business: $e");
      return null;
    }
  }

  // Fetch operating hours for a business
  Future<Map<String, String>> fetchBusinessHours(String businessId) async {
    Map<String, String> hours = {};
    try {
      QuerySnapshot snapshot =
          await _businessCollection.doc(businessId).collection('hours').get();

      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        bool isClosed = data['Closed'] ?? false;
        if (isClosed) {
          hours[doc.id] = "Closed";
        } else {
          String openTime = data['Open'] ?? '';
          String closeTime = data['Close'] ?? '';
          hours[doc.id] = "$openTime - $closeTime";
        }
      }
    } catch (e) {
      // Handle exceptions
      //print(e);
    }
    return hours;
  }

  // Add a new business
  Future<void> addBusiness(Business business) async {
    try {
      await _businessCollection.add(business.toMap());
    } catch (e) {
      // Handle exceptions
      //print(e);
    }
  }

  // Update an existing business
  Future<void> updateBusiness(String businessId, Business business) async {
    try {
      await _businessCollection.doc(businessId).update(business.toMap());
    } catch (e) {
      // Handle exceptions
      //print(e);
    }
  }

  // Delete a business
  Future<void> deleteBusiness(String businessId) async {
    try {
      await _businessCollection.doc(businessId).delete();
    } catch (e) {
      // Handle exceptions
      //print(e);
    }
  }

  // Additional methods as needed...
  Stream<List<Business>> fetchBusinesses() {
    return _businessCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Business.fromFirestore(doc)).toList();
    });
  }
}
