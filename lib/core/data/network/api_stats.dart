import 'package:go_status/core/model/stats_item.dart';
import 'package:go_status/core/model/user_profile.dart';
import 'package:go_status/core/model/user_stats.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ApiStats {
  //Attributes
  List<String> _getStatsUser = [
    "https://api.steampowered.com/ISteamUserStats/GetUserStatsForGame/v2/?key=",
    "&steamid=",
    "&appid=730"
  ];
  List<String> _getSteamId = [
    "https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v2/?key=",
    "&steamids="
  ];
  List<String> _getTimePlayed = [
    "https://api.steampowered.com/IPlayerService/GetOwnedGames/v1/?key=",
    "&steamid=",
    "&appids_filter[0]=730"
  ];

  updateUserStats(String steamId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String steamapikey = prefs.getString("steamapikey")!;

    var _uriConvert = Uri.parse(_getStatsUser[0] +
        steamapikey +
        _getStatsUser[1] +
        steamId +
        _getStatsUser[2]);

    UserStats userStats = UserStats();
    http.Response response = await http.get(_uriConvert);

    if (response.statusCode == 200) {
      Map<String, dynamic> retorno = json.decode(response.body);

      List<StatsItem> statsItems =
          retorno["playerstats"]["stats"].map<StatsItem>((map) {
        return StatsItem.fromJson(map);
      }).toList();

      UserProfile userProfile = await _getUserData(steamId);

      int kill = int.parse(_splitListStats(statsItems, "total_kills"));
      int death = int.parse(_splitListStats(statsItems, "total_deaths"));
      double killDeath = kill / death;

      userStats.name = userProfile.name;
      userStats.urlimage = userProfile.urlimage;
      userStats.killdeath = killDeath.toStringAsPrecision(2);
      userStats.kill = _splitListStats(statsItems, "total_kills");
      userStats.death = _splitListStats(statsItems, "total_deaths");
      userStats.timeplay = await _getTimePlayerd(steamId);
      userStats.wins = _splitListStats(statsItems, "total_wins");
      userStats.mvps = _splitListStats(statsItems, "total_mvps");
      userStats.headshots = _splitListStats(statsItems, "total_kills_headshot");

      print("GG 2 ::::::::: " + userStats.timeplay);

      return userStats;
    } else {
      return "error";
    }
  }

  String _splitListStats(List<StatsItem> list, String attribute) {
    List<StatsItem> stats =
        list.where((element) => element.name == attribute).toList();

    return stats[0].value.toString();
  }

  _getTimePlayerd(String steamId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String steamapikey = prefs.getString("steamapikey")!;

    var _uriConvert = Uri.parse(_getTimePlayed[0] +
        steamapikey +
        _getTimePlayed[1] +
        steamId +
        _getTimePlayed[2]);
    http.Response responseTime = await http.get(_uriConvert);
    Map<String, dynamic> retornoTime = json.decode(responseTime.body);

    return retornoTime["response"]["games"][0]["playtime_forever"].toString();
  }

  _getUserData(String steamId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String steamapikey = prefs.getString("steamapikey")!;
    UserProfile userProfile = UserProfile();
    var _uriConvert =
        Uri.parse(_getSteamId[0] + steamapikey + _getSteamId[1] + steamId);
    http.Response response = await http.get(_uriConvert);

    if (response.statusCode == 200) {
      Map<String, dynamic> returnData = json.decode(response.body);
      if (returnData["response"]["players"].toString() != "[]") {
        userProfile.email = "";
        userProfile.password = "";
        userProfile.team = "";
        userProfile.userid = steamId;
        userProfile.steamid =
            returnData["response"]["players"][0]["steamid"].toString();
        userProfile.urlimage =
            returnData["response"]["players"][0]["avatarfull"].toString();
        userProfile.name =
            returnData["response"]["players"][0]["personaname"].toString();
        userProfile.country =
            returnData["response"]["players"][0]["loccountrycode"].toString();

        return userProfile;
      } else {
        return "error";
      }
    } else {
      return "error";
    }
  }
}
