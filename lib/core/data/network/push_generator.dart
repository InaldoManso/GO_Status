import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_status/core/data/network/push_generator_api.dart';

class PushGenerator {
  sendPushOfNewPosting(String? tittle, String? body, String? urlImage) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await db.collection("users").get();
    List<DocumentSnapshot> snapshots = querySnapshot.docs;

    List<String> fmclist = [];
    for (var item in snapshots) {
      if (item['fcm'] == '') continue;
      fmclist.add(item['fcm']);
    }

    List<bool> success = [];
    for (var fcm in fmclist) {
      PushGeneratorApi pga = PushGeneratorApi();
      success
          .add(await pga.sendPushMotification(fcm, tittle!, body!, urlImage!));
    }

    return fmclist.length == success.length;
  }
}
