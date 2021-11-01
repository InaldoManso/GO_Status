import 'package:go_status/model/user_profile.dart';
import 'package:go_status/model/user_stats.dart';
import 'package:go_status/model/video.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const idChannel = "UC_KRbC4RyGuQI6LaQxahNEQ";
const urlBase = "https://www.googleapis.com/youtube/v3/";

class Api {
  String alertSteamPrivacy =
      "Verifique se seu perfil esta público na Steam e tente novamente!";

  List<String> getSteamUrl = [
    "https://api.steampowered.com/ISteamUser/ResolveVanityURL/v1/?key=",
    "&vanityurl="
  ];

  List<String> getSteamId = [
    "https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v2/?key=",
    "&steamids="
  ];

  List<String> getStatsUser = [
    "https://api.steampowered.com/ISteamUserStats/GetUserStatsForGame/v2/?key=",
    "&steamid=",
    "&appid=730"
  ];

  List<String> getTimePlayed = [
    "https://api.steampowered.com/IPlayerService/GetOwnedGames/v1/?key=",
    "&steamid=",
    "&appids_filter[0]=730"
  ];

  Future<String> recSteamIdFromUrl(String keyApi, String steamName) async {
    http.Response response =
        await http.get(getSteamUrl[0] + keyApi + getSteamUrl[1] + steamName);

    Map<String, dynamic> returnData = json.decode(response.body);
    print("GG " + response.body.toString());

    String success = returnData["response"]["success"].toString();

    if (success == "1") {
      return returnData["response"]["steamid"].toString();
    } else {}
  }

  validarSteamPublica(String keyApi, String steamid) async {
    http.Response response = await http.get(
        getStatsUser[0] + keyApi + getStatsUser[1] + steamid + getStatsUser[2]);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<UserProfile> recDataUserFromSteamID(
      String keyApi, String steamID) async {
    UserProfile userProfile = UserProfile();
    http.Response response =
        await http.get(getSteamId[0] + keyApi + getSteamId[1] + steamID);

    print(response.body.toString());

    if (response.statusCode == 200) {
      Map<String, dynamic> returnData = json.decode(response.body);
      if (returnData["response"]["players"].toString() != "[]") {
        userProfile.email = "";
        userProfile.password = "";
        userProfile.team = "";
        userProfile.userid = steamID;
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
        userProfile = null;
        return userProfile;
      }
    } else {
      userProfile = null;
      return userProfile;
    }
  }

  Future<UserStats> updateUserStats(
      String keyApi, String steamid, String name, String urlimage) async {
    UserStats csgoStats = UserStats();
    http.Response response = await http.get(
        getStatsUser[0] + keyApi + getStatsUser[1] + steamid + getStatsUser[2]);

    if (response.statusCode == 200) {
      Map<String, dynamic> retorno = json.decode(response.body);

      Map<String, dynamic> kills = retorno["playerstats"]["stats"][0];
      csgoStats.kill = kills["value"].toString();

      Map<String, dynamic> deaths = retorno["playerstats"]["stats"][1];
      csgoStats.death = deaths["value"].toString();

      Map<String, dynamic> wins = retorno["playerstats"]["stats"][5];
      csgoStats.wins = wins["value"].toString();

      Map<String, dynamic> mvps = retorno["playerstats"]["stats"][98];
      csgoStats.mvps = mvps["value"].toString();

      Map<String, dynamic> hshots = retorno["playerstats"]["stats"][25];
      csgoStats.headshots = hshots["value"].toString();

      int kill = int.parse(csgoStats.kill);
      int death = int.parse(csgoStats.death);
      double killDeath = kill / death;

      csgoStats.killdeath = killDeath.toStringAsPrecision(2);
      csgoStats.nome = name;
      csgoStats.urlimage = urlimage;

      //Rec time played from other api
      http.Response responseTime = await http.get(getTimePlayed[0] +
          keyApi +
          getTimePlayed[1] +
          steamid +
          getTimePlayed[2]);
      Map<String, dynamic> retornoTime = json.decode(responseTime.body);

      csgoStats.timeplay =
          retornoTime["response"]["games"][0]["playtime_forever"].toString();

      return csgoStats;
    } else {
      return null;
    }
  }

  Future<List<Video>> searchOnYoutube(String pesquisa, String apiKey) async {
    http.Response response = await http.get(urlBase +
        "search"
            "?part=snippet"
            "&type=video"
            "&maxResults=20"
            "&order=date"
            "&key=$apiKey"
            "&channelId=$idChannel"
            "&q=$pesquisa");

    if (response.statusCode == 200) {
      Map<String, dynamic> dadosJson = json.decode(response.body);

      List<Video> videos = dadosJson["items"].map<Video>((map) {
        return Video.fromJson(map);
      }).toList();

      return videos;
    } else {
      List<Video> video = [];
      return video;
    }
  }
}
