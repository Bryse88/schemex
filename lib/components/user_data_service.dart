import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For formatting date and time

class UserDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> logUserInteraction(
      {required String userId,
      required String action,
      String? businessName,
      String? itemName,
      String? businessId,
      String? price,
      List<String>? categoryNames,
      String? itemTime,
      String? businessTime,
      String? itemDescription}) async {
    // Get the current date and time
    DateTime now = DateTime.now();
    String formattedDate =
        DateFormat('yyyy-MM-dd').format(now); // Date in YYYY-MM-DD format
    String formattedTime =
        DateFormat('HH:mm:ss').format(now); // Time in HH:MM:SS format

    final interactionData = {
      'userId': userId,
      'action': action,
      'businessName': businessName,
      'itemName': itemName,
      'businessId': businessId,
      'date': formattedDate,
      'time': formattedTime,
      'timestamp': FieldValue.serverTimestamp(), // Firebase timestamp
      'categoryNames': categoryNames,
      'price': price,
      'itemTime': itemTime,
      'businessTime': businessTime,
      'itemDescription': itemDescription
    };

    // Add the interaction data to the user's 'userInteractions' subcollection
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('userInteractions')
        .add(interactionData);
  }
}
