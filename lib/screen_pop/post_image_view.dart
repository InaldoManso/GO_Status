import 'package:flutter/material.dart';
import 'package:go_status/general/helpers/color_pallete.dart';

class PostImageView extends StatefulWidget {
  // const PostImageView({ Key? key }) : super(key: key);
  String urlimage;
  PostImageView(this.urlimage);

  @override
  _PostImageViewState createState() => _PostImageViewState();
}

class _PostImageViewState extends State<PostImageView> {
  ColorPallete paleta = ColorPallete();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(top: 8),
          height: MediaQuery.of(context).size.width,
          alignment: Alignment.topLeft,
          decoration: BoxDecoration(
            color: paleta.grey900,
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
                image: NetworkImage(widget.urlimage), fit: BoxFit.scaleDown),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Icon(Icons.close_fullscreen_outlined),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
