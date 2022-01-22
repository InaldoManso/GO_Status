import 'package:flutter/material.dart';
import 'package:go_status/core/helper/color_pallete.dart';
import 'package:go_status/features/snapping_menu/aplication/snapping_button_icon.dart';

class SnappingButton extends StatefulWidget {
  final String? label;
  final String? id;
  final String? route;
  final String? argument;
  final BuildContext? context;
  const SnappingButton(
      this.label, this.id, this.route, this.argument, this.context);

  @override
  _SnappingButtonState createState() => _SnappingButtonState();
}

class _SnappingButtonState extends State<SnappingButton> {
  //Casses and Packages
  ColorPallete colorPallete = ColorPallete();
  SnappingButtonIcon sbi = SnappingButtonIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          alignment: Alignment.centerLeft,
          primary: Colors.white,
          padding: const EdgeInsets.all(15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        icon: Icon(sbi.setIcon(widget.id), color: colorPallete.dodgerBlue),
        label: Text(
          widget.label!,
          style: TextStyle(color: colorPallete.dodgerBlue),
        ),
        onPressed: () {
          if (widget.argument != "" && widget.argument != null) {
            Navigator.pushNamed(
              context,
              widget.route!,
              arguments: widget.argument!,
            );
          } else {
            Navigator.pushNamed(
              widget.context!,
              widget.route!,
            );
          }
        },
      ),
    );
  }
}
