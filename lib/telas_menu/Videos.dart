import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:go_status/helper/Api.dart';
import 'package:go_status/helper/CustomSearchDelegate.dart';
import 'package:go_status/helper/Paleta.dart';
import 'package:go_status/model/Video.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Videos extends StatefulWidget {
  String pesquisa;
  Videos(this.pesquisa);
  @override
  _VideosState createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  //Atributos
  String _pesquisa = "";
  Paleta paleta = Paleta();
  String steamapikey;
  String youtubeapikey;

  _listarVideos(String pesquisa) {
    Api api = Api();
    return api.pesquisaYoutube(pesquisa, youtubeapikey);
  }

  _recuperarAdmKeys() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      steamapikey = prefs.getString("steamapikey");
      youtubeapikey = prefs.getString("youtubeapikey");
    });
  }

  @override
  void initState() {
    _recuperarAdmKeys();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: Text(
          "\"" + _pesquisa + "\"",
          style: TextStyle(color: paleta.orange),
        ),
        actions: [
          _pesquisa == ""
              ? Container()
              : IconButton(
                  icon: Icon(
                    Icons.delete_forever_outlined,
                    color: paleta.royalBlue,
                  ),
                  onPressed: () async {
                    setState(
                      () {
                        _pesquisa = "";
                      },
                    );
                  },
                ),
          IconButton(
            icon: Icon(
              Icons.search_outlined,
              color: paleta.royalBlue,
            ),
            onPressed: () async {
              String res = await showSearch(
                  context: context, delegate: CustomSearchDelegate());
              setState(() {
                _pesquisa = res;
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Video>>(
        future: _listarVideos(_pesquisa),
        builder: (contex, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasData) {
                return ListView.separated(
                    itemBuilder: (context, index) {
                      List<Video> videos = snapshot.data;
                      Video video = videos[index];

                      return GestureDetector(
                        onTap: () {
                          FlutterYoutube.playYoutubeVideoById(
                              apiKey: youtubeapikey,
                              videoId: video.id,
                              autoPlay: true,
                              fullScreen: true);
                        },
                        child: Container(
                          margin: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(8)),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(video.imagem),
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.play_circle_outline_outlined,
                                    size: 50,
                                    color: paleta.royalBlue,
                                  ),
                                ),
                              ),
                              ListTile(
                                title: Text(video.titulo),
                                subtitle: Text(video.canal),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => Divider(
                          height: 2,
                          color: Colors.grey,
                        ),
                    itemCount: snapshot.data.length);
              } else {
                return Center(
                  child: Text("Nenhum dado a ser exibido!"),
                );
              }
              break;
          }
          return null;
        },
      ),
    );
  }
}
