import 'package:go_status/features/video/aplication/custom_search_delegade.dart';
import 'package:go_status/features/video/aplication/flutter_youtube_player.dart';
import 'package:go_status/features/video/data/network/video_api.dart';
import 'package:go_status/features/video/model/video.dart';
import 'package:go_status/features/video/presentation/widgets/tittle_seach.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_status/core/helper/color_pallete.dart';
import 'package:flutter/material.dart';

class Videos extends StatefulWidget {
  String? pesquisa;
  Videos(this.pesquisa);
  @override
  _VideosState createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  //Classes and packages
  ColorPallete colorPallete = ColorPallete();
  VideoApi videoApi = VideoApi();

  //Atributos
  String? _pesquisa = "";
  String? youtubeapikey;

  Future<List<Video>?> _listarVideos(String pesquisa) {
    return videoApi.searchOnYoutube(pesquisa, youtubeapikey);
  }

  _recuperarAdmKeys() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: TittleSearch(_pesquisa),
        actions: [
          _pesquisa == ""
              ? Container()
              : IconButton(
                  icon: Icon(
                    Icons.delete_forever_outlined,
                    color: colorPallete.dodgerBlue,
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
              color: colorPallete.dodgerBlue,
            ),
            onPressed: () async {
              String? res = await showSearch(
                  context: context, delegate: CustomSearchDelegate());
              setState(() {
                _pesquisa = res;
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Video>?>(
        future: _listarVideos(_pesquisa!),
        builder: (contex, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasData) {
                return ListView.separated(
                    itemBuilder: (context, index) {
                      List<Video> videos = snapshot.data!;
                      Video video = videos[index];

                      return GestureDetector(
                        onTap: () {
                          FlutterYoutubePlayer.playYoutubeVideoById(
                              apiKey: youtubeapikey,
                              videoId: video.id,
                              autoPlay: true,
                              fullScreen: true);
                        },
                        child: Container(
                          margin: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: colorPallete.grey850,
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
                                    image: NetworkImage(video.imagem!),
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.play_arrow_rounded,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              ListTile(
                                title: Text(video.titulo!),
                                subtitle: Text(
                                  video.canal!,
                                  style: TextStyle(color: colorPallete.orange),
                                ),
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
                    itemCount: snapshot.data!.length);
              } else {
                return Center(
                  child: Text("Nenhum dado a ser exibido!"),
                );
              }
          }
        },
      ),
    );
  }
}
