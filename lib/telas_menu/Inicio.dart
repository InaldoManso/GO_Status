import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:go_status/helper/Paleta.dart';
import 'package:go_status/model/Api.dart';
import 'package:go_status/model/Video.dart';

class Inicio extends StatefulWidget {
  String pesquisa;
  Inicio(this.pesquisa);

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  //Atributos
  String _resultado = "";
  Paleta paleta = Paleta();

  _listarVideos(String pesquisa) {
    Api api = Api();
    return api.pesquisar(pesquisa);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(
              Icons.youtube_searched_for_outlined,
              color: paleta.royalBlue,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.video_camera_back_outlined,
              color: paleta.royalBlue,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<List<Video>>(
        future: _listarVideos(widget.pesquisa),
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
                              apiKey: CHAVE_YOUTUBE_API,
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
                                    )),
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
