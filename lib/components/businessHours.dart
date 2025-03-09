import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class BusinessHours {
  Future<String> getBusinessHours(String businessId) async {
    String dayOfWeek = DateFormat('EEEE').format(DateTime.now());

    DocumentSnapshot hoursSnapshot = await FirebaseFirestore.instance
        .collection('Businesses')
        .doc(businessId)
        .collection('Hours')
        .doc(dayOfWeek)
        .get();

    if (hoursSnapshot.exists) {
      Map<String, dynamic> hoursData =
          hoursSnapshot.data() as Map<String, dynamic>;
      bool isClosed = hoursData['Closed'] ?? true;
      if (isClosed) {
        return 'Closed';
      } else {
        String openTime = hoursData['Open'] ?? 'Unknown';
        String closeTime = hoursData['Close'] ?? 'Unknown';
        return '$openTime - $closeTime';
      }
    } else {
      return 'Unavailable';
    }
  }
}
