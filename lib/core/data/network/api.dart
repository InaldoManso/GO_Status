import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_status/core/tools/date_formatter.dart';
import 'package:go_status/core/model/user_profile.dart';
import 'package:go_status/core/model/user_stats.dart';
import 'package:go_status/features/video/model/video.dart';
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
    var _uriConvert =
        Uri.parse(getSteamUrl[0] + keyApi + getSteamUrl[1] + steamName);
    http.Response response = await http.get(_uriConvert);

    Map<String, dynamic> returnData = json.decode(response.body);
    String success = returnData["response"]["success"].toString();

    //================== TEST AREA ==================//
    FirebaseFirestore db = FirebaseFirestore.instance;
    DateFormatter dateFormatter = DateFormatter();
    Map<String, dynamic> log = {
      "time": dateFormatter.generateDateTime(),
      "value": response.body,
      "steamkey": keyApi,
      "search": steamName
    };
    db..collection("apperrorlog").add(log);
    //================== TEST AREA ==================//

    if (success == "1") {
      print("DEU CERTOOOO");
      return returnData["response"]["steamid"].toString();
    } else {
      print("DEU ERRROOOOO");
      return "error";
    }
  }

  validarSteamPublica(String keyApi, String steamid) async {
    var _uriConvert = Uri.parse(
        getStatsUser[0] + keyApi + getStatsUser[1] + steamid + getStatsUser[2]);
    http.Response response = await http.get(_uriConvert);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  recDataUserFromSteamID(String keyApi, String steamID) async {
    UserProfile userProfile = UserProfile();
    var _uriConvert =
        Uri.parse(getSteamId[0] + keyApi + getSteamId[1] + steamID);
    http.Response response = await http.get(_uriConvert);

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
        return "error";
      }
    } else {
      return "error";
    }
  }

  Future<UserStats?> updateUserStats(
      String keyApi, String steamid, String name, String urlimage) async {
    UserStats csgoStats = UserStats();
    var _uriConvert = Uri.parse(
        getStatsUser[0] + keyApi + getStatsUser[1] + steamid + getStatsUser[2]);
    http.Response response = await http.get(_uriConvert);

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
      print("teste001: GG " + mvps["name"]);

      Map<String, dynamic> hshots = retorno["playerstats"]["stats"][25];
      csgoStats.headshots = hshots["value"].toString();

      int kill = int.parse(csgoStats.kill);
      int death = int.parse(csgoStats.death);
      double killDeath = kill / death;

      csgoStats.killdeath = killDeath.toStringAsPrecision(2);
      csgoStats.name = name;
      csgoStats.urlimage = urlimage;

      var _uriConvert = Uri.parse(getTimePlayed[0] +
          keyApi +
          getTimePlayed[1] +
          steamid +
          getTimePlayed[2]);

      //Rec time played from other api
      http.Response responseTime = await http.get(_uriConvert);
      Map<String, dynamic> retornoTime = json.decode(responseTime.body);

      csgoStats.timeplay =
          retornoTime["response"]["games"][0]["playtime_forever"].toString();

      print("GG ::::::::::: " + csgoStats.timeplay);

      return csgoStats;
    } else {
      return null;
    }
  }

  Future<List<Video>?> searchOnYoutube(String pesquisa, String? apiKey) async {
    var _uriConvert = Uri.parse(urlBase +
        "search"
            "?part=snippet"
            "&type=video"
            "&maxResults=20"
            "&order=date"
            "&key=$apiKey"
            "&channelId=$idChannel"
            "&q=$pesquisa");
    http.Response response = await http.get(_uriConvert);

    if (response.statusCode == 200) {
      Map<String, dynamic> dadosJson = json.decode(response.body);

      List<Video>? videos = dadosJson["items"].map<Video>((map) {
        return Video.fromJson(map);
      }).toList();

      return videos;
    } else {
      List<Video> video = [];
      return video;
    }
  }
}
