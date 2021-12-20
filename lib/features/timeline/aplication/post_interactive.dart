import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:go_status/features/timeline/model/post_reaction.dart';
import 'package:go_status/core/tools/date_formatter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostInteractive {
  //Classes and packages
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  DateFormatter dateFormatter = DateFormatter();

  sendGoodGame(String? postId, PostReaction postReaction) async {
    Map<String, dynamic> teste = {'teste': 'teste'};
    print(postReaction.toMap());
    await db
        .collection("publications")
        .doc(postId)
        .collection("reactions")
        .doc(postReaction.uidUser)
        .set(postReaction.toMap());
  }
}
