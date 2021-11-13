import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostEditor {
  //Classes and packages
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  excludePost(Map<String, dynamic> post) {
    db.collection("publications").doc(post["post"]).delete();

    print(
        "GTX: publicPost/" + post["userid"] + "/" + post["imageName"] + ".jpg");

    firebase_storage.Reference pastaRaiz = storage.ref();
    pastaRaiz
        .child("publicPost")
        .child(post["userid"])
        .child(post["imageName"] + ".jpg")
        .delete();
  }

  editMessage(String postId) {}
}
