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

  sendPushOfNewMessage(String? tittle, String? body) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await db.collection("users").get();
    List<DocumentSnapshot> snapshots = querySnapshot.docs;

    List<String> fmclist = [];
    for (var item in snapshots) {
      bool existis = await checkIfDocExists(item['userid']);
      if (existis) {
        if (item['sendchatnotify'] == false) continue;
        fmclist.add(item['fcm']);
      }
    }
    List<bool> success = [];
    for (var fcm in fmclist) {
      PushGeneratorApi pga = PushGeneratorApi();
      success.add(await pga.sendPushMotification(
          fcm, 'Nova mensagem de: ' + tittle!, body!, ""));
    }
    return fmclist.length == success.length;
  }

  Future<bool> checkIfDocExists(String? uid) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    var collectionRef = db.collection('users');
    var doc = await collectionRef.doc(uid).get();

    // print(doc.data()!.containsKey('sendchatnotify'));

    return doc.data()!.containsKey('sendchatnotify');
  }
}
