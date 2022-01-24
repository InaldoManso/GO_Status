import 'package:go_status/features/video/model/video.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const idChannel = "UC_KRbC4RyGuQI6LaQxahNEQ";
const urlBase = "https://www.googleapis.com/youtube/v3/";

class VideoApi {
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
