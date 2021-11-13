import 'package:shared_preferences/shared_preferences.dart';

class AdministrativeKeys {
  steamApiKey() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("steamapikey");
  }

  youtubeApiKey() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("youtubeapikey");
  }
}
