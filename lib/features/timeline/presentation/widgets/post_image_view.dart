import 'package:flutter/material.dart';
import 'package:go_status/core/helper/color_pallete.dart';

class PostImageView extends StatefulWidget {
  // const PostImageView({ Key? key }) : super(key: key);
  String urlimage;
  PostImageView(this.urlimage);

  @override
  _PostImageViewState createState() => _PostImageViewState();
}

class _PostImageViewState extends State<PostImageView>
    with TickerProviderStateMixin {
  final TransformationController _controller = TransformationController();
  ColorPallete paleta = ColorPallete();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: GestureDetector(
            child: InteractiveViewer(
              transformationController: _controller,
              child: Image.network(
                widget.urlimage,
                fit: BoxFit.contain,
              ),
            ),
            onDoubleTap: () {
              _controller.value = Matrix4.identity();
            },
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.close_outlined),
        backgroundColor: Colors.black12,
        splashColor: Colors.transparent,
        isExtended: false,
        elevation: 0,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
