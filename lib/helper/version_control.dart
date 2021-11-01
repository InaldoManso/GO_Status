import 'package:cloud_firestore/cloud_firestore.dart';

class VersionControl {
  //Attributes
  FirebaseFirestore db = FirebaseFirestore.instance;

  versionCheck(String version, String userid) {
    switch (version) {
      case "1.0.0":
        Map<String, dynamic> updates = {
          "version": "1.0.1",
          "admin": 0,
        };
        db.collection("users").doc(userid).update(updates);
        return false;
        break;

      default:
        return true;
    }
  }
}
