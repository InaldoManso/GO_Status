//Atributos desativados
// String steamId1 = "76561198960813990";
// String steamId2 = "STEAM_1:1:616436488";
import 'dart:convert';

import 'package:go_status/model/Video.dart';
import 'package:http/http.dart' as http;

const CHAVE_YOUTUBE_API = "AIzaSyAco60KceBeoM6j0VOsKdMRgA6VTatVERY";
const ID_CANAL = "UC_KRbC4RyGuQI6LaQxahNEQ";
const ID_CANAL2 = "UCGsYpTrwc-sPjlyoSGPbcbw";
const URL_BASE = "https://www.googleapis.com/youtube/v3/";

class Api {
  //Atributos:
  String webKey = "F11D7D33D32510B6C271445DC579001D";
  String appId = "730";

//RecuperarIdUser
  String recCSTime =
      "https://api.steampowered.com/IPlayerService/GetRecentlyPlayedGames/v1/?key=0850333260EF03D2E0AB3D29A0AC9176&steamid=76561198960813990";
  String recSteamURL =
      "https://api.steampowered.com/ISteamUser/ResolveVanityURL/v1/?key=0850333260EF03D2E0AB3D29A0AC9176&vanityurl=";
  String recSteamID =
      "https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v2/?key=0850333260EF03D2E0AB3D29A0AC9176&steamids=";
  String recCSGO1 =
      "https://api.steampowered.com/ISteamUserStats/GetUserStatsForGame/v2/?key=0850333260EF03D2E0AB3D29A0AC9176&steamid=";
  String recCSGO2 = "&appid=730";

//Avisos
  String avisoSteamPrivacidade =
      "Verifique se seu perfil esta público na Steam e tente novamente!";
  Future<List<Video>> pesquisar(String pesquisa) async {
    http.Response response = await http.get(URL_BASE +
        "search"
            "?part=snippet"
            "&type=video"
            "&maxResults=20"
            "&order=date"
            "&key=$CHAVE_YOUTUBE_API"
            "&channelId=$ID_CANAL"
            "&q=$pesquisa");

    if (response.statusCode == 200) {
      Map<String, dynamic> dadosJson = json.decode(response.body);

      List<Video> videos = dadosJson["items"].map<Video>((map) {
        return Video.fromJson(map);
        //return Video.converterJson(map);
      }).toList();

      return videos;

      //print("Resultado: " + videos.toString() );

      /*
      for( var video in dadosJson["items"] ){
        print("Resultado: " + video.toString() );
      }*/
      //print("resultado: " + dadosJson["items"].toString() );

    } else {}
  }
}
