import 'package:flutter/material.dart';
import 'package:go_status/helper/color_pallete.dart';
import 'package:go_status/model/MapDetails.dart';

class Maps extends StatefulWidget {
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  ColorPallete paleta = ColorPallete();

  List<MapDetails> listaMapas = [
    MapDetails("images/capas/capa_dustii.png", "images/maps/map_dust2.jpg",
        "Dust II", "Mapa legal", false),
    MapDetails("images/capas/capa_inferno.png", "images/maps/map_inferno.jpg",
        "Inferno", "zzz", false),
    MapDetails("images/capas/capa_mirage.png", "images/maps/map_mirage.jpg",
        "Mirage", "zzz", false),
    MapDetails("images/capas/capa_overpass.png", "images/maps/map_overpass.jpg",
        "Overpass", "zzz", false),
    MapDetails("images/capas/capa_train.png", "images/maps/map_train.jpg",
        "Train", "zzz", false),
    MapDetails("images/capas/capa_vertigo.png", "images/maps/map_vertigo.jpg",
        "Vertigo", "zzz", false),
    MapDetails("images/capas/capa_nuke.png", "images/maps/map_nuke.jpg", "Nuke",
        "zzz", false),
    MapDetails("images/capas/capa_cache.png", "images/maps/map_cache.jpg",
        "Cache", "zzz", false),
    MapDetails("images/capas/capa_cobblestone.png",
        "images/maps/map_cobblestone.jpg", "Cobblestone", "zzz", false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView.builder(
          padding: EdgeInsets.only(top: 40, bottom: 60),
          itemCount: listaMapas.length,
          itemBuilder: (context, index) {
            MapDetails mapDetails = listaMapas[index];

            return GestureDetector(
              onTap: () {
                if (mapDetails.exibirimage) {
                  mapDetails.exibirimage = false;
                  setState(() {});
                } else {
                  mapDetails.exibirimage = true;
                  setState(() {});
                }
              },
              child: Container(
                padding: EdgeInsets.only(top: 8, bottom: 8),
                margin: EdgeInsets.only(top: 4, bottom: 4),
                decoration: BoxDecoration(color: paleta.grey850),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      height: mapDetails.exibirimage
                          ? MediaQuery.of(context).size.width
                          : MediaQuery.of(context).size.width / 2,
                      alignment: Alignment.topLeft,
                      decoration: BoxDecoration(
                        color: paleta.grey850,
                        image: DecorationImage(
                          image: AssetImage(
                            mapDetails.exibirimage
                                ? mapDetails.image
                                : mapDetails.capa,
                          ),
                          fit: mapDetails.exibirimage
                              ? BoxFit.fill
                              : BoxFit.cover,
                        ),
                      ),
                      child: Text(
                        mapDetails.exibirimage ? "" : mapDetails.titulo,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(5.0, 5.0),
                              blurRadius: 10.0,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
