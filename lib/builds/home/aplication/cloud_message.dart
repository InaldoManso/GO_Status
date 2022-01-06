import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CloudMessage {
  saveFCMTokenInFirebase(String? fcmToken) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser!;
    db.collection("users").doc(user.uid).update({'fmc': fcmToken});
  }
}
