import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getBusinessesStream() {
    return _firestore.collection('Businesses').snapshots();
  }

  Future<String> getBusinessHours(String businessId) async {
    String dayOfWeek = DateFormat('EEEE').format(DateTime.now());
    DocumentSnapshot hoursSnapshot = await _firestore
        .collection('Businesses')
        .doc(businessId)
        .collection('Hours')
        .doc(dayOfWeek)
        .get();

    if (!hoursSnapshot.exists) {
      return 'Unavailable';
    }

    Map<String, dynamic> hoursData =
        hoursSnapshot.data() as Map<String, dynamic>? ?? {};
    bool isClosed = hoursData['Closed'] ?? true;
    if (isClosed) {
      return 'Closed';
    } else {
      String openTime = hoursData['Open'] as String? ?? 'Unknown';
      String closeTime = hoursData['Close'] as String? ?? 'Unknown';
      return '$openTime - $closeTime';
    }
  }
}
