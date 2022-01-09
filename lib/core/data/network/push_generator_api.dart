import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PushGeneratorApi {
  String? _urlSendPushFCM = 'https://fcm.googleapis.com/fcm/send';

  Future<bool> sendPushMotification(
      String fcm, String tittle, String body, String urlImage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _uriConvert = Uri.parse(_urlSendPushFCM!);

    String? cloudMessaging = prefs.getString("cloudmessaging");
    Map<String, String> _headerPush = {
      "Content-Type": 'application/json',
      "Authorization": 'key=$cloudMessaging',
    };
    var sendPushBody = jsonEncode(
      <String, dynamic>{
        'to': fcm,
        'notification': {
          'title': tittle,
          'body': body,
          'image': urlImage,
          'mutable_content': 1,
          'sound': "Tri-tone"
        },
        'data': {'url': urlImage, 'dl': "home"}
      },
    );

    http.Response response =
        await http.post(_uriConvert, headers: _headerPush, body: sendPushBody);

    print('goldem ' + response.body);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
