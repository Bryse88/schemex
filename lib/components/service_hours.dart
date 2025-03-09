import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ServiceHours {
  Future<String> getBusinessHours(String businessId,
      {String? specialTime}) async {
    String dayOfWeek = DateFormat('EEEE').format(DateTime.now());

    // If specialTime is "Normal", fetch the regular business hours
    if (specialTime == "Normal") {
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
    } else {
      // If specialTime is not "Normal", return the special time
      return specialTime ?? 'Unavailable';
    }
  }
}
