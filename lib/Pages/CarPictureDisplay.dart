import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class CarPictureDisplay extends StatelessWidget {
  final String picturePath;

  CarPictureDisplay({@required this.picturePath});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: PhotoView(
      imageProvider: AssetImage("$picturePath"),
    ));
  }
}
