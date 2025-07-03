import 'dart:io';
import 'package:flutter/material.dart';

class ImageDisplay extends StatelessWidget {
  final File? image;

  ImageDisplay({this.image});

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      return Text('Bir resim seçiniz.');
    } else {
      return Image.file(image!, height: 200);
    }
  }
}
