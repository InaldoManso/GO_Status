import 'package:go_status/model/CsgoStats.dart';
import 'package:go_status/model/Usuario.dart';
import 'package:go_status/model/Video.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const ID_CANAL = "UC_KRbC4RyGuQI6LaQxahNEQ";
const URL_BASE = "https://www.googleapis.com/youtube/v3/";

class Api {
  //Atributos de recuperacao por Steam URL
  String link_URL1 =
      "https://api.steampowered.com/ISteamUser/ResolveVanityURL/v1/?key=";
  String link_URL2 = "&vanityurl=";

  //Atributos de recuperacao por Stem ID
  String link_ID1 =
      "https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v2/?key=";
  String link_ID2 = "&steamids=";

  //Atributos de atualização do Stats
  String link_Stats1 =
      "https://api.steampowered.com/ISteamUserStats/GetUserStatsForGame/v2/?key=";
  String link_Stats2 = "&steamid=";
  String link_Stats3 = "&appid=730";

  //Atributos de atualização de Tempo jogado
  String link_Time1 =
      "https://api.steampowered.com/IPlayerService/GetOwnedGames/v1/?key=";
  String link_Time2 = "&steamid=";
  String link_Time3 = "&appids_filter[0]=730";

  //Avisos
  String avisoSteamPrivacidade =
      "Verifique se seu perfil esta público na Steam e tente novamente!";

  Future<String> resgatarDadosSteamURL(String keyApi, String steamName) async {
    http.Response response =
        await http.get(link_URL1 + keyApi + link_URL2 + steamName);

    Map<String, dynamic> retorno = json.decode(response.body);

    String sucesso = retorno["response"]["success"].toString();

    if (sucesso == "1") {
      return retorno["response"]["steamid"].toString();
    } else {
      return null;
    }
  }

  Future<Usuario> resgatarDadosSteamID(String keyApi, String steamID) async {
    Usuario usuario = Usuario();
    http.Response response =
        await http.get(link_ID1 + keyApi + link_ID2 + steamID);

    if (response.statusCode == 200) {
      Map<String, dynamic> retorno = json.decode(response.body);
      if (retorno["response"]["players"].toString() != "[]") {
        usuario.email = "";
        usuario.senha = "";
        usuario.time = "";
        usuario.userid = steamID;
        usuario.steamid =
            retorno["response"]["players"][0]["steamid"].toString();
        usuario.urlimage =
            retorno["response"]["players"][0]["avatarfull"].toString();
        usuario.nome =
            retorno["response"]["players"][0]["personaname"].toString();
        usuario.pais =
            retorno["response"]["players"][0]["loccountrycode"].toString();

        return usuario;
      } else {
        usuario = null;
        return usuario;
      }
    } else {
      usuario = null;
      return usuario;
    }
  }

  Future<CsgoStats> atualizarStatsCsgo(
      String keyApi, String steamid, String nome, String urlimage) async {
    CsgoStats csgoStats = CsgoStats();
    http.Response response = await http
        .get(link_Stats1 + keyApi + link_Stats2 + steamid + link_Stats3);

    if (response.statusCode == 200) {
      //Decodificar o resultado (String to Json)
      Map<String, dynamic> retorno = json.decode(response.body);

      //Total Kill
      Map<String, dynamic> kills = retorno["playerstats"]["stats"][0];
      csgoStats.kill = kills["value"].toString();

      //Total Deaths
      Map<String, dynamic> deaths = retorno["playerstats"]["stats"][1];
      csgoStats.death = deaths["value"].toString();

      //Total Wins
      Map<String, dynamic> wins = retorno["playerstats"]["stats"][5];
      csgoStats.wins = wins["value"].toString();

      //Total MVPs
      Map<String, dynamic> mvps = retorno["playerstats"]["stats"][98];
      csgoStats.mvps = mvps["value"].toString();

      //Total HShots
      Map<String, dynamic> hshots = retorno["playerstats"]["stats"][25];
      csgoStats.headshots = hshots["value"].toString();

      int kil = int.parse(csgoStats.kill);
      int dth = int.parse(csgoStats.death);
      double KD = kil / dth;

      csgoStats.resultkd = KD.toStringAsPrecision(2);
      csgoStats.nome = nome;
      csgoStats.urlimage = urlimage;

      //Recuperando tempo jogado
      http.Response responseTime = await http
          .get(link_Time1 + keyApi + link_Time2 + steamid + link_Time3);
      Map<String, dynamic> retornoTime = json.decode(responseTime.body);

      //Total Time
      csgoStats.timeplay =
          retornoTime["response"]["games"][0]["playtime_forever"].toString();

      return csgoStats;
    } else {
      return null;
    }
  }

  Future<List<Video>> pesquisaYoutube(String pesquisa, String apiKey) async {
    http.Response response = await http.get(URL_BASE +
        "search"
            "?part=snippet"
            "&type=video"
            "&maxResults=20"
            "&order=date"
            "&key=$apiKey"
            "&channelId=$ID_CANAL"
            "&q=$pesquisa");

    if (response.statusCode == 200) {
      Map<String, dynamic> dadosJson = json.decode(response.body);

      List<Video> videos = dadosJson["items"].map<Video>((map) {
        return Video.fromJson(map);
        //return Video.converterJson(map);
      }).toList();

      return videos;
    } else {}
  }
}
