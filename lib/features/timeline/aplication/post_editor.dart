import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_status/core/helper/color_pallete.dart';

class PostEditor {
  //Classes and packages
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  ColorPallete paleta = ColorPallete();

  excludePost(String postId) {}

  toEditMessage(String postId) {}
}
