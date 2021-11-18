import 'package:go_status/core/model/stats_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiStats {
  //Classes and Packages
  StatsItem statsItem = StatsItem();

  //Attributes
  List<String> getStatsUser = [
    "https://api.steampowered.com/ISteamUserStats/GetUserStatsForGame/v2/?key=",
    "&steamid=",
    "&appid=730"
  ];

  updateUserStats(
      /*
      String keyApi, String steamid, String name, String urlimage*/
      ) async {
    http.Response response = await http.get(getStatsUser[0] +
        "0850333260EF03D2E0AB3D29A0AC9176" +
        getStatsUser[1] +
        "76561198960813990" +
        getStatsUser[2]);

    if (response.statusCode == 200) {
      Map<String, dynamic> retorno = json.decode(response.body);

      List<StatsItem> statsItems =
          retorno["playerstats"]["stats"].map<StatsItem>((map) {
        return StatsItem.fromJson(map);
      }).toList();

      List<StatsItem> stats =
          statsItems.where((element) => element.name == "total_kills").toList();

      print("New API: " + stats[0].value.toString());
    } else {}
  }
}
